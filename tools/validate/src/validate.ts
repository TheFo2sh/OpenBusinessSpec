import { readLanguage } from './dialect.js';
import { languageManifestSchema, parseFile } from './manifests.js';
import { Problems, type Problem } from './problems.js';
import { readRepository } from './repository.js';
import { checkStory, type InstalledLanguage } from './stories.js';

/**
 * Checks every template of the repository at `root`: each language's
 * manifest and dialect files, and each story package against the languages
 * it depends on - its names, and the event model rules. Returns every
 * problem found; none means every template can be imported.
 */
export async function validateRepository(root: string): Promise<Problem[]> {
    const problems = new Problems();
    const repository = readRepository(root);
    const packageOwners = new Map<string, string>();
    const claimPackage = (packageId: string, folder: string) => {
        const owner = packageOwners.get(packageId.toLowerCase());
        if (owner) problems.add(`${folder}/manifest.yaml`, `PackageId ${packageId} is already used by ${owner}`);
        else packageOwners.set(packageId.toLowerCase(), folder);
    };

    const languagesByPackage = new Map<string, InstalledLanguage>();
    const itemOwners = new Map<string, string>();
    for (const language of repository.languages) {
        const manifestText = language.files['manifest.yaml'];
        if (manifestText === undefined) {
            problems.add(language.folder, 'has no manifest.yaml');
            continue;
        }
        const manifest = parseFile(`${language.folder}/manifest.yaml`, manifestText, languageManifestSchema, problems);
        const items = await readLanguage(language, problems);
        if (!manifest || !items) continue;
        claimPackage(manifest.PackageId, language.folder);

        for (const [kind, list] of Object.entries(items)) {
            const names = new Set<string>();
            for (const item of list as { id: string; name: string; file: string }[]) {
                const owner = itemOwners.get(item.id.toLowerCase());
                if (owner) problems.add(item.file, `${item.name}: id ${item.id} is already used by ${owner}`);
                else itemOwners.set(item.id.toLowerCase(), `${item.name} (${item.file})`);
                if (names.has(item.name.toLowerCase())) problems.add(item.file, `${item.name}: two ${kind} are called "${item.name}"`);
                names.add(item.name.toLowerCase());
            }
        }
        languagesByPackage.set(manifest.PackageId.toLowerCase(), { manifest, items, folder: language.folder });
    }

    for (const story of repository.stories) {
        const packageId = checkStory(story, languagesByPackage, problems);
        if (packageId) claimPackage(packageId, story.folder);
    }
    return problems.list;
}
