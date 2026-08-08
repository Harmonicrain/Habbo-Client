package com.sulake.habbo.ui.widget.chatinput.habbiconselector
{
    public class HabbiconSelectorEntry
    {
        public var habbiconId:int;
        public var name:String;
        public var searchName:String;
        public var color:uint;
        public var favorite:Boolean;

        public function HabbiconSelectorEntry(habbiconId:int, name:String, color:uint, favorite:Boolean)
        {
            this.habbiconId = habbiconId;
            this.name = name;
            this.searchName = name != null ? name.toLowerCase() : "";
            this.color = color;
            this.favorite = favorite;
        }
    }
}
