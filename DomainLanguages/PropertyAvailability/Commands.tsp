import "okeno-schema-markers";

@rest(Put, "/properties/{propertyId}/room-availability")
@command("30000000-0000-4000-8000-000000000005")
@icon("/iconify/mdi/calendar-edit-outline.svg")
model SetRoomAvailability {
  input: {
    property: Property;
    roomType: RoomType;
    date: plainDate;
    availableUnits: int32;
    minimumStay?: int32;
    maximumStay?: int32;
  };
  computed: {};
  output: {
    availability: RoomAvailability;
  };
  context: {};
}

@rest(Put, "/properties/{propertyId}/rate-plans")
@command("30000000-0000-4000-8000-000000000006")
@icon("/iconify/mdi/currency-usd.svg")
model SetRatePlan {
  input: {
    ratePlan: RatePlan;
  };
  computed: {};
  output: {
    ratePlan: RatePlan;
  };
  context: {};
}

@rest(Post, "/properties/{propertyId}/room-availability/close")
@command("30000000-0000-4000-8000-000000000007")
@icon("/iconify/mdi/calendar-remove-outline.svg")
model CloseRoomSales {
  input: {
    property: Property;
    roomType: RoomType;
    date: plainDate;
  };
  computed: {};
  output: {
    availability: RoomAvailability;
  };
  context: {};
}

@rest(Post, "/properties/{propertyId}/room-availability/open")
@command("30000000-0000-4000-8000-000000000008")
@icon("/iconify/mdi/calendar-check-outline.svg")
model OpenRoomSales {
  input: {
    property: Property;
    roomType: RoomType;
    date: plainDate;
  };
  computed: {};
  output: {
    availability: RoomAvailability;
  };
  context: {};
}

@command("30000000-0000-4000-8000-000000000020")
@icon("/iconify/mdi/bed-clock.svg")
model HoldRoom {
  input: {
    property: Property;
    roomType: RoomType;
    date: plainDate;
    rooms: int32;
    reservationReference: string;
  };
  computed: {};
  output: {
    availability: RoomAvailability;
  };
  context: {};
}

@command("30000000-0000-4000-8000-000000000022")
@icon("/iconify/mdi/bed-minus-outline.svg")
model ReleaseRoom {
  input: {
    property: Property;
    roomType: RoomType;
    date: plainDate;
    rooms: int32;
    reservationReference: string;
  };
  computed: {};
  output: {
    availability: RoomAvailability;
  };
  context: {};
}
