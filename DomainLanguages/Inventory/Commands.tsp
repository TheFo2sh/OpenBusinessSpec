import "okeno-schema-markers";

@command("a06e94fa-d0cb-45b3-ab04-da958135e7bc")
@icon("/iconify/mdi/package-variant-plus.svg")
model ReceiveStock {
  input: {
    variantReference: string;
    locationReference: string;
    quantity: int32;
  };
  output: {
    stock: InventoryStock;
  };
}

@command("c40b4bf6-fb50-4e4b-9d2d-b50564e776bc")
@icon("/iconify/mdi/package-variant-edit.svg")
model AdjustStock {
  input: {
    variantReference: string;
    locationReference: string;
    quantityChange: int32;
    reason: InventoryAdjustmentReason;
  };
  output: {
    stock: InventoryStock;
  };
}

@command("51a18650-4d06-4c10-be53-a1945a2082cf")
@icon("/iconify/mdi/package-variant-closed-check.svg")
model ReserveStock {
  input: {
    variantReference: string;
    locationReference: string;
    reference: string;
    quantity: int32;
    expiresAt?: utcDateTime;
  };
  output: {
    reservation: StockReservation;
    stock: InventoryStock;
  };
}

@command("93d9093e-6b77-4427-8791-b8ca8ebb2526")
@icon("/iconify/mdi/package-variant-remove.svg")
model ReleaseStockReservation {
  input: {
    reservationReference: string;
  };
  output: {
    reservation: StockReservation;
  };
}
