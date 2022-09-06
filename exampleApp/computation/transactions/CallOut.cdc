import Cocomputation from "../contracts/Cocomputation.cdc"

transaction (inputs: [UInt32]) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Cocomputation.testCallOut(toChain: "POLKADOT", 
                                    contractName: "Nika computor".utf8, 
                                    actionName: "compute".utf8, 
                                    numbers: inputs);
    }
}
