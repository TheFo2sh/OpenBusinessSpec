import "okeno-schema-markers";

// PaymentService: the payment's own record. It records what the payer asks
// for and, through policies, what the payment provider answered.

/** The payer starts paying for an order. */
@rest(Post, "/payments")
@command("c71e54e6-9bc2-4650-809d-a2ec8774166f")
@icon("/iconify/mdi/credit-card-plus-outline.svg")
model InitiatePayment {
  input: {
    amount: int64;
    currency: string;
    orderReference?: string;
    paymentMethod?: PaymentMethod;
  };
  output: {
    payment: Payment;
  };
}

/** Records the provider's answer to an authorization: the payment is authorized, or it failed. */
@rest(Post, "/payments/record-authorization")
@command("ab32ebe2-ce99-4cdc-8e5c-54906baf150e")
@icon("/iconify/mdi/credit-card-check-outline.svg")
model RecordAuthorization {
  input: {
    paymentId: string;
    charge: Charge;
  };
  output: {
    payment: Payment;
  };
}

/** Records that the provider captured the authorized money. */
@rest(Post, "/payments/record-capture")
@command("f20d3817-8b18-4b0d-85ee-0887022ad649")
@icon("/iconify/mdi/cash-check.svg")
model RecordCapture {
  input: {
    paymentId: string;
    charge: Charge;
  };
  output: {
    payment: Payment;
  };
}

/** Cancels a payment that was never completed. */
@rest(Post, "/payments/cancel")
@command("80a18fd4-96c5-478f-a61c-fd64ea24fb32")
@icon("/iconify/mdi/credit-card-remove-outline.svg")
model CancelPayment {
  input: {
    paymentId: string;
    reason?: PaymentCancellationReason;
  };
  output: {
    payment: Payment;
  };
}

/** The payer asks for money back on a captured payment. */
@rest(Post, "/payments/refund")
@command("14acfab0-aa76-431f-a754-c276b43cd742")
@icon("/iconify/mdi/cash-refund.svg")
model RefundPayment {
  input: {
    paymentId: string;
    amount?: int64;
    reason?: RefundReason;
  };
  output: {
    refund: Refund;
    payment: Payment;
  };
}

/** Records the provider's answer to a refund: it succeeded, or it failed. */
@rest(Post, "/refunds/record-result")
@command("81859837-4af9-4862-b1f7-3aabdd55d31a")
@icon("/iconify/mdi/cash-sync.svg")
model RecordRefund {
  input: {
    refundId: string;
    charge: Charge;
  };
  output: {
    refund: Refund;
  };
}

/** Where a payment stands, for the payer. */
@readModel
@rest(Get, "/payments/{paymentId}")
@command("2dd8484e-40ac-4983-ad4c-7e4410f49c66")
@icon("/iconify/mdi/credit-card-search-outline.svg")
model ViewPaymentStatus {
  input: {
    paymentId: string;
  };
  output: {
    payment: Payment;
  };
}

/** The payments started but never completed - what the nightly sweep cancels. */
@readModel
@rest(Get, "/payments/abandoned")
@command("b190502f-6d8c-4039-bcb9-51a63c3e1f78")
@icon("/iconify/mdi/credit-card-clock-outline.svg")
model ListAbandonedPayments {
  input: {
    olderThanHours?: int32;
  };
  output: {
    payments: Payment[];
  };
}

// PaymentProvider: the provider's own record of the charges it holds. It
// records its own answers; the payment service never records them for it.

/** The provider authorizes a charge on the payment method. */
@rest(Post, "/charges/authorize")
@command("c8145aa6-09fd-44dd-9178-f6b22858b6bc")
@icon("/iconify/mdi/bank-check.svg")
model AuthorizeCharge {
  input: {
    paymentId: string;
    amount: int64;
    currency: string;
    paymentMethod?: PaymentMethod;
  };
  output: {
    charge: Charge;
  };
}

/** The provider takes the authorized money. */
@rest(Post, "/charges/capture")
@command("ae26bb25-83f7-422c-b75c-d294cd7e5b5a")
@icon("/iconify/mdi/bank-transfer-in.svg")
model CaptureCharge {
  input: {
    chargeId: string;
    amount?: int64;
  };
  output: {
    charge: Charge;
  };
}

/** The provider pays money of a captured charge back. */
@rest(Post, "/charges/refund")
@command("9a8468d1-9b9b-48dd-a4fe-c6d396666a36")
@icon("/iconify/mdi/bank-transfer-out.svg")
model RefundCharge {
  input: {
    chargeId: string;
    refundId: string;
    amount: int64;
  };
  output: {
    charge: Charge;
  };
}

/** The provider releases an authorization that will never be captured. */
@rest(Post, "/charges/void")
@command("87bb4d5e-855b-4889-bddf-899bfb83e87e")
@icon("/iconify/mdi/bank-remove.svg")
model VoidAuthorization {
  input: {
    chargeId: string;
  };
  output: {
    charge: Charge;
  };
}
