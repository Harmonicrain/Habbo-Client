package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.components.InteractiveController;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class PressedButtonMiniAssetIconButtonPreset extends MiniAssetIconButtonPreset
    {
        public function PressedButtonMiniAssetIconButtonPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:String, _arg_6:Function)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this.clickArea.addEventListener(WindowMouseEvent.OUT, this.maybeCancelEvent);
            this.clickArea.addEventListener(WindowMouseEvent.UP, this.maybeCancelEvent);
            this.updateUI();
        }

        private function maybeCancelEvent(_arg_1:WindowMouseEvent):void
        {
            if ((_arg_1.type == WindowMouseEvent.OUT) && this._selected)
            {
                _arg_1.preventWindowOperation();
            }
            if (_arg_1.type == WindowMouseEvent.UP)
            {
                this.iconClicked(null);
                _arg_1.preventWindowOperation();
            }
        }

        override protected function updateUI():void
        {
            var controller:InteractiveController = InteractiveController(this.clickArea);
            controller.setStateFlag(16, this._selected);
            controller.setStateFlag(4, this._hovered);
            if (!this._hovered && !this._selected)
            {
                this.clickArea.color = 0xFFFFFF;
                return;
            }
            this.clickArea.color = lightenColor(this.selectedColor, (this._hovered && !this._selected) ? 1.6 : 1.38);
        }

        private static function lightenColor(_arg_1:uint, _arg_2:Number):uint
        {
            var r:uint = Math.min(255, ((_arg_1 >> 16) & 0xFF) * _arg_2);
            var g:uint = Math.min(255, ((_arg_1 >> 8) & 0xFF) * _arg_2);
            var b:uint = Math.min(255, (_arg_1 & 0xFF) * _arg_2);
            return (r << 16) | (g << 8) | b;
        }
    }
}
