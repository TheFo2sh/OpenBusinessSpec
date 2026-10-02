import "okeno-schema-markers";

@rest(Post, "/reservations")
@command("20000000-0000-4000-8000-000000000004")
@icon("/iconify/mdi/clipboard-plus-outline.svg")
model CreateReservation {
  input: {
    guest: Guest;
    option: ReservationOption;
    guarantee: ReservationGuarantee;
  };
  computed: {};
  output: {
    reservation: Reservation;
  };
  context: {};
}

@rest(Post, "/reservations/{reservationReference}/confirm")
@command("20000000-0000-4000-8000-000000000005")
@icon("/iconify/mdi/check-circle-outline.svg")
model ConfirmReservation {
  input: {
    reservationReference: string;
  };
  computed: {};
  output: {
    reservation: Reservation;
  };
  context: {};
}

@rest(Patch, "/reservations/{reservationReference}")
@command("20000000-0000-4000-8000-000000000006")
@icon("/iconify/mdi/clipboard-edit-outline.svg")
model ModifyReservation {
  input: {
    reservationReference: string;
    guest?: Guest;
    option?: ReservationOption;
  };
  computed: {};
  output: {
    reservation: Reservation;
  };
  context: {};
}

@rest(Post, "/reservations/{reservationReference}/cancel")
@command("20000000-0000-4000-8000-000000000007")
@icon("/iconify/mdi/clipboard-remove-outline.svg")
model CancelReservation {
  input: {
    reservationReference: string;
    reason?: string;
  };
  computed: {};
  output: {
    reservation: Reservation;
  };
  context: {};
}
