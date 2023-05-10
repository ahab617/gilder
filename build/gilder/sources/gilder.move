
module gilder::gilder {


    use std::option::{Self, Option, some, none};
    use std::string::{Self, String};
    use std::vector::{Self, length};
    use gilder::config::{GET_MAX_TEXT_LENGTH,GET_ACTION_REPOST,GET_ACTION_QUOTE_POST};
    //use gilder::URL::{GET_URL_META};
    // use gilder::Errors::{GET_ERROR_UNPREDICTED_ACTION};
   // use gilder::APPID::{GET_APP_ID_XMPP_SERVER} ;  
    use sui::object::{Self, UID};
    use sui::table::{Self, Table};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext, sender};
    use sui::url::{Self, Url};
    friend gilder::profile;

  


    const ERROR_UNPREDICTED_ACTION: u64 = 3;
    const ERROR_WRONG_ACTION: u64 = 4;
    const ERROR_POST_OVERFLOW: u64 = 1;


    struct ForumRepost has key {
        id: UID,
        post_sender: address
    }

    struct ForumLike has key {
        id: UID,
        post_sender: address
    }

    struct GilderMetaData has key {
        id: UID,
        next_pointer: u64,
        followers: Table<address, address>,
        gilder_table: Table<u64, Gilder>,
        url: Url
    }


    struct Gilder has key, store {
        id: UID,
        app_id: u8,
        post_sender: address,
        text: Option<String>,
        ref_id: Option<address>,
        action: u8,
        url: Url
    }

  

    fun internal_post(
        meta_data: &mut GilderMetaData,
        app_id: u8,
        text: vector<u8>,
        ctx: &mut TxContext,
    ) {
        assert!(length(&text) <= GET_MAX_TEXT_LENGTH(), gilder::Errors::GET_ERROR_POST_OVERFLOW());

        let gilder = Gilder {
            id: object::new(ctx),
            app_id,
            post_sender: tx_context::sender(ctx),
            text: some(string::utf8(text)),
            ref_id: none(),
            action: gilder::config::GET_ACTION_POST(),
            url: url::new_unsafe_from_bytes(gilder::URL::GET_URL_POST())
        };

        table::add(&mut meta_data.gilder_table, meta_data.next_pointer, gilder);
        meta_data.next_pointer = meta_data.next_pointer + 1
    }


    fun reinternal_post(
        meta_data: &mut GilderMetaData,
        app_id: u8,
        ref_id: Option<address>,
        ctx: &mut TxContext,
    ) {
        assert!(option::is_some(&ref_id), gilder::Errors::GET_ERROR_NEEDED_REF());

        let gilder = Gilder {
            id: object::new(ctx),
            app_id,
            post_sender: tx_context::sender(ctx),
            text: none(),
            ref_id,
            action: GET_ACTION_REPOST(),
            url: url::new_unsafe_from_bytes(gilder::URL::GET_URL_REPOST())
        };

        transfer::transfer(
            ForumRepost {
                id: object::new(ctx),
                post_sender: tx_context::sender(ctx),
            },
            option::extract(&mut ref_id)
        );

        table::add(&mut meta_data.gilder_table, meta_data.next_pointer, gilder);
        meta_data.next_pointer = meta_data.next_pointer + 1
    }


    fun recite_post_internal(
        meta_data: &mut GilderMetaData,
        app_id: u8,
        text: vector<u8>,
        ref_id: Option<address>,
        ctx: &mut TxContext,
    ) {
        assert!(length(&text) <= GET_MAX_TEXT_LENGTH(), gilder::Errors::GET_ERROR_POST_OVERFLOW());
        assert!(option::is_some(&ref_id), gilder::Errors::GET_ERROR_NEEDED_REF());

        let gilder = Gilder {
            id: object::new(ctx),
            app_id,
            post_sender: tx_context::sender(ctx),
            text: some(string::utf8(text)),
            ref_id,
            action: GET_ACTION_QUOTE_POST(),
            url: url::new_unsafe_from_bytes(gilder::URL::GET_URL_QUOTE_POST())
        };

        transfer::transfer(
            ForumRepost {
                id: object::new(ctx),
                post_sender: tx_context::sender(ctx),
            },
            option::extract(&mut ref_id)
        );

        table::add(&mut meta_data.gilder_table, meta_data.next_pointer, gilder);
        meta_data.next_pointer = meta_data.next_pointer + 1
    }





    public(friend) fun gilder_meta_data(
        ctx: &mut TxContext,
    ) {
        transfer::transfer(
            GilderMetaData {
                id: object::new(ctx),
                next_pointer: 0,
                followers: table::new<address, address>(ctx),
                gilder_table: table::new<u64, Gilder>(ctx),
                url: url::new_unsafe_from_bytes(gilder::URL::GET_URL_META())
            },
            tx_context::sender(ctx)
        )
    }


    public(friend) fun waste_all(
        meta_data: GilderMetaData,
    ) {
        let next_pointer = meta_data.next_pointer;
        group_delete_range(&mut meta_data, 0, next_pointer);
        let GilderMetaData { id, next_pointer: _, gilder_table, followers, url: _ } = meta_data;
        table::destroy_empty(gilder_table);
        table::drop(followers);
        object::delete(id);
    }



    fun internal_respond(
        meta_data: &mut GilderMetaData,
        app_id: u8,
        text: vector<u8>,
        ref_id: Option<address>,
        ctx: &mut TxContext,
    ) {
        assert!(length(&text) <= GET_MAX_TEXT_LENGTH(), gilder::Errors::GET_ERROR_POST_OVERFLOW());
        assert!(option::is_some(&ref_id), gilder::Errors::GET_ERROR_NEEDED_REF());

        let gilder = Gilder {
            id: object::new(ctx),
            app_id,
            post_sender: tx_context::sender(ctx),
            text: some(string::utf8(text)),
            ref_id,
            action: gilder::config::GET_ACTION_REPLY(),
            url: url::new_unsafe_from_bytes(gilder::URL::GET_URL_REPLY())
        };

        table::add(&mut meta_data.gilder_table, meta_data.next_pointer, gilder);
        meta_data.next_pointer = meta_data.next_pointer + 1
    }


    fun internal_like_post(
        meta_data: &mut GilderMetaData,
        app_id: u8,
        ref_id: Option<address>,
        ctx: &mut TxContext,
    ) {
        assert!(option::is_some(&ref_id), gilder::Errors::GET_ERROR_NEEDED_REF());

        let gilder = Gilder {
            id: object::new(ctx),
            app_id,
            post_sender: tx_context::sender(ctx),
            text: none(),
            ref_id,
            action: gilder::config::GET_ACTION_LIKE(),
            url: url::new_unsafe_from_bytes(gilder::URL::GET_URL_LIKE())
        };

        transfer::transfer(
            ForumLike {
                id: object::new(ctx),
                post_sender: tx_context::sender(ctx),
            },
            option::extract(&mut ref_id)
        );

        table::add(&mut meta_data.gilder_table, meta_data.next_pointer, gilder);
        meta_data.next_pointer = meta_data.next_pointer + 1
    }


    public entry fun forum_post(
        meta_data: &mut GilderMetaData,
        app_identifier: u8,
        action: u8,
        text: vector<u8>,
        ctx: &mut TxContext,
    ) {
        if (action == gilder::config::GET_ACTION_POST()) {
            assert!(length(&text) > 0, gilder::Errors::GET_ERROR_WRONG_ACTION());
            internal_post(meta_data, app_identifier, text, ctx);
        } else {
            abort gilder::Errors::GET_ERROR_UNPREDICTED_ACTION()
        }
    }


    public entry fun post_and_reference(
        meta_data: &mut GilderMetaData,
        app_identifier: u8,
        action: u8,
        text: vector<u8>,
        ref_identifier: address,
        ctx: &mut TxContext,
    ) {
        if (action == GET_ACTION_REPOST()) {
            assert!(length(&text) == 0 && ref_identifier != sender(ctx), gilder::Errors::GET_ERROR_WRONG_ACTION());
            reinternal_post(meta_data, app_identifier, some(ref_identifier), ctx)
        } else if (action == GET_ACTION_QUOTE_POST()) {
            assert!(length(&text) > 0 && ref_identifier != sender(ctx), gilder::Errors::GET_ERROR_WRONG_ACTION());
            recite_post_internal(meta_data, app_identifier, text, some(ref_identifier), ctx)
        } else if (action == gilder::config::GET_ACTION_REPLY()) {
            assert!(length(&text) > 0 && ref_identifier != sender(ctx), gilder::Errors::GET_ERROR_WRONG_ACTION());
            internal_respond(meta_data, app_identifier, text, some(ref_identifier), ctx)
        } else if (action == gilder::config::GET_ACTION_LIKE()) {
            assert!(length(&text) == 0 && ref_identifier != sender(ctx), gilder::Errors::GET_ERROR_WRONG_ACTION());
            internal_like_post(meta_data, app_identifier, some(ref_identifier), ctx)
        } else {
            abort gilder::Errors::GET_ERROR_UNPREDICTED_ACTION()
        }
    }




    public entry fun follow_account(
        meta_data: &mut GilderMetaData,
        accounts: vector<address>,
    ) {
        let (i, len) = (0, vector::length(&accounts));
        while (i < len) {
            let account = vector::pop_back(&mut accounts);
            table::add(&mut meta_data.followers, account, account);
            i = i + 1
        };
    }


    public entry fun unfollow_account(
        meta_data: &mut GilderMetaData,
        accounts: vector<address>,
    ) {
        let (i, len) = (0, vector::length(&accounts));
        while (i < len) {
            let account = vector::pop_back(&mut accounts);

            if (table::contains(&meta_data.followers, account)) {
                table::remove(&mut meta_data.followers, account);
            };

            i = i + 1
        };
    }


    public fun withdraw_by_object(gilder: Gilder) {
        let Gilder {
            id,
            app_id: _,
            post_sender: _,
            text: _,
            ref_id: _,
            action: _,
            url: _,
        } = gilder;

        object::delete(id);
    }

    public entry fun withdraw_by_objects_batch(
        gilder_vec: vector<Gilder>
    ) {
        let (i, len) = (0, vector::length(&gilder_vec));
        while (i < len) {
            withdraw_by_object(vector::pop_back(&mut gilder_vec));

            i = i + 1
        };


        vector::destroy_empty(gilder_vec)
    }

    public entry fun group_delete_range(
        meta_data: &mut GilderMetaData,
        start: u64,
        end: u64
    ) {
        let real_end = if (meta_data.next_pointer < end) {
            meta_data.next_pointer
        } else {
            end
        };

        while (start < real_end) {
            if (table::contains(&meta_data.gilder_table, start)) {

                withdraw_by_object(table::remove(&mut meta_data.gilder_table, start))
            };

            start = start + 1
        }
    }


    public entry fun group_remove_indexes(
        meta_data: &mut GilderMetaData,
        indexes: vector<u64>
    ) {
        let (i, len) = (0, vector::length(&indexes));
        while (i < len) {
            let index = vector::pop_back(&mut indexes);

            if (table::contains(&meta_data.gilder_table, index)) {
           
          
                withdraw_by_object(table::remove(&mut meta_data.gilder_table, index))
            };

            i = i + 1
        };
    }


    public entry fun fetch_batch(
        meta_data: &mut GilderMetaData,
        indexes: vector<u64>,
        receiver: address,
    ) {
        let (i, len) = (0, vector::length(&indexes));
        while (i < len) {
            let index = vector::pop_back(&mut indexes);

            if (table::contains(&meta_data.gilder_table, index)) {
             
             
                transfer::transfer(
                    table::remove(&mut meta_data.gilder_table, index),
                    receiver
                )
            };

            i = i + 1
        }
    }



    public fun meta_data_followers(
        gilder_mata: &GilderMetaData
    ): u64 {
        table::length(&gilder_mata.followers)
    }

    public fun meta_data_has_following(
        gilder_mata: &GilderMetaData,
        following: address
    ): bool {
        table::contains(&gilder_mata.followers, following)
    }

    public fun meta_data_index(
        gilder_mata: &GilderMetaData
    ): u64 {
        gilder_mata.next_pointer
    }

    public fun meta_data_gilder_count(
        gilder_mata: &GilderMetaData
    ): u64 {
        table::length(&gilder_mata.gilder_table)
    }

    public fun meta_data_gilder_exist(
        gilder_mata: &GilderMetaData,
        index: u64
    ): bool {
        table::contains(&gilder_mata.gilder_table, index)
    }


    public fun like_read(
        like: &ForumLike
    ): address {
        like.post_sender
    }

    public fun repost_read(
        repost: &ForumRepost
    ): address {
        repost.post_sender
    }


    public entry fun batch_put(
        meta_data: &mut GilderMetaData,
        gilder_vec: vector<Gilder>,
    ) {
        let (i, len) = (0, vector::length(&gilder_vec));
        while (i < len) {
            let gilder = vector::pop_back(&mut gilder_vec);

            table::add(&mut meta_data.gilder_table, meta_data.next_pointer, gilder);
            meta_data.next_pointer = meta_data.next_pointer + 1;

            i = i + 1
        };

       
        vector::destroy_empty(gilder_vec)
    }

    public fun read_gilder(
        gilder: &Gilder
    ): (u8, address, Option<String>, Option<address>, u8) {
        (
            gilder.app_id,
            gilder.post_sender,
            gilder.text,
            gilder.ref_id,
            gilder.action,
        )
    }


}
