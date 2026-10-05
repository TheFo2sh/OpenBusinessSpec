import "okeno-schema-markers";

@icon("/iconify/mdi/package-variant-plus.svg")
@event("f3618800-f351-4487-a15e-36a3abe03fe0", source:"/inventory")
model StockReceived {
  stock: InventoryStock;
  quantity: int32;
}

@icon("/iconify/mdi/package-variant-edit.svg")
@event("0c71c5df-03ef-4286-bd7f-cd91f22312bf", source:"/inventory")
model StockAdjusted {
  stock: InventoryStock;
  quantityChange: int32;
  reason: InventoryAdjustmentReason;
}

@icon("/iconify/mdi/package-variant-closed-check.svg")
@event("fcdbe63d-2966-4617-80f4-b75897c32ac5", source:"/inventory/reservations")
model StockReserved {
  reservation: StockReservation;
}

@icon("/iconify/mdi/package-variant-remove.svg")
@event("d8a4bebb-ea68-433e-a5b7-5f9cde27c97c", source:"/inventory/reservations")
model StockReservationReleased {
  reservation: StockReservation;
}

@icon("/iconify/mdi/package-check.svg")
@event("f4f0f9a7-3bc4-4fdd-8b1f-fe91c3adaa00", source:"/inventory/reservations")
model StockReservationConsumed {
  reservation: StockReservation;
}
