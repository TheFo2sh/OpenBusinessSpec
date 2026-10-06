import "okeno-schema-markers";

@rest(Post, "/carts")
@command("0a6d7b0f-4908-4318-b29b-72b8b52eac4e")
@icon("/iconify/mdi/cart-plus.svg")
model CreateCart {
  input: {
    currency: string;
    customerReference?: string;
  };
  output: {
    cart: ShoppingCart;
  };
}

@rest(Post, "/carts/items")
@command("c70add8c-051f-4ff0-8d54-9f54e55b153b")
@icon("/iconify/mdi-cart-arrow-down.svg")
model AddCartItem {
  input: {
    cartId: string;
    item: CartItem;
  };
  output: {
    cart: ShoppingCart;
  };
}

@rest(Patch, "/carts/items/quantity")
@command("4a8473f6-2da0-42ab-99ed-2dafc66119a7")
@icon("/iconify/mdi-cart-edit.svg")
model ChangeCartItemQuantity {
  input: {
    cartId: string;
    variantReference: string;
    quantity: int32;
  };
  output: {
    cart: ShoppingCart;
  };
}

@rest(Delete, "/carts/items")
@command("412dd18e-ea05-4abf-8ba8-0afb288d8c3e")
@icon("/iconify/mdi-cart-remove.svg")
model RemoveCartItem {
  input: {
    cartId: string;
    variantReference: string;
  };
  output: {
    cart: ShoppingCart;
  };
}

@command("56cb61a2-5fcf-40a5-9cfd-c0f5cb4df24d")
@icon("/iconify/mdi-cart-off.svg")
model AbandonCart {
  input: {
    cartId: string;
  };
  output: {
    cart: ShoppingCart;
  };
}

@readModel
@command("2ff1fd2c-718b-472a-892d-d6adc5b178e7")
@icon("/iconify/mdi/cart-outline.svg")
model ViewCart {
  input: {
    cartId: string;
  };
  output: {
    cart: ShoppingCart;
  };
}

@readModel
@command("84a86e15-0b99-4892-b62f-1aa2648a7703")
@icon("/iconify/mdi/cart-clock.svg")
model ListIdleCarts {
  input: {
    asOf?: utcDateTime;
  };
  output: {
    carts: ShoppingCart[];
  };
}
