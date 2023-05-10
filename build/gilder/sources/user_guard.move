
/*



   ___  _    _ _     _            ___       __ _                       
  / _ \| |__| (_)_ _(_)___ _ _   / __| ___ / _| |___ __ ____ _ _ _ ___ 
 | (_) | '_ \ | \ V / / _ \ ' \  \__ \/ _ \  _|  _\ V  V / _` | '_/ -_)
  \___/|_.__/_|_|\_/|_\___/_||_| |___/\___/_|  \__|\_/\_/\__,_|_| \___|
                                                                       



 blacklist module: This module takes care of potential spamming usernames such as admin
 It is possible to use it for other onchain  functions such as search (post search, etc.) or protections (aka post, etc.)

*/

module gilder::user_guard {


    use std::hash;
    use std::vector;

    const EHASH_COUNT_IS_ZERO: u64 = 0x10000;
    const EVECTOR_LENGTH_NOT_32: u64 = 0x10001;

    struct Filter has copy, drop, store {
        bitmap: u256,
        hash_count: u8
    }
   

    public fun get_hash_count(_item_num: u64): u8 {
        let num_of_hash = (256 * 144) / (_item_num * 100) + 1;
        if (num_of_hash < 256) (num_of_hash as u8) else 255
    }


    public fun add_to_bitmap(_bitmap: u256, _hash_count: u8, _item: vector<u8>): u256 {
        assert!(_hash_count > 0, EHASH_COUNT_IS_ZERO);
        assert!(vector::length(&_item) == 32, EVECTOR_LENGTH_NOT_32);
        let i: u8 = 0;
        vector::push_back(&mut _item, 0);
        while (i < _hash_count) {
            *vector::borrow_mut(&mut _item, 32) = i;
            let position = vector::pop_back(&mut hash::sha2_256(_item));
            let digest = 1 << position;
            _bitmap = _bitmap | digest;
            i = i + 1;
        };
        _bitmap
    }






    public fun false_positive(_bitmap: u256, _hash_count: u8, _item: vector<u8>): bool {
        assert!(_hash_count > 0, EHASH_COUNT_IS_ZERO);
        assert!(vector::length(&_item) == 32, EVECTOR_LENGTH_NOT_32);
        let i: u8 = 0;
        vector::push_back(&mut _item, 0);
        while (i < _hash_count) {
            *vector::borrow_mut(&mut _item, 32) = i;
            let position = vector::pop_back(&mut hash::sha2_256(_item));
            let digest = 1 << position;
            if (_bitmap != _bitmap | digest) return false;
            i = i + 1;
        };
        true
    }

    public fun new(_item_num: u64): Filter {
        Filter {
            bitmap: 0,
            hash_count: get_hash_count(_item_num)
        }
    }


    public fun add(_filter: &mut Filter, _item: vector<u8>) {
        *&mut _filter.bitmap = add_to_bitmap(_filter.bitmap, _filter.hash_count, _item);
    }


    public fun check(_filter: &Filter, _item: vector<u8>): bool {
        false_positive(_filter.bitmap, _filter.hash_count, _item)
    }

 #[test]
    public fun set_up() {
        // Test init: check hash count
        let filter = new(10);
       
        
        // Test adding elements
        add(&mut filter, b"admin");
        add(&mut filter, b"administrator");
        add(&mut filter, b"admins");
        add(&mut filter, b"ads");
        add(&mut filter, b"support");
        add(&mut filter, b"spam");
        add(&mut filter, b"scam");
        add(&mut filter, b"porn");
        add(&mut filter, b"sex");
        add(&mut filter, b"_");
 
        // Test checking for inclusion
        let included = b"admin";
        let not_included = b"normaluser";
        let i = 0;
        while (i < 10) {
            let key = hash::sha2_256(vector::singleton(*vector::borrow(&included, i)));
            add(&mut filter, key);
            i = i + 1;
        };
        let j = 0;
        while (j < 10) {
            let key = hash::sha2_256(vector::singleton(*vector::borrow(&included, j)));
            let false_positive = check(&filter, key);
            // It may exist or not
            assert!(false_positive, 3); // Should return false positive
            j = j + 1;
        };
      
    }
}
