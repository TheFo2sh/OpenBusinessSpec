import "okeno-schema-markers";

@icon("/iconify/mdi/tag-plus-outline.svg")
@event("afa4ad34-7187-453b-a1b5-082fb3ef9f8a", source:"/products")
model ProductCreated {
  product: Product;
}

@icon("/iconify/mdi/tag-edit-outline.svg")
@event("2ccb7b86-1f5c-44bc-8986-0ac84a51e2fe", source:"/products")
model ProductUpdated {
  product: Product;
}

@icon("/iconify/mdi/eye-check-outline.svg")
@event("28b8c2af-d1f5-446a-833e-f9ceef98e2ce", source:"/products")
model ProductPublished {
  product: Product;
}

@icon("/iconify/mdi/archive-outline.svg")
@event("71778b74-0088-4d78-ad05-bdccc7547a94", source:"/products")
model ProductArchived {
  product: Product;
}
