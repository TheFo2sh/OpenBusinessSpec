import "okeno-schema-markers";

@icon("/iconify/mdi/tag-plus-outline.svg")
@event("b45df87c-2ce5-47d8-b43e-b028ed918b40", source:"/promotions")
model PromotionCreated {
  promotion: Promotion;
}

@icon("/iconify/mdi/tag-check-outline.svg")
@event("b43ae0ba-d65a-41ad-abeb-75fb44c16471", source:"/promotions")
model PromotionActivated {
  promotion: Promotion;
}

@icon("/iconify/mdi/tag-off-outline.svg")
@event("1d56a593-5833-4d97-8a40-a845c5d8e350", source:"/promotions")
model PromotionDeactivated {
  promotionReference: string;
}

@icon("/iconify/mdi/cash-minus.svg")
@event("2503fa8a-2f64-4350-932b-118eab1b0353", source:"/discount-applications")
model DiscountApplied {
  application: DiscountApplication;
}
