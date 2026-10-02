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
