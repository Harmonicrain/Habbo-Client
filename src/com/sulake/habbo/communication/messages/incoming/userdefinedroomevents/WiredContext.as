package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents
{
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /**
     * Wired 2.0 variable-context block. Phase 1 STUB: the server is required to send
     * a block count of 0 until Phase 6 implements the full per-block readers. Any
     * non-zero count is a hard error (fail-fast) rather than a silent desync, since
     * there is no safe way to skip an unknown block payload.
     */
    public class WiredContext
    {
        public function WiredContext(k:IMessageDataWrapper)
        {
            super();
            var blockCount:int = k.readInteger();
            if (blockCount != 0)
            {
                throw new Error("WiredContext: non-zero block count (" + blockCount + ") requires Phase 6 readers");
            }
        }
    }
}
