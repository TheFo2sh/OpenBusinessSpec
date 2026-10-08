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

@command("40000000-0000-4000-8000-000000000010")
@icon("/iconify/mdi/bed-clock.svg")
model RegisterExpectedArrival {
  input: {
    reservationReference: string;
    guest: StayingGuest;
    accommodationName: string;
    arrivalDate: plainDate;
    departureDate: plainDate;
  };
  computed: {};
  output: {
    stay: Stay;
  };
  context: {};
}

@command("40000000-0000-4000-8000-000000000011")
@icon("/iconify/mdi/account-cancel-outline.svg")
model RecordNoShow {
  input: {
    reservationReference: string;
  };
  computed: {};
  output: {
    stay: Stay;
  };
  context: {};
}

@readModel
@rest(Get, "/stays/arrivals")
@command("40000000-0000-4000-8000-000000000012")
@icon("/iconify/mdi/calendar-account-outline.svg")
model ListTodaysArrivals {
  input: {
    date?: plainDate;
  };
  computed: {};
  output: {
    stays: Stay[];
  };
  context: {};
}

@readModel
@rest(Get, "/stays/no-shows")
@command("40000000-0000-4000-8000-000000000013")
@icon("/iconify/mdi/account-cancel-outline.svg")
model ListNoShows {
  input: {
    fromDate?: plainDate;
    toDate?: plainDate;
  };
  computed: {};
  output: {
    stays: Stay[];
  };
  context: {};
}
