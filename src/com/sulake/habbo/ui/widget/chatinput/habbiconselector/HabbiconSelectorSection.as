package com.sulake.habbo.ui.widget.chatinput.habbiconselector
{
    public class HabbiconSelectorSection
    {
        public var type:String;
        public var key:String;
        public var title:String;
        public var entries:Array;

        public function HabbiconSelectorSection(type:String, key:String, title:String, entries:Array)
        {
            this.type = type;
            this.key = key;
            this.title = title;
            this.entries = entries;
        }
    }
}
