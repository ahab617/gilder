module gilder::wallet{
    friend gilder::gilder;


    const WALLET_ADDRESS: vector<u8> =b"";
    const EXPLORER: vector<u8> = b"https://explorer.sui.io/";
    const NFT_SERVER: vector<u8> = b"HTTPS://";
    const FAUCET_ADDRESS: vector<u8> = b"HTTPS://"; 



    fun GET_WALLET_ADDRESS(): vector<u8> {
        return WALLET_ADDRESS
    }

    fun GET_EXPLORER(): vector<u8> {
        return EXPLORER
    }

    fun GET_NFT_SERVER(): vector<u8> {
        return NFT_SERVER
    }

    fun GET_FAUCET_ADDRESS(): vector<u8> {
        return FAUCET_ADDRESS
    }

    
}