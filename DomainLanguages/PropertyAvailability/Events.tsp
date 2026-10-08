import "okeno-schema-markers";

@icon("/iconify/mdi/calendar-check-outline.svg")
@event("30000000-0000-4000-8000-000000000009", source:"/room-availability")
model RoomAvailabilitySet {
  availability: RoomAvailability;
}

@icon("/iconify/mdi/currency-usd.svg")
@event("30000000-0000-4000-8000-000000000010", source:"/rate-plans")
model RatePlanSet {
  ratePlan: RatePlan;
}

@icon("/iconify/mdi/calendar-remove-outline.svg")
@event("30000000-0000-4000-8000-000000000011", source:"/room-availability")
model RoomSalesClosed {
  availability: RoomAvailability;
}

@icon("/iconify/mdi/calendar-check-outline.svg")
@event("30000000-0000-4000-8000-000000000012", source:"/room-availability")
model RoomSalesOpened {
  availability: RoomAvailability;
}

@icon("/iconify/mdi/bed-clock.svg")
@event("30000000-0000-4000-8000-000000000021", source:"/room-availability")
model RoomAvailabilityHeld {
  availability: RoomAvailability;
  reservationReference: string;
}

@icon("/iconify/mdi/bed-minus-outline.svg")
@event("30000000-0000-4000-8000-000000000023", source:"/room-availability")
model RoomAvailabilityReleased {
  availability: RoomAvailability;
  reservationReference: string;
}
