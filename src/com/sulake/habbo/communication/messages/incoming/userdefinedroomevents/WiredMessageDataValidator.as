package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** Shared fail-fast bounds for unframed Wired 2.0 packet collections. */
    public class WiredMessageDataValidator
    {
        public static function requireBytes(k:IMessageDataWrapper, amount:uint, label:String):void
        {
            if (k.bytesAvailable < amount)
            {
                throw new Error(label + ": needs at least " + amount + " bytes, has " + k.bytesAvailable);
            }
        }

        public static function readCount(k:IMessageDataWrapper, minimumEntryBytes:uint,
                                         hardLimit:int, label:String):int
        {
            requireBytes(k, 4, label + " count");
            var count:int = k.readInteger();
            if (count < 0)
            {
                throw new Error(label + ": negative count " + count);
            }
            if (count > hardLimit)
            {
                throw new Error(label + ": count " + count + " exceeds hard limit " + hardLimit);
            }
            if (minimumEntryBytes > 0 && count > int(k.bytesAvailable / minimumEntryBytes))
            {
                throw new Error(label + ": count " + count + " exceeds remaining packet bytes");
            }
            return count;
        }
    }
}
