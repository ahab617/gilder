module gilder::URL{
    friend gilder::gilder;


    const URL_CHAT_SERVER: vector<u8> =b"ipfs://";
    const URL_REPLY: vector<u8> = b"ipfs://";
    const URL_LIKE: vector<u8> = b"ipfs://";
    const URL_META: vector<u8> = b"ipfs://";
    const URL_POST: vector<u8> = b"ipfs://";
    const URL_REPOST: vector<u8> = b"ipfs://";
    const URL_QUOTE_POST: vector<u8> = b"ipfs://";


    public fun GET_URL_CHAT_SERVER(): vector<u8> {
        return URL_CHAT_SERVER
    }

    public fun GET_URL_POST(): vector<u8> {
        return URL_POST
    }

    public fun GET_URL_REPOST(): vector<u8> {
        return URL_REPOST
    }

    public fun GET_URL_QUOTE_POST(): vector<u8> {
        return URL_QUOTE_POST
    }

    public fun GET_URL_REPLY(): vector<u8> {
        return URL_REPLY
    }

    public fun GET_URL_LIKE(): vector<u8> {
        return URL_LIKE
    }

    public fun GET_URL_META(): vector<u8> {
        return URL_META
    }
}