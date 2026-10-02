import "okeno-schema-markers";

@workObject("40000000-0000-4000-8000-000000000001")
@icon("/iconify/mdi/bed-clock.svg")
model Stay {
  reservationReference: string;
  guest: StayingGuest;
  accommodationName: string;
  roomAssignment?: string;
  arrivalDate: plainDate;
  departureDate: plainDate;
  status: StayStatus;
  checkedInAt?: utcDateTime;
  checkedOutAt?: utcDateTime;
}

@workObject("40000000-0000-4000-8000-000000000002")
@icon("/iconify/mdi/account-check-outline.svg")
model StayingGuest {
  givenName: string;
  familyName: string;
}

enum StayStatus {
  Expected,
  InHouse,
  Completed,
  NoShow,
}
