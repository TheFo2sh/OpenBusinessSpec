import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { compile, getSourceLocation, NodeHost, type Model } from '@typespec/compiler';
import { Problems } from './problems.js';
import type { TemplateFolder } from './repository.js';

export type ActorType = 'Human' | 'InternalSystem' | 'ExternalSystem';

export type LanguageItem = { id: string; name: string; file: string };
export type LanguageItems = {
    actors: (LanguageItem & { actorType: ActorType })[];
    workObjects: LanguageItem[];
    /** `restExposed`: the command carries `@rest` - it is exposed as a REST API. */
    commands: (LanguageItem & { isReadModel: boolean; restExposed: boolean })[];
    events: LanguageItem[];
};

const TSP_FILES = ['WorkObjects.tsp', 'Actors.tsp', 'Commands.tsp', 'Events.tsp'];
const DIALECT_DECORATORS = new Set(['command', 'rest', 'event', 'restResponse', 'actor']);
const DECORATOR_LINE_RE = /^(\s*@)(\w+)(\s*\()(.*)(\)\s*)$/;
const NAMED_ARGUMENT_RE = /(^|,)(\s*)[A-Za-z_]\w*\s*:\s*(?=["\d-])/g;
const BARE_FIRST_ARGUMENT_RE = /^(\s*)([A-Za-z_]\w*)(\s*(?:,|$))/;
const GUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const ACTOR_TYPES: ActorType[] = ['Human', 'InternalSystem', 'ExternalSystem'];
const REST_VERBS = ['get', 'post', 'put', 'patch', 'delete'];

/**
 * What a template writes, in what the markers library accepts: named
 * arguments become positional (`source: "/payments"`) and `@rest`'s bare verb
 * is quoted (`Post`). TypeSpec has no syntax for either.
 */
export function normalizeDialectSource(source: string): string {
    return source
        .split(/\r\n|\r|\n/)
        .map((line) => {
            const match = DECORATOR_LINE_RE.exec(line);
            if (!match || !DIALECT_DECORATORS.has(match[2]!)) return line;
            let args = match[4]!.replace(NAMED_ARGUMENT_RE, '$1$2');
            if (match[2] === 'rest') args = args.replace(BARE_FIRST_ARGUMENT_RE, '$1"$2"$3');
            return `${match[1]}${match[2]}${match[3]}${args}${match[5]}`;
        })
        .join('\n');
}

const WORK_DIR = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '.work');

function markerOf(model: Model, name: string): unknown[] | undefined {
    const application = model.decorators.find((d) => d.decorator.name === `$${name}` || d.definition?.name === `@${name}`);
    return application ? application.args.map((arg) => arg.jsValue) : undefined;
}

/**
 * Compiles a language's dialect files with the TypeSpec compiler - every
 * type they use must exist - and reads its items off their markers. The files
 * are compiled from a work folder inside this tool, so `import
 * "okeno-schema-markers"` finds the vendored markers library.
 */
export async function readLanguage(language: TemplateFolder, problems: Problems): Promise<LanguageItems | undefined> {
    const present = TSP_FILES.filter((file) => language.files[file] !== undefined);
    for (const file of Object.keys(language.files).filter((f) => f.endsWith('.tsp') && !TSP_FILES.includes(f))) {
        problems.add(`${language.folder}/${file}`, `is not one of the dialect files (${TSP_FILES.join(', ')})`);
    }
    if (present.length === 0) {
        problems.add(language.folder, `has none of the dialect files (${TSP_FILES.join(', ')})`);
        return undefined;
    }

    const dir = path.join(WORK_DIR, language.id);
    fs.rmSync(dir, { recursive: true, force: true });
    fs.mkdirSync(dir, { recursive: true });
    for (const file of present) fs.writeFileSync(path.join(dir, file), normalizeDialectSource(language.files[file]!));
    const main = path.join(dir, 'main.tsp');
    fs.writeFileSync(main, present.map((file) => `import "./${file}";`).join('\n') + '\n');

    const program = await compile(NodeHost, main, { noEmit: true });
    const fileOf = (target: Parameters<typeof getSourceLocation>[0]) => `${language.folder}/${path.basename(getSourceLocation(target)?.file.path ?? "main.tsp")}`;
    const errors = program.diagnostics.filter((d) => d.severity === 'error');
    for (const diagnostic of errors) {
        const where = typeof diagnostic.target === 'object' && diagnostic.target !== null && 'kind' in diagnostic.target
            ? fileOf(diagnostic.target as never)
            : language.folder;
        problems.add(where.endsWith('main.tsp') ? language.folder : where, `TypeSpec: ${diagnostic.message}`);
    }
    if (errors.length > 0) return undefined;

    const items: LanguageItems = { actors: [], workObjects: [], commands: [], events: [] };
    const global = program.getGlobalNamespaceType();
    for (const model of global.models.values()) {
        if (!model.node || !path.resolve(getSourceLocation(model.node)?.file.path ?? "").startsWith(dir)) continue;
        const file = fileOf(model.node);
        const idOf = (args: unknown[], marker: string): string => {
            const id = typeof args[0] === 'string' ? args[0].trim() : '';
            if (!GUID_RE.test(id)) problems.add(file, `${model.name}: @${marker} needs the item's id as a GUID, not "${id}"`);
            return id;
        };

        const command = markerOf(model, 'command');
        const event = markerOf(model, 'event');
        const actor = markerOf(model, 'actor');
        const workObject = markerOf(model, 'workObject');
        const kinds = [command, event, actor, workObject].filter((m) => m !== undefined).length;
        if (kinds > 1) problems.add(file, `${model.name} is marked as more than one kind of item`);

        if (markerOf(model, 'readModel') && !command) problems.add(file, `${model.name}: @readModel only marks a @command`);
        const rest = markerOf(model, 'rest');
        if (rest) {
            if (!command) problems.add(file, `${model.name}: @rest only goes on a @command`);
            if (!REST_VERBS.includes(String(rest[0]).toLowerCase())) problems.add(file, `${model.name}: @rest verb "${String(rest[0])}" is not one of Get, Post, Put, Patch, Delete`);
            if (!String(rest[1] ?? '').startsWith('/')) problems.add(file, `${model.name}: @rest path "${String(rest[1] ?? '')}" must start with "/"`);
        }
        if (markerOf(model, 'restResponse') && !event) problems.add(file, `${model.name}: @restResponse only goes on an @event`);

        if (command) items.commands.push({ id: idOf(command, 'command'), name: model.name, file, isReadModel: !!markerOf(model, 'readModel'), restExposed: !!rest });
        else if (event) items.events.push({ id: idOf(event, 'event'), name: model.name, file });
        else if (actor) {
            const actorType = (actor[1] ?? 'InternalSystem') as ActorType;
            if (!ACTOR_TYPES.includes(actorType)) problems.add(file, `${model.name}: actor type "${String(actor[1])}" is not one of ${ACTOR_TYPES.join(', ')}`);
            items.actors.push({ id: idOf(actor, 'actor'), name: model.name, file, actorType });
        } else if (workObject) items.workObjects.push({ id: idOf(workObject, 'workObject'), name: model.name, file });
    }
    return items;
}
