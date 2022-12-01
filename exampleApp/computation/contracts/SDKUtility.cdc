///*
import SentMessageContract from 0xf8d6e0586b0a20c7;
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
import ContextKeeper from 0xf8d6e0586b0a20c7;
import Regestery from 0xf8d6e0586b0a20c7;
//*/

/*
import SentMessageContract from 0x5f37faed5f558aca;
import ReceivedMessageContract from 0x5f37faed5f558aca;
import MessageProtocol from 0x5f37faed5f558aca;
import ContextKeeper from 0x5f37faed5f558aca;
import Regestery from 0x5f37faed5f558aca;
*/

pub contract SDKUtility {
    init() {
        let recver <- ReceivedMessageContract.createReceivedMessageVault();
        self.account.save(<- recver, to: /storage/receivedMessageVault);
        self.account.link<&{ReceivedMessageContract.ReceivedMessageInterface}>(/public/receivedMessageVault, target: /storage/receivedMessageVault);
        Regestery.registerRecvAccount(address: self.account.address, link: "receivedMessageVault");

        let sendVault <- SentMessageContract.createSentMessageVault();
        self.account.save(<- sendVault, to: /storage/sentMessageVault);
        self.account.link<&{SentMessageContract.SentMessageInterface, SentMessageContract.AcceptorFace}>(/public/sentMessageVault, target: /storage/sentMessageVault);
        Regestery.registerSendAccount(address: self.account.address, link: "sentMessageVault");

        let submitter <- SentMessageContract.createMessageSubmitter();
        self.account.save(<- submitter, to: /storage/msgSubmitter);
        self.account.link<&{SentMessageContract.SubmitterFace}>(/public/msgSubmitter, target: /storage/msgSubmitter);
    }

    access(account) fun callOut(toChain: String, 
                                sqos: MessageProtocol.SQoS, 
                                contractName: [UInt8], 
                                actionName: [UInt8], 
                                data: MessageProtocol.MessagePayload,
                                callback: String?, 
                                commitment: [UInt8]?): ContextKeeper.Context? {
        let msg = SentMessageContract.msgToSubmit(toChain: toChain, 
                                                    sqos: sqos, 
                                                    contractName: contractName, 
                                                    actionName: actionName, 
                                                    data: data, 
                                                    callType: 2, 
                                                    callback: callback, 
                                                    commitment: commitment, 
                                                    answer: nil);
        return self.self_message_send_out(msg: msg);
    }

    access(account) fun sendOut(toChain: String, 
                                sqos: MessageProtocol.SQoS, 
                                contractName: [UInt8], 
                                actionName: [UInt8], 
                                data: MessageProtocol.MessagePayload): ContextKeeper.Context? {
        let msg = SentMessageContract.msgToSubmit(toChain: toChain, 
                                                    sqos: sqos, 
                                                    contractName: contractName, 
                                                    actionName: actionName, 
                                                    data: data, 
                                                    callType: 1, 
                                                    callback: nil, 
                                                    commitment: nil, 
                                                    answer: nil);
        return self.self_message_send_out(msg: msg);
    }

    access(account) fun respondOut(data: MessageProtocol.MessagePayload) {
        if let context = ContextKeeper.getContext() {
            let msg = SentMessageContract.msgToSubmit(toChain: context.fromChain, 
                                                    sqos: context.sqos, 
                                                    contractName: context.sender, 
                                                    actionName: context.session.callback!, 
                                                    data: data, 
                                                    callType: 3, 
                                                    callback: nil, 
                                                    commitment: nil, 
                                                    answer: nil);
            self.self_message_send_out(msg: msg);
        } else {
            panic("`context` not found. This may not be an atomic response.")
        }
    }

    access(account) fun self_message_send_out(msg: SentMessageContract.msgToSubmit): ContextKeeper.Context? {
        let submitterRef = self.account.borrow<&SentMessageContract.Submitter>(from: /storage/msgSubmitter)!;
        return submitterRef.submitWithAuth(msg, 
                                    acceptorAddr: self.account.address, 
                                    alink: "sentMessageVault", 
                                    oSubmitterAddr: self.account.address, 
                                    slink: "msgSubmitter");
    }

    /////////////////////////////////////////////////////////////////////
    /// SQoS
    access(account) fun set_sqos(sqos: MessageProtocol.SQoS) {
        let recverRef = self.account.borrow<&ReceivedMessageContract.ReceivedMessageVault>(from: /storage/receivedMessageVault)!;
        recverRef.setSQoS(sqos: sqos);
    }
}
