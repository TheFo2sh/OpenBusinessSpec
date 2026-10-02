import "okeno-schema-markers";

/**

 * A request to collect a specific monetary amount from a payer,

 * tracked from creation through authorization, capture, cancellation,

 * or failure.

 *

 * Stripe compatibility: PaymentIntent

 */

@workObject("ae237997-1113-4fd8-89c7-0f1114136289")
@icon("/iconify/mdi/credit-card-clock-outline.svg")
model Payment {
  amount: int64;
  currency: string;
  status: PaymentStatus;
  captureMethod: CaptureMethod;
  confirmationMethod: ConfirmationMethod;
  amountCapturable: int64;
  amountReceived: int64;
  paymentMethod?: PaymentMethod;
  description?: string;
  cancellationReason?: PaymentCancellationReason;
  canceledAt?: utcDateTime;
}

/**

 * A means by which a payer can provide funds for a payment.

 *

 * Stripe compatibility: PaymentMethod

 */

@workObject("b15cf9e9-7f21-4e79-bb67-cf2ffcfd1993")
@icon("/iconify/mdi/credit-card-outline.svg")
model PaymentMethod {
  type: PaymentMethodType;
  billingDetails?: BillingDetails;
  redisplay?: PaymentMethodRedisplay;
}

/**

 * An execution attempt made against a payment using a payment method.

 *

 * A payment can have more than one attempt during its lifecycle.

 *

 * Stripe compatibility: Charge

 */

@workObject("09fe9f5c-2b0a-4341-8001-8c7e0a9679da")
@icon("/iconify/mdi/swap-horizontal-circle-outline.svg")
model PaymentAttempt {
  payment: Payment;
  paymentMethod?: PaymentMethod;
  amount: int64;
  currency: string;
  amountCaptured: int64;
  amountRefunded: int64;
  captured: boolean;
  paid: boolean;
  status: PaymentAttemptStatus;
  failureCode?: string;
  failureMessage?: string;
}

/**

 * A return of all or part of funds previously collected for a payment.

 *

 * Stripe compatibility: Refund

 */

@workObject("faff01fc-36df-4686-b3a2-0178197c1649")
@icon("/iconify/mdi/cash-refund.svg")
model Refund {
  payment: Payment;
  paymentAttempt?: PaymentAttempt;
  amount: int64;
  currency: string;
  status: RefundStatus;
  reason?: RefundReason;
  failureReason?: string;
}

@workObject("2b8b8845-fda0-4c9e-918c-69aa270ba864")
model BillingDetails {
  name?: string;
  email?: string;
  phone?: string;
  address?: BillingAddress;
}

@workObject("1e51af85-5d7e-406b-9ec6-2b4f41c778f3")
model BillingAddress {
  line1?: string;
  line2?: string;
  city?: string;
  state?: string;
  postalCode?: string;
  country?: string;
}

enum PaymentStatus {
  RequiresPaymentMethod: "requires_payment_method",
  RequiresConfirmation: "requires_confirmation",
  RequiresAction: "requires_action",
  Processing: "processing",
  RequiresCapture: "requires_capture",
  Succeeded: "succeeded",
  Canceled: "canceled",
}

enum CaptureMethod {
  Automatic: "automatic",
  AutomaticAsync: "automatic_async",
  Manual: "manual",
}

enum ConfirmationMethod {
  Automatic: "automatic",
  Manual: "manual",
}

enum PaymentCancellationReason {
  Abandoned: "abandoned",
  Automatic: "automatic",
  Duplicate: "duplicate",
  Expired: "expired",
  FailedInvoice: "failed_invoice",
  Fraudulent: "fraudulent",
  RequestedByCustomer: "requested_by_customer",
  VoidInvoice: "void_invoice",
}

enum PaymentMethodRedisplay {
  Always: "always",
  Limited: "limited",
  Unspecified: "unspecified",
}

enum PaymentMethodType {
  Card: "card",
  CardPresent: "card_present",
  BankDebit: "bank_debit",
  BankRedirect: "bank_redirect",
  BankTransfer: "bank_transfer",
  Wallet: "wallet",
  BuyNowPayLater: "buy_now_pay_later",
  CashBased: "cash_based",
  Other: "other",
}

enum PaymentAttemptStatus {
  Succeeded: "succeeded",
  Pending: "pending",
  Failed: "failed",
}

enum RefundStatus {
  Pending: "pending",
  RequiresAction: "requires_action",
  Succeeded: "succeeded",
  Failed: "failed",
  Canceled: "canceled",
}

enum RefundReason {
  Duplicate: "duplicate",
  Fraudulent: "fraudulent",
  RequestedByCustomer: "requested_by_customer",
}