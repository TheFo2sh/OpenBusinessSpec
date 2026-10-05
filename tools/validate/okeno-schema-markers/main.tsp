import "./lib.js";

/**
 * Marks a field as copied in from another model — e.g. a command's `input`
 * model field copied from its work object's model. Purely informational: a
 * no-op decorator, kept only so a generated schema's provenance is visible
 * as a real, valid TypeSpec construct instead of a comment convention.
 */
extern dec from(target: unknown, source: valueof string);

/**
 * Links a model to the domain language work object it represents, by that
 * work object's stable Domain Language Item id
 * (specs/0025-Domain-Language-Refactor). This is the only thing that ties
 * the two together: a model carrying it is that work object, whatever either
 * is renamed to, and a model without it is one the schema has just gained.
 */
extern dec workObject(target: unknown, id: valueof string);

/**
 * The work object's icon, as the relative Iconify url the domain language
 * stores (`iconify/mdi/cart`). Round-trips the one work object field that
 * has no natural TypeSpec home — a description is already `@doc`, and the
 * name is the model's own.
 */
extern dec icon(target: unknown, url: valueof string);

/**
 * Marks a model as a domain language command, by its stable Domain Language
 * Item id. The model's `input`, `computed`, `output` and `context`
 * properties are the command's payload sections — the single-model form of
 * the four separate `input`/`computed`/`output`/`context` models a stored
 * command payload uses.
 */
extern dec command(target: Reflection.Model, id: valueof string);

/**
 * Exposes a command over REST — the TypeSpec form of a command's rest
 * config (`{ enabled: true, method, url }`). `verb` is `Get`, `Post`, `Put`,
 * `Patch` or `Delete`, case-insensitive.
 *
 * A template writes the verb bare — `@rest(Post, "/payments")` — which
 * `templateTypeSpecSource.ts` quotes before compiling. It is deliberately not
 * an enum with `Post`/`Get`/... aliases: those would be global names, and
 * would clash with any schema declaring a model called `Post`.
 */
extern dec rest(target: Reflection.Model, verb: valueof string, path: valueof string);

/**
 * Marks a model as a domain language event, by its stable Domain Language
 * Item id. The model is the event's `EventData`; the `EventEnvelope` is
 * built around it, with `source` as the envelope's source.
 *
 * A template writes the source as `source: "/payments"`, which TypeSpec has
 * no syntax for — `templateTypeSpecSource.ts` rewrites it to a positional
 * argument before compiling.
 */
extern dec event(target: Reflection.Model, id: valueof string, source?: valueof string);

/**
 * The response an event produces when its command is called over REST —
 * the TypeSpec form of an event's response config
 * (`{ enabled: true, statusCode, body }`). `body` is a JSON example.
 */
extern dec restResponse(target: Reflection.Model, statusCode: valueof int32, body?: valueof string);

/**
 * Marks a model as a domain language actor, by its stable Domain Language
 * Item id. `type` is `Human`, `InternalSystem` or `ExternalSystem`, written
 * `type: "Human"` in a template (see `@event` for how that is accepted).
 */
extern dec actor(target: Reflection.Model, id: valueof string, type?: valueof string);

/**
 * Marks a `@command` model as a read model: a command that answers a
 * question instead of changing state - built from the events it shows,
 * recording none. The TypeSpec form of a command's `isReadModel` flag.
 */
extern dec readModel(target: Reflection.Model);
