///*
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
//*/

/*
import ReceivedMessageContract from 0x5f37faed5f558aca;
import MessageProtocol from 0x5f37faed5f558aca;
*/

transaction(){
    let signer: AuthAccount;

    prepare(signer: AuthAccount){
        self.signer = signer
    }

    execute {
        if let recvRef = self.signer.borrow<&ReceivedMessageContract.ReceivedMessageVault>(from: /storage/receivedMessageVault) {
            let item = MessageProtocol.SQoSItem(type: MessageProtocol.SQoSType.Reveal, value: []);
            recvRef.addSQoSItem(item: item);
        }
    }
}
