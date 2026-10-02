import "okeno-schema-markers";

@workObject("b4ae75c0-e56f-4c00-91f8-ef057054764d")
@icon("/iconify/mdi/keyboard-return.svg")
model ReturnRequest {
  orderReference: string;
  items: ReturnItem[];
  reason: ReturnReason;
  status: ReturnStatus;
  requestedAt: utcDateTime;
  receivedAt?: utcDateTime;
}

@workObject("a34285a6-412a-441f-8bb7-55af5b8d776d")
@icon("/iconify/mdi/package-variant-closed.svg")
model ReturnItem {
  orderLineReference: string;
  quantity: int32;
  condition?: ReturnedItemCondition;
}

enum ReturnStatus {
  Requested: "requested",
  Approved: "approved",
  Received: "received",
  Rejected: "rejected",
}

enum ReturnReason {
  Unwanted: "unwanted",
  Damaged: "damaged",
  IncorrectItem: "incorrect_item",
  Other: "other",
}

enum ReturnedItemCondition {
  Unopened: "unopened",
  Unused: "unused",
  Damaged: "damaged",
}
