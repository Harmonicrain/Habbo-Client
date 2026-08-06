package com.sulake.habbo.roomevents.events
{
    import flash.events.Event;
    import __AS3__.vec.Vector;

    public class WiredAchievementsUpdatedEvent extends Event
    {
        public static const WIRED_ACHIEVEMENTS_UPDATED:String = "WIRED_ACHIEVEMENTS_UPDATED";

        private var _achievements:Vector.<String>;

        public function WiredAchievementsUpdatedEvent(type:String, achievements:Vector.<String>,
                                                       bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this._achievements = achievements != null
                ? achievements.concat()
                : new Vector.<String>();
        }

        public function get achievements():Vector.<String>
        {
            return this._achievements.concat();
        }

        override public function clone():Event
        {
            return new WiredAchievementsUpdatedEvent(
                type, this._achievements, bubbles, cancelable);
        }
    }
}
