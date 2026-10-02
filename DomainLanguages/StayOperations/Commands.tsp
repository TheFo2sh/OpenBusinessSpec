import "okeno-schema-markers";

@rest(Post, "/stays/{reservationReference}/check-in")
@command("40000000-0000-4000-8000-000000000003")
@icon("/iconify/mdi/account-arrow-right-outline.svg")
model CheckInGuest {
  input: {
    reservationReference: string;
    roomAssignment?: string;
  };
  computed: {};
  output: {
    stay: Stay;
  };
  context: {};
}

@rest(Post, "/stays/{reservationReference}/check-out")
@command("40000000-0000-4000-8000-000000000004")
@icon("/iconify/mdi/account-arrow-left-outline.svg")
model CheckOutGuest {
  input: {
    reservationReference: string;
  };
  computed: {};
  output: {
    stay: Stay;
  };
  context: {};
}
