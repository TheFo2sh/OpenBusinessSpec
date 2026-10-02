import "okeno-schema-markers";

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

@rest(Post, "/payments/authorize")
@command("ef7b0381-f566-48da-ba84-f256e25180d7")
@icon("/iconify/mdi/credit-card-check-outline.svg")
model AuthorizePayment {
  input: {
    paymentId: string;
    paymentMethod: PaymentMethod;
  };
  output: {
    payment: Payment;
  };
}

@rest(Post, "/payments/capture")
@command("331ba015-d5f3-4417-992a-c49f107b8816")
@icon("/iconify/mdi/cash-check.svg")
model CapturePayment {
  input: {
    paymentId: string;
    amount?: int64;
  };
  output: {
    payment: Payment;
  };
}

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