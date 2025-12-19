/**
 * Validators & Input Validation Utilities
 */

// ============================================
// STATUS ENUMS
// ============================================

export enum PickupRequestStatus {
  REQUESTED = "requested",
  CONFIRMED = "confirmed",
  ASSIGNED = "assigned",
  DONE = "done",
  CANCELED = "canceled",
}

export enum PickupTaskStatus {
  ASSIGNED = "assigned",
  ON_THE_WAY = "on_the_way",
  ARRIVED = "arrived",
  PICKED_UP = "picked_up",
  COMPLETED = "completed",
}

export enum CouponStatus {
  ACTIVE = "active",
  USED = "used",
  EXPIRED = "expired",
}

export enum RedeemRequestStatus {
  PENDING = "pending",
  COMPLETED = "completed",
  FAILED = "failed",
}

export enum MembershipStatus {
  NONE = "none",
  ACTIVE = "active",
  EXPIRED = "expired",
}

export enum PaymentStatus {
  PENDING = "pending",
  PAID = "paid",
  FAILED = "failed",
  EXPIRED = "expired",
}

// ============================================
// WASTE CATEGORIES
// ============================================

export const WASTE_CATEGORIES = [
  "plastic",
  "glass",
  "can",
  "cardboard",
  "fabric",
  "ceramicStone",
] as const;

export type WasteCategory = (typeof WASTE_CATEGORIES)[number];

/**
 * Validate waste category
 */
export function isValidWasteCategory(
  category: string
): category is WasteCategory {
  return WASTE_CATEGORIES.includes(category as WasteCategory);
}

// ============================================
// STATUS VALIDATION
// ============================================

/**
 * Validate pickup request status
 */
export function isValidPickupRequestStatus(
  status: string
): status is PickupRequestStatus {
  return Object.values(PickupRequestStatus).includes(
    status as PickupRequestStatus
  );
}

/**
 * Validate pickup task status
 */
export function isValidPickupTaskStatus(
  status: string
): status is PickupTaskStatus {
  return Object.values(PickupTaskStatus).includes(status as PickupTaskStatus);
}

/**
 * Validate status transition for pickup tasks
 */
export function isValidTaskStatusTransition(
  currentStatus: PickupTaskStatus,
  newStatus: PickupTaskStatus
): boolean {
  const validTransitions: Record<PickupTaskStatus, PickupTaskStatus[]> = {
    [PickupTaskStatus.ASSIGNED]: [PickupTaskStatus.ON_THE_WAY],
    [PickupTaskStatus.ON_THE_WAY]: [PickupTaskStatus.ARRIVED],
    [PickupTaskStatus.ARRIVED]: [PickupTaskStatus.PICKED_UP],
    [PickupTaskStatus.PICKED_UP]: [PickupTaskStatus.COMPLETED],
    [PickupTaskStatus.COMPLETED]: [], // Final state
  };

  return validTransitions[currentStatus]?.includes(newStatus) ?? false;
}

/**
 * Validate coupon status
 */
export function isValidCouponStatus(status: string): status is CouponStatus {
  return Object.values(CouponStatus).includes(status as CouponStatus);
}

// ============================================
// INPUT VALIDATION
// ============================================

/**
 * Validate email format
 */
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Validate phone number (Indonesian format)
 */
export function isValidPhone(phone: string): boolean {
  const phoneRegex = /^(^\+62|62|^08)(\d{8,11})$/;
  return phoneRegex.test(phone.replace(/[^\d+]/g, ""));
}

/**
 * Validate UID format
 */
export function isValidUid(uid: string): boolean {
  return typeof uid === "string" && uid.length > 0 && uid.length <= 128;
}

/**
 * Validate positive number
 */
export function isPositiveNumber(value: number): boolean {
  return typeof value === "number" && value > 0 && !isNaN(value);
}

/**
 * Validate non-negative number
 */
export function isNonNegativeNumber(value: number): boolean {
  return typeof value === "number" && value >= 0 && !isNaN(value);
}

/**
 * Validate integer
 */
export function isInteger(value: number): boolean {
  return Number.isInteger(value);
}

/**
 * Validate date is in future
 */
export function isFutureDate(date: Date): boolean {
  return date.getTime() > Date.now();
}

/**
 * Validate date is in past
 */
export function isPastDate(date: Date): boolean {
  return date.getTime() < Date.now();
}

/**
 * Validate coordinates
 */
export function isValidCoordinates(lat: number, lng: number): boolean {
  return (
    typeof lat === "number" &&
    typeof lng === "number" &&
    lat >= -90 &&
    lat <= 90 &&
    lng >= -180 &&
    lng <= 180
  );
}

/**
 * Validate PIN (6 digits)
 */
export function isValidPIN(pin: string): boolean {
  return /^\d{6}$/.test(pin);
}

/**
 * Validate OTP (6 digits)
 */
export function isValidOTP(otp: string): boolean {
  return /^\d{6}$/.test(otp);
}

/**
 * Validate postal code (Indonesian, 5 digits)
 */
export function isValidPostalCode(postalCode: string): boolean {
  return /^\d{5}$/.test(postalCode);
}

// ============================================
// BUSINESS LOGIC VALIDATION
// ============================================

/**
 * Validate pickup quantities
 */
export function isValidPickupQuantities(
  quantities: Record<string, number>
): boolean {
  if (!quantities || typeof quantities !== "object") return false;

  const categories = Object.keys(quantities);
  if (categories.length === 0) return false;

  // All categories must be valid
  if (!categories.every((cat) => isValidWasteCategory(cat))) return false;

  // All quantities must be positive integers
  return Object.values(quantities).every(
    (qty) => isPositiveNumber(qty) && isInteger(qty)
  );
}

/**
 * Validate points value
 */
export function isValidPointsValue(points: number): boolean {
  return isNonNegativeNumber(points) && points <= 1000000; // Max 1M points
}

/**
 * Validate coupon quantity
 */
export function isValidCouponQuantity(quantity: number): boolean {
  return isPositiveNumber(quantity) && isInteger(quantity) && quantity <= 100;
}

/**
 * Validate cashout amount
 */
export function isValidCashoutAmount(amount: number): boolean {
  return (
    isPositiveNumber(amount) &&
    amount >= 10000 && // Min 10K IDR
    amount <= 10000000 // Max 10M IDR
  );
}

/**
 * Validate membership plan ID
 */
export function isValidPlanId(planId: string): boolean {
  const validPlans = ["basic", "silver", "gold", "platinum"];
  return validPlans.includes(planId);
}

/**
 * Validate payment method type
 */
export function isValidPaymentMethodType(type: string): boolean {
  return ["bank", "ewallet"].includes(type);
}

/**
 * Validate payment provider
 */
export function isValidPaymentProvider(
  provider: string,
  type: string
): boolean {
  const bankProviders = ["BCA", "Mandiri", "BNI", "BRI", "CIMB"];
  const ewalletProviders = ["GoPay", "OVO", "DANA", "ShopeePay", "LinkAja"];

  if (type === "bank") {
    return bankProviders.includes(provider);
  } else if (type === "ewallet") {
    return ewalletProviders.includes(provider);
  }

  return false;
}

// ============================================
// REQUIRED FIELDS VALIDATION
// ============================================

/**
 * Check if required fields are present
 */
export function hasRequiredFields<T extends object>(
  obj: T,
  requiredFields: (keyof T)[]
): boolean {
  return requiredFields.every((field) => {
    const value = obj[field];
    return value !== undefined && value !== null && value !== "";
  });
}

/**
 * Validate pickup request data
 */
export function validatePickupRequestData(data: any): {
  valid: boolean;
  errors: string[];
} {
  const errors: string[] = [];

  if (!isValidUid(data.uid)) {
    errors.push("Invalid user ID");
  }

  if (!data.addressId || typeof data.addressId !== "string") {
    errors.push("Invalid address ID");
  }

  if (!data.date || !(data.date instanceof Date)) {
    errors.push("Invalid date");
  }

  if (!data.slotId || typeof data.slotId !== "string") {
    errors.push("Invalid slot ID");
  }

  if (!isValidPickupQuantities(data.quantities)) {
    errors.push("Invalid quantities");
  }

  if (!isNonNegativeNumber(data.estPoints)) {
    errors.push("Invalid estimated points");
  }

  if (!isPositiveNumber(data.estWeightKg)) {
    errors.push("Invalid estimated weight");
  }

  return {
    valid: errors.length === 0,
    errors,
  };
}

/**
 * Validate redeem request data
 */
export function validateRedeemRequestData(data: any): {
  valid: boolean;
  errors: string[];
} {
  const errors: string[] = [];

  if (!isValidUid(data.uid)) {
    errors.push("Invalid user ID");
  }

  if (!["coupon", "balance"].includes(data.type)) {
    errors.push("Invalid redeem type");
  }

  if (data.type === "coupon") {
    if (!isValidCouponQuantity(data.qtyCoupons)) {
      errors.push("Invalid coupon quantity");
    }
  } else if (data.type === "balance") {
    if (!isValidCashoutAmount(data.amount)) {
      errors.push("Invalid cashout amount");
    }
    if (!data.destMethodId || typeof data.destMethodId !== "string") {
      errors.push("Invalid destination payment method");
    }
  }

  if (!isValidPointsValue(data.pointsDeducted)) {
    errors.push("Invalid points value");
  }

  return {
    valid: errors.length === 0,
    errors,
  };
}

// ============================================
// SANITIZATION
// ============================================

/**
 * Sanitize string input
 */
export function sanitizeString(input: string): string {
  return input.trim().replace(/[<>]/g, "");
}

/**
 * Sanitize phone number
 */
export function sanitizePhone(phone: string): string {
  // Remove all non-digit characters except +
  return phone.replace(/[^\d+]/g, "");
}

/**
 * Normalize phone to E.164 format (+62xxx)
 */
export function normalizePhone(phone: string): string {
  const cleaned = sanitizePhone(phone);

  if (cleaned.startsWith("+62")) {
    return cleaned;
  } else if (cleaned.startsWith("62")) {
    return `+${cleaned}`;
  } else if (cleaned.startsWith("0")) {
    return `+62${cleaned.substring(1)}`;
  }

  return `+62${cleaned}`;
}

// ============================================
// ERROR MESSAGES
// ============================================

export const ErrorMessages = {
  INVALID_INPUT: "Invalid input data",
  INVALID_UID: "Invalid user ID",
  INVALID_EMAIL: "Invalid email format",
  INVALID_PHONE: "Invalid phone number",
  INVALID_COORDINATES: "Invalid coordinates",
  INVALID_STATUS: "Invalid status",
  INVALID_TRANSITION: "Invalid status transition",
  INVALID_QUANTITIES: "Invalid pickup quantities",
  INVALID_POINTS: "Invalid points value",
  INVALID_AMOUNT: "Invalid amount",
  INVALID_PIN: "Invalid PIN format",
  INVALID_OTP: "Invalid OTP format",
  REQUIRED_FIELD: "Required field is missing",
  PERMISSION_DENIED: "Permission denied",
  RESOURCE_NOT_FOUND: "Resource not found",
  RESOURCE_ALREADY_EXISTS: "Resource already exists",
  INSUFFICIENT_BALANCE: "Insufficient points balance",
  SLOT_FULL: "Pickup slot is full",
  SLOT_EXPIRED: "Pickup slot has expired",
  COUPON_ALREADY_USED: "Coupon has already been used",
  COUPON_EXPIRED: "Coupon has expired",
  PAYMENT_FAILED: "Payment failed",
  OPERATION_FAILED: "Operation failed",
};
