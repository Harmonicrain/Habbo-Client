package
{
    import com.sulake.habbo.utils.HabboWebTools;
    import flash.desktop.NativeApplication;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.BrowserInvokeEvent;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.InvokeEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Matrix;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    import images.HabboAir_LoginBackground;

    public class HabboAir extends MovieClip
    {
        private static const DEFAULT_BASE_URL:String = "https://swf.nextgenhabbo.com";
        private static const GORDON_PATH:String = "/gordon/PRODUCTION-201611291003-338511768/";
        private static const DEFAULT_HOST:String = "109.122.1.113";
        private static const DEFAULT_PORT:String = "3000,3001";
        private static const AIR_USER_AGENT:String = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0 Safari/537.36";

        private static var _instance:HabboAir;

        private var _startTime:int;
        private var _stageReady:Boolean = false;
        private var _argumentsReady:Boolean = false;
        private var _parameters:Dictionary;
        private var _loadingScreen:IHabboLoadingScreen;
        private var _main:HabboMain;
        private var _loginBackgroundData:BitmapData;
        private var _loginBackgroundLayer:Sprite;
        private var _loginBackgroundBitmap:Bitmap;
        private var _loginBackgroundVisible:Boolean = false;
        private var _configBaseUrl:String = DEFAULT_BASE_URL;
        private var _configGordonPath:String = GORDON_PATH;

        public function HabboAir()
        {
            super();
            _instance = this;
            HabboWebTools.showAirLoginBackgroundCallback = showLoginBackground;
            HabboWebTools.hideAirLoginBackgroundCallback = hideLoginBackground;
            HabboWebTools.renderAirLoginBackgroundCallback = renderLoginBackground;
            HabboWebTools.setAirLoadingScreenVisibleCallback = setLoadingScreenVisible;
            HabboWebTools.airDebugLogCallback = debugLog;
            _startTime = getTimer();
            _parameters = new Dictionary();
            stop();

            if (stage)
            {
                onAddedToStage();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }

            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
            NativeApplication.nativeApplication.addEventListener(BrowserInvokeEvent.BROWSER_INVOKE, onBrowserInvoke);
            NativeApplication.nativeApplication.addEventListener(Event.EXITING, onApplicationExiting);
        }

        public static function showLoginBackground():void
        {
            if (_instance != null)
            {
                _instance.showLoginBackgroundInternal();
            }
        }

        public static function hideLoginBackground():void
        {
            if (_instance != null)
            {
                _instance.hideLoginBackgroundInternal();
            }
        }

        public static function renderLoginBackground(target:BitmapData):Boolean
        {
            return _instance != null && _instance.renderLoginBackgroundInternal(target);
        }

        public static function setLoadingScreenVisible(visible:Boolean):void
        {
            var displayObject:DisplayObject;
            if (_instance == null || _instance._loadingScreen == null)
            {
                return;
            }
            displayObject = (_instance._loadingScreen as DisplayObject);
            if (displayObject == null)
            {
                return;
            }
            displayObject.visible = visible;
        }

        public static function debugLog(message:String):void
        {
            if (_instance != null)
            {
                _instance.debugLogInternal(message);
            }
        }

        private function debugLogInternal(message:String):void
        {
            var file:File;
            var stream:FileStream;
            var line:String;
            try
            {
                file = File.applicationStorageDirectory.resolvePath("debug.log");
                stream = new FileStream();
                stream.open(file, FileMode.APPEND);
                line = "[" + ((getTimer() - _startTime) / 1000).toFixed(3) + "s] " + message + "\n";
                stream.writeUTFBytes(line);
                stream.close();
            }
            catch (e:Error)
            {
                try { stream.close(); } catch (_:Error) {}
            }
        }

        private function onAddedToStage(event:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            _stageReady = true;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.quality = StageQuality.LOW;
            stage.align = StageAlign.TOP_LEFT;
            stage.color = 0x000000;
            root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
            tryInit();
        }

        private function onInvoke(event:InvokeEvent):void
        {
            NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
            parseArguments(event.arguments);
        }

        private function onBrowserInvoke(event:BrowserInvokeEvent):void
        {
            NativeApplication.nativeApplication.removeEventListener(BrowserInvokeEvent.BROWSER_INVOKE, onBrowserInvoke);
            parseArguments(event.arguments);
        }

        private function parseArguments(args:Array):void
        {
            var key:String;
            var value:String;
            var index:int = 0;
            while (args != null && index + 1 < args.length)
            {
                key = String(args[index]).replace(/^-+/, "");
                value = String(args[index + 1]);
                if (key == "server")
                {
                    setAirParameter("environment.id", value);
                }
                else if (key == "ticket")
                {
                    setAirParameter("sso.ticket", value);
                    setAirParameter("sso.token", value);
                }
                else if (key == "host")
                {
                    setAirParameter("connection.info.host", value);
                }
                else if (key == "port")
                {
                    setAirParameter("connection.info.port", value);
                }
                else if (key == "account")
                {
                    setAirParameter("account_id", value);
                    setAirParameter("unique_habbo_id", value);
                }
                index += 2;
            }

            _argumentsReady = true;
            tryInit();
        }

        private function tryInit():void
        {
            if (!_stageReady || !_argumentsReady)
            {
                return;
            }

            loadRuntimeConfig();
            applyDefaultParameters();
            startClient();
        }

        private function loadRuntimeConfig():void
        {
            loadConfigFile(File.applicationDirectory.resolvePath("config.ini"));
            loadConfigFile(File.applicationStorageDirectory.resolvePath("config.ini"));
        }

        private function loadConfigFile(file:File):void
        {
            if (file == null || !file.exists)
            {
                return;
            }
            var stream:FileStream = new FileStream();
            try
            {
                stream.open(file, FileMode.READ);
                var text:String = stream.readUTFBytes(stream.bytesAvailable);
                stream.close();
                applyConfigText(text);
            }
            catch (e:Error)
            {
                try { stream.close(); } catch (_:Error) {}
            }
        }

        private function applyConfigText(text:String):void
        {
            var lines:Array = text.split(/\r\n|\r|\n/);
            for each (var raw:String in lines)
            {
                var line:String = raw.replace(/^\s+|\s+$/g, "");
                if (line.length == 0 || line.charAt(0) == "#" || line.charAt(0) == ";")
                {
                    continue;
                }
                var eq:int = line.indexOf("=");
                if (eq <= 0)
                {
                    continue;
                }
                var key:String = line.substring(0, eq).replace(/^\s+|\s+$/g, "");
                var value:String = line.substring(eq + 1).replace(/^\s+|\s+$/g, "");
                if (key == "base.url")
                {
                    _configBaseUrl = value;
                    continue;
                }
                if (key == "gordon.path")
                {
                    _configGordonPath = value;
                    continue;
                }
                setDefaultAirParameter(key, value);
            }
        }

        private function applyDefaultParameters():void
        {
            setDefaultAirParameter("client.allow.cross.domain", "1");
            setDefaultAirParameter("client.notify.cross.domain", "0");
            setDefaultAirParameter("connection.info.host", DEFAULT_HOST);
            setDefaultAirParameter("connection.info.port", DEFAULT_PORT);
            setDefaultAirParameter("site.url", _configBaseUrl);
            setDefaultAirParameter("url.prefix", _configBaseUrl);
            setDefaultAirParameter("client.reload.url", _configBaseUrl + "/index.php");
            setDefaultAirParameter("client.fatal.error.url", _configBaseUrl + "/index.php");
            setDefaultAirParameter("client.connection.failed.url", _configBaseUrl + "/index.php");
            setDefaultAirParameter("external.variables.txt", _configBaseUrl + "/gamedata/external_dev_vars.txt?v=1778036604");
            setDefaultAirParameter("external.texts.txt", _configBaseUrl + "/gamedata/external_dev_texts.txt");
            setDefaultAirParameter("external.override.variables.txt", _configBaseUrl + "/gamedata/override/external_override_variables.txt?v=1777060058");
            setDefaultAirParameter("external.override.texts.txt", _configBaseUrl + "/gamedata/override/external_flash_override_texts.txt?v=1778972658");
            setDefaultAirParameter("external.figurepartlist.txt", _configBaseUrl + "/gamedata/figuredata.xml");
            setDefaultAirParameter("flash.dynamic.avatar.download.configuration", _configBaseUrl + "/gamedata/figuremap.xml");
            setDefaultAirParameter("productdata.load.url", _configBaseUrl + "/gamedata/productdata.txt");
            setDefaultAirParameter("furnidata.load.url", _configBaseUrl + "/furnidata.xml?v=1776546424");
            setDefaultAirParameter("flash.client.url", _configBaseUrl + _configGordonPath);
            setDefaultAirParameter("client.starting", "Scratching ear's ear");
            setDefaultAirParameter("has.identity", "1");
            setDefaultAirParameter("account_id", "1");
            setDefaultAirParameter("unique_habbo_id", "1");
            setDefaultAirParameter("processlog.enabled", "0");
            setDefaultAirParameter("flash.client.origin", "popup");
        }

        private function startClient():void
        {
            HabboWebTools.isAirDesktop = true;
            configureAirNetworkDefaults();
            HabboWebTools.airParameters = _parameters;
            HabboWebTools.rootLoaderInfo = loaderInfo;
            HabboWebTools.isSpaWeb = getAirParameter("spaweb") == "1";
            Habbo.CONNECTION_HOST = getAirParameter("connection.info.host");
            Habbo.CONNECTION_PORTS = getAirParameter("connection.info.port");
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_START);

            createLoadingScreen();
            _main = new HabboMain(_loadingScreen);
            addChild(_main);
        }

        private function configureAirNetworkDefaults():void
        {
            var defaultsClass:Class;
            try
            {
                defaultsClass = getDefinitionByName("flash.net.URLRequestDefaults") as Class;
                defaultsClass["userAgent"] = AIR_USER_AGENT;
                defaultsClass["followRedirects"] = true;
                defaultsClass["manageCookies"] = true;
            }
            catch (error:Error)
            {
            }
        }

        private function createLoadingScreen():void
        {
            var starting:String = getAirParameter("client.starting");
            if (starting == null || starting.length == 0)
            {
                starting = "client.starting";
            }
            _loadingScreen = new HabboLoadingScreen(stage.stageWidth, stage.stageHeight, starting, null);
            _loadingScreen._Str_774(HabboMain.CORE_RATIO);
            stage.addChild(DisplayObject(_loadingScreen));
        }

        private function showLoginBackgroundInternal():void
        {
            if (stage == null)
            {
                return;
            }
            _loginBackgroundVisible = true;
            if (_loginBackgroundLayer == null)
            {
                _loginBackgroundData = new HabboAir_LoginBackground().bitmapData;
                _loginBackgroundBitmap = new Bitmap(_loginBackgroundData, "auto", true);
                _loginBackgroundLayer = new Sprite();
                _loginBackgroundLayer.mouseEnabled = false;
                _loginBackgroundLayer.mouseChildren = false;
                _loginBackgroundLayer.addChild(_loginBackgroundBitmap);
            }
            if (_loginBackgroundLayer.parent == null)
            {
                addChildAt(_loginBackgroundLayer, 0);
                stage.addEventListener(Event.RESIZE, onLoginBackgroundResize);
            }
            resizeLoginBackground();
        }

        private function hideLoginBackgroundInternal():void
        {
            _loginBackgroundVisible = false;
            if (stage != null)
            {
                stage.removeEventListener(Event.RESIZE, onLoginBackgroundResize);
            }
            if (_loginBackgroundLayer != null && _loginBackgroundLayer.parent != null)
            {
                _loginBackgroundLayer.parent.removeChild(_loginBackgroundLayer);
            }
        }

        private function onLoginBackgroundResize(event:Event):void
        {
            resizeLoginBackground();
        }

        private function resizeLoginBackground():void
        {
            var scale:Number;
            if (_loginBackgroundBitmap == null || stage == null)
            {
                return;
            }
            scale = Math.max(stage.stageWidth / _loginBackgroundBitmap.bitmapData.width, stage.stageHeight / _loginBackgroundBitmap.bitmapData.height);
            _loginBackgroundBitmap.width = _loginBackgroundBitmap.bitmapData.width * scale;
            _loginBackgroundBitmap.height = _loginBackgroundBitmap.bitmapData.height * scale;
            _loginBackgroundBitmap.x = Math.round((stage.stageWidth - _loginBackgroundBitmap.width) / 2);
            _loginBackgroundBitmap.y = Math.round((stage.stageHeight - _loginBackgroundBitmap.height) / 2);
        }

        private function renderLoginBackgroundInternal(target:BitmapData):Boolean
        {
            var scale:Number;
            var matrix:Matrix;
            if (!_loginBackgroundVisible || target == null)
            {
                return false;
            }
            if (_loginBackgroundData == null)
            {
                _loginBackgroundData = new HabboAir_LoginBackground().bitmapData;
            }
            scale = Math.max(target.width / _loginBackgroundData.width, target.height / _loginBackgroundData.height);
            matrix = new Matrix();
            matrix.scale(scale, scale);
            matrix.translate(Math.round((target.width - (_loginBackgroundData.width * scale)) / 2), Math.round((target.height - (_loginBackgroundData.height * scale)) / 2));
            target.draw(_loginBackgroundData, matrix, null, null, null, true);
            return true;
        }

        private function setDefaultAirParameter(key:String, value:String):void
        {
            if (_parameters[key] == null)
            {
                _parameters[key] = value;
            }
        }

        private function setAirParameter(key:String, value:String):void
        {
            _parameters[key] = value;
        }

        private function getAirParameter(key:String):String
        {
            return _parameters[key] as String;
        }

        private function onUncaughtError(event:UncaughtErrorEvent):void
        {
            var errorObject:Object = event.error;
            var error:Error = errorObject as Error;
            var errorEvent:ErrorEvent = errorObject as ErrorEvent;
            var message:String = "Uncaught AIR client error, eventType: " + event.type + " errorID: " + event.errorID + " runtime: " + ((getTimer() - _startTime) / 1000) + "s";
            if (errorObject != null)
            {
                message += " errorClass=" + getQualifiedClassName(errorObject);
                if (error != null)
                {
                    message += " errorMessage=" + error.message;
                }
                else
                {
                    message += " errorValue=" + String(errorObject);
                }
                if (errorEvent != null)
                {
                    message += " eventText=" + errorEvent.text + " eventErrorID=" + errorEvent.errorID;
                }
            }
            debugLogInternal("UNCAUGHT: " + message);
            if ((errorObject is IOErrorEvent) || (errorObject is SecurityErrorEvent))
            {
                if (event.cancelable)
                {
                    event.preventDefault();
                }
                event.stopImmediatePropagation();
                return;
            }
            Habbo.reportCrash(message, Habbo.ERROR_UNCAUGHT_ERROR, true, error);
        }

        private function onApplicationExiting(event:Event):void
        {
            hideLoginBackgroundInternal();
            if (_instance == this)
            {
                HabboWebTools.showAirLoginBackgroundCallback = null;
                HabboWebTools.hideAirLoginBackgroundCallback = null;
                HabboWebTools.renderAirLoginBackgroundCallback = null;
            }
            if (_main != null)
            {
                _main.unloading();
            }
        }
    }
}
