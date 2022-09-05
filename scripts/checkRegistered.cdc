// import CrossChain from 0xf8d6e0586b0a20c7;
import CrossChain from 0xa8913f4f31ead2ee;

pub fun main(): [[Address]]{
    log(CrossChain.queryRegisteredRecvAccount());
    log(CrossChain.queryRegisteredSendAccount());

    return [CrossChain.queryRegisteredRecvAccount(), CrossChain.queryRegisteredSendAccount()];
}
