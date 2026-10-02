import "okeno-schema-markers";

@rest(Post, "/payments")
@command("c71e54e6-9bc2-4650-809d-a2ec8774166f")
@icon("/iconify/mdi/credit-card-plus-outline.svg")
model CreatePayment {
  input: {
    amount: int64;
    currency: string;
    paymentMethod?: PaymentMethod;
    captureMethod?: CaptureMethod;
    confirmationMethod?: ConfirmationMethod;
    description?: string;
  };
  computed: {
  };
  output: {
    payment: Payment;
  };
  context: {
  };
}

@rest(Post, "/confirm-payment")
@command("ef7b0381-f566-48da-ba84-f256e25180d7")
@icon("/iconify/mdi/credit-card-check-outline.svg")
model ConfirmPayment {
  input: {
    payment: Payment;
    paymentMethod?: PaymentMethod;
  };
  computed: {
  };
  output: {
    payment: Payment;
  };
  context: {
  };
}

@rest(Post, "/capture-payment")
@command("331ba015-d5f3-4417-992a-c49f107b8816")
@icon("/iconify/mdi/cash-check.svg")
model CapturePayment {
  input: {
    payment: Payment;
    amount?: int64;
  };
  computed: {
  };
  output: {
    payment: Payment;
  };
  context: {
  };
}

@rest(Post, "/cancel-payment")
@command("80a18fd4-96c5-478f-a61c-fd64ea24fb32")
@icon("/iconify/mdi/credit-card-remove-outline.svg")
model CancelPayment {
  input: {
    payment: Payment;
    reason?: PaymentCancellationReason;
  };
  computed: {
  };
  output: {
    payment: Payment;
  };
  context: {
  };
}

@rest(Post, "/refund-payment")
@command("14acfab0-aa76-431f-a754-c276b43cd742")
@icon("/iconify/mdi/cash-refund.svg")
model RefundPayment {
  input: {
    payment: Payment;
    amount?: int64;
    reason?: RefundReason;
  };
  computed: {
  };
  output: {
    refund: Refund;
    payment: Payment;
  };
  context: {
  };
}