package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.newvariablepicker.tabbuttons
{
    public class TabButtonConfig
    {
        private var _tabId:int;
        private var _assetUri:String;
        private var _tooltipCaption:String;
        private var _filteredVariables:Function;

        public function TabButtonConfig(tabId:int, assetUri:String, tooltipCaption:String, filteredVariables:Function)
        {
            this._tabId = tabId;
            this._assetUri = assetUri;
            this._tooltipCaption = tooltipCaption;
            this._filteredVariables = filteredVariables;
        }

        public function get tabId():int { return this._tabId; }
        public function get assetUri():String { return this._assetUri; }
        public function get tooltipCaption():String { return this._tooltipCaption; }
        public function get filteredVariables():Function { return this._filteredVariables; }
    }
}
