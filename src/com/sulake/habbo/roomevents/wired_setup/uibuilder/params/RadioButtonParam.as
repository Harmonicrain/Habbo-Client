package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

    public class RadioButtonParam
    {
        private var _id:int;
        private var _text:String;
        private var _iconAssetName:String;
        private var _extra1:WiredUIPreset;
        private var _extra2:WiredUIPreset;
        private var _newLine:Boolean;

        public function RadioButtonParam(_arg_1:int, _arg_2:String, _arg_3:WiredUIPreset = null, _arg_4:WiredUIPreset = null, _arg_5:Boolean = false)
        {
            super();
            this._id = _arg_1;
            this._text = _arg_2;
            this._extra1 = _arg_3;
            this._extra2 = _arg_4;
            this._newLine = _arg_5;
        }

        public function get id():int { return this._id; }
        public function get text():String { return this._text; }
        public function get iconAssetName():String { return this._iconAssetName; }
        public function set iconAssetName(_arg_1:String):void { this._iconAssetName = _arg_1; }
        public function get extra1():WiredUIPreset { return this._extra1; }
        public function set extra1(_arg_1:WiredUIPreset):void { this._extra1 = _arg_1; }
        public function get extra2():WiredUIPreset { return this._extra2; }
        public function set extra2(_arg_1:WiredUIPreset):void { this._extra2 = _arg_1; }
        public function get newLine():Boolean { return this._newLine; }
        public function set newLine(_arg_1:Boolean):void { this._newLine = _arg_1; }
    }
}
