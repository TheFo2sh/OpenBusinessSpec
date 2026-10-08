import "okeno-schema-markers";

@readModel
@rest(Post, "/accommodations/search")
@command("10000000-0000-4000-8000-000000000004")
@icon("/iconify/mdi/magnify.svg")
model SearchAccommodations {
  input: {
    criteria: SearchCriteria;
  };
  computed: {};
  output: {
    offers: AccommodationOffer[];
  };
  context: {};
}

@readModel
@rest(Get, "/accommodations/{accommodationId}")
@command("10000000-0000-4000-8000-000000000005")
@icon("/iconify/mdi/office-building-search-outline.svg")
model ViewAccommodationDetails {
  input: {
    accommodationId: string;
  };
  computed: {};
  output: {
    accommodation: Accommodation;
    roomTypes: RoomType[];
  };
  context: {};
}

@readModel
@rest(Post, "/accommodations/availability")
@command("10000000-0000-4000-8000-000000000006")
@icon("/iconify/mdi/calendar-search-outline.svg")
model CheckAccommodationAvailability {
  input: {
    accommodationId: string;
    criteria: SearchCriteria;
  };
  computed: {};
  output: {
    offers: AccommodationOffer[];
  };
  context: {};
}

@command("10000000-0000-4000-8000-000000000020")
@icon("/iconify/mdi/database-sync-outline.svg")
model RefreshSearchableOffers {
  input: {
    propertyId: string;
    roomTypeId: string;
    date: plainDate;
    availableUnits?: int32;
    ratePlanId?: string;
    nightlyPrice?: float64;
    currency?: string;
  };
  computed: {};
  output: {
    offers: AccommodationOffer[];
  };
  context: {};
}
