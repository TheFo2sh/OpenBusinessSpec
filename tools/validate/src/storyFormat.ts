import { z } from 'zod';

/**
 * The files of a domain story package besides its manifest, as
 * DomainStories/README.md describes them. Items are named, never given ids;
 * a name is looked up in the package's dependency languages (`Alias/Name`
 * when two of them have it).
 */

const name = z.string().trim().min(1);
const names = z.array(name).min(1);

const sentenceSchema = z
    .object({
        actor: name,
        activity: name,
        workObject: name.optional(),
        workObjects: names.optional(),
        recipient: name.optional(),
        recipientActivity: z.string().trim().optional(),
    })
    .strict()
    .refine((s) => !!s.workObject !== !!s.workObjects, { message: 'Give either workObject or workObjects' });

export const domainStoryFileSchema = z
    .object({
        name: z.string().trim().optional(),
        description: z.string().optional(),
        sentences: z.array(sentenceSchema).min(1),
    })
    .strict();

const placed = z.union([name, z.object({ name, system: name.optional() }).strict()]);

const triggerSchema = z
    .object({
        name,
        kind: z.enum(['frontend', 'event', 'time']).default('frontend'),
        cron: z.string().trim().optional(),
        system: name.optional(),
    })
    .strict()
    .refine((t) => !t.cron || t.kind === 'time', { message: 'Only a time trigger has a cron' });

const policySchema = z
    .object({
        name,
        description: z.string().optional(),
        rules: z
            .array(
                z
                    .object({
                        when: name,
                        then: name.optional(),
                        condition: z
                            .object({ field: name, operator: z.enum(['eq', 'neq', 'gt', 'gte', 'lt', 'lte', 'contains']), value: z.string() })
                            .strict()
                            .optional(),
                        description: z.string().optional(),
                    })
                    .strict(),
            )
            .min(1),
        system: name.optional(),
    })
    .strict();

const flowSchema = z
    .object({
        system: name.optional(),
        startedBy: name.optional(),
        trigger: triggerSchema.optional(),
        policy: policySchema.optional(),
        command: placed.optional(),
        events: z.array(placed).optional(),
        reads: names.optional(),
    })
    .strict()
    .refine((f) => f.trigger || f.policy || f.command, { message: 'A flow needs a trigger, a policy or a command' })
    .refine((f) => !f.reads || f.trigger || f.policy, { message: 'A flow that reads a read model needs a trigger or a policy to ask it' });

const readModelSchema = z.object({ name, system: name.optional(), from: names }).strict();

export const eventModelFileSchema = z
    .object({
        systems: names,
        flows: z.array(flowSchema).min(1),
        readModels: z.array(readModelSchema).optional(),
    })
    .strict();

export type DomainStoryFile = z.infer<typeof domainStoryFileSchema>;
export type EventModelFile = z.infer<typeof eventModelFileSchema>;
export type PlacedName = z.infer<typeof placed>;

export function placedName(step: PlacedName): { name: string; system?: string } {
    return typeof step === 'string' ? { name: step } : step;
}
