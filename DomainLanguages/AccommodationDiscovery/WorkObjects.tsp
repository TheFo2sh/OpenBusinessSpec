import "okeno-schema-markers";

@workObject("10000000-0000-4000-8000-000000000001")
@icon("/iconify/mdi/office-building-marker-outline.svg")
model Accommodation {
  name: string;
  description?: string;
  location: Location;
  amenities: Amenity[];
  rating?: float64;
}

@workObject("10000000-0000-4000-8000-000000000002")
@icon("/iconify/mdi/bed-outline.svg")
model RoomType {
  name: string;
  description?: string;
  maximumOccupancy: int32;
  bedTypes: BedType[];
  amenities: Amenity[];
}

@workObject("10000000-0000-4000-8000-000000000003")
@icon("/iconify/mdi/tag-outline.svg")
model AccommodationOffer {
  accommodation: Accommodation;
  roomType: RoomType;
  rateName: string;
  arrivalDate: plainDate;
  departureDate: plainDate;
  availableUnits: int32;
  totalPrice: float64;
  currency: string;
  cancellationTerms: string;
  includedMeals: MealPlan;
}

model Location {
  city: string;
  region?: string;
  country: string;
  latitude?: float64;
  longitude?: float64;
}

@workObject("10000000-0000-4000-8000-000000000022")
@icon("/iconify/mdi/filter-outline.svg")
model SearchCriteria {
  destination: string;
  arrivalDate: plainDate;
  departureDate: plainDate;
  adults: int32;
  children: int32;
  rooms: int32;
  requiredAmenities?: Amenity[];
}

enum Amenity {
  Wifi,
  Parking,
  Pool,
  Restaurant,
  FitnessCenter,
  AirConditioning,
  AccessibleFacilities,
}

enum BedType {
  Single,
  Double,
  Queen,
  King,
  Bunk,
}

enum MealPlan {
  None,
  Breakfast,
  HalfBoard,
  FullBoard,
  AllInclusive,
}
