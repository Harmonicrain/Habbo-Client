package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    public class AssetButtonParam
    {
        private var _assetName:String;
        private var _tooltip:String;
        private var _onClick:Function;
        private var _isFollowedBySplitter:Boolean;
        private var _alignRight:Boolean;

        public function AssetButtonParam(_arg_1:String, _arg_2:String, _arg_3:Function, _arg_4:Boolean = false, _arg_5:Boolean = false)
        {
            super();
            this._assetName = _arg_1;
            this._tooltip = _arg_2;
            this._onClick = _arg_3;
            this._isFollowedBySplitter = _arg_4;
            this._alignRight = _arg_5;
        }

        public function get assetName():String { return this._assetName; }
        public function get tooltip():String { return this._tooltip; }
        public function get onClick():Function { return this._onClick; }
        public function get isFollowedBySplitter():Boolean { return this._isFollowedBySplitter; }
        public function get alignRight():Boolean { return this._alignRight; }
    }
}
