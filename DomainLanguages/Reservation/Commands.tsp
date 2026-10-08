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

@command("20000000-0000-4000-8000-000000000015")
@icon("/iconify/mdi/home-check-outline.svg")
model ConfirmPropertyReservation {
  input: {
    reservationReference: string;
    option: ReservationOption;
  };
  computed: {};
  output: {
    reservationReference: string;
  };
  context: {};
}

@command("20000000-0000-4000-8000-000000000016")
@icon("/iconify/mdi/credit-card-check-outline.svg")
model RecordGuaranteeAuthorization {
  input: {
    reservationReference: string;
    paymentId: string;
  };
  computed: {};
  output: {
    reservation: Reservation;
  };
  context: {};
}

@command("20000000-0000-4000-8000-000000000018")
@icon("/iconify/mdi/credit-card-remove-outline.svg")
model FailReservationGuarantee {
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

@readModel
@rest(Get, "/reservations/{reservationReference}/confirmation")
@command("20000000-0000-4000-8000-000000000017")
@icon("/iconify/mdi/clipboard-check-outline.svg")
model ViewReservationConfirmation {
  input: {
    reservationReference: string;
  };
  computed: {};
  output: {
    reservation: Reservation;
  };
  context: {};
}
