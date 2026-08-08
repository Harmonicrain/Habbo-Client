package com.sulake.habbo.session
{
    import com.sulake.core.assets.AssetLibrary;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.session.events.FurniIconImageReadyEvent;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.IEventDispatcher;
    import flash.net.URLRequest;

    public class FurniIconImageManager
    {
        private static const ASSET_PREFIX:String = "furni_icon_";
        private static const LOADING_ICON_PLACEHOLDER:String = "loading_icon";

        private var _assets:IAssetLibrary;
        private var _events:IEventDispatcher;
        private var _configuration:IHabboConfigurationManager;
        private var _sessionDataManager:ISessionDataManager;
        private var _loadingInfo:Map;
        private var _ownsAssets:Boolean;
        private var _disposed:Boolean;

        public function FurniIconImageManager(assets:IAssetLibrary, events:IEventDispatcher, configuration:IHabboConfigurationManager, sessionDataManager:ISessionDataManager)
        {
            if (assets == null)
            {
                assets = new AssetLibrary("furni_icon_images");
                this._ownsAssets = true;
            }
            this._loadingInfo = new Map();
            this._assets = assets;
            this._events = events;
            this._configuration = configuration;
            this._sessionDataManager = sessionDataManager;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;

            if (this._loadingInfo != null)
            {
                for each (var entry:Array in this._loadingInfo.getValues())
                {
                    this.detachLoader(entry == null ? null : entry[3] as AssetLoaderStruct, true);
                }
                this._loadingInfo.dispose();
                this._loadingInfo = null;
            }
            if (this._ownsAssets && this._assets != null)
            {
                this._assets.dispose();
            }
            this._assets = null;
            this._events = null;
            this._configuration = null;
            this._sessionDataManager = null;
        }

        private function getData(wallItem:Boolean, typeId:int):IFurnitureData
        {
            if (this._sessionDataManager == null)
            {
                return null;
            }
            return wallItem ? this._sessionDataManager.getWallItemData(typeId) : this._sessionDataManager.getFloorItemData(typeId);
        }

        private function getClassName(wallItem:Boolean, typeId:int, extra:String):String
        {
            var data:IFurnitureData = this.getData(wallItem, typeId);
            return data == null ? String(wallItem) + "_" + typeId + "_" + extra : data.className + extra;
        }

        private function getAssetName(wallItem:Boolean, typeId:int, extra:String):String
        {
            var assetName:String = ASSET_PREFIX + this.getClassName(wallItem, typeId, extra);
            var data:IFurnitureData = this.getData(wallItem, typeId);
            if (data != null && data.hasIndexedColor)
            {
                assetName += "_" + data.colourIndex;
            }
            return assetName;
        }

        public function getFurniIconImage(wallItem:Boolean, typeId:int, extra:String, usePlaceholder:Boolean=true):BitmapData
        {
            var image:BitmapData = this.getFurniIconImageInternal(wallItem, typeId, extra == null ? "" : extra);
            if (image == null && usePlaceholder)
            {
                image = this.getPlaceholder();
            }
            return image;
        }

        public function getFurniIconImageAssetName(wallItem:Boolean, typeId:int, extra:String):String
        {
            extra = extra == null ? "" : extra;
            var assetName:String = this.getAssetName(wallItem, typeId, extra);
            if (this._loadingInfo != null && this._loadingInfo.hasKey(assetName))
            {
                this.addLoadingRequest(assetName, wallItem, typeId, extra);
                return null;
            }
            if (this.getLoadedImage(assetName) != null)
            {
                return assetName;
            }
            this.removeInvalidAsset(assetName);
            return this.beginLoad(wallItem, typeId, extra, assetName) ? null : LOADING_ICON_PLACEHOLDER;
        }

        private function getFurniIconImageInternal(wallItem:Boolean, typeId:int, extra:String):BitmapData
        {
            if (this._disposed || this._assets == null)
            {
                return null;
            }

            var assetName:String = this.getAssetName(wallItem, typeId, extra);
            if (this._loadingInfo != null && this._loadingInfo.hasKey(assetName))
            {
                return null;
            }
            var content:BitmapData = this.getLoadedImage(assetName);
            if (content != null)
            {
                return content.clone();
            }
            this.removeInvalidAsset(assetName);
            this.beginLoad(wallItem, typeId, extra, assetName);
            return null;
        }

        private function getLoadedImage(assetName:String):BitmapData
        {
            if (this._assets == null || !this._assets.hasAsset(assetName))
            {
                return null;
            }
            var asset:BitmapDataAsset = this._assets.getAssetByName(assetName) as BitmapDataAsset;
            return asset == null ? null : asset.content as BitmapData;
        }

        private function removeInvalidAsset(assetName:String):void
        {
            if (this._assets == null || !this._assets.hasAsset(assetName) || this.getLoadedImage(assetName) != null)
            {
                return;
            }
            var asset:IAsset = this._assets.getAssetByName(assetName);
            if (asset != null)
            {
                this._assets.removeAsset(asset);
                asset.dispose();
            }
        }

        private function beginLoad(wallItem:Boolean, typeId:int, extra:String, assetName:String):Boolean
        {
            if (this._disposed || this._assets == null || this._configuration == null)
            {
                return false;
            }
            if (this._loadingInfo.hasKey(assetName))
            {
                this.addLoadingRequest(assetName, wallItem, typeId, extra);
                return true;
            }

            var data:IFurnitureData = this.getData(wallItem, typeId);
            if (data == null)
            {
                return false;
            }

            var urlBase:String = this._configuration.getProperty("flash.dynamic.download.url");
            var urlTemplate:String = this._configuration.getProperty("flash.dynamic.icon.download.name.template");
            if (urlBase == null || urlTemplate == null || urlTemplate.length == 0)
            {
                return false;
            }

            var className:String = this.getClassName(wallItem, typeId, extra);
            var url:String = urlBase + urlTemplate;
            url = url.replace("%revision%", String(data.revision));
            url = url.replace("%typeid%", className);
            url = url.replace("%param%", data.hasIndexedColor ? "_" + data.colourIndex : "");

            var loader:AssetLoaderStruct;
            try
            {
                loader = this._assets.loadAssetFromFile(assetName, new URLRequest(url), "image/png");
            }
            catch (error:Error)
            {
                return false;
            }
            if (loader == null)
            {
                return false;
            }

            this._loadingInfo.add(assetName, [wallItem, typeId, extra, loader, [[wallItem, typeId, extra]]]);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onFurniIconImageReady);
            loader.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onFurniIconImageError);
            return true;
        }

        private function addLoadingRequest(assetName:String, wallItem:Boolean, typeId:int, extra:String):void
        {
            if (this._loadingInfo == null)
            {
                return;
            }
            var entry:Array = this._loadingInfo.getValue(assetName) as Array;
            if (entry == null)
            {
                return;
            }
            var requests:Array = entry[4] as Array;
            if (requests == null)
            {
                requests = [[entry[0], entry[1], entry[2]]];
                entry[4] = requests;
            }
            for each (var request:Array in requests)
            {
                if (Boolean(request[0]) == wallItem && int(request[1]) == typeId && String(request[2]) == extra)
                {
                    return;
                }
            }
            requests.push([wallItem, typeId, extra]);
        }

        private function onFurniIconImageReady(event:AssetLoaderEvent):void
        {
            var loader:AssetLoaderStruct = event.target as AssetLoaderStruct;
            var entry:Array = this.takeLoadingEntry(loader);
            if (entry == null || this._disposed)
            {
                return;
            }

            var image:BitmapData;
            if (loader.assetLoader != null)
            {
                var bitmap:Bitmap = loader.assetLoader.content as Bitmap;
                if (bitmap != null)
                {
                    image = bitmap.bitmapData;
                }
                else
                {
                    image = loader.assetLoader.content as BitmapData;
                }
            }
            if (image == null)
            {
                this.removeInvalidAsset(loader.assetName);
                this.dispatchRequests(loader.assetName, entry, null, false);
                return;
            }
            this.dispatchRequests(loader.assetName, entry, image, true);
        }

        private function onFurniIconImageError(event:AssetLoaderEvent):void
        {
            var loader:AssetLoaderStruct = event.target as AssetLoaderStruct;
            var entry:Array = this.takeLoadingEntry(loader);
            if (entry != null && !this._disposed)
            {
                this.removeInvalidAsset(loader.assetName);
                this.dispatchRequests(loader.assetName, entry, null, false);
            }
        }

        private function takeLoadingEntry(loader:AssetLoaderStruct):Array
        {
            if (loader == null || this._loadingInfo == null)
            {
                return null;
            }
            var entry:Array = this._loadingInfo.remove(loader.assetName) as Array;
            this.detachLoader(loader, false);
            return entry;
        }

        private function detachLoader(loader:AssetLoaderStruct, disposeLoader:Boolean):void
        {
            if (loader == null)
            {
                return;
            }
            loader.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this.onFurniIconImageReady);
            loader.removeEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this.onFurniIconImageError);
            if (disposeLoader)
            {
                loader.dispose();
            }
        }

        private function dispatchRequests(assetName:String, entry:Array, image:BitmapData, success:Boolean):void
        {
            var requests:Array = entry[4] as Array;
            if (requests == null)
            {
                requests = [[entry[0], entry[1], entry[2]]];
            }
            for each (var request:Array in requests)
            {
                this.dispatchResult(assetName, request, success && image != null ? image.clone() : null, success);
            }
        }

        private function dispatchResult(assetName:String, request:Array, image:BitmapData, success:Boolean):void
        {
            try
            {
                if (this._events != null)
                {
                    this._events.dispatchEvent(new FurniIconImageReadyEvent(assetName, Boolean(request[0]), int(request[1]), String(request[2]), image, success));
                }
            }
            finally
            {
                if (image != null)
                {
                    image.dispose();
                }
            }
        }

        private function getPlaceholder():BitmapData
        {
            if (this._assets == null)
            {
                return null;
            }
            var asset:BitmapDataAsset = this._assets.getAssetByName("loading_icon") as BitmapDataAsset;
            var image:BitmapData = asset == null ? null : asset.content as BitmapData;
            return image == null ? null : image.clone();
        }
    }
}
