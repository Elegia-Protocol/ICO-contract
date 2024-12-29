import { CompilerConfig } from '@ton/blueprint';

export const compile: CompilerConfig = {
    lang: 'tact',
    target: 'contracts/i_c_o.tact',
    options: {
        debug: true,
    },
};
