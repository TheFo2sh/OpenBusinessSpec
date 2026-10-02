import "okeno-schema-markers";

@rest(Post, "/checkouts")
@command("863616a6-d002-4f84-8da2-a7be5214f0b5")
@icon("/iconify/mdi/credit-card-check-outline.svg")
model BeginCheckout {
  input: {
    cartReference: string;
  };
  output: {
    checkout: Checkout;
  };
}

@rest(Patch, "/checkouts/contact")
@command("e7f2382e-b0a8-4879-80ea-9d186f513f61")
@icon("/iconify/mdi/account-edit-outline.svg")
model ProvideCustomerDetails {
  input: {
    checkoutId: string;
    email: string;
    shippingAddress: PostalAddress;
    billingAddress?: PostalAddress;
  };
  output: {
    checkout: Checkout;
  };
}

@rest(Patch, "/checkouts/delivery")
@command("3cc79c5f-be9d-4c88-b56f-c1f1be18d004")
@icon("/iconify/mdi/truck-check-outline.svg")
model SelectDeliveryOption {
  input: {
    checkoutId: string;
    deliveryOption: DeliveryOption;
  };
  output: {
    checkout: Checkout;
  };
}

@rest(Post, "/checkouts/complete")
@command("138cc015-d1e5-4ae1-a323-7812e202f0e1")
@icon("/iconify/mdi/check-circle-outline.svg")
model CompleteCheckout {
  input: {
    checkoutId: string;
  };
  output: {
    orderReference: string;
  };
}
