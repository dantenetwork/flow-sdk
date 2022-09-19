import Cocomputation from "../contracts/Cocomputation.cdc"

transaction (toChain: String, 
            contractName: [UInt8], 
            actionName: [UInt8], 
            inputs: [UInt32]) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Cocomputation.testCallOut(toChain: toChain, 
                                    contractName: contractName, 
                                    actionName: actionName, 
                                    numbers: inputs);
    }
}
