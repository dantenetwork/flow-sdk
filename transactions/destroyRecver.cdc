//import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
//import CrossChain from 0xf8d6e0586b0a20c7;

import ReceivedMessageContract from 0xa8913f4f31ead2ee;
import CrossChain from 0xa8913f4f31ead2ee;

transaction () {

    prepare(acct: AuthAccount) {

        if let recverRef = acct.borrow<&ReceivedMessageContract.ReceivedMessageVault>(from: /storage/receivedMessageVault) {
            recverRef.setOffline();
            CrossChain.removeRecvAccount(address: acct.address, link: "receivedMessageVault");
        }

        if let recverValt <- acct.load<@ReceivedMessageContract.ReceivedMessageVault>(from: /storage/receivedMessageVault) {
            destroy recverValt;
        }
    }

    execute {
        
    }
}