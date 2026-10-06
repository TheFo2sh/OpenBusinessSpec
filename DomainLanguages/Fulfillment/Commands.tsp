import "okeno-schema-markers";

@command("692a904b-b456-40ad-8461-70ce747a5ff6")
@icon("/iconify/mdi/truck-plus-outline.svg")
model CreateFulfillment {
  input: {
    orderReference: string;
    lines: FulfillmentLine[];
  };
  output: {
    fulfillment: Fulfillment;
  };
}

@rest(Post, "/fulfillments/{fulfillmentReference}/ship")
@command("6823e546-a0a4-43e0-949b-9c6e03ca2419")
@icon("/iconify/mdi/truck-check-outline.svg")
model ShipFulfillment {
  input: {
    fulfillmentReference: string;
    carrier: string;
    trackingNumber?: string;
  };
  output: {
    fulfillment: Fulfillment;
  };
}

@command("d4fc0a86-443e-4032-a4a2-097a864198d7")
@icon("/iconify/mdi/package-check.svg")
model MarkFulfillmentDelivered {
  input: {
    fulfillmentReference: string;
    deliveredAt: utcDateTime;
  };
  output: {
    fulfillment: Fulfillment;
  };
}

@command("653488cb-417e-4efc-b2f4-4cb6f3fbb769")
@icon("/iconify/mdi/truck-remove-outline.svg")
model CancelFulfillment {
  input: {
    fulfillmentReference: string;
    reason: FulfillmentCancellationReason;
  };
  output: {
    fulfillment: Fulfillment;
  };
}

@readModel
@rest(Get, "/fulfillments/to-ship")
@command("8665cca6-bead-4fee-b98e-4bdb95101c3a")
@icon("/iconify/mdi/clipboard-list-outline.svg")
model ListFulfillmentsToShip {
  input: {
    locationReference?: string;
  };
  output: {
    fulfillments: Fulfillment[];
  };
}
