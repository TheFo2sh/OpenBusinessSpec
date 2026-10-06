import "okeno-schema-markers";

@rest(Post, "/promotions")
@command("ae54b85e-269e-4816-ae05-95ad063decb2")
@icon("/iconify/mdi/tag-plus-outline.svg")
model CreatePromotion {
  input: {
    name: string;
    code?: string;
    discount: DiscountRule;
    startsAt?: utcDateTime;
    endsAt?: utcDateTime;
    minimumPurchaseAmount?: int64;
  };
  output: {
    promotion: Promotion;
  };
}

@rest(Post, "/promotions/{promotionReference}/activate")
@command("53591aad-fc98-4830-a159-a3bb3d33d8e8")
@icon("/iconify/mdi/tag-check-outline.svg")
model ActivatePromotion {
  input: {
    promotionReference: string;
  };
  output: {
    promotion: Promotion;
  };
}

@rest(Post, "/promotions/{promotionReference}/deactivate")
@command("088e5bea-036d-4b7d-bd50-3242acc634bc")
@icon("/iconify/mdi/tag-off-outline.svg")
model DeactivatePromotion {
  input: {
    promotionReference: string;
  };
  output: {
    promotion: Promotion;
  };
}

@command("fff0755e-7129-42bd-b863-5d5e84ff6115")
@icon("/iconify/mdi/percent-outline.svg")
model ApplyPromotion {
  input: {
    promotionCode: string;
    purchaseReference: string;
    subtotal: int64;
    currency: string;
  };
  output: {
    application: DiscountApplication;
  };
}

@readModel
@rest(Get, "/promotions/active")
@command("8f5d2385-619d-4f85-9d00-e510af79b36c")
@icon("/iconify/mdi/tag-check-outline.svg")
model ListActivePromotions {
  input: {};
  output: {
    promotions: Promotion[];
  };
}

@readModel
@command("d9b09ce5-433f-4c96-9f8f-db6966839e42")
@icon("/iconify/mdi/tag-clock-outline.svg")
model ListPromotionsDueToEnd {
  input: {
    asOf?: utcDateTime;
  };
  output: {
    promotions: Promotion[];
  };
}
