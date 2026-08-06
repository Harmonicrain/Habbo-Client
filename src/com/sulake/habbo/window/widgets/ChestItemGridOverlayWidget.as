package com.sulake.habbo.window.widgets
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.habbo.window.utils.ChestItemOverlayNumberBitmapGenerator;

    /** July chest contents-count plaque used by inventory thumbnails. */
    public class ChestItemGridOverlayWidget
        implements IChestItemGridOverlayWidget
    {
        public static const TYPE:String = "chest_overlay_grid";
        public static const COLOR_SILVER:String = "silver";
        public static const COLOR_GOLD:String = "gold";
        public static const COLOR_BROWN:String = "brown";

        private var _disposed:Boolean;
        private var _widgetWindow:IWidgetWindow;
        private var _windowManager:HabboWindowManagerComponent;
        private var _root:IWindowContainer;
        private var _contentsCount:int;
        private var _color:String;

        public function ChestItemGridOverlayWidget(window:IWidgetWindow,
            windowManager:HabboWindowManagerComponent)
        {
            this._widgetWindow = window;
            this._windowManager = windowManager;
            this._root = IWindowContainer(windowManager.buildFromXML(
                XML(windowManager.assets.getAssetByName(
                    "chest_overlay_griditem_xml").content)));
            this._widgetWindow.rootWindow = this._root;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            if (this._widgetWindow != null)
            {
                this._widgetWindow.rootWindow = null;
                this._widgetWindow = null;
            }
            if (this._root != null)
            {
                this._root.dispose();
                this._root = null;
            }
            this._windowManager = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function get properties():Array
        {
            return [];
        }

        public function set properties(value:Array):void
        {
        }

        public function get iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        public function set contentsCount(value:int):void
        {
            this._contentsCount = value;
            var number:IBitmapWrapperWindow = IBitmapWrapperWindow(
                this._root.findChildByName(
                    "chest_plaque_number_bitmap"));
            number.bitmap = ChestItemOverlayNumberBitmapGenerator.createBitmap(
                this._windowManager.assets, value, number.width, number.height);
        }

        public function get contentsCount():int
        {
            return this._contentsCount;
        }

        public function set color(value:String):void
        {
            this._color = value;
            IStaticBitmapWrapperWindow(this._root.findChildByName(
                "chest_plaque_bitmap")).assetUri =
                "chest_overlay_" + value + "_plaque";
        }

        public function get color():String
        {
            return this._color;
        }
    }
}
