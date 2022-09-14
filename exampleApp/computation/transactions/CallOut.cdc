import Cocomputation from "../contracts/Cocomputation.cdc"

transaction (toChain: String, 
            contractName: String, 
            actionName: String, 
            inputs: [UInt32]) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Cocomputation.testCallOut(toChain: toChain, 
                                    contractName: contractName.utf8, 
                                    actionName: actionName.utf8, 
                                    numbers: inputs);
    }
}
