import { Address, toNano } from '@ton/core';
import { ICO } from '../wrappers/ICO';
import { NetworkProvider, sleep } from '@ton/blueprint';

export async function run(provider: NetworkProvider, args: string[]) {
    const ui = provider.ui();

    const address = Address.parse(args.length > 0 ? args[0] : await ui.input('Ico contract address'));

    if (!(await provider.isContractDeployed(address))) {
        ui.write(`Error: Contract at address ${address} is not deployed!`);
        return;
    }

    const ico = provider.open(ICO.fromAddress(address));

    await ico.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        "stop"
    )

    await ico.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Widthrow',
            jettons_amount: toNano('0.5')
        }
    );
    await ico.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        'open'
    )

    ui.clearActionPrompt();
    ui.write('Ico restarted successfully!');
}
