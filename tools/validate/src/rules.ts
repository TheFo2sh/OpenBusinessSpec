/**
 * The rules every event model is held to - the same catalogue the editor
 * holds a saved model to. Each takes the model as nodes (with their kind and
 * system) and edges, and names the nodes that break it.
 */

export type ModelNode = {
    id: string;
    kind: 'trigger' | 'command' | 'event' | 'policy';
    name: string;
    system: string;
    /** Triggers only: what fires it - a person's UI (`frontend`), another system's event, or a schedule. */
    triggerKind?: 'frontend' | 'event' | 'time';
    /** Commands only: exposed as a REST API (`@rest` in its language). */
    restExposed?: boolean;
};
export type ModelGraph = { nodes: ModelNode[]; edges: { source: string; target: string; where: string }[] };
export type RuleViolation = { rule: string; where: string; message: string };

export type Rule = { id: string; title: string; check(graph: ModelGraph): RuleViolation[] };

/** R1: a command - a read model too - only connects to events of its own system. */
export const R1: Rule = {
    id: 'R1',
    title: 'A command only connects to events of its own system',
    check(graph) {
        const byId = new Map(graph.nodes.map((n) => [n.id, n]));
        const violations: RuleViolation[] = [];
        for (const edge of graph.edges) {
            const a = byId.get(edge.source);
            const b = byId.get(edge.target);
            const command = a?.kind === 'command' ? a : b?.kind === 'command' ? b : undefined;
            const event = a?.kind === 'event' ? a : b?.kind === 'event' ? b : undefined;
            if (!command || !event || command.system === event.system) continue;
            violations.push({
                rule: 'R1',
                where: edge.where,
                message: `command "${command.name}" (${command.system}) connects to event "${event.name}" of another system (${event.system}). A command only connects to events of its own system; reach another system through a policy in that system, which issues that system's own command.`,
            });
        }
        return violations;
    },
};

/**
 * R2: a command a UI trigger starts - a read model a screen asks, too - is
 * exposed as a REST API. A person's screen reaches a system over HTTP; a
 * command it calls that isn't exposed can't be called at all.
 */
export const R2: Rule = {
    id: 'R2',
    title: 'A command started by a UI trigger is exposed as a REST API',
    check(graph) {
        const byId = new Map(graph.nodes.map((n) => [n.id, n]));
        const violations: RuleViolation[] = [];
        const seen = new Set<string>();
        for (const edge of graph.edges) {
            const trigger = byId.get(edge.source);
            const command = byId.get(edge.target);
            if (trigger?.kind !== 'trigger' || trigger.triggerKind !== 'frontend' || command?.kind !== 'command' || command.restExposed) continue;
            if (seen.has(command.id)) continue;
            seen.add(command.id);
            violations.push({
                rule: 'R2',
                where: edge.where,
                message: `command "${command.name}" is started by the UI trigger "${trigger.name}" but is not exposed as a REST API. Give it @rest(<Verb>, "<path>") in its domain language (and bump the language's version).`,
            });
        }
        return violations;
    },
};

export const RULES: readonly Rule[] = [R1, R2];

export function checkRules(graph: ModelGraph): RuleViolation[] {
    return RULES.flatMap((rule) => rule.check(graph));
}
