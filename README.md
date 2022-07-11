# Human verification for Lens

Assert your Lens profile belongs to an actual human through Worldcoin's [World ID](https://id.worldcoin.org) protocol.

<!-- TODO: Profile with badge here -->

## ℹ️ About

This repository contains the **smart contract** that enables verification of [Lens Protocol](https://lens.xyz) profiles as owned by a unique human.
- The verification is always exposed on-chain.
- Human verification is done via the [World ID](https://id.worldcoin.org) protocol.
- A single human can only have one verified Lens profile. Verifying a new profile will remove the verification from the previous profile.

## 🚀 Deployment

The official World ID <> Lens smart contract can be found at `0x000`. To deploy your own version of this contract, follow these instructions.
1. Update `HumanCheck.sol` with your own Action ID (you can obtain one from Worldcoin's [Developer Portal](https://developer.worldcoin.org)).
2. Run `make deploy`.

<!-- WORLD-ID-SHARED-README-TAG:START - Do not remove or modify this section directly -->
<!-- The contents of this file are inserted to all World ID repositories to provide general context on World ID. -->
<!-- WORLD-ID-SHARED-README-TAG:END -->

## 🧑‍💻 Development & testing

1. Install [Foundry](https://github.com/gakonst/foundry).
    ```sh
    curl -L https://foundry.paradigm.xyz | bash
    foundryup # run on a new terminal window; installs latest version
    ```
2. Install [Node.js](https://nodejs.org/en/) v16 or above (required for tests). We recommend [nvm](https://github.com/nvm-sh/nvm) if you use multiple node versions.
3. Install dependencies & build smart contracts
    ```sh
    make
    ```
4. Run tests
    ```sh
    make test
    ```

To test the contract with your own deployment, we recommend you use World ID's [Staging network](https://id.worldcoin.org/test),

1. Point your smart contract to the World ID's Staging network contract, which can be found at https://developer.worldcoin.org/api/v1/contracts.
2. Register an identity as "verified" using Worldcoin's [Simulator](https://simulator.worldcoin.org). Be sure to click on **verify identity.**
3. Use the hosted World ID's widget & the Simulator to generate a ZKP to execute the humanity check.
    - Easiest way is to visit `https://id.worldcoin.org/use?action_id={your_action_id}&signal={lensProfileId}&return_to=https%3A%2F%2Flocalhost%3A8000`
    - When you click on the widget you'll get a QR code, copy it and paste it in the simulator.
    - After going through the process on the Simulator, you'll get the proof, nullifier hash & Merkle root in your return URL (as query string parameters).
4. Call `HumanCheck.verify(PROFILE_ID, merkle_root, nullifier_hash, proof)` in your contract. The last three parameters are obtained on step 6.
5. You can now check your profile is verified by calling `HumanCheck.isVerified(PROFILE_ID)`.
