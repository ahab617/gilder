module gilder::backend{
    friend gilder::gilder;


    const IP_BACKEND_PORT: vector<u8> =b":8080";
    const STORAGE_SERVICE: vector<u8> = b"gilder.AWS";
    const FONT_SERVER: vector<u8> = b"HTTPS://";



    fun GET_IP_BACKEND_PORT(): vector<u8> {
        return IP_BACKEND_PORT
    }

    fun GET_STORAGE_SERVICE(): vector<u8> {
        return STORAGE_SERVICE
    }

     fun GET_FONT_SERVER(): vector<u8> {
        return FONT_SERVER
    }

    
}