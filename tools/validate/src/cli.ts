import path from 'node:path';
import { validateRepository } from './validate.js';

const root = path.resolve(process.argv[2] ?? '.');
const problems = await validateRepository(root);
const inActions = process.env.GITHUB_ACTIONS === 'true';

for (const problem of problems) {
    // On GitHub, each problem is an annotation on the file it is in.
    if (inActions) console.log(`::error file=${problem.file},title=Template::${problem.message.replace(/\r?\n/g, ' ')}`);
    else console.log(`${problem.file}: ${problem.message}`);
}
if (problems.length > 0) {
    console.log(`\n${problems.length} problem${problems.length === 1 ? '' : 's'} found.`);
    process.exit(1);
}
console.log('Every template is valid.');
