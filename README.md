# Dante Protocol SDK for Flow
## Introduction
This is the SDK with which developers can easily build their Omnichain dApps based on Dante Protocol Stack on Flow. It's a little bit different from SDKs in other technology stack, the `flow-sdk` are quite convenient and even if with the `low-level-api` developers only need to create their own [Submitter](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L39) and [SentMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L163) resources to make smart contracts invocation and send messages out to other chains. Similarly, they only need to create their own [ReceivedMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L194) to receive resouce calls and messages from other chains.  
More details can be seen at [High-Level-API](#high-level-api) and [Low-Level-API](#low-level-api), and we provide two typical examples at [examples](#examples);

## Index
* [Environment](#environment)
* [High-Level API](#high-level-api)
* [Basic Tools](#basic-tools)
* [Low-Level API](#low-level-api)
* [Omnichain NFT](#omnichain-nft)
* [Examples](#examples)

## Environment
### Deployment
#### Testnet
* Officially, we have deployed the Protocol Stack at `0x5f37faed5f558aca` including the [Dante Protocol Stack](https://github.com/dantenetwork/cadence-contracts) and [Omnichain NFT Infrastructure](https://github.com/dantenetwork/cadence-contracts/tree/main/omniverseNFT).  
* We also deploy the Protocol Stack at [0x2999fe13d3CAa63C0bC523E8D5b19A265637dbd2](https://github.com/dantenetwork/solidity-contract-template/tree/flow-rinkeby#cross-chain-contract-address) on Rinkeby for dev-test. If you want to build your own Omnichain smart contracts on Rinkeby, you can see more details at [solidity sdk tutorial](https://github.com/dantenetwork/solidity-contract-template/tree/flow-rinkeby).

**Note that the `testnet-account` in [flow.json](./flow.json) is just for dev-testing, which may have already been used. So remember to create your own account to make operation on Testnet. You can follow this [tutorial](https://developers.flow.com/tools/flow-cli/create-accounts) to create a new account on Testnet and fund faucet [here](https://testnet-faucet.onflow.org/fund-account)** 

#### Emulator
As an Omnichain infrastructure, it's necessary to cooperate with other chains and in order to test in the local environment, there needs a simulator. Currently, the simulator is under developing. So we recommend you to choose the Testnet version to develop your dApps.

## High-Level API
The high-level api provides a very convenient way to create `resources`. When the contract [SDKUtility](./contracts/SDKUtility.cdc) is deployed with your own account, all omnichain resources including `ReceivedMessageVault`, `SentMessageVault`, and `Submitter` are created, saved and registered by the constructor. More over, `SDKUtility` provides some methods with `access(account)` to help developers implement cross-chain operations. The `access(account)` means only the deployed account related smart contracts and resources has the permission to call these methods.  
* [callOut](./contracts/SDKUtility.cdc#L30): help developers send an invocation out with a callback to receive results. The parameter `callback` is a string to build a `PublicPath`, which is transformed to `utf8` to be the input. And the `callback` is related to the interface `ReceivedMessageContract.Callee` of resources that is neccessary to receive messages from outside. In addition, although the `callOut` and `callback` heppen in different blocks, which is asynchronous of course, they could still be "connected" by [Session](./exampleApp/computation/contracts/Cocomputation.cdc#L53) in [Context](./exampleApp/computation/contracts/Cocomputation.cdc#L50).  
* [sendOut](./contracts/SDKUtility.cdc#L49): help developers send a common message out without a callback. An example can be found at [ComputationServer](./exampleApp/computation/contracts/Cocomputation.cdc#L88).  

Both `callOut` and `sendOut` return a [ContextKeeper.Context](https://github.com/dantenetwork/cadence-contracts/blob/f4f834e9b1d899619db8273554273e23d8e10d9c/contracts/ContextKeeper.cdc#L5), which contains a [Session](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/MessageProtocol.cdc#L319) with a `Session.id` inside that might be neccessary when processing the `callback`. The [Requester](./exampleApp/computation/contracts/Cocomputation.cdc#L47) example descripes an use case about how a `Session` can help connect context between `callOut` and `callback`(interface `ReceivedMessageInterface.Callee`).   

The two above methods in `SDKUtility` are responsible for sending invocations or messages out, and we still need methods to receive messages. In resource-oriented programming we need to bind receiving to every concrete resource, that is, every resource who wants to receive outside invocations or messages needs to implement the interface [ReceivedMessageInterface.Callee](https://github.com/dantenetwork/cadence-contracts/blob/b75d47440cf1a7e1246217c6a2fa0381a70d7bb5/contracts/ReceivedMessageContract.cdc#L20). Examples can be fount both at [Greetings](./exampleApp/greetings/contracts/Greetings.cdc) and [Cocomputation](./exampleApp/computation/contracts/Cocomputation.cdc).  

Generally, the example [Cocomputation](./exampleApp/computation/) is a typical use case of the high-level api.  

## Basic Tools
Note that remember to switch the import address when swiching between `emulator` and `testnet`.

To use the Omnichain functions of Dante protocol, there needs to be a `ReceivedMessageVault` resource and a `SentMessageVault` resource. We have deployed a **global** resource at `0x5f37faed5f558aca`, with public link `sentMessageVault` and `receivedMessageVault`.  

To use your own `ReceivedMessageVault` and `SentMessageVault` to be more secure, try the following tools. Example of the [Flow CLI](https://developers.flow.com/tools/flow-cli) can be found in [opsh](./opsh);

### Transactions
* [initSender](./transactions/initSender.cdc) creates account bound `SentMessageVault` and registered to `CrossChain`
* [initRecver](./transactions/initRecver.cdc) creates account bound `ReceivedMessageVault` and registered to `CrossChain`
* [destroySender](./transactions/destroySender.cdc) clear the related resource
* [destroyRecver](./transactions/destroyRecver.cdc) clear the related resource
* [transferFlow](./transactions/transferFlow.cdc) Flow token transferring tool

### Scripts
* [checkRegistered](./scripts/checkRegistered.cdc) check the registered `ReceivedMessageVault`s and `SentMessageVault`s.   

## Low-Level API
### Message Protocol
The public sections of Omnichain messages related to dApp development are defined in [MessageProtocol](https://github.com/dantenetwork/cadence-contracts/blob/main/contracts/MessageProtocol.cdc), including:
* [MessagePayload](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/MessageProtocol.cdc#L224) expresses user difined content used for interaction with other smart contracts deployed on other chains. `MessagePayload` is composed of [MessageItem](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/MessageProtocol.cdc#L99)s, which is compatible with all the different technology stack and supports all of the build-in types of different chains. The usage of how to construct a `MessagePayload` can be seen [here](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/omniverseNFT/contracts/StarLocker.cdc#L245).
* [SQoS](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/MessageProtocol.cdc#L295) is used for setting the demand of security quality of services for dApps to make a balance between security and scalability. If the user does not set SQoS explicitly, the underlying will work defaultly.
* [Seesion](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/MessageProtocol.cdc#L319) is maintained by the underlying and users only need to set callback and commitment/answer if neccessary.  

### Receive/Called From
#### ReceivedMessageVault
* Creation and Destroying
```sh
# create account bound `ReceivedMessageVault`
flow transactions send ./transactions/initRecver.cdc --signer <your account> -n testnet

# clear the `ReceivedMessageVault` resource
flow transactions send ./transactions/destroyRecver.cdc --signer <your account> -n testnet
```

* [Callee Interface](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L19) provides a public interface for user-defined resources to receive invocations outside, the usage of which can be seen in [examples](./exampleApp/greetings/contracts/Greetings.cdc#L17).

* (*Can be ignored by smart contract builders*)The [Public Interface](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L8) of `ReceivedMessageVault` mainly includes `getNextMessageID` and `submitRecvMessage`, both of which is for off-chain routers.

### Send/Call Out
#### SentMessageVault
* Creation and Destroying
```sh
# create account bound `SentMessageVault`
flow transactions send ./transactions/initSender.cdc --signer <your account> -n testnet

# clear the `SentMessageVault` resource
flow transactions send ./transactions/destroySender.cdc --signer <your account> -n testnet
```
* (*Can be ignored by smart contract builders*)The [Public Interface](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L146) of `SentMessageVault` mainly includes `getAllMessages()` and `getMessageById(messageId: UInt128)`, both of which is for off-chain routers.

#### Submitter
* Creation and Destroying
```sh
cd exampleApp/greetings

# create account bound `Submitter`
flow transactions send ./transactions/initSubmitter.cdc --signer <your account> -n testnet

# clear the `Submitter` resource
flow transactions send ./transactions/destroySubmitter.cdc --signer <your account> -n testnet

```

* The [Resource Interface](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L52) of `Submitter` is `submitWithAuth`, which is responsible for submit messages or invocations out. The usage of `submitWithAuth` can be seen in [example](./exampleApp/greetings/contracts/Greetings.cdc#L58):
    * @param `outContent`: Struct [msgToSubmit](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L7)
    * @param `acceptorAddr`: The owner address of the `SentMessageVault` resource, which can be the global one or created by yourself.
    * @param `alink`: the public link of the `SentMessageVault` resource, which is default to be *sentMessageVault*
    * @param `oSubmitterAddr`: The owner address of the `Submitter`
    * @param `slink`: the `Submitter`'s public link, which is default to be *msgSubmitter*

## Omniverse NFT
You can find detailed introduction of `Omniverse NFT` [here](https://github.com/dantenetwork/cadence-contracts/tree/main/omniverseNFT).  

The usage of the Omnichain NFT Infrastructure is quite convenient, and the details are as follows:  
### Send NFT Out
* [StarLocker.sendoutNFT(...)](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/omniverseNFT/contracts/StarLocker.cdc#L202): Send an NFT from Flow to outside chains:
    * @param `transferToken`: An NFT implements the interface `NonFungibleToken.INFT` on Flow
    * @param `toChain`: The [target chain name]()
    * @param `contractName`: The `StarLocker` contract address on the target chain. *This will be optimized in the future*
    * @param `actionName`: The `function selector` receiving the NFTs from outside of the `StarLocker` on the target chain. *This will be optimized in the future*
    * @param `receiver`: The reciever(owner of the NFT) address on the target chain.
    * @param `hashValue`: The hash question to claim the NFT on the target chain.   
The use case can be seen [here](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/omniverseNFT/scripts/SendNFToutTest.cdc#L153)

### Claim NFT Coming in
* [StarLocker.claimNFT(...)](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/omniverseNFT/contracts/StarLocker.cdc#L264): Claim an NFT back to Flow account when receiving an NFT outside.
   * @param: `domain: String`: the NFT name in the `DisplayView`
   * @param: `id: UInt64`: the NFT id
   * @param: `answer: String`, the hash answer to claim the NFT
The use case can be seen [here](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/omniverseNFT/scripts/SendNFToutTest.cdc#L223)

# Examples
Note that the following tutorial just details the steps on Flow, and you can find more details at the [demo](https://github.com/dantenetwork/cross-chain-demo/tree/flow-rinkeby#interoperation-between-flow-testnet-and-rinkeby)  
## Classic `Greetings` Case
[Greetings](./exampleApp/greetings/contracts/Greetings.cdc) is a calssic example of how to use Dante Protocol to build Omnichain dApps. It shows the simplest case of sending message out and receiving message from outside.  
In `Greetings`, we show how to use the [Low-Level API](#low-level-api) to manage omnichain `resources`. That is, we create manage all resources of Dante protocol stack outside of a contract, including `ReceivedMessageVault`, `SentMessageVault`, and `Submitter`. This brings in quite a lot of flexibility and safer access control but makes the creation steps dispersed and manual.  

You can try it as follows:
* Initiallize your own `ReceivedMessageVault` and `SentMessageVault` as mentioned above: [recver](#receivedmessagevault) and [sender](#sentmessagevault). Or use the global ones.
* Initiallize your own `Submitter` as [mentioned above](#submitter). 
* Deployed `Greetings`: 
    * Testnet: The address of `Greetings` contract deployed on Testnet is `0x86fc6f40cd9f9c66`. 

### Send message out
* Sending
```sh
cd exampleApp/greetings/

flow transactions send ./transactions/sendMessageOut.cdc <"toChain"> <"contract name on other chains"> <"action name"> <'SentMessageVault' address> --signer <your account> -n testnet
```
* Check the message received on the other chains.  

### Receive message from
* Wait message from other chains
* Check if received
```sh
flow scripts execute ./scripts/getRecvedGreetings.cdc
```  

## Classic `Cooperate Computation` Case
[Cocomputation](./exampleApp/computation/contracts/Cocomputation.cdc) is another classic example that descripes how a resource on Flow can cooperate with other smart contracts deployed on other chains. More that sigle-direction messages sending and receiving in `Greetings`, `Cocomputation` has implemented bi-direction invocations between resouces on Flow and smart contracts on other chains.  
In `Cooperate Computation`, we use [High-Level API](#high-level-api) to manage omnichain `resources`. That is, we create all underlying resources directly in contract, which is another way to create and manage resources. We use the [High-Level](#high-level-api) SDK [SDKUtility](./contracts/SDKUtility.cdc) make it more convenient.  

You can try it as follows:
* Deployed `Cocomputation`:
    * Testnet: The address of `Cocomputation` contract deployed on Testnet is `0xc133efc4b43676a0`. 

### [Requester](./exampleApp/computation/contracts/Cocomputation.cdc#L36)
A `Requester` call smart contracts deployed on other chains to make a simple computation and get the result through `callback`(The [callMe](./exampleApp/computation/contracts/Cocomputation.cdc#L47)).

* Call out
```sh
flow transactions send ./transactions/CallOut.cdc <"toChain"> <"contract name on other chains"> <"action name"> '[1, 2, 3, 4, 5]' --signer <your account> -n testnet
```
* Wait for result coming back
* Check the results
```sh
flow scripts execute ./scripts/getComputeResults.cdc <'Cocomputation' deployed account> -n testnet
```

### [ComputationServer](./exampleApp/computation/contracts/Cocomputation.cdc#L88)
A `ComputationServer` receive remote invocations from smart contracts deployed on other chains through [callMe](./exampleApp/computation/contracts/Cocomputation.cdc#L95), make a computation, and [response the result](./exampleApp/computation/contracts/Cocomputation.cdc#L110).  

* Wait for computation task coming
* Check received tasks
```sh
flow scripts execute ./scripts/getComputeTasks.cdc <'Cocomputation' deployed account>
```
* Check the computation results on calling chains

## [Omniverse NFT]()
Note that currently this NFT case is not a real Omniverse NFT, instead it works as a normal NFT bridge. That is, when an NFT transferred from Flow to Rinkeby, it is locked on Flow and minted on Rinkeby, and vice versa.  
In this case, any NFT following standard `NonfungibleToken.NFT` on Flow can travel out to other chains.  

We are preparing a real omniverse NFT nowadays, please look forward to.

### From Flow to Rinkeby
* Mint the NFT on Flow and send out to Rinkeby
```sh
cd exampleApp/omniNFT

# initiallize collection
flow transactions send ./transactions/initExampleCollection.cdc --signer <your account in flow.json> -n testnet

# free mint NFT
flow transactions send ./transactions/freeMintExample.cdc "<your description of the NFT>" --signer <your account in flow.json> -n testnet

# check NFT 
flow scripts execute ./scripts/checkNFT.cdc 0x86fc6f40cd9f9c66 -n testnet

# send nft out
flow transactions send ./transactions/sendNFT2Opensea.cdc "RINKEBY" "f0ED116DF876512F193195a7b3331F613030B852" '9bee6fc1' "<your hash question to claim NFT on rinkeby>" "04e5d0f5478849C94F02850bFF91113d8F02864D" 1 --signer <your account in flow.json> -n testnet

```

* Waiting for Rinkeby received and operate it on Rinkeby
(Operations on rinkeby)


* Claim NFT on Flow
```sh
# operate in './exampleApp/omniNFT'
# cd exampleApp/omniNFT

# Claim nft coming back from rinkeby
flow transactions send ./transactions/claimNFT.cdc 8 '<your hash answer to claim NFT on Flow>' --signer <your account in flow.json> -n testnet

# check NFT 
flow scripts execute ./scripts/checkNFT.cdc 0x86fc6f40cd9f9c66 -n testnet

```

