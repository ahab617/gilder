module gilder::config{

    friend gilder::gilder;
    /// Max text length.
    const MAX_TEXT_LENGTH: u64 = 16384;



    const ACTION_POST: u8 = 0;
    const ACTION_REPOST: u8 = 1;
    const ACTION_QUOTE_POST: u8 = 2;
    const ACTION_REPLY: u8 = 3;
    const ACTION_LIKE: u8 = 4;

    public fun GET_MAX_TEXT_LENGTH(): u64 {
         return MAX_TEXT_LENGTH
   }

    public fun GET_ACTION_POST(): u8 {
         return ACTION_POST
   }

    public fun GET_ACTION_REPOST(): u8 {
         return ACTION_REPOST
   }

    public fun GET_ACTION_QUOTE_POST(): u8 {
         return ACTION_QUOTE_POST
   }

    public fun GET_ACTION_REPLY(): u8 {
         return ACTION_REPLY
   }

    public fun GET_ACTION_LIKE(): u8 {
         return ACTION_LIKE
   }

}