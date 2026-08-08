package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class CollapseExpandSectionButtonPreset extends WiredUIPreset
    {
        private var _region:IRegionWindow;
        private var _callback:Function;

        public function CollapseExpandSectionButtonPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Function, _arg_5:Boolean)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._callback = _arg_4;
            this._region = _arg_3.createExpandCollapseSectionRegion();
            this.upArrow.visible = _arg_5;
            this.downArrow.visible = !_arg_5;
            this._region.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
        }

        override public function get window():IWindow
        {
            return this._region;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
        }

        override public function hasStaticWidth():Boolean
        {
            return true;
        }

        override public function get staticWidth():int
        {
            return this._region.width;
        }

        public function get isExpanded():Boolean
        {
            return this.upArrow.visible;
        }

        private function onButtonClicked(_arg_1:WindowMouseEvent):void
        {
            var _local_2:Boolean = !this.isExpanded;
            this.upArrow.visible = _local_2;
            this.downArrow.visible = !_local_2;
            if (this._callback != null)
            {
                this._callback(_local_2);
            }
        }

        private function get upArrow():IStaticBitmapWrapperWindow
        {
            return this._region.findChildByName("up_arrow") as IStaticBitmapWrapperWindow;
        }

        private function get downArrow():IStaticBitmapWrapperWindow
        {
            return this._region.findChildByName("down_arrow") as IStaticBitmapWrapperWindow;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._region.dispose();
            this._region = null;
            this._callback = null;
        }
    }
}
