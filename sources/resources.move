module gilder::resources{
    friend gilder::gilder;


    const URL_LOGO_ADDRESS: vector<u8> =b"HTTPS://";
    const URL_FRONTEND_ADDRESS: vector<u8> = b"HTTPS://";
    const URL_IPFS_NODE: vector<u8> = b"HTTPS://";



    fun GET_URL_LOGO_ADDRESS(): vector<u8> {
        return URL_LOGO_ADDRESS
    }

    fun GET_URL_FRONTEND_ADDRESS(): vector<u8> {
        return URL_FRONTEND_ADDRESS
    }

     fun GET_URL_IPFS_NODE(): vector<u8> {
        return URL_IPFS_NODE
    }

    
}