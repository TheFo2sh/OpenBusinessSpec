import "okeno-schema-markers";

@workObject("01adf4ad-bc5b-42ea-a69f-9375b91fa1bb")
@icon("/iconify/mdi/tag-outline.svg")
model Product {
  title: string;
  description?: string;
  category?: string;
  tags: string[];
  status: ProductStatus;
  variants: ProductVariant[];
}

@workObject("00a75255-daeb-4e1b-a26f-cfb7afc5763b")
@icon("/iconify/mdi/tag-multiple-outline.svg")
model ProductVariant {
  sku?: string;
  optionValues: VariantOption[];
  price: ProductPrice;
  status: ProductVariantStatus;
}

@workObject("65c785bf-8ea9-4c2d-848d-7083904c1152")
@icon("/iconify/mdi/cash-multiple.svg")
model ProductPrice {
  amount: int64;
  currency: string;
}

@workObject("4ba7e7c1-290c-48b1-a416-235026a93ca5")
@icon("/iconify/mdi/format-list-bulleted-type.svg")
model VariantOption {
  name: string;
  value: string;
}

enum ProductStatus {
  Draft: "draft",
  Active: "active",
  Archived: "archived",
}

enum ProductVariantStatus {
  Active: "active",
  Inactive: "inactive",
}
