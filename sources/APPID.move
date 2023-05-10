module gilder::APPID{

    friend gilder::gilder;

       // app ids for filterations
    
    const APP_ID_XMPP_SERVER: u8=2;
    const APP_ID_FOR_CHAT_APP: u8 = 0;
    const APP_ID_FOR_CHAT_WEB: u8 = 1;
    const APP_META_DATA: vector<u8> = b"50 72 6F 67 72 61 6D 6D 65 72 20 26 20 41 72 63 68 69 74 65 63 74 3A 20 4D 6F 68 61 6D 6D 61 64 72 65 7A 61 20 41 73 68 6F 75 72 69 2C 20 32 30 32 33 20 53 65 6E 69 6F 72 20 45 6E 67 69 6E 65 65 72 20 61 74 20 63 61 74 61 6C 79 7A 65 2E 6F 6E 65 20 48 75 62 6D 61 6B 65 72 6C 61 62 73 20 4F 62 6C 69 76 69 6F 6E 20 53 6F 66 74 77 61 72 65";
    


    public fun GET_APP_ID_FOR_CHAT_APP() :u8 {
        return APP_ID_FOR_CHAT_APP
    }

    public fun GET_APP_ID_FOR_CHAT_WEB() :u8 {
        return APP_ID_FOR_CHAT_WEB
    }

    public fun GET_APP_ID_XMPP_SERVER() :u8 {
        return APP_ID_XMPP_SERVER
    }

     public fun GET_APP_META_DATA() :vector<u8>{
        return APP_META_DATA
    }

}