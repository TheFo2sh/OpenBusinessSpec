/**
 * The rules every event model is held to - the same catalogue the editor
 * holds a saved model to. Each takes the model as nodes (with their kind and
 * system) and edges, and names the nodes that break it.
 */

export type ModelNode = { id: string; kind: 'trigger' | 'command' | 'event' | 'policy'; name: string; system: string };
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

export const RULES: readonly Rule[] = [R1];

export function checkRules(graph: ModelGraph): RuleViolation[] {
    return RULES.flatMap((rule) => rule.check(graph));
}
