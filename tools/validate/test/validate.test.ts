import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { afterEach, describe, expect, it } from 'vitest';
import { validateRepository } from '../src/validate.js';

const REPO = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..', '..');
const copies: string[] = [];

/** A copy of the repository's templates, changed by `edit` (repository-relative path -> new contents, or a function of the old). */
function copyRepository(edit: Record<string, string | ((old: string) => string) | null> = {}): string {
    const root = fs.mkdtempSync(path.join(os.tmpdir(), 'obs-validate-'));
    copies.push(root);
    for (const top of ['DomainLanguages', 'DomainStories']) fs.cpSync(path.join(REPO, top), path.join(root, top), { recursive: true });
    for (const [file, change] of Object.entries(edit)) {
        const target = path.join(root, file);
        if (change === null) fs.rmSync(target);
        else fs.writeFileSync(target, typeof change === 'function' ? change(fs.readFileSync(target, 'utf-8')) : change);
    }
    return root;
}

afterEach(() => {
    for (const root of copies.splice(0)) fs.rmSync(root, { recursive: true, force: true });
});

const messages = async (root: string) => (await validateRepository(root)).map((p) => `${p.file}: ${p.message}`);

describe('the repository', () => {
    it('has only valid templates', async () => {
        expect(await validateRepository(REPO)).toEqual([]);
    });
});

describe('domain story templates', () => {
    const EVENT_MODEL = 'DomainStories/PayForOrder/EventModel.yaml';

    it('refuses a command recording another system\'s event (R1)', async () => {
        const root = copyRepository({
            [EVENT_MODEL]: (old) => old.replace('events: [PaymentAuthorized, PaymentFailed]', 'events: [PaymentAuthorized, { name: PaymentFailed, system: PaymentProvider }]'),
        });
        expect(await messages(root)).toEqual(expect.arrayContaining([
            expect.stringMatching(/EventModel\.yaml: flow 3: R1 - command "RecordAuthorization" \(paymentservice\) connects to event "PaymentFailed" of another system \(paymentprovider\)/),
        ]));
    });

    it('refuses a read model built from another system\'s events (R1), and one that is not marked @readModel', async () => {
        const root = copyRepository({
            [EVENT_MODEL]: (old) =>
                old
                    .replace('from: [PaymentCreated, PaymentAuthorized, PaymentFailed, PaymentCaptured, PaymentCanceled]', 'from: [PaymentCreated, ChargeCaptured]')
                    .replace('  - name: ViewPaymentStatus', '  - name: RecordCapture')
                    .replace('reads: [ViewPaymentStatus]', 'reads: [RecordCapture]'),
        });
        expect(await messages(root)).toEqual(expect.arrayContaining([
            expect.stringMatching(/read model 2: R1 - command "ListAbandonedPayments" \(paymentservice\) connects to event "ChargeCaptured"/),
            expect.stringMatching(/read model 1: "RecordCapture" is a command that is not marked as a read model/),
        ]));
    });

    it('refuses the PayForOrder of version 0.0.1, whose service recorded the provider\'s events', async () => {
        const root = copyRepository({
            [EVENT_MODEL]: null,
            'DomainStories/PayForOrder/EventModel.json': JSON.stringify({
                systems: ['PaymentService', 'PaymentProvider'],
                flows: [
                    { system: 'PaymentService', startedBy: 'Payer', trigger: { name: 'Checkout payment form', kind: 'frontend' }, command: 'InitiatePayment', events: ['PaymentCreated'] },
                    { system: 'PaymentService', command: 'RefundPayment', events: ['RefundRequested', { name: 'RefundSucceeded', system: 'PaymentProvider' }] },
                ],
            }),
        });
        expect(await messages(root)).toEqual([
            expect.stringMatching(/flow 2: R1 - command "RefundPayment" \(paymentservice\) connects to event "RefundSucceeded" of another system \(paymentprovider\)/),
        ]);
    });

    it('names what the languages lack, a wrong dependency version and an event recorded twice', async () => {
        const root = copyRepository({
            [EVENT_MODEL]: (old) =>
                old
                    .replace('command: CaptureCharge', 'command: CaptureMoney')
                    .replace('startedBy: Payer', 'startedBy: Shopper')
                    .replace('events: [PaymentCaptured]', 'events: [PaymentCaptured, PaymentAuthorized]'),
            'DomainStories/PayForOrder/manifest.yaml': (old) => old.replace('    Version: 0.0.2', '    Version: 0.0.1'),
        });
        expect(await messages(root)).toEqual(expect.arrayContaining([
            expect.stringMatching(/flow 4 command: no command "CaptureMoney"/),
            expect.stringMatching(/flow 1 startedBy: no actor "Shopper"/),
            expect.stringMatching(/manifest\.yaml: depends on M1Spec\.DomainLanguages\.Payment 0\.0\.1, but DomainLanguages\/Payment is version 0\.0\.2/),
            expect.stringMatching(/event "PaymentAuthorized" is recorded by more than one command \(RecordAuthorization, RecordCapture\)/),
        ]));
    });

    it('refuses an event model system the story never tells', async () => {
        const root = copyRepository({
            'DomainStories/ShopAndFillCart/DomainStory.yaml': (old) =>
                old.replace('recipient: CatalogService', 'recipient: CartService').replace('    recipientActivity: in\n', ''),
        });
        expect(await messages(root)).toEqual(expect.arrayContaining([
            expect.stringMatching(/ShopAndFillCart\/EventModel\.yaml: systems: "CatalogService" is a system of the event model but no sentence of the domain story has it/),
        ]));
    });

    it('checks the domain story names against the languages', async () => {
        const root = copyRepository({
            'DomainStories/PayForOrder/DomainStory.yaml': (old) => old.replace('workObject: PaymentMethod', 'workObject: Wallet'),
        });
        expect(await messages(root)).toEqual([expect.stringMatching(/DomainStory\.yaml: sentence 1 work object: no work object "Wallet"/)]);
    });
});

describe('domain language templates', () => {
    it('reports TypeSpec errors, ids that are not GUIDs or are used twice, and an unknown actor type', async () => {
        const root = copyRepository({
            'DomainLanguages/Payment/Events.tsp': (old) => old.replace('  charge: Charge;\n  declineReason?: string;', '  charge: Chrage;'),
            'DomainLanguages/Payment/Actors.tsp': (old) =>
                old.replace('"9b9f64dd-a52d-43aa-bc8f-3dd4bf9962c6", type:"Human"', '"not-a-guid", type:"Person"'),
            'DomainLanguages/Order/Commands.tsp': (old) => old.replace(/@command\("[^"]+"\)/, '@command("c71e54e6-9bc2-4650-809d-a2ec8774166f")'),
        });
        const found = await messages(root);
        expect(found).toEqual(expect.arrayContaining([
            expect.stringMatching(/DomainLanguages\/Payment\/Events\.tsp: TypeSpec: Unknown identifier Chrage/),
        ]));

        const typeSpecFixed = copyRepository({
            'DomainLanguages/Payment/Actors.tsp': (old) =>
                old.replace('"9b9f64dd-a52d-43aa-bc8f-3dd4bf9962c6", type:"Human"', '"not-a-guid", type:"Person"'),
            'DomainLanguages/Order/Commands.tsp': (old) => old.replace(/@command\("[^"]+"\)/, '@command("c71e54e6-9bc2-4650-809d-a2ec8774166f")'),
        });
        expect(await messages(typeSpecFixed)).toEqual(expect.arrayContaining([
            expect.stringMatching(/Payment\/Actors\.tsp: Payer: @actor needs the item's id as a GUID, not "not-a-guid"/),
            expect.stringMatching(/Payment\/Actors\.tsp: Payer: actor type "Person" is not one of/),
            expect.stringMatching(/Payment\/Commands\.tsp: InitiatePayment: id c71e54e6-9bc2-4650-809d-a2ec8774166f is already used by \w+ \(DomainLanguages\/Order\/Commands\.tsp\)/),
        ]));
    });

    it('refuses a package id used twice', async () => {
        const root = copyRepository({
            'DomainLanguages/Order/manifest.yaml': (old) => old.replace(/PackageId: .*/, 'PackageId: M1Spec.DomainLanguages.Payment'),
        });
        expect(await messages(root)).toEqual(expect.arrayContaining([expect.stringMatching(/PackageId M1Spec\.DomainLanguages\.Payment is already used by/)]));
    });
});
