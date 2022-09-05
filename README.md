# Introduction
This is the SDK with which developers can easily build their Omnichain dApps based on Dante Protocol Stack on Flow. It's a little bit different from SDKs in other technology stack, the `flow-sdk` are quite convenient and developers only need to create their own [Submitter](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L39) and [SentMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L163) resources to make smart contracts invocation and send messages out to other chains. Similarly, they only need to create their own [ReceivedMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L194) to receive resouce calls and messages from other chains.  
More details can be seen at [API](#api), and we provide two typical examples at [examples](#examples);

## Environment
### Deployment
#### Testnet
Officially, we have deployed the smart contract at `0x0xa8913f4f31ead2ee` including the [Dante Protocol Stack](https://github.com/dantenetwork/cadence-contracts) and [Omnichain NFT Infrastructure](https://github.com/dantenetwork/cadence-contracts/tree/main/omniverseNFT).  

Note that the `testnet-account` in [flow.json](./flow.json) has already been used, which is just for dev-testing. So remember to create your own account to make operation on Testnet. You can follow this [tutorial](https://developers.flow.com/tools/flow-cli/create-accounts) to create a new account on Testnet and fund faucet [here](https://testnet-faucet.onflow.org/fund-account). 

#### Emulator
To use emulator for testing, we need to clone the [Dante Protocol Stack](https://github.com/dantenetwork/cadence-contracts/tree/main), start emulator, and deploy first:
* Deploy on emulator
```sh
git clone https://github.com/dantenetwork/cadence-contracts

cd cadence-contracts

flow emulator --verbose

flow project deploy --update

```
* Prapare an account to operate
After started the emulator, create an account and transfer some simu-Flow to it for gas as follows:
```sh
flow accounts create --key 81262aa27f1630ccf1293300e8e1d9a6ba542dffa796b860d53873867175e9d31bd7b7581d2f200f9c3dfdbc10ae912ff036946981e3d8996a14f186d20e3e2f

# transfer Flow Token
flow transactions send ./transactions/test/transferFlow.cdc 100.0 0x01cf0e2f2f715450
```
As we have set the address `0x01cf0e2f2f715450` as `emulator-Alice` in `flow.json`, directly execute the scripts above works well and we can use account `emulator-Alice` in emulator to make operation now.

## Basic Tools
Note that remember to switch the import address when swiching between `emulator` and `testnet`.

To use the Omnichain functions of Dante protocol, there needs to be a `ReceivedMessageVault` resource and a `SentMessageVault` resource. We have deployed a globle resource at `0x0xa8913f4f31ead2ee`, with public link `sentMessageVault` and `receivedMessageVault`.  

To use your own `ReceivedMessageVault` and `SentMessageVault` to be more secure, try the following tools. Example of usage can be found in [opsh](./opsh);

### Transactions
* [initSender](./transactions/initSender.cdc) creates account bound `SentMessageVault` and registered to `CrossChain`
* [initRecver](./transactions/initRecver.cdc) creates account bound `ReceivedMessageVault` and registered to `CrossChain`
* [destroySender](./transactions/destroySender.cdc) clear the related resource
* [destroyRecver](./transactions/destroyRecver.cdc) clear the related resource
* [transferFlow](./transactions/transferFlow.cdc) Flow token transferring tool

### Scripts
* [checkRegistered](./scripts/checkRegistered.cdc) check the registered `ReceivedMessageVault`s and `SentMessageVault`s.   

## API
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
flow transactions send ./transactions/initRecver.cdc -n testnet --signer <your account>

# clear the `ReceivedMessageVault` resource
flow transactions send ./transactions/destroyRecver.cdc -n testnet --signer <your account>
```
* Resource Interface

* [Callee Interface](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L19) provides a public interface for user-defined resources to receive invocations outside, the usage of which can be seen in [examples]().

* (*Can be ignored by smart contract builders*)The [Public Interface](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L8) of `ReceivedMessageVault` mainly includes `getNextMessageID` and `submitRecvMessage`, both of which is for off-chain routers.

### Send/Call Out
#### SentMessageVault
* Creation and Destroying
```sh
# create account bound `SentMessageVault`
flow transactions send ./transactions/initSender.cdc -n testnet --signer <your account>

# clear the `SentMessageVault` resource
flow transactions send ./transactions/destroySender.cdc -n testnet --signer <your account>
```
* (*Can be ignored by smart contract builders*)The [Public Interface](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L146) of `SentMessageVault` mainly includes `getAllMessages()` and `getMessageById(messageId: UInt128)`, both of which is for off-chain routers.

#### Submitter
* Creation and Destroying
* Resource Interface
* Public Interface

### Omnichain NFT
The usage of the Omnichain NFT Infrastructure is quite convenient, and you can see more details [here](https://github.com/dantenetwork/cadence-contracts/tree/crypto-dev/omniverseNFT).

#### Send NFT Out
* [StarLocker.sendoutNFT(...)](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/omniverseNFT/contracts/StarLocker.cdc#L202): Send an NFT from Flow to outside chains:
    * @param `transferToken`: An NFT implements the interface `NonFungibleToken.INFT` on Flow
    * @param `toChain`: The [target chain name]()
    * @param `contractName`: The `StarLocker` contract address on the target chain. *This will be optimized in the future*
    * @param `actionName`: The `function selector` receiving the NFTs from outside of the `StarLocker` on the target chain. *This will be optimized in the future*
    * @param `receiver`: The reciever(owner of the NFT) address on the target chain.
    * @param `hashValue`: The answer of the hash-locker on the target chain. 

#### Claim NFT Coming in
* [StarLocker.claimNFT(...)](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/omniverseNFT/contracts/StarLocker.cdc#L264): Claim an NFT back to Flow account when receiving an NFT outside.

# Examples
## Classic `Greetings` Case

## Classic `Cooperate Computation` Case

# Test

