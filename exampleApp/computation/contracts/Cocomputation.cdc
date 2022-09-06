import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
import ContextKeeper from 0xf8d6e0586b0a20c7;

//import ReceivedMessageContract from 0x5f37faed5f558aca;
//import MessageProtocol from 0x5f37faed5f558aca;
//import ContextKeeper from 0x5f37faed5f558aca;

import SDKUtility from "./SDKUtility.cdc";

pub contract Cocomputation {
    pub resource Requester: ReceivedMessageContract.Callee {
        pub let results: [UInt32];
        pub let link: String;

        init(link: String) {
            self.results = [];
            self.link = link;
        }

        pub fun callMe(data: MessageProtocol.MessagePayload, contextID: String) {
            if let rst = data.getItem(name: "result") {
                if let val = rst.value as? UInt32 {
                    self.results.append(val);
                }
            }
        }

        pub fun RemoteInvocate(toChain: String, 
                                contractName: [UInt8], 
                                actionName: [UInt8], 
                                numbers: [UInt32]) {
            let msgPL = MessageProtocol.MessagePayload();

            let msgItem = MessageProtocol.createMessageItem(name: "nums", type: MessageProtocol.MsgType.cdcVecU32, value: numbers);
            msgPL.addItem(item: msgItem!);
            
            SDKUtility.callOut(toChain: toChain, 
                                sqos: MessageProtocol.SQoS(), 
                                contractName: contractName, 
                                actionName: actionName, 
                                data: msgPL,
                                callback: self.link.utf8, 
                                commitment: nil)
        }
    }

    pub resource ComputationServer: ReceivedMessageContract.Callee {
        pub let tasks: [[UInt32]];

        init() {
            self.tasks = [];
        }

        pub fun callMe(data: MessageProtocol.MessagePayload, contextID: String) {

        }
    }

    init() {
        self.account.save(<- create Requester(link: "requester"), to: /storage/requester);
        self.account.link<&{ReceivedMessageContract.Callee}>(/public/requester, target: /storage/requester);

        self.account.save(<- create ComputationServer(), to: /storage/computationServer);
        self.account.link<&{ReceivedMessageContract.Callee}>(/public/computationServer, target: /storage/computationServer);
    }

    pub fun testCallOut(toChain: String, 
                        contractName: [UInt8], 
                        actionName: [UInt8], 
                        numbers: [UInt32]) {

        let requesterRef = self.account.borrow<&Requester>(from: /storage/requester)!;

        requesterRef.RemoteInvocate(toChain: toChain, 
                        contractName: contractName, 
                        actionName: actionName, 
                        numbers: numbers);
    }
}
