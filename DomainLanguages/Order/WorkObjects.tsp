import "okeno-schema-markers";

@workObject("21e58e27-7cc8-4d43-ada6-1438017373f6")
@icon("/iconify/mdi/clipboard-list-outline.svg")
model Order {
  orderNumber: string;
  customerReference?: string;
  lines: OrderLine[];
  shippingAddress: OrderAddress;
  totalAmount: int64;
  currency: string;
  status: OrderStatus;
  placedAt: utcDateTime;
}

@workObject("0c44acd4-9f0f-4f7a-8054-df208f558e96")
@icon("/iconify/mdi/package-variant-closed.svg")
model OrderLine {
  productReference: string;
  variantReference: string;
  productTitle: string;
  sku?: string;
  quantity: int32;
  unitPrice: int64;
}

@workObject("537e4f2e-16bd-4f82-a804-3d71923fa230")
@icon("/iconify/mdi/map-marker-outline.svg")
model OrderAddress {
  recipient: string;
  addressLine1: string;
  addressLine2?: string;
  city: string;
  region?: string;
  postalCode?: string;
  country: string;
}

enum OrderStatus {
  Open: "open",
  Canceled: "canceled",
  Closed: "closed",
}

enum OrderCancellationReason {
  RequestedByCustomer: "requested_by_customer",
  PaymentFailed: "payment_failed",
  OutOfStock: "out_of_stock",
  Other: "other",
}
