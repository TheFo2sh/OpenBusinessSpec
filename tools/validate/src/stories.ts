import type { LanguageItem, LanguageItems } from './dialect.js';
import { parseFile, storyManifestSchema, type LanguageManifest } from './manifests.js';
import { Problems } from './problems.js';
import type { TemplateFolder } from './repository.js';
import { checkRules, type ModelGraph, type ModelNode } from './rules.js';
import { domainStoryFileSchema, eventModelFileSchema, placedName, type EventModelFile } from './storyFormat.js';

export type InstalledLanguage = { manifest: LanguageManifest; items: LanguageItems; folder: string };
type Kind = keyof LanguageItems;
type Dependency = { packageId: string; alias?: string; language: InstalledLanguage };

const STORY_FILE = /^DomainStory\.(ya?ml|json)$/i;
const EVENT_MODEL_FILE = /^EventModel\.(ya?ml|json)$/i;
const SINGULAR: Record<Kind, string> = { actors: 'actor', workObjects: 'work object', commands: 'command', events: 'event' };

/** Looks names up in a story's dependencies, as the editor does on import: `Name`, or `Alias/Name` when two dependencies have it. */
class Resolver {
    constructor(private readonly dependencies: Dependency[], private readonly problems: Problems) {}

    resolve<K extends Kind>(kind: K, reference: string, file: string, where: string): LanguageItems[K][number] | undefined {
        const slash = reference.indexOf('/');
        const alias = slash > 0 ? reference.slice(0, slash).trim().toLowerCase() : undefined;
        const name = (slash > 0 ? reference.slice(slash + 1) : reference).trim().toLowerCase();
        const languages = alias
            ? this.dependencies.filter((d) => d.alias?.toLowerCase() === alias || d.packageId.toLowerCase() === alias)
            : this.dependencies;
        if (alias && languages.length === 0) {
            this.problems.add(file, `${where}: no dependency is called "${reference.slice(0, slash)}"`);
            return undefined;
        }
        const matches = languages.flatMap((d) => (d.language.items[kind] as LanguageItem[]).filter((item) => item.name.toLowerCase() === name));
        if (matches.length === 0) this.problems.add(file, `${where}: no ${SINGULAR[kind]} "${reference}" in the story's dependencies`);
        if (matches.length > 1) this.problems.add(file, `${where}: "${reference}" is a ${SINGULAR[kind]} of more than one dependency - qualify it as Alias/Name`);
        return matches.length === 1 ? (matches[0] as LanguageItems[K][number]) : undefined;
    }
}

export function checkStory(story: TemplateFolder, languagesByPackage: Map<string, InstalledLanguage>, problems: Problems): string | undefined {
    const manifestFile = `${story.folder}/manifest.yaml`;
    if (story.files['manifest.yaml'] === undefined) {
        problems.add(story.folder, 'has no manifest.yaml');
        return undefined;
    }
    const manifest = parseFile(manifestFile, story.files['manifest.yaml'], storyManifestSchema, problems);
    for (const file of Object.keys(story.files)) {
        if (file !== 'manifest.yaml' && !STORY_FILE.test(file) && !EVENT_MODEL_FILE.test(file) && file.toLowerCase() !== 'readme.md') {
            problems.add(`${story.folder}/${file}`, 'is not a file of a story package (manifest.yaml, DomainStory.*, EventModel.*)');
        }
    }
    if (!manifest) return undefined;

    const dependencies: Dependency[] = [];
    for (const dependency of manifest.Dependencies) {
        const language = languagesByPackage.get(dependency.PackageId.toLowerCase());
        if (!language) {
            problems.add(manifestFile, `depends on ${dependency.PackageId}, which is not a domain language of this repository`);
            continue;
        }
        if (dependency.Version && dependency.Version !== language.manifest.Version) {
            problems.add(manifestFile, `depends on ${dependency.PackageId} ${dependency.Version}, but ${language.folder} is version ${language.manifest.Version}`);
        }
        dependencies.push({ packageId: dependency.PackageId, alias: dependency.Alias, language });
    }
    const resolver = new Resolver(dependencies, problems);

    const pick = (pattern: RegExp, what: string, required: boolean): string | undefined => {
        const files = Object.keys(story.files).filter((f) => pattern.test(f));
        if (files.length > 1) problems.add(story.folder, `has more than one ${what} file (${files.join(', ')})`);
        if (files.length === 0 && required) problems.add(story.folder, `has no ${what} file (DomainStory.yaml, .yml or .json)`);
        return files[0];
    };

    // The story's actors, by item id - an event model system must be one of them.
    const told = new Set<string>();
    const storyFile = pick(STORY_FILE, 'domain story', true);
    if (storyFile) {
        const file = `${story.folder}/${storyFile}`;
        const domainStory = parseFile(file, story.files[storyFile]!, domainStoryFileSchema, problems);
        for (const [index, sentence] of (domainStory?.sentences ?? []).entries()) {
            const where = `sentence ${index + 1}`;
            const actor = resolver.resolve('actors', sentence.actor, file, `${where} actor`);
            if (actor) told.add(actor.id);
            if (sentence.recipient) {
                const recipient = resolver.resolve('actors', sentence.recipient, file, `${where} recipient`);
                if (recipient) told.add(recipient.id);
            }
            for (const workObject of sentence.workObjects ?? [sentence.workObject!]) resolver.resolve('workObjects', workObject, file, `${where} work object`);
        }
    }

    const eventModelFile = pick(EVENT_MODEL_FILE, 'event model', false);
    if (eventModelFile) {
        const file = `${story.folder}/${eventModelFile}`;
        const eventModel = parseFile(file, story.files[eventModelFile]!, eventModelFileSchema, problems);
        if (eventModel) {
            checkEventModel(eventModel, resolver, file, problems);
            // The editor's board has a band per system of the story: a system only
            // the event model knows would leave its steps nowhere to stand.
            if (storyFile) {
                for (const system of eventModel.systems) {
                    const actor = resolver.resolve('actors', system, file, 'systems');
                    if (actor && !told.has(actor.id)) {
                        problems.add(file, `systems: "${system}" is a system of the event model but no sentence of the domain story has it as an actor or recipient - tell its part in the story`);
                    }
                }
            }
        }
    }
    return manifest.PackageId;
}

/**
 * Every name the event model uses, what each must be, and the event model
 * rules (R1, ...) on the model the flows build. A command or event sits in
 * the system of the first flow that names it, as the editor places it.
 */
function checkEventModel(model: EventModelFile, resolver: Resolver, file: string, problems: Problems): void {
    const systems = new Set(model.systems.map((s) => s.toLowerCase()));
    const inSystems = (system: string | undefined, where: string) => {
        if (system && !systems.has(system.toLowerCase())) problems.add(file, `${where}: "${system}" is not one of the event model's systems`);
    };
    for (const system of model.systems) {
        const actor = resolver.resolve('actors', system, file, 'systems');
        if (actor?.actorType === 'Human') problems.add(file, `systems: "${system}" is a human actor; a system is an internal or external system`);
    }

    const nodes = new Map<string, ModelNode>();
    const graph: ModelGraph = { nodes: [], edges: [] };
    const defaultSystem = model.systems[0]!.toLowerCase();
    const place = (kind: ModelNode['kind'], name: string, system: string | undefined): ModelNode => {
        const id = `${kind}:${name.toLowerCase()}`;
        if (!nodes.has(id)) nodes.set(id, { id, kind, name, system: (system ?? defaultSystem).toLowerCase() });
        return nodes.get(id)!;
    };
    const connect = (from: ModelNode | undefined, to: ModelNode | undefined, where: string) => {
        if (from && to) graph.edges.push({ source: from.id, target: to.id, where });
    };

    // Every command and its events first, in the systems their flows give them.
    const recordedBy = new Map<string, Set<string>>();
    for (const [index, flow] of model.flows.entries()) {
        const where = `flow ${index + 1}`;
        inSystems(flow.system, where);
        const step = flow.command ? placedName(flow.command) : undefined;
        let command: ModelNode | undefined;
        if (step) {
            inSystems(step.system, where);
            const item = resolver.resolve('commands', step.name, file, `${where} command`);
            if (item?.isReadModel && (flow.events ?? []).length > 0) problems.add(file, `${where}: "${step.name}" is a read model; a read model records no event`);
            command = place('command', step.name, step.system ?? flow.system);
            if (item) command.restExposed = item.restExposed;
        }
        for (const eventStep of (flow.events ?? []).map(placedName)) {
            inSystems(eventStep.system, where);
            resolver.resolve('events', eventStep.name, file, `${where} event`);
            const event = place('event', eventStep.name, eventStep.system ?? flow.system);
            connect(command, event, where);
            if (step) recordedBy.set(event.id, new Set([...(recordedBy.get(event.id) ?? []), step.name]));
        }
    }
    for (const [eventId, commands] of recordedBy) {
        if (commands.size > 1) problems.add(file, `event "${nodes.get(eventId)!.name}" is recorded by more than one command (${[...commands].join(', ')}); a fact is recorded by the one command that makes it happen`);
    }

    const readModels = new Map<string, ModelNode>();
    for (const [index, readModel] of (model.readModels ?? []).entries()) {
        const where = `read model ${index + 1}`;
        inSystems(readModel.system, where);
        const item = resolver.resolve('commands', readModel.name, file, where);
        if (item && !item.isReadModel) problems.add(file, `${where}: "${readModel.name}" is a command that is not marked as a read model (@readModel)`);
        const node = place('command', readModel.name, readModel.system);
        if (item) node.restExposed = item.restExposed;
        readModels.set(readModel.name.toLowerCase(), node);
        for (const eventName of readModel.from) {
            resolver.resolve('events', eventName, file, `${where} from`);
            connect(place('event', eventName, readModel.system), node, where);
        }
    }

    for (const [index, flow] of model.flows.entries()) {
        const where = `flow ${index + 1}`;
        let trigger: ModelNode | undefined;
        if (flow.trigger) {
            inSystems(flow.trigger.system, where);
            // A flow's trigger is its own node - two flows' triggers are two triggers, even with one name.
            trigger = { id: `trigger:${index}`, kind: 'trigger', name: flow.trigger.name, system: (flow.trigger.system ?? flow.system ?? model.systems[0]!).toLowerCase(), triggerKind: flow.trigger.kind };
            nodes.set(trigger.id, trigger);
            if (flow.command) connect(trigger, nodes.get(`command:${placedName(flow.command).name.toLowerCase()}`), where);
        }
        if (flow.startedBy) {
            const person = resolver.resolve('actors', flow.startedBy, file, `${where} startedBy`);
            if (person && person.actorType !== 'Human') problems.add(file, `${where}: startedBy "${flow.startedBy}" is not a human actor`);
            if (flow.trigger?.kind !== 'frontend') problems.add(file, `${where}: a person starts a flow through a frontend trigger`);
        }
        if (flow.policy) {
            inSystems(flow.policy.system, where);
            const policy = place('policy', flow.policy.name, flow.policy.system ?? flow.system);
            for (const rule of flow.policy.rules) {
                resolver.resolve('events', rule.when, file, `${where} policy rule`);
                connect(place('event', rule.when, flow.system), policy, where);
                if (rule.then) {
                    resolver.resolve('commands', rule.then, file, `${where} policy rule`);
                    connect(policy, place('command', rule.then, flow.system), where);
                } else if (!flow.command) {
                    problems.add(file, `${where}: a policy rule without "then" needs the flow's command`);
                }
            }
        }
        for (const read of flow.reads ?? []) {
            if (!readModels.has(read.toLowerCase())) problems.add(file, `${where}: reads "${read}", which is not one of the event model's read models`);
            else connect(trigger, readModels.get(read.toLowerCase()), where);
        }
    }

    graph.nodes = [...nodes.values()];
    for (const violation of checkRules(graph)) problems.add(file, `${violation.where}: ${violation.rule} - ${violation.message}`);
}
