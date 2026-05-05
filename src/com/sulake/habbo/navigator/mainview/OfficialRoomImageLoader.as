package com.sulake.habbo.navigator.mainview
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import flash.display.BitmapData;
    import flash.geom.Matrix;

    public class OfficialRoomImageLoader implements IDisposable 
    {
        private var _navigator:IHabboTransitionalNavigator;
        private var _picRef:String;
        private var _url:String;
        private var _mimeType:String;
        private var _renderWidth:int;
        private var _renderHeight:int;
        private var _bitmapWrapper:IBitmapWrapperWindow;
        private var _disposed:Boolean;

        public function OfficialRoomImageLoader(k:IHabboTransitionalNavigator, _arg_2:String, _arg_3:IBitmapWrapperWindow, _arg_4:String=null, _arg_5:String="image/gif", _arg_6:int=-1, _arg_7:int=-1)
        {
            var _local_8:String;
            this._navigator = k;
            this._picRef = _arg_2;
            this._bitmapWrapper = _arg_3;
            this._renderWidth = _arg_6;
            this._renderHeight = _arg_7;
            var _local_6:String = this._navigator.getProperty("image.library.url");
            if ((_arg_4 != null) && (!(_arg_4 == "")))
            {
                this._url = _arg_4;
            }
            else
            {
                if (((this._picRef.indexOf("http://") == 0) || (this._picRef.indexOf("https://") == 0)))
                {
                    this._url = this._picRef;
                }
                else
                {
                    _local_8 = this._picRef;
                    if (_local_8.indexOf("c_images/") == 0)
                    {
                        _local_8 = _local_8.substr("c_images/".length);
                    }
                    this._url = (_local_6 + _local_8);
                }
            }
            this._mimeType = this._Str_25240(this._url, _arg_5);
            Logger.log(("[OFFICIAL ROOM ICON IMAGE DOWNLOADER] : " + this._url));
        }

        private function _Str_25240(k:String, _arg_2:String):String
        {
            var _local_3:String = k.toLowerCase();
            if (_local_3.indexOf(".png") == (_local_3.length - 4))
            {
                return "image/png";
            }
            if (((_local_3.indexOf(".jpg") == (_local_3.length - 4)) || (_local_3.indexOf(".jpeg") == (_local_3.length - 5))))
            {
                return "image/jpeg";
            }
            return _arg_2;
        }

        public function _Str_24517():void
        {
            var _local_1:URLRequest;
            var _local_2:AssetLoaderStruct;
            if (this._navigator.assets.hasAsset(this._picRef))
            {
                this.setImage();
            }
            else
            {
                _local_1 = new URLRequest(this._url);
                _local_2 = this._navigator.assets.loadAssetFromFile(this._picRef, _local_1, this._mimeType);
                _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_25041);
                _local_2.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTERROR, this._Str_24273);
            }
        }

        private function _Str_25041(k:AssetLoaderEvent):void
        {
            if (this._disposed)
            {
                return;
            }
            var _local_2:AssetLoaderStruct = (k.target as AssetLoaderStruct);
            if (_local_2 == null)
            {
                Logger.log((("Loading pic from url: " + this._url) + " failed. loaderStruct == null"));
                return;
            }
            this.setImage();
        }

        private function setImage():void
        {
            var k:BitmapData;
            var _local_2:BitmapData;
            var _local_3:Number;
            var _local_4:Matrix;
            if (((((this._navigator) && (!(this._navigator.disposed))) && (this._bitmapWrapper)) && (!(this._bitmapWrapper.disposed))))
            {
                k = this._navigator.getButtonImage(this._picRef, "");
                if (k)
                {
                    if (((this._renderWidth > 0) && (this._renderHeight > 0)))
                    {
                        _local_2 = new BitmapData(this._renderWidth, this._renderHeight, false, 0xFFFFFFFF);
                        _local_3 = Math.min((this._renderWidth / k.width), (this._renderHeight / k.height));
                        _local_4 = new Matrix();
                        _local_4.scale(_local_3, _local_3);
                        _local_4.translate(((this._renderWidth - (k.width * _local_3)) / 2), ((this._renderHeight - (k.height * _local_3)) / 2));
                        _local_2.draw(k, _local_4, null, null, null, true);
                        this._bitmapWrapper.disposesBitmap = true;
                        this._bitmapWrapper.bitmap = _local_2;
                        this._bitmapWrapper.width = this._renderWidth;
                        this._bitmapWrapper.height = this._renderHeight;
                    }
                    else
                    {
                        this._bitmapWrapper.disposesBitmap = false;
                        this._bitmapWrapper.bitmap = k;
                        this._bitmapWrapper.width = k.width;
                        this._bitmapWrapper.height = k.height;
                    }
                    this._bitmapWrapper.visible = true;
                }
                else
                {
                    Logger.log(("OfficialRoomImageLoader - Image not found: " + this._picRef));
                }
            }
            this.dispose();
        }

        private function _Str_24273(k:AssetLoaderEvent):void
        {
            Logger.log(((("Error loading image: " + this._url) + ", ") + k));
            this.dispose();
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._bitmapWrapper = null;
            this._navigator = null;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }
    }
}
