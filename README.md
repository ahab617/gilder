# Gilder: Decentralized Gaming Forum & Chat Platform

Welcome to Gilder, a cutting-edge decentralized gaming forum and chat platform built on the Sui blockchain. Gilder is designed to foster a vibrant, secure, and inclusive community where gamers can discuss, share, and interact with one another without the constraints of traditional centralized platforms. Experience a new level of freedom, transparency, and innovation, all powered by the advanced capabilities of the Sui blockchain and the Move language.

## Features

- **Decentralized Governance**: Gilder ensures a fair and transparent platform, free from centralized control and censorship.
- **Secure & Immutable**: Benefit from the inherent security of the Sui blockchain, with encrypted chat and immutable forum content.
- **Native Token Integration**: Seamlessly use Sui tokens for in-platform transactions, tipping, and monetization opportunities.
- **Smart Contracts**: Leverage the power of Move language and smart contracts for unique features and automation.
- **Scalable & High-performance**: Enjoy a smooth user experience with the scalability and high throughput of the Sui blockchain.
- **Interoperable**: Connect with other blockchain networks and applications for cross-chain collaboration and integration.
- **Customizable User Experience**: Tailor your Gilder experience with customizable themes, avatars, and user profiles.

Join Gilder today and discover the future of decentralized gaming communities!



## Gilder is live on the devnet now!

```
BUILDING gilder
Successfully verified dependencies on-chain against source.
----- Transaction Digest ----
7mcaidhbz7KKD2YgYNiXkhV7Uu6fsg8Dq58xe39bMDp9
----- Transaction Data ----
Transaction Signature: [Signature(Secp256k1SuiSignature(Secp256k1SuiSignature([1, 103, 142, 231, 40, 50, 152, 233, 155, 108, 76, 155, 164, 2, 139, 51, 29, 61, 6, 20, 118, 186, 60, 177, 237, 169, 184, 20, 167, 181, 235, 152, 125, 21, 12, 80, 160, 21, 249, 235, 137, 186, 137, 184, 37, 31, 74, 229, 248, 20, 29, 13, 99, 119, 150, 66, 16, 3, 241, 3, 196, 92, 132, 15, 75, 3, 157, 134, 180, 13, 49, 70, 220, 202, 230, 138, 150, 225, 148, 170, 155, 140, 228, 209, 73, 139, 28, 119, 30, 34, 63, 135, 201, 37, 113, 238, 96, 157])))]
Transaction Kind : Programmable
Inputs: [Pure(SuiPureValue { value_type: Some(Address), value: "0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a" })]
Commands: [
  Publish(_,0x0000000000000000000000000000000000000000000000000000000000000001,0x0000000000000000000000000000000000000000000000000000000000000002),
  TransferObjects([Result(0)],Input(0)),
]

Sender: 0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a
Gas Payment: Object ID: 0x4d5a0e408bedeafa514c8910b5a8625b45711eb2627b96d6d9b3d0f69eea6291, version: 0x53ab, digest: 9njKqCP8dtBRGjhW3G9cgyCncWhW9bDaGij55qASG3yH 
Gas Owner: 0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a
Gas Price: 1000
Gas Budget: 300000000

----- Transaction Effects ----
Status : Success
Created Objects:
  - ID: 0x585ad1bdbd09bdfa7f4c57d839fe05424c3a576cee51043bc83bc8f9d089dc12 , Owner: Account Address ( 0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a )
  - ID: 0x7c866efbf6d3f8c56190fc358c862c373cb14ebf674b2eaabe48d0694548049f , Owner: Immutable
  - ID: 0xe880060e9405f0d4bb2645bc9105f4f2d92b6f63cbd54cac274fb2d0c8bb279d , Owner: Shared
Mutated Objects:
  - ID: 0x4d5a0e408bedeafa514c8910b5a8625b45711eb2627b96d6d9b3d0f69eea6291 , Owner: Account Address ( 0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a )

----- Events ----
Array []
----- Object changes ----
Array [
    Object {
        "type": String("mutated"),
        "sender": String("0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a"),
        "owner": Object {
            "AddressOwner": String("0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a"),
        },
        "objectType": String("0x2::coin::Coin<0x2::sui::SUI>"),
        "objectId": String("0x4d5a0e408bedeafa514c8910b5a8625b45711eb2627b96d6d9b3d0f69eea6291"),
        "version": String("21420"),
        "previousVersion": String("21419"),
        "digest": String("FuAzVZSw5ofs4mDFMwPd9dP9Z68GXuuZg4Epm6qSRc5N"),
    },
    Object {
        "type": String("created"),
        "sender": String("0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a"),
        "owner": Object {
            "AddressOwner": String("0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a"),
        },
        "objectType": String("0x2::package::UpgradeCap"),
        "objectId": String("0x585ad1bdbd09bdfa7f4c57d839fe05424c3a576cee51043bc83bc8f9d089dc12"),
        "version": String("21420"),
        "digest": String("AHeXu3W51RcUYV4qCksu1EGM5ghMojnWpY1UgYatEbUw"),
    },
    Object {
        "type": String("published"),
        "packageId": String("0x7c866efbf6d3f8c56190fc358c862c373cb14ebf674b2eaabe48d0694548049f"),
        "version": String("1"),
        "digest": String("7dUZMwKm2Xjn6w1znwHP9sWbQ2C6pQmj9pMStXKGYVd3"),
        "modules": Array [
            String("APPID"),
            String("Errors"),
            String("URL"),
            String("backend"),
            String("bcd"),
            String("calendar"),
            String("chat"),
            String("config"),
            String("gilder"),
            String("profile"),
            String("resources"),
            String("security"),
            String("storage"),
            String("user_guard"),
            String("wallet"),
        ],
    },
    Object {
        "type": String("created"),
        "sender": String("0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a"),
        "owner": Object {
            "Shared": Object {
                "initial_shared_version": Number(21420),
            },
        },
        "objectType": String("0x7c866efbf6d3f8c56190fc358c862c373cb14ebf674b2eaabe48d0694548049f::profile::General"),
        "objectId": String("0xe880060e9405f0d4bb2645bc9105f4f2d92b6f63cbd54cac274fb2d0c8bb279d"),
        "version": String("21420"),
        "digest": String("ErzBbiQpyytd7vDDWAWnuoNRZcFPbdEP5oFaEfmuHEz5"),
    },
]
----- Balance changes ----
Array [
    Object {
        "owner": Object {
            "AddressOwner": String("0x25275e6065ee9a13cdde391e5b6ed91d0df8fb896f1df2baf6c268f2c34bf29a"),
        },
        "coinType": String("0x2::sui::SUI"),
        "amount": String("-153316680"),
    },
]



```
