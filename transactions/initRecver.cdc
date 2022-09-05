import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import CrossChain from 0xf8d6e0586b0a20c7;

//import ReceivedMessageContract from 0xa8913f4f31ead2ee;
//import CrossChain from 0xa8913f4f31ead2ee;

transaction () {

    prepare(acct: AuthAccount) {
        let recvVault <- ReceivedMessageContract.createReceivedMessageVault();

        acct.save(<- recvVault, to: /storage/receivedMessageVault);
        acct.link<&{ReceivedMessageContract.ReceivedMessageInterface}>(/public/receivedMessageVault, target: /storage/receivedMessageVault);

        CrossChain.registerRecvAccount(address: acct.address, link: "receivedMessageVault");
    }

    execute {
        
    }
}