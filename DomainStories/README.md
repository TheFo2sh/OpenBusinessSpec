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
systems: [PaymentService, PaymentProvider]   # the board's bands, in order: non-human actors
flows:                                       # each flow is a chain, joined by edges
  - system: PaymentService                   # the system its steps belong to (default: the first system)
    startedBy: Payer                         # a human actor; needs a frontend trigger
    trigger: { name: Checkout form, kind: frontend }   # frontend | event | time (+ cron: "0 2 * * *")
    command: InitiatePayment
    events: [PaymentCreated]                 # recorded by the command - in its own system (R1)
  - system: PaymentProvider                  # a translation: the provider reacts in its own system
    policy:
      name: Authorize new payments
      rules:
        - when: PaymentCreated               # the event it reacts to
          then: AuthorizeCharge              # the command it issues (default: the flow's command)
          condition: { field: payment.status, operator: eq, value: pending }   # optional
          description: ...
    command: AuthorizeCharge
    events: [ChargeAuthorized, ChargeDeclined]
  - system: PaymentService
    startedBy: Payer
    trigger: { name: Payment status page, kind: frontend }
    reads: [ViewPaymentStatus]               # read models the trigger (or policy) asks; no command: a state view
readModels:                                  # optional
  - name: ViewPaymentStatus                  # a command of the language marked @readModel
    system: PaymentService
    from: [PaymentCreated, PaymentAuthorized]  # the events it is built from - of its own system (R1)
```

Edges run `startedBy` -> `trigger` -> `command` -> each event; for a policy,
each rule's `when` event -> policy -> its `then` command; for a read model,
each `from` event -> read model, and each `reads` -> its asker. A command or
event mentioned in several flows is one node, in the system of the first flow
that names it - so list the flow that records an event before the flows that
react to it. Policies and time triggers are created in the language of the
command they lead to.

## Rules

Every event model is held to these rules - by the editor when it is saved,
and by this repository's CI (`tools/validate`) for every template.

- **R1 - a command only connects to events of its own system.** The system
  that executes a command records what happened; it never records another
  system's facts, and a read model is built only from its own system's
  events. When another system answers, that system's own command records the
  answer, and a policy in the asking system - a translation - turns it into
  the asking system's command and event:

  ```
  PaymentService   InitiatePayment -> PaymentCreated
  PaymentProvider                       (Authorize new payments) -> AuthorizeCharge -> ChargeAuthorized
  PaymentService   (Record authorization results) -> RecordAuthorization -> PaymentAuthorized   <- ChargeAuthorized
  ```

- **R2 - a command a UI trigger starts is exposed as a REST API.** A person's
  screen reaches a system over HTTP, so a command (or a read model) asked
  through a `frontend` trigger carries `@rest(<Verb>, "<path>")` in its domain
  language. Commands only policies, event triggers or schedules issue need none.

Besides the rules, a template must name only what its dependencies have, a
person starts a flow through a frontend trigger, an event is recorded by
exactly one command, and **every system of the event model is an actor (or
recipient) of the domain story** - the editor's board has a band for each of
the story's systems, so a system only the event model knows would leave its
steps nowhere to stand.

`PayForOrder/` is a complete example told in the Payment domain language: a
payment service and a payment provider handing a payment back and forth
through translations, with a status page and the nightly sweep's list of
abandoned payments as read models. Its story and event model are YAML; either
file can be JSON as well.
