
module gilder::profile {


    use sui::url::{Self, Url};
    use gilder::gilder::{gilder_meta_data, waste_all, GilderMetaData};
    use std::bcs;
    use std::hash::sha3_256;
    use sui::dynamic_object_field as dof;
    use sui::ed25519::ed25519_verify;
    use sui::object::{Self, ID, UID};
    use std::vector;
    use sui::object_table::{Self, ObjectTable};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    const INIT_CAPTCHA_PUBLIC_KEY: vector<u8> = x"";
    const URL_GLOABL: vector<u8> = b"ipfs://";
    const URL_PROFILE: vector<u8> = b"ipfs://";
    const ERR_NO_PERMISSIONS: u64 = 1;
    const ERR_INVALID_CAPTCHA: u64 = 2;
  //--------------------------------------------------------------------------------

      #[test_only]
    public fun testing_initialize(ctx: &mut TxContext) {
        transfer::share_object(
            General {
                id: object::new(ctx),
                composer: tx_context::sender(ctx),
                captcha_pubkey: x"",
                profiles: object_table::new<address, CoverProfile>(ctx),
                url: url::new_unsafe_from_bytes(URL_GLOABL)
            }
        )
    }

    #[test]
    fun prove_ed25519() {
        use std::hash;
        use sui::ed25519::ed25519_verify;

        let _privkey = x"";
        let pubkey = x"";

        let signature = x"";
        // origin msg: 0x000000000000000000000000000000000000000b + 'test'
        let origin_msg = x"";
        let sign_msg = x"";

        assert!(sign_msg == hash::sha3_256(origin_msg), 1);
        assert!(ed25519_verify(&signature, &pubkey, &sign_msg), 2)
    }

  //--------------------------------------------------------------------------------











    struct CoverProfile has key, store {
        id: UID,
        profile: vector<u8>,
        owner: address,
        url: Url
    }

    struct General has key {
        id: UID,
        composer: address,
        captcha_pubkey: vector<u8>,
        profiles: ObjectTable<address, CoverProfile>,
        url: Url
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            General {
                id: object::new(ctx),
                composer: tx_context::sender(ctx),
                captcha_pubkey: INIT_CAPTCHA_PUBLIC_KEY,
                profiles: object_table::new<address, CoverProfile>(ctx),
                url: url::new_unsafe_from_bytes(URL_GLOABL)
            }
        )
    }

    public fun user_exists(
        general: &General,
        user: address
    ): bool {
        object_table::contains(&general.profiles, user)
    }


    public entry fun upgrade_captcha(
        general: &mut General,
        new_pubkey: vector<u8>,
        ctx: &mut TxContext
    ) {
        assert!(general.composer == tx_context::sender(ctx), ERR_NO_PERMISSIONS);
        general.captcha_pubkey = new_pubkey
    }


    public entry fun signup(
        general: &mut General,
        profile: vector<u8>,
        signature: vector<u8>,
        ctx: &mut TxContext
    ) {
        let user = tx_context::sender(ctx);

        let info: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut info, bcs::to_bytes(&user));
        vector::append<u8>(&mut info, bcs::to_bytes(&profile));
        let captcha: vector<u8> = sha3_256(info);

        assert!(
            ed25519_verify(&signature, &general.captcha_pubkey, &captcha),
            ERR_INVALID_CAPTCHA
        );

        if (!user_exists(general, user)) {
            let cover_profileprofile = CoverProfile {
                id: object::new(ctx),
                url: url::new_unsafe_from_bytes(URL_PROFILE),
                owner: user,
                profile
            };

            object_table::add(&mut general.profiles, user, cover_profileprofile);
            gilder_meta_data(ctx);
        };

        let mut_profile = object_table::borrow_mut(&mut general.profiles, user);
        mut_profile.profile = profile
    }


    public entry fun connect_item<T: key + store>(
        general: &mut General,
        item: T,
        ctx: &mut TxContext
    ) {
        let user = tx_context::sender(ctx);
        let mut_profile = object_table::borrow_mut(&mut general.profiles, user);

        dof::add(&mut mut_profile.id, object::id(&item), item);
    }

    public entry fun delete_item<T: key + store>(
        general: &mut General,
        item_id: ID,
        ctx: &mut TxContext
    ) {
        let user = tx_context::sender(ctx);
        let mut_profile = object_table::borrow_mut(&mut general.profiles, user);

        transfer::public_transfer(
            dof::remove<ID, T>(&mut mut_profile.id, item_id),
            tx_context::sender(ctx)
        );
    }

    public entry fun waste(
        general: &mut General,
        meta_data: GilderMetaData,
        ctx: &mut TxContext
    ) {
        let cover_profileprofile = object_table::remove(
            &mut general.profiles,
            tx_context::sender(ctx)
        );

        let CoverProfile { id, profile: _profile, url: _url, owner: _owner } = cover_profileprofile;
        object::delete(id);

        waste_all(meta_data)
    }

   
}
