package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

    public class CheckboxOptionParam
    {
        private var _text:String;
        private var _id:int = -1;
        private var _iconAssetName:String;
        private var _extra1:WiredUIPreset;
        private var _extra2:WiredUIPreset;

        public function CheckboxOptionParam(_arg_1:String, _arg_2:int = -1, _arg_3:WiredUIPreset = null, _arg_4:WiredUIPreset = null)
        {
            super();
            this._text = _arg_1;
            this._id = _arg_2;
            this._extra1 = _arg_3;
            this._extra2 = _arg_4;
        }

        public function get text():String { return this._text; }
        public function get iconAssetName():String { return this._iconAssetName; }
        public function set iconAssetName(_arg_1:String):void { this._iconAssetName = _arg_1; }
        public function get extra1():WiredUIPreset { return this._extra1; }
        public function set extra1(_arg_1:WiredUIPreset):void { this._extra1 = _arg_1; }
        public function get extra2():WiredUIPreset { return this._extra2; }
        public function set extra2(_arg_1:WiredUIPreset):void { this._extra2 = _arg_1; }
        public function get id():int { return this._id; }
        public function set id(_arg_1:int):void { this._id = _arg_1; }
    }
}
