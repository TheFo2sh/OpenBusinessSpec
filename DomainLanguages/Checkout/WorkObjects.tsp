import "okeno-schema-markers";

@workObject("502bc0d4-0147-4557-8d6e-e648915774e6")
@icon("/iconify/mdi/credit-card-check-outline.svg")
model Checkout {
  cartReference: string;
  email?: string;
  shippingAddress?: PostalAddress;
  billingAddress?: PostalAddress;
  deliveryOption?: DeliveryOption;
  totalAmount: int64;
  currency: string;
  status: CheckoutStatus;
}

@workObject("6d7beb85-381a-46dc-9997-7827be2cbf6c")
@icon("/iconify/mdi/map-marker-outline.svg")
model PostalAddress {
  recipient: string;
  addressLine1: string;
  addressLine2?: string;
  city: string;
  region?: string;
  postalCode?: string;
  country: string;
}

@workObject("1cd112dc-efcd-43cc-8b5e-ffb528df64d3")
@icon("/iconify/mdi/truck-outline.svg")
model DeliveryOption {
  name: string;
  amount: int64;
  estimatedDelivery?: string;
}

enum CheckoutStatus {
  InProgress: "in_progress",
  Completed: "completed",
  Expired: "expired",
}
