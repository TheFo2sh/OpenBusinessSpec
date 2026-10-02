import "okeno-schema-markers";

@rest(Post, "/returns")
@command("c82c48a9-6b82-4e8a-aeb0-c626c6702669")
@icon("/iconify/mdi/keyboard-return.svg")
model RequestReturn {
  input: {
    orderReference: string;
    items: ReturnItem[];
    reason: ReturnReason;
  };
  output: {
    returnRequest: ReturnRequest;
  };
}

@command("f82c236d-71b3-4fc2-809f-6cefca3f7f61")
@icon("/iconify/mdi/check-circle-outline.svg")
model ApproveReturn {
  input: {
    returnReference: string;
  };
  output: {
    returnRequest: ReturnRequest;
  };
}

@command("d44d129a-dd55-4c35-a2d6-c68a1886a329")
@icon("/iconify/mdi/package-check.svg")
model ReceiveReturn {
  input: {
    returnReference: string;
    items: ReturnItem[];
  };
  output: {
    returnRequest: ReturnRequest;
  };
}

@command("b1375487-a25f-41a1-a564-e592a0ce5ddb")
@icon("/iconify/mdi/close-circle-outline.svg")
model RejectReturn {
  input: {
    returnReference: string;
    reason: string;
  };
  output: {
    returnRequest: ReturnRequest;
  };
}
