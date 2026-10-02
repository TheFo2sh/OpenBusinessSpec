import "okeno-schema-markers";

@icon("/iconify/mdi/clipboard-plus-outline.svg")
@event("20000000-0000-4000-8000-000000000008", source:"/reservations")
model ReservationCreated {
  reservation: Reservation;
}

@icon("/iconify/mdi/check-circle-outline.svg")
@event("20000000-0000-4000-8000-000000000009", source:"/reservations")
model ReservationConfirmed {
  reservation: Reservation;
}

@icon("/iconify/mdi/clipboard-edit-outline.svg")
@event("20000000-0000-4000-8000-000000000010", source:"/reservations")
model ReservationModified {
  reservation: Reservation;
}

@icon("/iconify/mdi/clipboard-remove-outline.svg")
@event("20000000-0000-4000-8000-000000000011", source:"/reservations")
model ReservationCancelled {
  reservation: Reservation;
  cancellationTerms: string;
}
