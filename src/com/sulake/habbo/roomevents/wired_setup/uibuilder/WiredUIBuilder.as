package com.sulake.habbo.roomevents.wired_setup.uibuilder
{
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout.FramePreset;
    import flash.system.Capabilities;

    /**
     * Preset accumulator (May WiredUIBuilder). Collects top-level presets via
     * addElements and delegates the real layout to PresetManager.createFramePreset.
     */
    public class WiredUIBuilder
    {
        private var _presetManager:PresetManager;
        private var _onClose:Function;
        private var _holderKey:String;
        private var _code:int;
        private var _frame:FramePreset;
        protected var _elements:Array;
        private var _resizable:Boolean;
        private var _initialWidth:int;

        public function WiredUIBuilder(_arg_1:PresetManager, _arg_2:Function, _arg_3:String, _arg_4:int, _arg_5:Boolean = false)
        {
            super();
            this._presetManager = _arg_1;
            this._onClose = _arg_2;
            this._resizable = _arg_5;
            this._holderKey = _arg_3;
            this._code = _arg_4;
            this._elements = [];
        }

        public function addElements(... rest):void
        {
            for each (var _local_2:* in rest)
            {
                this._elements.push(_local_2);
            }
        }

        public function get frame():FramePreset
        {
            return this._frame;
        }

        public function build(_arg_1:Number = 1, _arg_2:Boolean = false):void
        {
            var _local_3:ListScrollParams;
            if (_arg_2)
            {
                _local_3 = new ListScrollParams(false, 0, (Capabilities.screenResolutionY / 1.8), true, true);
            }
            this._frame = this._presetManager.createFramePreset(this._elements, this._onClose, this._holderKey, this._code, this._resizable, true, _local_3);
            this._elements = null;
            this._initialWidth = this._frame.window.width;
            this._frame.resizeToWidth(this._initialWidth * _arg_1);
        }

        public function get initialWidth():int
        {
            return this._initialWidth;
        }
    }
}
