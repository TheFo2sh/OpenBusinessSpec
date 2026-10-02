import "okeno-schema-markers";

@icon("/iconify/mdi/cart-plus.svg")
@event("4fcf7280-8a9c-4e17-bf1c-c5304aa58aaa", source:"/carts")
model CartCreated {
  cart: ShoppingCart;
}

@icon("/iconify/mdi/cart-arrow-down.svg")
@event("9dac36f2-c561-4c76-9b1f-450b837b68dd", source:"/carts")
model CartItemAdded {
  cartId: string;
  item: CartItem;
}

@icon("/iconify/mdi/cart-edit.svg")
@event("7a6d129b-3510-454d-ace6-92a5e54f80cd", source:"/carts")
model CartItemQuantityChanged {
  cartId: string;
  variantReference: string;
  quantity: int32;
}

@icon("/iconify/mdi/cart-remove.svg")
@event("0f75d116-9acc-4bc9-8176-7f7fb7eabb17", source:"/carts")
model CartItemRemoved {
  cartId: string;
  variantReference: string;
}

@icon("/iconify/mdi/cart-off.svg")
@event("ae6770c5-f955-46e6-b8e7-53c33eafb407", source:"/carts")
model CartAbandoned {
  cartId: string;
}
