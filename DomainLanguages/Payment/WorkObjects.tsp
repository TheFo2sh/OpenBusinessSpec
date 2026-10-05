import "okeno-schema-markers";

@workObject("ae237997-1113-4fd8-89c7-0f1114136289")
@icon("/iconify/mdi/credit-card-clock-outline.svg")
model Payment {
  amount: int64;
  currency: string;
  status: PaymentStatus;
  orderReference?: string;
  paymentMethod?: PaymentMethod;
  attempts: PaymentAttempt[];
  capturedAmount: int64;
  cancellationReason?: PaymentCancellationReason;
}

@workObject("b15cf9e9-7f21-4e79-bb67-cf2ffcfd1993")
@icon("/iconify/mdi/credit-card-outline.svg")
model PaymentMethod {
  type: PaymentMethodType;
  displayName?: string;
}

@workObject("09fe9f5c-2b0a-4341-8001-8c7e0a9679da")
@icon("/iconify/mdi/swap-horizontal-circle-outline.svg")
model PaymentAttempt {
  paymentId: string;
  amount: int64;
  currency: string;
  paymentMethod?: PaymentMethodType;
  status: PaymentAttemptStatus;
  attemptedAt: utcDateTime;
}

@workObject("faff01fc-36df-4686-b3a2-0178197c1649")
@icon("/iconify/mdi/cash-refund.svg")
model Refund {
  paymentId: string;
  amount: int64;
  currency: string;
  status: RefundStatus;
  reason?: RefundReason;
}

/** The provider's own record of an authorization on a payment method - what it authorizes, captures, refunds and voids. */
@workObject("94a987cf-1edc-4570-bd49-0f924f4a3672")
@icon("/iconify/mdi/bank-outline.svg")
model Charge {
  paymentId: string;
  providerReference: string;
  amount: int64;
  currency: string;
  capturedAmount: int64;
  refundedAmount: int64;
  status: ChargeStatus;
}

enum ChargeStatus {
  Authorized: "authorized",
  Declined: "declined",
  Captured: "captured",
  PartiallyRefunded: "partially_refunded",
  Refunded: "refunded",
  Voided: "voided",
}

enum PaymentStatus {
  Pending: "pending",
  Authorized: "authorized",
  Captured: "captured",
  PartiallyRefunded: "partially_refunded",
  Refunded: "refunded",
  Failed: "failed",
  Canceled: "canceled",
}

enum PaymentCancellationReason {
  RequestedByPayer: "requested_by_payer",
  Duplicate: "duplicate",
  Fraud: "fraud",
}

enum PaymentMethodType {
  Card: "card",
  BankAccount: "bank_account",
  Wallet: "wallet",
  Cash: "cash",
  BuyNowPayLater: "buy_now_pay_later",
  Other: "other",
}

enum PaymentAttemptStatus {
  Succeeded: "succeeded",
  Pending: "pending",
  Failed: "failed",
}

enum RefundStatus {
  Pending: "pending",
  Succeeded: "succeeded",
  Failed: "failed",
}

enum RefundReason {
  Duplicate: "duplicate",
  Fraud: "fraud",
  RequestedByPayer: "requested_by_payer",
}