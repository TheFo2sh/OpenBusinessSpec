import "okeno-schema-markers";

@workObject("8bada9b5-2643-40b9-b887-56059b777614")
@icon("/iconify/mdi/truck-delivery-outline.svg")
model Fulfillment {
  orderReference: string;
  lines: FulfillmentLine[];
  status: FulfillmentStatus;
  carrier?: string;
  trackingNumber?: string;
  shippedAt?: utcDateTime;
  deliveredAt?: utcDateTime;
}

@workObject("4cde87dc-238e-4df6-9d69-5f214849dc28")
@icon("/iconify/mdi/package-variant-closed.svg")
model FulfillmentLine {
  orderLineReference: string;
  quantity: int32;
}

enum FulfillmentStatus {
  Preparing: "preparing",
  Shipped: "shipped",
  Delivered: "delivered",
  Canceled: "canceled",
}

enum FulfillmentCancellationReason {
  OrderCanceled: "order_canceled",
  UnableToFulfill: "unable_to_fulfill",
  Other: "other",
}
