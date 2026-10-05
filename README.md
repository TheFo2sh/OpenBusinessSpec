# OpenBusinessSpec

Business templates to start a project from: domain languages and the domain
stories told in them.

- `DomainLanguages/<Name>/` - a domain language package: `manifest.yaml` and
  its items as TypeSpec, in the `okeno-schema-markers` dialect
  (`WorkObjects.tsp`, `Actors.tsp`, `Commands.tsp`, `Events.tsp`). Each item is
  marked with its stable id - `@workObject`, `@actor`, `@command` (`@rest`
  for its endpoint, `@readModel` for a command that answers a question
  instead of changing state), `@event` (`@restResponse`).
- `DomainStories/<Name>/` - a domain story package and, optionally, its event
  model; see [DomainStories/README.md](DomainStories/README.md), including
  the rules every event model is held to.

## Validation

Every push and pull request runs [`tools/validate`](tools/validate)
([workflow](.github/workflows/validate.yml)). It compiles every language with
the TypeSpec compiler, checks manifests, ids and package dependencies,
resolves every name a story uses, and holds each event model to the rules.
To run it locally:

```sh
cd tools/validate
npm ci
npm run validate
```
