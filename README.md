# Introduction
This is the SDK with which developers can easily build their Omnichain dApps based on Dante Protocol Stack on Flow. It's a little bit different from SDKs in other technology stack, the `flow-sdk` are quite convenient and developers only need to create their own [Submitter](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L39) and [SentMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L163) resources to make smart contracts invocation and send messages out to other chains. Similarly, they only need to create their own [ReceivedMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L194) to receive resouce calls and messages from other chains.  
More details can be seen at [API](#api), and we provide two typical examples at [examples](#examples);

## Environment
### Deployment
#### Testnet
Officially, we have deployed the smart contract at `0x0xa8913f4f31ead2ee` including the [Dante Protocol Stack](https://github.com/dantenetwork/cadence-contracts/tree/crypto-dev) and [Omnichain NFT Infrastructure](https://github.com/dantenetwork/cadence-contracts/tree/crypto-dev/omniverseNFT).  

Note that the `testnet-account` in [flow.json](./flow.json) has already been used, which is just for dev-testing. So remember to create your own account to make operation on Testnet. You can follow this [tutorial](https://developers.flow.com/tools/flow-cli/create-accounts) to create a new account on Testnet and fund faucet [here](https://testnet-faucet.onflow.org/fund-account). 

#### Emulator
To use emulator for testing, we need to clone the [Dante Protocol Stack](https://github.com/dantenetwork/cadence-contracts/tree/crypto-dev), start emulator, and deploy first:
* Deploy on emulator
```sh
git clone https://github.com/dantenetwork/cadence-contracts/tree/crypto-dev

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
Note that remember to switch the import address 

### Transactions


### Scripts


## API
### Message Protocol

### Receive/Called From
#### ReceivedMessageVault
* Creation and Destroying
* Resource Interface
* Public Interface

### Send/Call Out
#### SentMessageVault
* Creation and Destroying
* Resource Interface
* Public Interface

#### Submitter
* Creation and Destroying
* Resource Interface
* Public Interface

### Omnichain NFT
The usage of the Omnichain NFT Infrastructure is quite convenient, and you can see more details [here](https://github.com/dantenetwork/cadence-contracts/tree/crypto-dev/omniverseNFT).

#### Send NFT Out

#### Claim NFT Coming in

# Examples
## Classic `Greetings` Case

## Classic `Cooperate Computation` Case

# Test

