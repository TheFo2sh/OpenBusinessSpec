import "okeno-schema-markers";

@icon("/iconify/mdi/magnify.svg")
@event("10000000-0000-4000-8000-000000000007", source:"/accommodation-searches")
model AccommodationSearchCompleted {
  criteria: SearchCriteria;
  offers: AccommodationOffer[];
}

@icon("/iconify/mdi/office-building-check-outline.svg")
@event("10000000-0000-4000-8000-000000000008", source:"/accommodations")
model AccommodationDetailsViewed {
  accommodation: Accommodation;
}

@icon("/iconify/mdi/calendar-check-outline.svg")
@event("10000000-0000-4000-8000-000000000009", source:"/accommodation-availability")
model AccommodationAvailabilityPresented {
  accommodationId: string;
  offers: AccommodationOffer[];
}

@icon("/iconify/mdi/database-check-outline.svg")
@event("10000000-0000-4000-8000-000000000021", source:"/search-index")
model SearchableOffersUpdated {
  accommodationId: string;
  offers: AccommodationOffer[];
}
