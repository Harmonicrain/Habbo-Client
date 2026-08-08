package com.sulake.habbo.roomevents.wired_trading
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.UbuntuWiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July uses a dedicated Ubuntu style for Wired trading surfaces. */
    public class UbuntuPresetManager extends PresetManager
    {
        private var _style:WiredStyle;
        public function UbuntuPresetManager(roomEvents:HabboUserDefinedRoomEvents)
        {
            super(roomEvents);
            this._style = new UbuntuWiredStyle(roomEvents);
        }
        override public function get wiredStyle():WiredStyle { return this._style; }
    }
}
