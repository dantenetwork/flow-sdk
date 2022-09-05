import Greetings from "../contracts/Greetings.cdc"

transaction (senderAddr: Address) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Greetings.sendGreeting(greetingMessage: "Hello nika", senderAddr: senderAddr, link: "msgSubmitter");
    }
}
