import * as admin from "firebase-admin";
import { https } from "firebase-functions/v2";
import { ErrorMessages } from "./validators";

/**
 * Authentication & Authorization Utilities
 * Handles role-based access control using custom claims
 */

// ============================================
// USER ROLES
// ============================================

export enum UserRole {
  USER = "user",
  COURIER = "courier",
  ADMIN = "admin",
}

export interface CustomClaims {
  roles: string[];
}

// ============================================
// AUTH CONTEXT
// ============================================

export interface AuthContext {
  uid: string;
  email?: string;
  roles: string[];
}

/**
 * Get authenticated user context from request
 */
export async function getAuthContext(
  request: https.CallableRequest
): Promise<AuthContext> {
  if (!request.auth) {
    throw new https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const { uid, token } = request.auth;
  const email = token.email;
  const roles = (token.roles as string[]) || [UserRole.USER];

  return { uid, email, roles };
}

/**
 * Get user ID from request (throws if not authenticated)
 */
export function requireAuth(request: https.CallableRequest): string {
  if (!request.auth) {
    throw new https.HttpsError(
      "unauthenticated",
      ErrorMessages.PERMISSION_DENIED
    );
  }
  return request.auth.uid;
}

// ============================================
// ROLE CHECKS
// ============================================

/**
 * Check if user has specific role
 */
export function hasRole(context: AuthContext, role: UserRole): boolean {
  return context.roles.includes(role);
}

/**
 * Check if user has any of the specified roles
 */
export function hasAnyRole(context: AuthContext, roles: UserRole[]): boolean {
  return roles.some((role) => context.roles.includes(role));
}

/**
 * Check if user has all of the specified roles
 */
export function hasAllRoles(context: AuthContext, roles: UserRole[]): boolean {
  return roles.every((role) => context.roles.includes(role));
}

/**
 * Require specific role (throws if not authorized)
 */
export function requireRole(context: AuthContext, role: UserRole): void {
  if (!hasRole(context, role)) {
    throw new https.HttpsError(
      "permission-denied",
      `User must have ${role} role`
    );
  }
}

/**
 * Require any of the specified roles
 */
export function requireAnyRole(context: AuthContext, roles: UserRole[]): void {
  if (!hasAnyRole(context, roles)) {
    throw new https.HttpsError(
      "permission-denied",
      `User must have one of these roles: ${roles.join(", ")}`
    );
  }
}

/**
 * Check if user is admin
 */
export function isAdmin(context: AuthContext): boolean {
  return hasRole(context, UserRole.ADMIN);
}

/**
 * Check if user is courier
 */
export function isCourier(context: AuthContext): boolean {
  return hasRole(context, UserRole.COURIER);
}

/**
 * Require admin role
 */
export function requireAdmin(context: AuthContext): void {
  requireRole(context, UserRole.ADMIN);
}

/**
 * Require courier role
 */
export function requireCourier(context: AuthContext): void {
  requireRole(context, UserRole.COURIER);
}

// ============================================
// CUSTOM CLAIMS MANAGEMENT
// ============================================

/**
 * Set custom claims for user
 */
export async function setUserRoles(
  uid: string,
  roles: UserRole[]
): Promise<void> {
  const customClaims: CustomClaims = { roles };
  await admin.auth().setCustomUserClaims(uid, customClaims);
}

/**
 * Add role to user
 */
export async function addUserRole(uid: string, role: UserRole): Promise<void> {
  const user = await admin.auth().getUser(uid);
  const currentRoles = (user.customClaims?.roles as string[]) || [];

  if (!currentRoles.includes(role)) {
    const newRoles = [...currentRoles, role];
    await setUserRoles(uid, newRoles);
  }
}

/**
 * Remove role from user
 */
export async function removeUserRole(
  uid: string,
  role: UserRole
): Promise<void> {
  const user = await admin.auth().getUser(uid);
  const currentRoles = (user.customClaims?.roles as string[]) || [];

  const newRoles = currentRoles.filter((r) => r !== role);
  await setUserRoles(uid, newRoles);
}

/**
 * Get user roles
 */
export async function getUserRoles(uid: string): Promise<string[]> {
  const user = await admin.auth().getUser(uid);
  return (user.customClaims?.roles as string[]) || [UserRole.USER];
}

// ============================================
// RESOURCE OWNERSHIP
// ============================================

/**
 * Check if user owns the resource
 */
export function isOwner(context: AuthContext, resourceUid: string): boolean {
  return context.uid === resourceUid;
}

/**
 * Require ownership or admin role
 */
export function requireOwnerOrAdmin(
  context: AuthContext,
  resourceUid: string
): void {
  if (!isOwner(context, resourceUid) && !isAdmin(context)) {
    throw new https.HttpsError(
      "permission-denied",
      "User must be the owner or admin"
    );
  }
}

/**
 * Require ownership
 */
export function requireOwnership(
  context: AuthContext,
  resourceUid: string
): void {
  if (!isOwner(context, resourceUid)) {
    throw new https.HttpsError(
      "permission-denied",
      "User must be the owner of this resource"
    );
  }
}

// ============================================
// USER VERIFICATION
// ============================================

/**
 * Check if user email is verified
 */
export async function isEmailVerified(uid: string): Promise<boolean> {
  const user = await admin.auth().getUser(uid);
  return user.emailVerified;
}

/**
 * Require email verification
 */
export async function requireEmailVerified(uid: string): Promise<void> {
  const verified = await isEmailVerified(uid);
  if (!verified) {
    throw new https.HttpsError("failed-precondition", "Email must be verified");
  }
}

/**
 * Check if user is disabled
 */
export async function isUserDisabled(uid: string): Promise<boolean> {
  const user = await admin.auth().getUser(uid);
  return user.disabled;
}

/**
 * Require user is not disabled
 */
export async function requireUserEnabled(uid: string): Promise<void> {
  const disabled = await isUserDisabled(uid);
  if (disabled) {
    throw new https.HttpsError("permission-denied", "User account is disabled");
  }
}

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Create error response for unauthorized access
 */
export function unauthorizedError(message?: string): https.HttpsError {
  return new https.HttpsError(
    "permission-denied",
    message || ErrorMessages.PERMISSION_DENIED
  );
}

/**
 * Create error response for unauthenticated access
 */
export function unauthenticatedError(message?: string): https.HttpsError {
  return new https.HttpsError(
    "unauthenticated",
    message || "User must be authenticated"
  );
}

/**
 * Validate auth context
 */
export function validateAuthContext(context: AuthContext): void {
  if (!context.uid) {
    throw unauthenticatedError();
  }

  if (!context.roles || context.roles.length === 0) {
    throw new https.HttpsError(
      "internal",
      "User roles not properly configured"
    );
  }
}

// ============================================
// TOKEN VALIDATION
// ============================================

/**
 * Verify ID token and get user
 */
export async function verifyIdToken(
  idToken: string
): Promise<admin.auth.DecodedIdToken> {
  try {
    return await admin.auth().verifyIdToken(idToken);
  } catch (error) {
    throw new https.HttpsError(
      "unauthenticated",
      "Invalid authentication token"
    );
  }
}

/**
 * Get user by UID (throws if not found)
 */
export async function getUserOrThrow(
  uid: string
): Promise<admin.auth.UserRecord> {
  try {
    return await admin.auth().getUser(uid);
  } catch (error) {
    throw new https.HttpsError("not-found", `User with UID ${uid} not found`);
  }
}

// ============================================
// COURIER ASSIGNMENT HELPERS
// ============================================

/**
 * Get available couriers in zone
 */
export async function getAvailableCouriers(zoneId: string): Promise<string[]> {
  // TODO: Implement courier availability logic
  // This should query Firestore for couriers in the zone with availability
  // For now, return mock data
  console.log(`Getting available couriers for zone: ${zoneId}`);
  return [];
}

/**
 * Check if courier is available
 */
export async function isCourierAvailable(courierId: string): Promise<boolean> {
  // TODO: Implement courier availability check
  // Check if courier has active tasks, work hours, etc.
  console.log(`Checking availability for courier: ${courierId}`);
  return true;
}

// ============================================
// ADMIN FUNCTIONS
// ============================================

/**
 * Grant admin role (must be called by existing admin)
 */
export async function grantAdminRole(
  adminContext: AuthContext,
  targetUid: string
): Promise<void> {
  requireAdmin(adminContext);
  await addUserRole(targetUid, UserRole.ADMIN);
}

/**
 * Grant courier role (must be called by admin)
 */
export async function grantCourierRole(
  adminContext: AuthContext,
  targetUid: string
): Promise<void> {
  requireAdmin(adminContext);
  await addUserRole(targetUid, UserRole.COURIER);
}

/**
 * Revoke admin role (must be called by existing admin)
 */
export async function revokeAdminRole(
  adminContext: AuthContext,
  targetUid: string
): Promise<void> {
  requireAdmin(adminContext);

  // Prevent self-revocation
  if (adminContext.uid === targetUid) {
    throw new https.HttpsError(
      "invalid-argument",
      "Cannot revoke your own admin role"
    );
  }

  await removeUserRole(targetUid, UserRole.ADMIN);
}

/**
 * Revoke courier role (must be called by admin)
 */
export async function revokeCourierRole(
  adminContext: AuthContext,
  targetUid: string
): Promise<void> {
  requireAdmin(adminContext);
  await removeUserRole(targetUid, UserRole.COURIER);
}
