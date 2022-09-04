# Introduction
This is the SDK with which developers can easily build their Omnichain dApps based on Dante Protocol Stack on Flow. It's a little bit different from SDKs in other technology stack, the `flow-sdk` are quite convenient and developers only need to create their own [Submitter](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L39) and [SentMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/SentMessageContract.cdc#L163) resources to make smart contracts invocation and send messages out to other chains. Similarly, they only need to create their own [ReceivedMessageVault](https://github.com/dantenetwork/cadence-contracts/blob/45ced3d891c7a680e6750870e46b33c2dc609a64/contracts/ReceivedMessageContract.cdc#L194) to receive resouce calls and messages from other chains.  
More details can be seen at [API](#api), and we provide two typical examples at [examples](#examples);

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

# Examples
## Classic `Greetings` Case

## Classic `Cooperate Computation` Case

# Test

