package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class StaticBitmapAssetWrapperPreset extends WiredUIPreset
    {
        private var _container:IStaticBitmapWrapperWindow;

        public function StaticBitmapAssetWrapperPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("static_bitmap_view") as IStaticBitmapWrapperWindow;
            this._container.assetUri = _arg_4;
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        public function get assetUri():String
        {
            return this._container.assetUri;
        }

        public function set assetUri(_arg_1:String):void
        {
            this._container.assetUri = _arg_1;
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
            return this._container.width;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
        }
    }
}
