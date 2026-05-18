package com.sulake.core.assets.loaders
{
    import flash.display.Loader;
    import flash.system.LoaderContext;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.utils.ByteArray;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import com.sulake.core.utils.PlayerVersionCheck;
    import com.sulake.habbo.utils.images.PNGEncoder;
    import flash.events.TimerEvent;
    import flash.system.Security;
    import com.sulake.habbo.utils.HabboWebTools;

    public class BitmapFileLoader extends AssetLoaderEventBroker implements IAssetLoader 
    {
        private static const AIR_BITMAP_USER_AGENT:String = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0 Safari/537.36";
        private static const AIR_BITMAP_ACCEPT:String = "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8";
        private static const AIR_BITMAP_REFERER:String = "https://swf.nextgenhabbo.com/index.php";

        protected var _url:String;
        protected var _type:String;
        protected var _loader:Loader;
        protected var _loaderContext:LoaderContext;
        private var _cacheKey:String = null;
        private var _cacheRevision:int = -1;
        private var _fromCache:Boolean = false;
        private var _id:int = -1;
        private var _securityPollTimer:Timer;
        private var _storedCompleteEvent:Event;
        private var _securityPollCount:int = 0;
        private var _airBinaryFallbackLoader:URLLoader;
        private var _airBinaryFallbackAttempted:Boolean = false;
        private var _airBinaryFallbackLoading:Boolean = false;

        public function BitmapFileLoader(type:String, urlRequest:URLRequest=null, cacheKey:String=null, cacheRevision:int=-1, buffer:ByteArray=null, id:int=-1)
        {
            this._url = ((urlRequest == null) ? "" : urlRequest.url);
            this._type = type;
            this._loader = new Loader();
            this._loaderContext = new LoaderContext();
            this._loaderContext.checkPolicyFile = !HabboWebTools.isAirDesktop;
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.completeEventHandler);
            this._loader.contentLoaderInfo.addEventListener(Event.UNLOAD, this.loaderEventHandler);
            this._loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.loaderEventHandler);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.loaderEventHandler);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loaderEventHandler);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderEventHandler);
            this._cacheKey = cacheKey;
            this._cacheRevision = cacheRevision;
            this._id = id;
            if (((!(buffer == null)) && (buffer.length > 0)))
            {
                this._fromCache = true;
                this._loader.loadBytes(buffer);
            }
            else
            {
                if (((!(urlRequest == null)) && (!(urlRequest.url == null))))
                {
                    this.loadPreparedRequest(urlRequest, "START");
                }
            }
        }

        public function get url():String
        {
            return this._url;
        }

        public function get content():Object
        {
            return (this._loader) ? this._loader.content : null;
        }

        public function get bytes():ByteArray
        {
            var bitmap:Bitmap = (this.content as Bitmap);
            if (bitmap == null)
            {
                return null;
            }
            if (PlayerVersionCheck.isVersionAtLeast(11, 3))
            {
            }
            return PNGEncoder.encode(bitmap.bitmapData);
        }

        public function get mimeType():String
        {
            return this._type;
        }

        public function get bytesLoaded():uint
        {
            return (this._loader) ? this._loader.contentLoaderInfo.bytesLoaded : 0;
        }

        public function get bytesTotal():uint
        {
            return (this._loader) ? this._loader.contentLoaderInfo.bytesTotal : 0;
        }

        public function get loaderContext():LoaderContext
        {
            return this._loaderContext;
        }

        public function get cacheKey():String
        {
            return this._cacheKey;
        }

        public function get cacheRevision():int
        {
            return this._cacheRevision;
        }

        public function get fromCache():Boolean
        {
            return this._fromCache;
        }

        public function get id():int
        {
            return this._id;
        }

        public function load(urlRequest:URLRequest):void
        {
            this._url = urlRequest.url;
            _retries = 0;
            this._airBinaryFallbackAttempted = false;
            this.cleanupAirBinaryFallbackLoader();
            this.loadPreparedRequest(urlRequest, "RELOAD");
        }

        override protected function retry():Boolean
        {
            if (!_disposed)
            {
                if (++_retries <= _attempts)
                {
                    try
                    {
                        this._loader.close();
                        this._loader.unload();
                    }
					catch(e : Error)
					{
					};
                    var retryUrl:String = (((this._url + ((this._url.indexOf("?") == -1) ? "?" : "&")) + "retry=") + _retries);
                    this.loadPreparedRequest(new URLRequest(retryUrl), "RETRY_LOAD attempt=" + _retries);
                    return true;
                }
            }
            return false;
        }

        override public function dispose():void
        {
            if (!_disposed)
            {
                super.dispose();
                this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.completeEventHandler);
                this._loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, this.loaderEventHandler);
                this._loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.loaderEventHandler);
                this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.loaderEventHandler);
                this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.loaderEventHandler);
                this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderEventHandler);
                if (this._securityPollTimer)
                {
                    this._securityPollTimer.stop();
                    this._securityPollTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.securityPollTimerEvent);
                    this._securityPollTimer = null;
                }
                this.cleanupAirBinaryFallbackLoader();
                try
                {
                    this._loader.close();
                }
                catch(e : Error)
                {
                }
                this._loader.unload();
                this._loader = null;
                this._type = null;
                this._url = null;
            }
        }

        private function completeEventHandler(event:Event):void
        {
            if (HabboWebTools.isAirDesktop)
            {
                loadEventHandler(event);
                return;
            }
            if (this._url == this._loader.contentLoaderInfo.url)
            {
                loadEventHandler(event);
                return;
            }
            this._storedCompleteEvent = event;
            var pathIndex:int = this._loader.contentLoaderInfo.url.indexOf("//");
            var crossdomainXml:* = (this._loader.contentLoaderInfo.url.slice(0, (this._loader.contentLoaderInfo.url.indexOf("/", (pathIndex + 3)) + 1)) + "crossdomain.xml");
            Security.loadPolicyFile(crossdomainXml);
            this._securityPollCount = 0;
            this.startSecurityPolling();
        }

        private function securityPollTimerEvent(event:TimerEvent):void
        {
            this._securityPollCount++;
            if (this._loader.contentLoaderInfo.childAllowsParent)
            {
                loadEventHandler(this._storedCompleteEvent);
            }
            else
            {
                this.startSecurityPolling();
            }
        }

        private function startSecurityPolling():void
        {
            this._securityPollTimer = new Timer(250, 1);
            this._securityPollTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.securityPollTimerEvent);
            this._securityPollTimer.start();
        }

        private function loaderEventHandler(event:Event):void
        {
            if (event.type == HTTPStatusEvent.HTTP_STATUS)
            {
            }
            else if (event.type == IOErrorEvent.IO_ERROR)
            {
                if (this.shouldUseAirBinaryFallback(event))
                {
                    this.startAirBinaryFallback();
                    return;
                }
            }
            else if (event.type == SecurityErrorEvent.SECURITY_ERROR)
            {
            }
            else if (event.type == Event.UNLOAD)
            {
            }
            loadEventHandler(event);
        }

        private function loadPreparedRequest(urlRequest:URLRequest, label:String):void
        {
            var preparedRequest:URLRequest = this.prepareAirBitmapRequest(urlRequest);
            var requestMode:String = (preparedRequest == urlRequest) ? "default" : "browser_headers";
            this.startLoaderLoad(preparedRequest, urlRequest, label, requestMode);
        }

        private function startLoaderLoad(preparedRequest:URLRequest, originalRequest:URLRequest, label:String, requestMode:String):void
        {
            try
            {
                this._loader.load(preparedRequest, this._loaderContext);
            }
            catch (error:Error)
            {
                if (preparedRequest != originalRequest)
                {
                    try
                    {
                        this._loader.load(originalRequest, this._loaderContext);
                        return;
                    }
                    catch (fallbackError:Error)
                    {
                    }
                }
                loadEventHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
            }
        }

        private function prepareAirBitmapRequest(urlRequest:URLRequest):URLRequest
        {
            var preparedRequest:URLRequest;
            var headers:Array;
            var existingHeader:URLRequestHeader;
            if (urlRequest == null || !this.isAirRemoteBitmapUrl(urlRequest.url))
            {
                return urlRequest;
            }
            preparedRequest = new URLRequest(urlRequest.url);
            preparedRequest.data = urlRequest.data;
            preparedRequest.method = urlRequest.method;
            preparedRequest.contentType = urlRequest.contentType;
            headers = [];
            if (urlRequest.requestHeaders != null)
            {
                for each (existingHeader in urlRequest.requestHeaders)
                {
                    if (!this.isManagedAirBitmapHeader(existingHeader.name))
                    {
                        headers.push(existingHeader);
                    }
                }
            }
            headers.push(new URLRequestHeader("User-Agent", AIR_BITMAP_USER_AGENT));
            headers.push(new URLRequestHeader("Accept", AIR_BITMAP_ACCEPT));
            headers.push(new URLRequestHeader("Referer", AIR_BITMAP_REFERER));
            preparedRequest.requestHeaders = headers;
            return preparedRequest;
        }

        private function isManagedAirBitmapHeader(name:String):Boolean
        {
            var lowerName:String;
            if (name == null)
            {
                return false;
            }
            lowerName = name.toLowerCase();
            return lowerName == "user-agent" || lowerName == "accept" || lowerName == "referer";
        }

        private function isAirRemoteBitmapUrl(url:String=null):Boolean
        {
            var lowerUrl:String;
            var value:String = (url == null) ? this._url : url;
            if (!HabboWebTools.isAirDesktop || value == null)
            {
                return false;
            }
            lowerUrl = value.toLowerCase();
            return ((lowerUrl.indexOf("http://") == 0) || (lowerUrl.indexOf("https://") == 0)) && (((lowerUrl.indexOf(".png") >= 0) || (lowerUrl.indexOf(".gif") >= 0)) || ((lowerUrl.indexOf(".jpg") >= 0) || (lowerUrl.indexOf(".jpeg") >= 0)));
        }

        private function shouldUseAirBinaryFallback(event:Event):Boolean
        {
            return event.type == IOErrorEvent.IO_ERROR && this._status == 403 && this.isAirRemoteBitmapUrl() && !this._airBinaryFallbackAttempted && !this._airBinaryFallbackLoading;
        }

        private function startAirBinaryFallback():void
        {
            var request:URLRequest = this.prepareAirBitmapRequest(new URLRequest(this._url));
            this._airBinaryFallbackAttempted = true;
            this._airBinaryFallbackLoading = true;
            this._airBinaryFallbackLoader = new URLLoader();
            this._airBinaryFallbackLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this._airBinaryFallbackLoader.addEventListener(Event.COMPLETE, this.airBinaryFallbackCompleteHandler);
            this._airBinaryFallbackLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.airBinaryFallbackStatusHandler);
            this._airBinaryFallbackLoader.addEventListener(IOErrorEvent.IO_ERROR, this.airBinaryFallbackErrorHandler);
            this._airBinaryFallbackLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.airBinaryFallbackErrorHandler);
            try
            {
                this._airBinaryFallbackLoader.load(request);
            }
            catch (error:Error)
            {
                this.cleanupAirBinaryFallbackLoader(false);
                loadEventHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
            }
        }

        private function airBinaryFallbackStatusHandler(event:HTTPStatusEvent):void
        {
            this._status = event.status;
            loadEventHandler(event);
        }

        private function airBinaryFallbackCompleteHandler(event:Event):void
        {
            var bytes:ByteArray = this._airBinaryFallbackLoader.data as ByteArray;
            this.cleanupAirBinaryFallbackLoader(false);
            if (bytes != null && bytes.length > 0)
            {
                try
                {
                    bytes.position = 0;
                    this._loader.loadBytes(bytes, this._loaderContext);
                    return;
                }
                catch (error:Error)
                {
                }
            }
            loadEventHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "AIR binary bitmap fallback produced no usable bytes"));
        }

        private function airBinaryFallbackErrorHandler(event:Event):void
        {
            this.cleanupAirBinaryFallbackLoader(false);
            loadEventHandler(event);
        }

        private function cleanupAirBinaryFallbackLoader(closeLoader:Boolean=true):void
        {
            if (this._airBinaryFallbackLoader == null)
            {
                this._airBinaryFallbackLoading = false;
                return;
            }
            this._airBinaryFallbackLoader.removeEventListener(Event.COMPLETE, this.airBinaryFallbackCompleteHandler);
            this._airBinaryFallbackLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.airBinaryFallbackStatusHandler);
            this._airBinaryFallbackLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.airBinaryFallbackErrorHandler);
            this._airBinaryFallbackLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.airBinaryFallbackErrorHandler);
            if (closeLoader)
            {
                try
                {
                    this._airBinaryFallbackLoader.close();
                }
                catch (error:Error)
                {
                }
            }
            this._airBinaryFallbackLoader = null;
            this._airBinaryFallbackLoading = false;
        }
    }
}
