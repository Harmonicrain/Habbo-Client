package com.sulake.habbo.roomevents.events
{
    import flash.events.Event;

    public class WiredUserClickHandledEvent extends Event
    {
        public static const WIRED_USER_CLICK_HANDLED:String = "WIRED_USER_CLICK_HANDLED";

        private var _index:int;
        private var _openMenu:Boolean;

        public function WiredUserClickHandledEvent(type:String, index:int, openMenu:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this._index = index;
            this._openMenu = openMenu;
        }

        public function get index():int
        {
            return this._index;
        }

        public function get openMenu():Boolean
        {
            return this._openMenu;
        }
    }
}
