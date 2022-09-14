import Greetings from "../contracts/Greetings.cdc"

transaction (toChain: String, 
            contractName: String, 
            actionName: String,
            senderAddr: Address) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Greetings.sendGreeting(toChain: toChain, 
                                contractName: contractName.utf8, 
                                actionName: actionName.utf8,
                                greetingMessage: "Hello nika", 
                                senderAddr: senderAddr, 
                                link: "msgSubmitter");
    }
}
