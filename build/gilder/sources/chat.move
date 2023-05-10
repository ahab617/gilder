module gilder::chat{
    friend gilder::gilder;


    const URL_CHAT_SERVER: vector<u8> =b"ipfs://";
    const URL_REPLY: vector<u8> = b"ipfs://";
    const URL_LIKE: vector<u8> = b"ipfs://";
    const URL_META: vector<u8> = b"ipfs://";
    const URL_POST: vector<u8> = b"ipfs://";
    const URL_REPOST: vector<u8> = b"ipfs://";
    const URL_QUOTE_POST: vector<u8> = b"ipfs://";


    fun GET_URL_CHAT_SERVER(): vector<u8> {
        return URL_CHAT_SERVER
    }

    fun GET_URL_POST(): vector<u8> {
        return URL_POST
    }

     fun GET_URL_REPOST(): vector<u8> {
        return URL_REPOST
    }

     fun GET_URL_QUOTE_POST(): vector<u8> {
        return URL_QUOTE_POST
    }

     fun GET_URL_REPLY(): vector<u8> {
        return URL_REPLY
    }

     fun GET_URL_LIKE(): vector<u8> {
        return URL_LIKE
    }

     fun GET_URL_META(): vector<u8> {
        return URL_META
    }
}