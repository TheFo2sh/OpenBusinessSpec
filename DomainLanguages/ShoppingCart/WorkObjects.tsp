import "okeno-schema-markers";

@workObject("24667bd8-6315-4b4a-952f-da962a59924c")
@icon("/iconify/mdi/cart-outline.svg")
model ShoppingCart {
  items: CartItem[];
  currency: string;
  subtotal: int64;
  status: CartStatus;
  customerReference?: string;
  expiresAt?: utcDateTime;
}

@workObject("0f1f1171-d1d7-442b-9fad-8094415d99a2")
@icon("/iconify/mdi/cart-plus.svg")
model CartItem {
  variantReference: string;
  productTitle: string;
  variantDescription?: string;
  sku?: string;
  unitPrice: int64;
  quantity: int32;
}

enum CartStatus {
  Active: "active",
  Converted: "converted",
  Abandoned: "abandoned",
}
