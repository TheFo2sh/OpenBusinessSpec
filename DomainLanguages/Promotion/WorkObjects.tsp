import "okeno-schema-markers";

@workObject("45a83b29-1ae0-46d2-b056-61504d6d0de8")
@icon("/iconify/mdi/tag-heart-outline.svg")
model Promotion {
  name: string;
  code?: string;
  discount: DiscountRule;
  status: PromotionStatus;
  startsAt?: utcDateTime;
  endsAt?: utcDateTime;
  minimumPurchaseAmount?: int64;
  usageLimit?: int32;
}

@workObject("637a99fc-af0c-492a-bbb1-69eb82367f74")
@icon("/iconify/mdi/percent-outline.svg")
model DiscountRule {
  type: DiscountType;
  value: int64;
}

@workObject("efccf44e-d6da-4e13-9a81-38846429de5f")
@icon("/iconify/mdi/cash-minus.svg")
model DiscountApplication {
  promotionReference: string;
  purchaseReference: string;
  discountAmount: int64;
  currency: string;
}

enum PromotionStatus {
  Draft: "draft",
  Active: "active",
  Inactive: "inactive",
  Expired: "expired",
}

enum DiscountType {
  FixedAmount: "fixed_amount",
  Percentage: "percentage",
}
