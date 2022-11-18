///*
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
//*/

/*
import ReceivedMessageContract from 0x5f37faed5f558aca;
import MessageProtocol from 0x5f37faed5f558aca;
*/

pub fun main(recver: Address): MessageProtocol.SQoS? {
    if let recvRef = ReceivedMessageContract.getRecverRef(recverAddress: recver, link: "receivedMessageVault") {
        return recvRef.getSQoS();
    }

    return nil;
}