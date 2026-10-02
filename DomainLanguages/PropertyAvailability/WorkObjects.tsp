import "okeno-schema-markers";

@workObject("30000000-0000-4000-8000-000000000001")
@icon("/iconify/mdi/office-building-outline.svg")
model Property {
  name: string;
  address: PropertyAddress;
  timeZone: string;
}

@workObject("30000000-0000-4000-8000-000000000002")
@icon("/iconify/mdi/bed-outline.svg")
model RoomType {
  name: string;
  maximumOccupancy: int32;
  totalUnits: int32;
}

@workObject("30000000-0000-4000-8000-000000000003")
@icon("/iconify/mdi/calendar-multiple-check.svg")
model RoomAvailability {
  property: Property;
  roomType: RoomType;
  date: plainDate;
  availableUnits: int32;
  salesStatus: SalesStatus;
  minimumStay?: int32;
  maximumStay?: int32;
}

@workObject("30000000-0000-4000-8000-000000000004")
@icon("/iconify/mdi/tag-outline.svg")
model RatePlan {
  name: string;
  roomType: RoomType;
  nightlyPrice: float64;
  currency: string;
  cancellationTerms: string;
  mealPlan: MealPlan;
}

model PropertyAddress {
  street: string;
  city: string;
  region?: string;
  postalCode?: string;
  country: string;
}

enum SalesStatus {
  Open,
  Closed,
}

enum MealPlan {
  None,
  Breakfast,
  HalfBoard,
  FullBoard,
  AllInclusive,
}
