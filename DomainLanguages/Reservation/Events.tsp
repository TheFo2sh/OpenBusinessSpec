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

@icon("/iconify/mdi/home-check-outline.svg")
@event("20000000-0000-4000-8000-000000000019", source:"/property-reservations")
model AccommodationReservationAccepted {
  reservationReference: string;
}

@icon("/iconify/mdi/credit-card-check-outline.svg")
@event("20000000-0000-4000-8000-000000000020", source:"/reservations")
model ReservationGuaranteeSecured {
  reservation: Reservation;
}

@icon("/iconify/mdi/credit-card-remove-outline.svg")
@event("20000000-0000-4000-8000-000000000021", source:"/reservations")
model ReservationGuaranteeFailed {
  reservation: Reservation;
  reason?: string;
}
