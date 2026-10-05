import fs from 'node:fs';
import path from 'node:path';

export type TemplateFolder = {
    /** The folder's name, which is the template's id. */
    id: string;
    /** Relative to the repository root, with forward slashes. */
    folder: string;
    /** File name -> contents. */
    files: Record<string, string>;
};

export type Repository = {
    root: string;
    languages: TemplateFolder[];
    stories: TemplateFolder[];
};

function folders(root: string, parent: string): TemplateFolder[] {
    const dir = path.join(root, parent);
    if (!fs.existsSync(dir)) return [];
    return fs
        .readdirSync(dir, { withFileTypes: true })
        .filter((entry) => entry.isDirectory())
        .map((entry) => {
            const folderDir = path.join(dir, entry.name);
            const files = Object.fromEntries(
                fs
                    .readdirSync(folderDir, { withFileTypes: true })
                    .filter((file) => file.isFile())
                    .map((file) => [file.name, fs.readFileSync(path.join(folderDir, file.name), 'utf-8')]),
            );
            return { id: entry.name, folder: `${parent}/${entry.name}`, files };
        })
        .sort((a, b) => a.id.localeCompare(b.id));
}

/** The repository's templates: `DomainLanguages/<Name>/` and `DomainStories/<Name>/`. */
export function readRepository(root: string): Repository {
    return { root, languages: folders(root, 'DomainLanguages'), stories: folders(root, 'DomainStories') };
}
