import "okeno-schema-markers";

@icon("/iconify/mdi/credit-card-check-outline.svg")
@event("29246fa0-b197-470a-8f05-82dfe5d8b807", source:"/checkouts")
model CheckoutStarted {
  checkout: Checkout;
}

@icon("/iconify/mdi/account-check-outline.svg")
@event("baa0bbc6-6cb1-4fa5-811e-1dc8dd9613b5", source:"/checkouts")
model CustomerDetailsProvided {
  checkoutId: string;
}

@icon("/iconify/mdi/truck-check-outline.svg")
@event("fd5eb3c5-d61d-4179-a6e4-f90fa50fd6e8", source:"/checkouts")
model DeliveryOptionSelected {
  checkoutId: string;
  deliveryOption: DeliveryOption;
}

@icon("/iconify/mdi/check-circle-outline.svg")
@event("64077add-17fe-4bda-b55c-4e18e5a0c84d", source:"/checkouts")
model CheckoutCompleted {
  checkoutId: string;
  orderReference: string;
}
