package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;

    public class SectionParam
    {
        public static var EXPAND_MODE_EXPANDED:int = 0;
        public static var EXPAND_MODE_COLLAPSED:int = 1;
        public static var EXPAND_MODE_HIDDEN:int = 2;

        public static var DEFAULT:SectionParam = new SectionParam(null, 0);
        public static var COLLAPSED:SectionParam = new SectionParam(null, 1);
        public static var HIDDEN:SectionParam = new SectionParam(null, 2);

        private var _miscHeaderOptions:Array = [];
        private var _expandMode:int;
        private var _sourceTypeSelectorParam:SourceTypeSelectorParam;
        private var _headerOptionLeft:WiredUIPreset;
        private var _titleYOffset:int;

        public function SectionParam(_arg_1:SourceTypeSelectorParam = null, _arg_2:int = 0, _arg_3:WiredUIPreset = null, _arg_4:int = 0)
        {
            super();
            this._expandMode = _arg_2;
            this._sourceTypeSelectorParam = _arg_1;
            this._headerOptionLeft = _arg_3;
            this._titleYOffset = _arg_4;
        }

        public function get expandMode():int { return this._expandMode; }
        public function set expandMode(_arg_1:int):void { this._expandMode = _arg_1; }
        public function get sourceTypeSelectorParam():SourceTypeSelectorParam { return this._sourceTypeSelectorParam; }
        public function set sourceTypeSelectorParam(_arg_1:SourceTypeSelectorParam):void { this._sourceTypeSelectorParam = _arg_1; }
        public function addHeaderOption(_arg_1:WiredUIPreset):void { this._miscHeaderOptions.push(_arg_1); }
        public function get miscHeaderOptions():Array { return this._miscHeaderOptions; }
        public function get headerOptionLeft():WiredUIPreset { return this._headerOptionLeft; }
        public function set headerOptionLeft(_arg_1:WiredUIPreset):void { this._headerOptionLeft = _arg_1; }
        public function get titleYOffset():int { return this._titleYOffset; }
        public function set titleYOffset(_arg_1:int):void { this._titleYOffset = _arg_1; }
    }
}
