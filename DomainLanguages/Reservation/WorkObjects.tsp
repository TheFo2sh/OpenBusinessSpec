import "okeno-schema-markers";

@workObject("20000000-0000-4000-8000-000000000001")
@icon("/iconify/mdi/clipboard-text-outline.svg")
model Reservation {
  reference: string;
  status: ReservationStatus;
  guest: Guest;
  option: ReservationOption;
  createdAt: utcDateTime;
  confirmedAt?: utcDateTime;
  guarantee: ReservationGuarantee;
}

@workObject("20000000-0000-4000-8000-000000000002")
@icon("/iconify/mdi/account-outline.svg")
model Guest {
  givenName: string;
  familyName: string;
  email: string;
  phone?: string;
  specialRequests?: string;
}

@workObject("20000000-0000-4000-8000-000000000003")
@icon("/iconify/mdi/bed-outline.svg")
model ReservationOption {
  accommodationName: string;
  roomType: string;
  arrivalDate: plainDate;
  departureDate: plainDate;
  adults: int32;
  children: int32;
  rooms: int32;
  totalPrice: float64;
  currency: string;
  cancellationTerms: string;
}

enum ReservationStatus {
  Requested,
  Confirmed,
  Modified,
  Cancelled,
  Rejected,
}

enum GuaranteeType {
  None,
  PaymentCard,
  Prepayment,
  Deposit,
}

enum GuaranteeStatus {
  NotRequired,
  Pending,
  Secured,
  Failed,
}

model ReservationGuarantee {
  type: GuaranteeType;
  status: GuaranteeStatus;
  amount?: float64;
  currency?: string;
}
