///*
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
import ContextKeeper from 0xf8d6e0586b0a20c7;
import OmniverseInformation from 0xf8d6e0586b0a20c7;
//*/

/*
import ReceivedMessageContract from 0x5f37faed5f558aca;
import MessageProtocol from 0x5f37faed5f558aca;
import ContextKeeper from 0x5f37faed5f558aca;
*/

import SDKUtility from "./SDKUtility.cdc";

pub contract Cocomputation {
    pub struct RequestRecord {
        pub let sessionID: UInt128;
        pub var input: [UInt32]?;
        pub var results: UInt32?;
        pub var err: UInt8?;

        init(sessionID: UInt128) {
            self.sessionID = sessionID;
            self.input = nil;
            self.results = nil;
            self.err = nil;
        }

        pub fun setInput(input: [UInt32]) {
            self.input = input;
        }

        pub fun setResults(results: UInt32) {
            self.results = results;
        }

        pub fun setErr(err: UInt8) {
            self.err = err;
        }
    }

    pub resource Requester: ReceivedMessageContract.Callee {
        pub let recorder: {String: [RequestRecord]};
        pub let link: String;

        init(link: String) {
            self.recorder = {};
            self.link = link;
        }

        pub fun callMe(data: MessageProtocol.MessagePayload) {
            if let context = ContextKeeper.getContext() {
                log("Receiving from chain: ".concat(context.fromChain));
                log("Receiving session id is: ".concat(context.session.id.toString()));
                log("Receiving session type is: ".concat(context.session.type.toString()));

                if UInt8(3) == context.session.type {
                    // seccessful callback results
                    if let rst = data.getItem(name: "result") {
                        if let val = rst.value as? UInt32 {
                            if let requestRecRef: &[RequestRecord] = (&self.recorder[context.fromChain] as &[RequestRecord]?) {
                                var idx = 0;
                                while idx < requestRecRef.length {
                                    if requestRecRef[idx].sessionID == context.session.id {
                                        requestRecRef[idx].setResults(results: val);
                                        break;
                                    }
                                    
                                    idx = idx + 1;
                                }
                            }
                        }
                    }
                } else if OmniverseInformation.remoteError == context.session.type {
                    // remote invocation failed
                    if let rst = data.getItem(name: OmniverseInformation.item_err) {
                        if let err = rst.value as? UInt8 {
                            if let requestRecRef: &[RequestRecord] = (&self.recorder[context.fromChain] as &[RequestRecord]?) {
                                var idx = 0;
                                while idx < requestRecRef.length {
                                    if requestRecRef[idx].sessionID == context.session.id {
                                        requestRecRef[idx].setErr(err: err);
                                        log("The error is: ".concat(err.toString()));
                                        break;
                                    }
                                    
                                    idx = idx + 1;
                                }
                            }
                        }
                    }
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
            
            if let context = SDKUtility.callOut(toChain: toChain, 
                                sqos: MessageProtocol.SQoS(), 
                                contractName: contractName, 
                                actionName: actionName, 
                                data: msgPL,
                                callback: self.link, 
                                commitment: nil) {
                log("Calling out session id is: ".concat(context.session.id.toString()));
                let record = RequestRecord(sessionID: context.session.id);
                record.setInput(input: numbers); 
                if self.recorder.containsKey(toChain) {
                    self.recorder[toChain]!.append(record);
                } else {
                    self.recorder[toChain] = [record];
                }       
            }
        }
    }

    pub resource ComputationServer: ReceivedMessageContract.Callee {
        pub let tasks: [[UInt32]];

        init() {
            self.tasks = [];
        }

        pub fun callMe(data: MessageProtocol.MessagePayload) {
            // panic("Just test error remote call");
            ///*
            if let context = ContextKeeper.getContext() {
                if let item = data.getItem(name: "nums") {
                    var sum: UInt32 = 0;
                    self.tasks.append(item.value as! [UInt32]);
                    for ele in item.value as! [UInt32] {
                        sum = sum + ele;
                    }

                    let msgPL = MessageProtocol.MessagePayload();
                    let msgItem = MessageProtocol.createMessageItem(name: "result", 
                                                                    type: MessageProtocol.MsgType.cdcU32,
                                                                    value: sum);
                    msgPL.addItem(item: msgItem!);

                    SDKUtility.respondOut(data: msgPL);
                }
            }
            //*/
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
 