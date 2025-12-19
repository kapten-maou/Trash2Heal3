import { onCall, HttpsError } from "firebase-functions/v2/https";
import { requireAuth } from "../utils/auth";
import { collections, runTransaction } from "../utils/firestore";
import {
  withIdempotency,
  generatePaymentIntentKey,
} from "../utils/idempotency";
import * as admin from "firebase-admin";
import * as crypto from "crypto";

interface CreatePaymentIntentRequest {
  planId: string;
  paymentMethod: "va" | "qris";
  bank?: string; // For VA: "bca" | "bni" | "mandiri" | "bri"
  idempotencyKey?: string;
}

interface CreatePaymentIntentResponse {
  success: boolean;
  paymentId: string;
  method: string;
  amount: number;
  vaNumber?: string;
  qrisUrl?: string;
  expiredAt: string;
  instructions: string[];
}

// ========== MEMBERSHIP PLANS ==========

const MEMBERSHIP_PLANS = {
  silver: {
    name: "Silver",
    price: 49000,
    durationDays: 30,
    multiplier: 1.2,
  },
  gold: {
    name: "Gold",
    price: 129000,
    durationDays: 90,
    multiplier: 1.5,
  },
  platinum: {
    name: "Platinum",
    price: 449000,
    durationDays: 365,
    multiplier: 2.0,
  },
};

// ========== MOCK PAYMENT GATEWAY ==========

/**
 * Generate VA number (mock)
 * Format: {bank_code}{user_id_hash}{timestamp}
 */
function generateVANumber(bank: string, userId: string): string {
  const bankCodes: Record<string, string> = {
    bca: "80777",
    bni: "88888",
    mandiri: "70012",
    bri: "26215",
  };

  const code = bankCodes[bank] || "99999";
  const userHash = crypto
    .createHash("md5")
    .update(userId)
    .digest("hex")
    .substring(0, 8);
  const timestamp = Date.now().toString().substring(-5);

  return `${code}${userHash}${timestamp}`;
}

/**
 * Generate QRIS URL (mock)
 */
function generateQRISUrl(paymentId: string, amount: number): string {
  const payload = Buffer.from(
    JSON.stringify({
      paymentId,
      amount,
      merchantId: "TRASH2HEAL001",
      timestamp: Date.now(),
    })
  ).toString("base64");

  return `https://api.trash2heal.com/qris/${payload}`;
}

/**
 * Generate payment instructions
 */
function generateInstructions(
  method: string,
  bank?: string,
  vaNumber?: string
): string[] {
  if (method === "va" && bank && vaNumber) {
    const bankNames: Record<string, string> = {
      bca: "BCA",
      bni: "BNI",
      mandiri: "Mandiri",
      bri: "BRI",
    };

    const bankName = bankNames[bank] || bank.toUpperCase();

    return [
      `Buka aplikasi atau ATM ${bankName}`,
      "Pilih menu Transfer / Bayar",
      "Pilih Virtual Account / VA",
      `Masukkan nomor VA: ${vaNumber}`,
      "Periksa detail pembayaran",
      "Konfirmasi pembayaran",
      "Simpan bukti transaksi",
    ];
  }

  if (method === "qris") {
    return [
      "Buka aplikasi e-wallet (GoPay, OVO, Dana, dll)",
      "Scan QR Code yang ditampilkan",
      "Periksa jumlah pembayaran",
      "Konfirmasi pembayaran",
      "Tunggu notifikasi sukses",
      "Membership akan aktif otomatis",
    ];
  }

  return ["Ikuti instruksi pembayaran"];
}

/**
 * Calculate payment expiry (24 hours from now)
 */
function calculateExpiry(): Date {
  const expiry = new Date();
  expiry.setHours(expiry.getHours() + 24);
  return expiry;
}

/**
 * Generate signature for webhook verification
 * In production, this would be your secret key
 */
function generateSignature(paymentId: string, amount: number): string {
  const secret = "TRASH2HEAL_SECRET_KEY_2024"; // Store in env
  const payload = `${paymentId}:${amount}:${secret}`;
  return crypto.createHash("sha256").update(payload).digest("hex");
}

/**
 * Create payment intent for membership purchase
 * Mock integration with Midtrans/Xendit
 */
export const createPaymentIntent = onCall<
  CreatePaymentIntentRequest,
  Promise<CreatePaymentIntentResponse>
>(async (request) => {
  const uid = requireAuth(request);
  const { planId, paymentMethod, bank, idempotencyKey } = request.data;

  // Validation
  if (!planId || !MEMBERSHIP_PLANS[planId as keyof typeof MEMBERSHIP_PLANS]) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid plan ID. Choose: silver, gold, or platinum"
    );
  }

  if (!paymentMethod || !["va", "qris"].includes(paymentMethod)) {
    throw new HttpsError(
      "invalid-argument",
      "Payment method must be 'va' or 'qris'"
    );
  }

  if (paymentMethod === "va" && !bank) {
    throw new HttpsError("invalid-argument", "Bank is required for VA payment");
  }

  if (
    paymentMethod === "va" &&
    bank &&
    !["bca", "bni", "mandiri", "bri"].includes(bank)
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid bank. Choose: bca, bni, mandiri, or bri"
    );
  }

  const plan = MEMBERSHIP_PLANS[planId as keyof typeof MEMBERSHIP_PLANS];
  const amount = plan.price;

  // Idempotency check
  const idemKey =
    idempotencyKey || generatePaymentIntentKey(uid, planId, amount);
  const existingResult = await withIdempotency<CreatePaymentIntentResponse>(
    idemKey,
    async () => {
      // Check if user already has active membership
      const userRef = collections.users.doc(uid);
      const userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw new HttpsError("not-found", "User not found");
      }

      const userData = userDoc.data()!;

      // Check active membership
      if (
        userData.member?.status === "active" &&
        userData.member?.expiresAt &&
        userData.member.expiresAt.toMillis() > Date.now()
      ) {
        throw new HttpsError(
          "failed-precondition",
          "Anda sudah memiliki membership aktif. Tunggu hingga membership berakhir untuk upgrade."
        );
      }

      // Create payment record
      const paymentRef = collections.payments.doc();
      const paymentId = paymentRef.id;
      const now = admin.firestore.Timestamp.now();
      const expiry = calculateExpiry();

      // Generate payment details
      let vaNumber: string | undefined;
      let qrisUrl: string | undefined;

      if (paymentMethod === "va" && bank) {
        vaNumber = generateVANumber(bank, uid);
      } else if (paymentMethod === "qris") {
        qrisUrl = generateQRISUrl(paymentId, amount);
      }

      // Generate signature for webhook verification
      const signature = generateSignature(paymentId, amount);

      // Store payment intent
      const paymentData = {
        id: paymentId,
        userId: uid,
        planId,
        planName: plan.name,
        amount,
        method: paymentMethod,
        bank: bank || null,
        vaNumber: vaNumber || null,
        qrisUrl: qrisUrl || null,
        status: "pending" as const,
        signature, // For webhook verification
        createdAt: now,
        expiredAt: admin.firestore.Timestamp.fromDate(expiry),
        paidAt: null,
        metadata: {
          userEmail: userData.email,
          userName: userData.fullName,
          planDuration: plan.durationDays,
          multiplier: plan.multiplier,
        },
      };

      await paymentRef.set(paymentData);

      // Generate instructions
      const instructions = generateInstructions(paymentMethod, bank, vaNumber);

      // Send notification
      try {
        await collections.notifications.add({
          userId: uid,
          title: "Menunggu Pembayaran",
          body: `Selesaikan pembayaran ${
            plan.name
          } sebesar Rp ${amount.toLocaleString("id-ID")} dalam 24 jam`,
          type: "payment_pending",
          read: false,
          data: {
            paymentId,
            planId,
            amount,
            method: paymentMethod,
          },
          createdAt: now,
        });
      } catch (error) {
        console.error("Failed to send notification:", error);
      }

      return {
        success: true,
        paymentId,
        method: paymentMethod,
        amount,
        vaNumber,
        qrisUrl,
        expiredAt: expiry.toISOString(),
        instructions,
      };
    }
  );

  return existingResult;
});
