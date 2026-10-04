# Domain story templates

Each folder here is one package: a domain story and, optionally, its event
model. Everything is business only. There are no coordinates: the editor lays
both canvases out the first time they are opened. Items are referred to by
name and looked up in the domain language packages the story depends on.

```
DomainStories/<Name>/
  manifest.yaml                     # required
  DomainStory.yaml | .yml | .json   # required
  EventModel.yaml  | .yml | .json   # optional
```

## manifest.yaml

```yaml
Name: Pay for an order
PackageId: M1Spec.DomainStories.PayForOrder
Version: 0.0.1
Description: ...
Icon: "/iconify/mdi/cash-check.svg"
Publisher: M1Spec
Dependencies:                        # domain language packages, by their PackageId
  - PackageId: M1Spec.DomainLanguages.Payment
    Version: 0.0.1                   # the version the story was written against
    Alias: Payment                   # optional; lets a name be qualified as Payment/Payer
```

A dependency the project doesn't have yet is offered for installation from
this repository when the story is imported. If it isn't installed, the story
is not created.

## DomainStory

```yaml
name: Payer pays for an order
description: ...
sentences:                           # numbered in this order
  - actor: Payer                     # an actor of a dependency
    activity: enters                 # the verb on the first arrow
    workObject: PaymentMethod        # or workObjects: [A, B]
    recipient: PaymentService        # optional second actor
    recipientActivity: to            # optional, the verb on the second arrow (default "to")
```

## EventModel

```yaml
systems: [PaymentService, PaymentProvider]   # matrix columns, in order: non-human actors
flows:                                       # each flow is a chain, joined by edges
  - system: PaymentService                   # the column its steps sit in (default: first system)
    startedBy: Payer                         # a human actor; needs a frontend trigger
    trigger: { name: Checkout form, kind: frontend }   # frontend | event | time (+ cron: "0 2 * * *")
    command: InitiatePayment
    events: [PaymentCreated, { name: PaymentAuthorized, system: PaymentProvider }]
  - policy:
      name: Capture authorized payments
      rules:
        - when: PaymentAuthorized            # the event it reacts to
          then: CapturePayment               # the command it issues (default: the flow's command)
          condition: { field: payment.status, operator: eq, value: authorized }   # optional
          description: ...
    command: CapturePayment
```

Edges run `startedBy` -> `trigger` -> `command` -> each event, and for a
policy, each rule's `when` event -> policy -> its `then` command. A command or
event mentioned in several flows is one node. Policies and time triggers are
created in the language of the command they lead to.

`PayForOrder/` is a complete example told in the Payment domain language. Its
story is in YAML and its event model in JSON; either file can use either
format.
