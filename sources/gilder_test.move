
#[test_only]
module gilder::gilder_test {
    use std::option::some;
    use std::vector;
    use sui::test_scenario::{Self, Scenario};
    use gilder::gilder::{Self, GilderMetaData, Gilder, ForumLike, ForumRepost};
    use gilder::profile::General;

    const CREATOR: address = @0xA;
    const USER: address = @0xB;
    const SOME_POST: address = @0xC;

    /// Max post length.
    const MAX_TEXT_LENGTH: u64 = 40000;// based on reddit

    /// Action Types
    const ACTION_POST: u8 = 0;
    const ACTION_REPOST: u8 = 1;
    const ACTION_QUOTE_POST: u8 = 2;
    const ACTION_REPLY: u8 = 3;
    const ACTION_LIKE: u8 = 4;

    /// APP IDs for filter
    const APP_ID_FOR_COMINGCHAT_TEST: u8 = 3;

    fun init_(scenario: &mut Scenario) {
        gilder::profile::testing_initialize(test_scenario::ctx(scenario));
    }

    fun signup_(scenario: &mut Scenario) {
        let general = test_scenario::take_shared<General>(scenario);

        gilder::profile::signup(
            &mut general,
            b"test",
            x"7423732E9A3BDB39A685C0B9FCB0B6272A443C7E9889D1DC4AD9BA17C0FEF7BA5064D7826C4EE32CFC42EB7F2822CC7DAB7327D482EFD56A1E912BA333A8160D",
            test_scenario::ctx(scenario)
        );

        assert!(gilder::profile::user_exists(&general, USER), 1);
        test_scenario::return_shared(general);
    }

    fun waste_(scenario: &mut Scenario) {
        let general = test_scenario::take_shared<General>(scenario);
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        gilder::profile::waste(
            &mut general,
            gilder_meta_data,
            test_scenario::ctx(scenario)
        );

        assert!(!gilder::profile::user_exists(&general, USER), 2);

        test_scenario::return_shared(general);
    }

    fun follow_(scenario: &mut Scenario) {
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        let accounts = vector::empty<address>();
        vector::push_back(&mut accounts, CREATOR);
        gilder::follow_account(
            &mut gilder_meta_data,
            accounts
        );
        assert!(gilder::meta_data_has_following(&gilder_meta_data, CREATOR), 3);

        test_scenario::return_to_sender(scenario, gilder_meta_data)
    }

    fun unfollow_(scenario: &mut Scenario) {
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        let accounts = vector::empty<address>();
        vector::push_back(&mut accounts, CREATOR);
        gilder::unfollow_account(
            &mut gilder_meta_data,
            accounts,
        );
        assert!(gilder::meta_data_followers(&gilder_meta_data) == 0, 4);

        test_scenario::return_to_sender(scenario, gilder_meta_data)
    }

    fun forum_post_(
        app_identifier: u8,
        action: u8,
        text: vector<u8>,
        scenario: &mut Scenario
    ) {
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        let gilder_index = gilder::meta_data_index(&gilder_meta_data);
        gilder::forum_post(
            &mut gilder_meta_data,
            app_identifier,
            action,
            text,
            test_scenario::ctx(scenario)
        );
        assert!(gilder::meta_data_index(&gilder_meta_data) == gilder_index + 1, 5);

        test_scenario::return_to_sender(scenario, gilder_meta_data)
    }

    fun post_like(
        app_identifier: u8,
        action: u8,
        text: vector<u8>,
        ref_identifier: address,
        take_index: u64,
        scenario: &mut Scenario
    ) {
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        let gilder_index = gilder::meta_data_index(&gilder_meta_data);
        gilder::post_and_reference(
            &mut gilder_meta_data,
            app_identifier,
            action,
            text,
            ref_identifier,
            test_scenario::ctx(scenario)
        );
        assert!(gilder::meta_data_index(&gilder_meta_data) == gilder_index + 1, 6);
        test_scenario::return_to_sender(scenario, gilder_meta_data);

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);
            let like_object = test_scenario::take_from_address<ForumLike>(scenario, SOME_POST);
            assert!(gilder::like_read(&like_object) == USER, 1);
            test_scenario::return_to_address(SOME_POST, like_object);

            let indexes = vector::empty<u64>();
            vector::push_back(&mut indexes, take_index);

            gilder::fetch_batch(
                &mut gilder_meta_data,
                indexes,
                USER
            );

            test_scenario::return_to_sender(scenario, gilder_meta_data)
        };

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_like = test_scenario::take_from_sender<Gilder>(scenario);

            let (_app, post_sender, _text, ref_id, action) = gilder::read_gilder(&gilder_like);
            assert!(post_sender == USER, 2);
            assert!(ref_id == some(SOME_POST), 3);
            assert!(action == ACTION_LIKE, 4);

            let burns = vector::empty<Gilder>();
            vector::push_back(&mut burns, gilder_like);

            gilder::withdraw_by_objects_batch(burns)
        };

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 0, 5);

            test_scenario::return_to_sender(scenario, gilder_meta_data)
        };
    }

    fun repost_or_quote_forum_post_(
        app_identifier: u8,
        action: u8,
        text: vector<u8>,
        ref_identifier: address,
        take_index: u64,
        gilder_count: u64,
        scenario: &mut Scenario
    ) {
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        let gilder_index = gilder::meta_data_index(&gilder_meta_data);
        gilder::post_and_reference(
            &mut gilder_meta_data,
            app_identifier,
            action,
            text,
            ref_identifier,
            test_scenario::ctx(scenario)
        );
        assert!(gilder::meta_data_index(&gilder_meta_data) == gilder_index + 1, 7);
        test_scenario::return_to_sender(scenario, gilder_meta_data);

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

            let repost_object = test_scenario::take_from_address<ForumRepost>(scenario, SOME_POST);
            assert!(gilder::repost_read(&repost_object) == USER, 1);
            test_scenario::return_to_address(SOME_POST, repost_object);

            let indexes = vector::empty<u64>();
            vector::push_back(&mut indexes, take_index);

            gilder::fetch_batch(
                &mut gilder_meta_data,
                indexes,
                USER
            );

            test_scenario::return_to_sender(scenario, gilder_meta_data)
        };

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

            let gilder_repost = test_scenario::take_from_sender<Gilder>(scenario);

            let (_app, post_sender, _text, ref_id, action_type) = gilder::read_gilder(&gilder_repost);
            assert!(post_sender == USER, 2);
            assert!(ref_id == some(SOME_POST), 3);
            assert!(action_type == action, 4);

            let gilder_vec = vector::empty<Gilder>();
            vector::push_back(&mut gilder_vec, gilder_repost);

            gilder::batch_put(&mut gilder_meta_data, gilder_vec);

            test_scenario::return_to_sender(scenario, gilder_meta_data)
        };

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == gilder_count, 5);

            test_scenario::return_to_sender(scenario, gilder_meta_data)
        };
    }

    fun post_reply_(
        app_identifier: u8,
        action: u8,
        text: vector<u8>,
        ref_identifier: address,
        scenario: &mut Scenario
    ) {
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        let gilder_index = gilder::meta_data_index(&gilder_meta_data);
        gilder::post_and_reference(
            &mut gilder_meta_data,
            app_identifier,
            action,
            text,
            ref_identifier,
            test_scenario::ctx(scenario)
        );
        assert!(gilder::meta_data_index(&gilder_meta_data) == gilder_index + 1, 8);

        test_scenario::return_to_sender(scenario, gilder_meta_data)
    }

    fun batch_(count: u64, scenario: &mut Scenario) {
        let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

        let i = 0u64;
        while (i < count) {
            gilder::forum_post(
                &mut gilder_meta_data,
                APP_ID_FOR_COMINGCHAT_TEST,
                ACTION_POST,
                b"post",
                test_scenario::ctx(scenario)
            );
            i = i + 1
        };

        assert!(gilder::meta_data_index(&gilder_meta_data) == count, 9);

        test_scenario::return_to_sender(scenario, gilder_meta_data)
    }

    #[test]
    fun test_signup() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);

        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

            assert!(gilder::meta_data_followers(&gilder_meta_data) == 0, 1);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 0, 2);
            assert!(gilder::meta_data_index(&gilder_meta_data) == 0, 3);

            test_scenario::return_to_sender(scenario, gilder_meta_data);
        };

        test_scenario::end(begin);
    }

    #[test]
    fun test_waste() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);

        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        waste_(scenario);

        test_scenario::end(begin);
    }

    #[test]
    fun test_follow_account() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        follow_(scenario);

        test_scenario::end(begin);
    }

    #[test]
    #[expected_failure]
    fun test_follow_fail() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        follow_(scenario);

        test_scenario::next_tx(scenario, USER);
        follow_(scenario);

        test_scenario::end(begin);
    }

    #[test]
    fun test_unfollow_account() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        follow_(scenario);

        test_scenario::next_tx(scenario, USER);
        unfollow_(scenario);

        test_scenario::end(begin);
    }

    #[test]
    fun test_unfollow_without_followings_should_ok() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        unfollow_(scenario);

        test_scenario::end(begin);
    }

    #[test]
    fun test_post_action_forum() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_POST,
            b"test_post",
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    #[expected_failure(abort_code = gilder::gilder::ERROR_WRONG_ACTION)]
    fun test_post_fail_empty_text() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_POST,
            b"",
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    #[expected_failure(abort_code = gilder::gilder::ERROR_POST_OVERFLOW)]
    fun test_post_fail_text_long() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        let (i, text) = (0, vector::empty<u8>());
        while (i < MAX_TEXT_LENGTH) {
            vector::push_back(&mut text, 0u8);
            i = i + 1;
        };
        vector::push_back(&mut text, 0u8);


        forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_POST,
            text,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_forum_like_action() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        post_like(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_LIKE,
            b"",
            SOME_POST,
            0,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    #[expected_failure(abort_code = gilder::gilder::ERROR_WRONG_ACTION)]
    fun test_like_forum_invalid_action() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        post_like(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_LIKE,
            b"test_like",
            SOME_POST,
            0,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_like_action_twice_ok() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        post_like(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_LIKE,
            b"",
            SOME_POST,
            0,
            scenario
        );

        test_scenario::next_tx(scenario, USER);
        post_like(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_LIKE,
            b"",
            SOME_POST,
            1,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_repost_action() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        repost_or_quote_forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_REPOST,
            b"",
            SOME_POST,
            0,
            1,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_repost_action_twice_ok() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        repost_or_quote_forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_REPOST,
            b"",
            SOME_POST,
            0,
            1,
            scenario
        );

        test_scenario::next_tx(scenario, USER);
        repost_or_quote_forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_REPOST,
            b"",
            SOME_POST,
            1,
            2,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_quote_post_action() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        repost_or_quote_forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_QUOTE_POST,
            b"test_quote_post",
            SOME_POST,
            0,
            1,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_quote_post_forum_twice_ok() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        repost_or_quote_forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_QUOTE_POST,
            b"test_quote_post",
            SOME_POST,
            0,
            1,
            scenario
        );

        test_scenario::next_tx(scenario, USER);
        repost_or_quote_forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_QUOTE_POST,
            b"test_quote_post",
            SOME_POST,
            1,
            2,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_reply_action() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        post_reply_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_REPLY,
            b"test_reply",
            SOME_POST,
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    #[expected_failure(abort_code = gilder::gilder::ERROR_UNPREDICTED_ACTION)]
    fun test_unexpected_action() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        forum_post_(
            APP_ID_FOR_COMINGCHAT_TEST,
            ACTION_REPLY,
            b"test_reply",
            scenario
        );

        test_scenario::end(begin);
    }

    #[test]
    fun test_group_remove_indexes() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        batch_(100, scenario);

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);
            let burns = vector::empty<u64>();
            vector::push_back(&mut burns, 0);
            vector::push_back(&mut burns, 99);
            vector::push_back(&mut burns, 0);

            assert!(gilder::meta_data_gilder_exist(&gilder_meta_data, 0), 1);
            assert!(gilder::meta_data_gilder_exist(&gilder_meta_data, 99), 2);

            gilder::group_remove_indexes(&mut gilder_meta_data, burns);

            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 98, 3);
            assert!(!gilder::meta_data_gilder_exist(&gilder_meta_data, 0), 4);
            assert!(!gilder::meta_data_gilder_exist(&gilder_meta_data, 99), 5);

            test_scenario::return_to_sender(scenario, gilder_meta_data)
        };

        test_scenario::end(begin);
    }

    #[test]
    fun test_group_delete_range() {
        let begin = test_scenario::begin(CREATOR);
        let scenario = &mut begin;

        init_(scenario);
        test_scenario::next_tx(scenario, USER);
        signup_(scenario);

        test_scenario::next_tx(scenario, USER);
        batch_(100, scenario);

        test_scenario::next_tx(scenario, USER);
        {
            let gilder_meta_data = test_scenario::take_from_sender<GilderMetaData>(scenario);

            gilder::group_delete_range(&mut gilder_meta_data, 0, 10);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 90, 1);

            gilder::group_delete_range(&mut gilder_meta_data, 10, 20);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 80, 2);

            gilder::group_delete_range(&mut gilder_meta_data, 10, 25);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 75, 3);

            gilder::group_delete_range(&mut gilder_meta_data, 25, 25);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 75, 4);

            gilder::group_delete_range(&mut gilder_meta_data, 25, 26);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 74, 5);

            gilder::group_delete_range(&mut gilder_meta_data, 90, 101);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 64, 6);

            gilder::group_delete_range(&mut gilder_meta_data, 90, 201);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 64, 7);

            gilder::group_delete_range(&mut gilder_meta_data, 0, 201);
            assert!(gilder::meta_data_gilder_count(&gilder_meta_data) == 0, 8);

            test_scenario::return_to_sender(scenario, gilder_meta_data)
        };

        test_scenario::end(begin);
    }
}
