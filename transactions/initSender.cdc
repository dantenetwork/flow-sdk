import SentMessageContract from 0xf8d6e0586b0a20c7;
import CrossChain from 0xf8d6e0586b0a20c7;

transaction () {

    prepare(acct: AuthAccount) {
        let sendVault <- SentMessageContract.createSentMessageVault();
        acct.save(<- sendVault, to: /storage/sentMessageVault);
        acct.link<&{SentMessageContract.SentMessageInterface}>(/public/sentMessageVault, target: /storage/sentMessageVault);
        acct.link<&{SentMessageContract.AcceptorFace}>(/public/acceptorFace, target: /storage/sentMessageVault);

        CrossChain.registerSendAccount(address: acct.address, link: "sentMessageVault");
    }

    execute {
        
    }
}