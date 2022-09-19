import Greetings from "../contracts/Greetings.cdc"

transaction (toChain: String, 
            contractName: [UInt8], 
            actionName: [UInt8],
            senderAddr: Address) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Greetings.sendGreeting(toChain: toChain, 
                                contractName: contractName, 
                                actionName: actionName,
                                greetingMessage: "Hello nika", 
                                senderAddr: senderAddr, 
                                link: "msgSubmitter");
    }
}
