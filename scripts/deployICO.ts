import { toNano } from '@ton/core';
import { ICO } from '../wrappers/ICO';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const iCO = provider.open(await ICO.fromInit());

    await iCO.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(iCO.address);

    // run methods on `iCO`
}
