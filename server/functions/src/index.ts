import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Initialize Firebase Admin
admin.initializeApp();

// Export all function modules
export * from "./payments/createPaymentIntent";
export * from "./payments/webhookPayments";
export * from "./payments/disbursement";

export * from "./pickup/reserveSlot";
export * from "./pickup/assignCourier";
export * from "./pickup/updateTaskStatus";

export * from "./points/redeemToCoupon";
export * from "./points/redeemToBalance";
export * from "./points/ledger";

export * from "./events/redeemCoupon";

export * from "./notifications/sendFcm";
export * from "./notifications/triggers";

export * from "./chat/onMessageWrite";

export * from "./membership/activatePlan";
export * from "./membership/expireWatcher";
