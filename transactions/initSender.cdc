//import SentMessageContract from 0xf8d6e0586b0a20c7;
//import CrossChain from 0xf8d6e0586b0a20c7;

import SentMessageContract from 0xa8913f4f31ead2ee;
import CrossChain from 0xa8913f4f31ead2ee;

transaction () {

    prepare(acct: AuthAccount) {
        let sendVault <- SentMessageContract.createSentMessageVault();
        acct.save(<- sendVault, to: /storage/sentMessageVault);
        acct.link<&{SentMessageContract.SentMessageInterface, SentMessageContract.AcceptorFace}>(/public/sentMessageVault, target: /storage/sentMessageVault);

        CrossChain.registerSendAccount(address: acct.address, link: "sentMessageVault");
    }

    execute {
        
    }
}