import "okeno-schema-markers";

@icon("/iconify/mdi/credit-card-plus-outline.svg")
@event("8554aee7-4e7c-4e08-83a5-b96d678ff79e", source:"/payments")
model PaymentCreated {
  payment: Payment;
}

@icon("/iconify/mdi/credit-card-check-outline.svg")
@event("1a690fc3-1154-4217-a046-b6261c466f95", source:"/payments")
model PaymentAuthorized {
  payment: Payment;
}

@icon("/iconify/mdi/cash-check.svg")
@event("642d83f0-a683-4d16-a851-52ea7bc4e415", source:"/payments")
model PaymentCaptured {
  payment: Payment;
  amount: int64;
}

@icon("/iconify/mdi/credit-card-off-outline.svg")
@event("6469b0fc-70bb-4899-9329-febcf08311a1", source:"/payments")
model PaymentFailed {
  payment: Payment;
  attempt: PaymentAttempt;
}

@icon("/iconify/mdi/credit-card-remove-outline.svg")
@event("d318b2af-31cf-40a7-a8d3-e6a914bed26b", source:"/payments")
model PaymentCanceled {
  payment: Payment;
  reason?: PaymentCancellationReason;
}

@icon("/iconify/mdi/cash-refund.svg")
@event("aed10c8f-f3e2-47b3-bf06-8b19b683fb83", source:"/refunds")
model RefundCreated {
  refund: Refund;
}

@icon("/iconify/mdi/cash-check.svg")
@event("2249075a-6f33-42db-b409-b08f23842faf", source:"/refunds")
model RefundSucceeded {
  refund: Refund;
}

@icon("/iconify/mdi/cash-remove.svg")
@event("a56fc404-1b75-4551-a56a-84cf28910d42", source:"/refunds")
model RefundFailed {
  refund: Refund;
}