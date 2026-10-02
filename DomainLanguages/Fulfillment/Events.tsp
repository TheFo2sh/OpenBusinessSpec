import "okeno-schema-markers";

@icon("/iconify/mdi/truck-plus-outline.svg")
@event("8a982fa7-c17c-41c3-934c-160e5fe8f619", source:"/fulfillments")
model FulfillmentCreated {
  fulfillment: Fulfillment;
}

@icon("/iconify/mdi/truck-check-outline.svg")
@event("ca251c73-588b-464e-97a0-9171b70d0d28", source:"/fulfillments")
model FulfillmentShipped {
  fulfillment: Fulfillment;
}

@icon("/iconify/mdi/package-check.svg")
@event("86f64413-8e88-4d8e-b5c6-808a0d1a8207", source:"/fulfillments")
model FulfillmentDelivered {
  fulfillment: Fulfillment;
}

@icon("/iconify/mdi/truck-remove-outline.svg")
@event("c9f2915d-f340-4e0c-9e63-731bdae7c6fb", source:"/fulfillments")
model FulfillmentCanceled {
  fulfillment: Fulfillment;
  reason: FulfillmentCancellationReason;
}
