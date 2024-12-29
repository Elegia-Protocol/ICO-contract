import { Address, Cell, toNano } from '@ton/core';
import { ICO } from '../wrappers/ICO';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const ico = provider.open(await ICO.fromInit(Cell.fromBase64(`Wallet code`), Address.parse("Jetton master address"), toNano("cost in TON per 1 token")));

    await ico.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(ico.address);

}
