# Elegia ICO contract
# Be careful! The contract is in alpha version, vulnerabilities are possible. 
To configure the contract and then deploy it, edit the scripts/deployIco.ts file\
[Example](https://testnet.tonviewer.com/kQANyRL6_O-0E3mP1Gqrc5VjNi6imNQX25mhArHIsVCbLmBW "Tonviewer")

## Project structure

-   `contracts` - source code of all the smart contracts of the project and their dependencies.
-   `wrappers` - wrapper classes (implementing `Contract` from ton-core) for the contracts, including any [de]serialization primitives and compilation functions.
-   `scripts` - scripts used by the project, mainly the deployment scripts.

## How to use

### Build

`npx blueprint build` or `yarn blueprint build`

### Deploy or run another script

`npx blueprint run` or `yarn blueprint run`
