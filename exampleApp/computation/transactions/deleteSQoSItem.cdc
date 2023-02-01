///*
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
//*/

/*
import ReceivedMessageContract from 0x5f37faed5f558aca;
import MessageProtocol from 0x5f37faed5f558aca;
*/

transaction(type: UInt8){
    let signer: AuthAccount;

    prepare(signer: AuthAccount){
        self.signer = signer
    }

    execute {
        if let recvRef = self.signer.borrow<&ReceivedMessageContract.ReceivedMessageVault>(from: /storage/receivedMessageVault) {
            if type == MessageProtocol.SQoSType.Reveal.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.Reveal);

            } else if type == MessageProtocol.SQoSType.Challenge.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.Challenge);

            } else if type == MessageProtocol.SQoSType.Threshold.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.Threshold);

            } else if type == MessageProtocol.SQoSType.Priority.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.Priority);

            } else if type == MessageProtocol.SQoSType.ExceptionRollback.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.ExceptionRollback);

            } else if type == MessageProtocol.SQoSType.SelectionDelay.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.SelectionDelay);
                
            } else if type == MessageProtocol.SQoSType.Anonymous.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.Anonymous);
                
            } else if type == MessageProtocol.SQoSType.Identity.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.Identity);
                
            } else if type == MessageProtocol.SQoSType.Isolation.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.Isolation);
                
            } else if type == MessageProtocol.SQoSType.CrossVerify.rawValue {
                recvRef.deleteSQoSItem(type: MessageProtocol.SQoSType.CrossVerify);
                
            } else {
                panic("Invalid SQoSType value!");
            }
        }
    }
}
