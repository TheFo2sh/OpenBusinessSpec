import "okeno-schema-markers";

// PaymentService's facts.

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

@icon("/iconify/mdi/credit-card-off-outline.svg")
@event("6469b0fc-70bb-4899-9329-febcf08311a1", source:"/payments")
model PaymentFailed {
  payment: Payment;
  attempt: PaymentAttempt;
}

@icon("/iconify/mdi/cash-check.svg")
@event("642d83f0-a683-4d16-a851-52ea7bc4e415", source:"/payments")
model PaymentCaptured {
  payment: Payment;
  amount: int64;
}

@icon("/iconify/mdi/credit-card-remove-outline.svg")
@event("d318b2af-31cf-40a7-a8d3-e6a914bed26b", source:"/payments")
model PaymentCanceled {
  payment: Payment;
  reason?: PaymentCancellationReason;
}

@icon("/iconify/mdi/cash-refund.svg")
@event("aed10c8f-f3e2-47b3-bf06-8b19b683fb83", source:"/refunds")
model RefundRequested {
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

// PaymentProvider's facts.

@icon("/iconify/mdi/bank-check.svg")
@event("fad8c998-8ec9-4c29-b7e5-e5304ae24468", source:"/charges")
model ChargeAuthorized {
  charge: Charge;
}

@icon("/iconify/mdi/bank-off.svg")
@event("499b4002-fc13-4c94-a36b-efebf04b5f4d", source:"/charges")
model ChargeDeclined {
  charge: Charge;
  declineReason?: string;
}

@icon("/iconify/mdi/bank-transfer-in.svg")
@event("44cdb9a1-e229-45ee-a979-a2040cfb7a0f", source:"/charges")
model ChargeCaptured {
  charge: Charge;
  amount: int64;
}

@icon("/iconify/mdi/bank-transfer-out.svg")
@event("c2a7ba82-9886-45cb-b944-32f2d2b5417d", source:"/charges")
model ChargeRefunded {
  charge: Charge;
  refundId: string;
  amount: int64;
}

@icon("/iconify/mdi/bank-minus.svg")
@event("f5f255f5-16a1-4953-8b8f-52403fff4830", source:"/charges")
model RefundDeclined {
  charge: Charge;
  refundId: string;
  declineReason?: string;
}

@icon("/iconify/mdi/bank-remove.svg")
@event("0fd9ffe9-83bc-41c7-b386-ff919ce9781f", source:"/charges")
model AuthorizationVoided {
  charge: Charge;
}
