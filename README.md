# Human verification for Lens

Assert your Lens profile belongs to an actual human through Worldcoin's [World ID](https://docs.worldcoin.org/world-id) protocol.

## ℹ️ About

This repository contains the **smart contract** that enables verification of [Lens Protocol](https://lens.xyz) profiles as owned by a unique human.

-   The verification is always exposed on-chain.
-   Human verification is done via the [World ID](https://docs.worldcoin.org/world-id) protocol.
-   A single human can only have one verified Lens profile. Verifying a new profile will remove the verification from the previous profile.

## 🚀 Deployment

The official World ID <> Lens smart contract can be found at `0x8f9b3A2Eb1dfa6D90dEE7C6373f9C0088FeEebAB` on the Polygon Network. To deploy your own version of this contract, follow these instructions.

1. Get an App ID and action from Worldcoin's [Developer Portal](https://developer.worldcoin.org).
2. Run [Foundry's `forge create` command](https://book.getfoundry.sh/reference/forge/forge-create).

<!-- WORLD-ID-SHARED-README-TAG:START - Do not remove or modify this section directly -->
<!-- The contents of this file are inserted to all World ID repositories to provide general context on World ID. -->
<!-- WORLD-ID-SHARED-README-TAG:END -->

## 🧑‍💻 Development

1. Install [Foundry](https://getfoundry.sh/).
2. Install dependencies & build smart contracts
    ```sh
    make
    ```

### Using the contract

To test the contract with your own deployment, we recommend you use World ID's [Staging network](https://docs.worldcoin.org/quick-start/testing),

1. Point your smart contract to the World ID's Staging network contract, which can be found at https://docs.worldcoin.org/reference/address-book.
2. Register an identity as "verified" using Worldcoin's [Simulator](https://simulator.worldcoin.org).
3. Use the hosted IDKit's widget & the Simulator to generate a World ID proof to execute the humanity check.
    - Easiest way is to use the [Try it out](https://docs.worldcoin.org/try) page on the Worldcoin Docs.
    - After going through the process on the Simulator, you'll get the proof, nullifier hash & Merkle root.
4. Call `HumanCheck.verify(PROFILE_ID, merkle_root, nullifier_hash, proof)` in your contract. The last three parameters are obtained on step 6.
5. You can now check your profile is verified by calling `HumanCheck.isVerified(PROFILE_ID)`.
