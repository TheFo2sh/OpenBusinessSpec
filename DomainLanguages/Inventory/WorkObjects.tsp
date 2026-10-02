import "okeno-schema-markers";

@workObject("a4406fb5-9aee-49d1-a3c4-d9bd8d10e987")
@icon("/iconify/mdi/package-variant.svg")
model InventoryStock {
  variantReference: string;
  locationReference: string;
  onHandQuantity: int32;
  reservedQuantity: int32;
  availableQuantity: int32;
}

@workObject("48d7d33b-189d-4856-ae63-de6df67a1fc8")
@icon("/iconify/mdi/package-variant-closed-check.svg")
model StockReservation {
  variantReference: string;
  locationReference: string;
  reference: string;
  quantity: int32;
  status: ReservationStatus;
  expiresAt?: utcDateTime;
}

enum ReservationStatus {
  Active: "active",
  Released: "released",
  Expired: "expired",
}

enum InventoryAdjustmentReason {
  Received: "received",
  Damaged: "damaged",
  Correction: "correction",
  Other: "other",
}
