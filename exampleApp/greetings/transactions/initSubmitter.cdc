import SentMessageContract from 0xf8d6e0586b0a20c7;

//import SentMessageContract from 0xa8913f4f31ead2ee;

transaction () {

    prepare(acct: AuthAccount) {
        let submitter <- SentMessageContract.createMessageSubmitter();
        acct.save(<- submitter, to: /storage/msgSubmitter);
        acct.link<&{SentMessageContract.SubmitterFace}>(/public/msgSubmitter, target: /storage/msgSubmitter);
    }

    execute {
        
    }
}
