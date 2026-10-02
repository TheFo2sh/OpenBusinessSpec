import "okeno-schema-markers";

@icon("/iconify/mdi/keyboard-return.svg")
@event("ca576f80-5f8d-4163-942a-13a8d0f21839", source:"/returns")
model ReturnRequested {
  returnRequest: ReturnRequest;
}

@icon("/iconify/mdi/check-circle-outline.svg")
@event("8dc2f064-3e8b-49fc-b167-898e6ed7cff0", source:"/returns")
model ReturnApproved {
  returnRequest: ReturnRequest;
}

@icon("/iconify/mdi/package-check.svg")
@event("bc001c1f-1f4e-4eeb-85b3-ce5dc67462e3", source:"/returns")
model ReturnReceived {
  returnRequest: ReturnRequest;
}

@icon("/iconify/mdi/close-circle-outline.svg")
@event("cb1f33ab-cfcf-451b-9978-b90a9cf1b053", source:"/returns")
model ReturnRejected {
  returnRequest: ReturnRequest;
  reason: string;
}
