package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.utils.LibraryLoader;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLRequest;

    public class GamehallAssetLibrary extends EventDispatcher
    {
        public static const READY:String = "GAMEHALL_ASSETS_READY";
        public static const ERROR:String = "GAMEHALL_ASSETS_ERROR";

        private var _libraryLoader:LibraryLoader;
        private var _assets:AssetLibrary;
        private var _error:Boolean = false;

        public function get isReady():Boolean
        {
            return this._assets != null && this._assets.isReady;
        }

        public function get hasError():Boolean
        {
            return this._error;
        }

        public function load(baseUrl:String):void
        {
            if (this._assets != null)
            {
                return;
            }
            if (baseUrl == null || baseUrl == "")
            {
                this._error = true;
                dispatchEvent(new Event(ERROR));
                return;
            }
            if (baseUrl.charAt(baseUrl.length - 1) != "/")
            {
                baseUrl += "/";
            }
            this._libraryLoader = new LibraryLoader();
            this._assets = new AssetLibrary("gamehall_games");
            this._assets.addEventListener(AssetLibrary.ASSET_LIBRARY_READY, this.onReady);
            this._assets.addEventListener(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR, this.onError);
            this._assets.loadFromFile(this._libraryLoader, true);
            this._libraryLoader.load(new URLRequest(baseUrl + "hh_games.swf"));
        }

        public function assetDisplay(name:String):DisplayObject
        {
            if (!this.isReady)
            {
                return null;
            }
            var asset:IAsset = this._assets.getAssetByName(name);
            if (asset == null)
            {
                return null;
            }
            var content:Object = asset.content;
            if (content is BitmapData)
            {
                return new Bitmap(content as BitmapData);
            }
            if (content is Class)
            {
                var instance:Object = new (content as Class)();
                if (instance is BitmapData)
                {
                    return new Bitmap(instance as BitmapData);
                }
                return instance as DisplayObject;
            }
            return content as DisplayObject;
        }

        public function hasAsset(name:String):Boolean
        {
            return this.isReady && this._assets.getAssetByName(name) != null;
        }

        public function dispose():void
        {
            if (this._assets != null)
            {
                this._assets.removeEventListener(AssetLibrary.ASSET_LIBRARY_READY, this.onReady);
                this._assets.removeEventListener(AssetLibrary.ASSET_LIBRARY_LOAD_ERROR, this.onError);
                this._assets.dispose();
                this._assets = null;
            }
            if (this._libraryLoader != null)
            {
                if (!this._libraryLoader.disposed)
                {
                    this._libraryLoader.dispose();
                }
                this._libraryLoader = null;
            }
        }

        private function onReady(event:Event):void
        {
            this._error = false;
            dispatchEvent(new Event(READY));
        }

        private function onError(event:Event):void
        {
            this._error = true;
            dispatchEvent(new Event(ERROR));
        }
    }
}
