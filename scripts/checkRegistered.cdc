import CrossChain from 0xf8d6e0586b0a20c7;

pub fun main() {
    log(CrossChain.queryRegisteredRecvAccount());
    log(CrossChain.queryRegisteredSendAccount());
}