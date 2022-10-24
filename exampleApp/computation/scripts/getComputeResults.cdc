import Cocomputation from "../contracts/Cocomputation.cdc"

pub fun main(addr: Address): {String: [Cocomputation.RequestRecord]} {
    let acct = getAuthAccount(addr);
    let requesterRef = acct.borrow<&Cocomputation.Requester>(from: /storage/requester)!;
    return requesterRef.recorder;
}
