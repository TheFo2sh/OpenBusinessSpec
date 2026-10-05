/** One thing wrong with a template, and the file it is in (relative to the repository root). */
export type Problem = { file: string; message: string };

export class Problems {
    readonly list: Problem[] = [];

    add(file: string, message: string): void {
        if (!this.list.some((p) => p.file === file && p.message === message)) this.list.push({ file, message });
    }
}
