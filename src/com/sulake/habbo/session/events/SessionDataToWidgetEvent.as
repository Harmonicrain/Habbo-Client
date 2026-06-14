package com.sulake.habbo.session.events
{
    import flash.events.Event;

    public class SessionDataToWidgetEvent extends Event
    {
        public static const PURCHASABLE_STYLES_UPDATED:String = "SDTWE_PURCHASABLE_STYLES_UPDATED";

        public function SessionDataToWidgetEvent(k:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }
}
