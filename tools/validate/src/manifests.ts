import { parse } from 'yaml';
import { z } from 'zod';
import { Problems } from './problems.js';

const text = z.string().trim().min(1);
const version = z.string().regex(/^\d+\.\d+\.\d+$/, 'a version is major.minor.patch, e.g. 0.0.1');
const packageId = z.string().regex(/^[A-Za-z][\w]*(\.[A-Za-z][\w]*)+$/, 'a PackageId is dotted, e.g. M1Spec.DomainLanguages.Payment');
const icon = z.string().regex(/^\/iconify\/[a-z0-9-]+\/[a-z0-9-]+\.svg$/, 'an icon is "/iconify/<set>/<name>.svg"');

export const languageManifestSchema = z
    .object({
        Name: text,
        PackageId: packageId,
        Version: version,
        Description: z.string().optional(),
        Icon: icon.optional(),
        Color: z.string().regex(/^#[0-9A-Fa-f]{6}$/).optional(),
        Publisher: text.optional(),
    })
    .strict();

export const storyManifestSchema = z
    .object({
        Name: text,
        PackageId: packageId,
        Version: version,
        Description: z.string().optional(),
        Icon: icon.optional(),
        Publisher: text.optional(),
        Dependencies: z
            .array(z.object({ PackageId: packageId, Version: version.optional(), Alias: z.string().regex(/^[A-Za-z]\w*$/).optional() }).strict())
            .min(1),
    })
    .strict();

export type LanguageManifest = z.infer<typeof languageManifestSchema>;
export type StoryManifest = z.infer<typeof storyManifestSchema>;

/** Parses a YAML or JSON file against a schema, reporting where it breaks it. */
export function parseFile<T>(file: string, content: string, schema: z.ZodType<T, z.ZodTypeDef, unknown>, problems: Problems): T | undefined {
    let data: unknown;
    try {
        data = /\.json$/i.test(file) ? JSON.parse(content) : parse(content);
    } catch (error) {
        problems.add(file, `is not valid ${/\.json$/i.test(file) ? 'JSON' : 'YAML'}: ${error instanceof Error ? error.message : String(error)}`);
        return undefined;
    }
    const result = schema.safeParse(data);
    if (!result.success) {
        for (const issue of result.error.issues) problems.add(file, `${issue.path.join('.') || '(root)'}: ${issue.message}`);
        return undefined;
    }
    return result.data;
}
