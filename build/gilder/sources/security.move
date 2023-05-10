module gilder::security{
    friend gilder::gilder;


    const ANTI_SPAM_SERVICE: vector<u8> =b"";
    const ANTI_BOT_SERVICE: vector<u8> = b"";
    const POST_ANALYZER: vector<u8> = b"HTTPS://";



    fun GET_ANTI_SPAM_SERVICE(): vector<u8> {
        return ANTI_SPAM_SERVICE
    }

    fun GET_ANTI_BOT_SERVICE(): vector<u8> {
        return ANTI_BOT_SERVICE
    }

     fun GET_POST_ANALYZER(): vector<u8> {
        return POST_ANALYZER
    }

    
}