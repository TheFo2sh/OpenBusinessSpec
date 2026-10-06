import "okeno-schema-markers";

@rest(Post, "/products")
@command("2476e517-7ab1-4885-954d-b547841cce5e")
@icon("/iconify/mdi/tag-plus-outline.svg")
model CreateProduct {
  input: {
    title: string;
    description?: string;
    category?: string;
    variants: ProductVariant[];
  };
  output: {
    product: Product;
  };
}

@rest(Put, "/products/{productId}")
@command("a23f1eae-5c65-4fe1-906a-5a721e598d47")
@icon("/iconify/mdi/tag-edit-outline.svg")
model UpdateProduct {
  input: {
    productId: string;
    title?: string;
    description?: string;
    category?: string;
    tags?: string[];
  };
  output: {
    product: Product;
  };
}

@rest(Post, "/products/{productId}/publish")
@command("af904420-9195-4ab2-9cda-a55e1d22ec8c")
@icon("/iconify/mdi/eye-check-outline.svg")
model PublishProduct {
  input: {
    productId: string;
  };
  output: {
    product: Product;
  };
}

@command("2793eee1-d4e9-4158-842c-9c2c69a7f1a2")
@icon("/iconify/mdi/archive-outline.svg")
model ArchiveProduct {
  input: {
    productId: string;
  };
  output: {
    product: Product;
  };
}

@readModel
@rest(Get, "/products/published")
@command("62f9e8a8-ac8f-46a8-b85f-878aa47e6f56")
@icon("/iconify/mdi/tag-multiple-outline.svg")
model ListPublishedProducts {
  input: {
    category?: string;
  };
  output: {
    products: Product[];
  };
}
