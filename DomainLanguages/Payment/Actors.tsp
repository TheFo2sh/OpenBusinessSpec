@actor("9b9f64dd-a52d-43aa-bc8f-3dd4bf9962c6", type:"Human")
@icon("/iconify/mdi/account-outline.svg")
model Payer {}

@actor("ab4e4d67-c85b-41c4-946d-78cc67e38883", type:"InternalSystem")
@icon("/iconify/mdi/store-cog-outline.svg")
model PaymentService {}

@actor("1343d57f-c51f-4e91-8dd9-fc687cc85f4d", type:"ExternalSystem")
@icon("/iconify/mdi/bank-transfer.svg")
model PaymentProvider {}