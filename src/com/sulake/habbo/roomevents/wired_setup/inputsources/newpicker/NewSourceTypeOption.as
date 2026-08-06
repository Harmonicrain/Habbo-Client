package com.sulake.habbo.roomevents.wired_setup.inputsources.newpicker
{
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.enum.WindowState;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    public class NewSourceTypeOption
    {
        private var _picker:NewSourceTypePicker;
        private var _container:IContainerButtonWindow;
        private var _option:int;
        private var _active:Boolean = false;
        private var _hovered:Boolean = false;

        public function NewSourceTypeOption(k:NewSourceTypePicker, _arg_2:IContainerButtonWindow, _arg_3:int)
        {
            super();
            this._picker = k;
            this._container = _arg_2;
            this._option = _arg_3;
            this._container.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onOut);
            this._container.addEventListener(WindowMouseEvent.OUT, this.maybeCancelEvent);
            this._container.addEventListener(WindowMouseEvent.UP, this.maybeCancelEvent);
            var roomEvents:HabboUserDefinedRoomEvents = k.roomEvents;
            var sourceName:String = WiredInputSourcePicker.getTypeNameForSource(_arg_3);
            this._container.toolTipCaption = roomEvents.localization.getLocalization("wiredfurni.params.sourcetype." + sourceName, sourceName);
            this.typeImage.assetUri = "wired_styles_illumina_icon_source_" + sourceName;
            this.typeImage.y = (this._container.height + 1) / 2 - (this.typeImage.height + 1) / 2;
            this.updateVisuals();
        }

        public function activate():void
        {
            this._active = true;
            this.updateVisuals();
        }

        public function deactivate():void
        {
            this._active = false;
            this.updateVisuals();
        }

        private function updateVisuals():void
        {
            this._container.setStateFlag(WindowState.SELECTED, this._active);
            this._container.setStateFlag(WindowState.HOVERING, this._hovered);
            if (!this._active && !this._hovered)
            {
                this._container.color = 0xFFFFFF;
                this._picker.updateColorings();
                return;
            }
            var color:uint = 0x1D84CD;
            if (this._option == WiredInputSourcePicker.USER_SOURCE)
            {
                color = 0x268E29;
            }
            else if (this._option == WiredInputSourcePicker.FURNI_SOURCE)
            {
                color = 0xBA9D16;
            }
            else if (this._option == VariableExtraSourceTypes.CONTEXT_SOURCE)
            {
                color = 0xB05B1E;
            }
            this._container.color = lightenColor(color, this._hovered && !this._active ? 1.55 : 1.26);
            this._picker.updateColorings();
        }

        private static function lightenColor(k:uint, _arg_2:Number):uint
        {
            var r:int = Math.min(255, int(((k >> 16) & 0xFF) * _arg_2));
            var g:int = Math.min(255, int(((k >> 8) & 0xFF) * _arg_2));
            var b:int = Math.min(255, int((k & 0xFF) * _arg_2));
            return (r << 16) | (g << 8) | b;
        }

        private function onOut(k:WindowMouseEvent):void
        {
            if (!this._container.isEnabled())
            {
                return;
            }
            this._hovered = false;
            this.updateVisuals();
        }

        private function onOver(k:WindowMouseEvent):void
        {
            if (!this._container.isEnabled())
            {
                return;
            }
            this._hovered = true;
            this.updateVisuals();
        }

        private function maybeCancelEvent(k:WindowMouseEvent):void
        {
            if (k.type == WindowMouseEvent.OUT && this._active)
            {
                k.preventWindowOperation();
            }
            if (k.type == WindowMouseEvent.UP)
            {
                this.onClick(null);
                k.preventWindowOperation();
            }
        }

        private function onClick(k:WindowMouseEvent):void
        {
            this._picker.onClick(this);
        }

        public function get option():int { return this._option; }
        public function get container():IContainerButtonWindow { return this._container; }
        public function get active():Boolean { return this._active; }
        public function get hovered():Boolean { return this._hovered; }
        public function get color():uint { return this._container.color; }

        private function get typeImage():IStaticBitmapWrapperWindow
        {
            return this._container.findChildByName("type_image") as IStaticBitmapWrapperWindow;
        }

        public function dispose():void
        {
            if (this._container != null)
            {
                this._container.dispose();
                this._container = null;
            }
            this._picker = null;
        }
    }
}
