import SentMessageContract from 0xf8d6e0586b0a20c7;
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
import ContextKeeper from 0xf8d6e0586b0a20c7;
import CrossChain from 0xf8d6e0586b0a20c7;

//import SentMessageContract from 0x5f37faed5f558aca;
//import ReceivedMessageContract from 0x5f37faed5f558aca;
//import MessageProtocol from 0x5f37faed5f558aca;
//import ContextKeeper from 0x5f37faed5f558aca;
//import CrossChain from 0x5f37faed5f558aca;

pub contract SDKUtility {
    init() {
        let recver <- ReceivedMessageContract.createReceivedMessageVault();
        self.account.save(<- recver, to: /storage/receivedMessageVault);
        self.account.link<&{ReceivedMessageContract.ReceivedMessageInterface}>(/public/receivedMessageVault, target: /storage/receivedMessageVault);
        CrossChain.registerRecvAccount(address: self.account.address, link: "receivedMessageVault");

        let sendVault <- SentMessageContract.createSentMessageVault();
        self.account.save(<- sendVault, to: /storage/sentMessageVault);
        self.account.link<&{SentMessageContract.SentMessageInterface, SentMessageContract.AcceptorFace}>(/public/sentMessageVault, target: /storage/sentMessageVault);
        CrossChain.registerSendAccount(address: self.account.address, link: "sentMessageVault");

        let submitter <- SentMessageContract.createMessageSubmitter();
        self.account.save(<- submitter, to: /storage/msgSubmitter);
        self.account.link<&{SentMessageContract.SubmitterFace}>(/public/msgSubmitter, target: /storage/msgSubmitter);
    }

    access(account) fun callOut(toChain: String, 
                                sqos: MessageProtocol.SQoS, 
                                contractName: [UInt8], 
                                actionName: [UInt8], 
                                data: MessageProtocol.MessagePayload,
                                callback: [UInt8]?, 
                                commitment: [UInt8]?) {
        let msg = SentMessageContract.msgToSubmit(toChain: toChain, 
                                                    sqos: sqos, 
                                                    contractName: contractName, 
                                                    actionName: actionName, 
                                                    data: data, 
                                                    callType: 2, 
                                                    callback: callback, 
                                                    commitment: commitment, 
                                                    answer: nil);
        self.self_message_send_out(msg: msg);
    }

    access(account) fun sendOut(toChain: String, 
                                sqos: MessageProtocol.SQoS, 
                                contractName: [UInt8], 
                                actionName: [UInt8], 
                                data: MessageProtocol.MessagePayload) {
        let msg = SentMessageContract.msgToSubmit(toChain: toChain, 
                                                    sqos: sqos, 
                                                    contractName: contractName, 
                                                    actionName: actionName, 
                                                    data: data, 
                                                    callType: 1, 
                                                    callback: nil, 
                                                    commitment: nil, 
                                                    answer: nil);
        self.self_message_send_out(msg: msg);
    }

    priv fun self_message_send_out(msg: SentMessageContract.msgToSubmit) {
        let submitterRef = self.account.borrow<&SentMessageContract.Submitter>(from: /storage/msgSubmitter)!;
        submitterRef.submitWithAuth(msg, 
                                    acceptorAddr: self.account.address, 
                                    alink: "sentMessageVault", 
                                    oSubmitterAddr: self.account.address, 
                                    slink: "msgSubmitter");
    }
}