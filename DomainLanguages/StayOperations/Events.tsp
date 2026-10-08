import "okeno-schema-markers";

@icon("/iconify/mdi/account-arrow-right-outline.svg")
@event("40000000-0000-4000-8000-000000000005", source:"/stays")
model GuestCheckedIn {
  stay: Stay;
}

@icon("/iconify/mdi/account-arrow-left-outline.svg")
@event("40000000-0000-4000-8000-000000000006", source:"/stays")
model GuestCheckedOut {
  stay: Stay;
}

@icon("/iconify/mdi/bed-clock.svg")
@event("40000000-0000-4000-8000-000000000014", source:"/stays")
model ExpectedArrivalRegistered {
  stay: Stay;
}

@icon("/iconify/mdi/account-cancel-outline.svg")
@event("40000000-0000-4000-8000-000000000015", source:"/stays")
model NoShowRecorded {
  stay: Stay;
}
