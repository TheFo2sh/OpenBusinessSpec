import "okeno-schema-markers";

@command("fd1bc699-f72e-4e12-b2f0-b0958bbeb080")
@icon("/iconify/mdi/clipboard-plus-outline.svg")
model PlaceOrder {
  input: {
    customerReference?: string;
    lines: OrderLine[];
    shippingAddress: OrderAddress;
    totalAmount: int64;
    currency: string;
  };
  output: {
    order: Order;
  };
}

@rest(Post, "/orders/cancel")
@command("3f82318c-9140-4fea-ac41-21290be41c1f")
@icon("/iconify/mdi/clipboard-remove-outline.svg")
model CancelOrder {
  input: {
    orderReference: string;
    reason: OrderCancellationReason;
  };
  output: {
    order: Order;
  };
}

@command("7287d10b-5ccc-4ba9-8ad7-101cc6dfdfe5")
@icon("/iconify/mdi/clipboard-check-outline.svg")
model CloseOrder {
  input: {
    orderReference: string;
  };
  output: {
    order: Order;
  };
}

@readModel
@rest(Get, "/customers/{customerReference}/orders")
@command("6720db30-8bc4-4766-9708-ef26f3fdb697")
@icon("/iconify/mdi/clipboard-list-outline.svg")
model ViewCustomerOrders {
  input: {
    customerReference: string;
  };
  output: {
    orders: Order[];
  };
}
