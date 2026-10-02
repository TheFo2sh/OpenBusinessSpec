import "okeno-schema-markers";

@icon("/iconify/mdi/clipboard-plus-outline.svg")
@event("4cbc1bbf-b0fb-41bc-9723-a9af1da64618", source:"/orders")
model OrderPlaced {
  order: Order;
}

@icon("/iconify/mdi/clipboard-remove-outline.svg")
@event("b878a293-09ad-4892-a819-8e629edfb07c", source:"/orders")
model OrderCanceled {
  order: Order;
  reason: OrderCancellationReason;
}

@icon("/iconify/mdi/clipboard-check-outline.svg")
@event("86779b50-4b7a-4841-a2c7-d3397d2098c0", source:"/orders")
model OrderClosed {
  orderReference: string;
}
