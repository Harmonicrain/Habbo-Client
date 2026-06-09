package
{
    import com.sulake.core.Core;
    import com.sulake.habbo.utils.HabboWebTools;
    import flash.desktop.NativeApplication;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageDisplayState;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.BrowserInvokeEvent;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.InvokeEvent;
    import flash.events.IOErrorEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;
    import fonts._Str_10940;
    import fonts._Str_11970;
    import images.HabboAir_LoginBackground;
    import images.HabboAir_LoginForeground;
    import images.HabboWindowManagerCom_help_error_state;
    import images.HabboWindowManagerCom_habbo_skin_ubuntu_png;

    public class HabboAir extends MovieClip
    {
        private static const DEFAULT_BASE_URL:String = "https://swf.nextgenhabbo.com";
        private static const GORDON_PATH:String = "/gordon/PRODUCTION-201611291003-338511768/";
        private static const DEFAULT_HOST:String = "109.122.1.113";
        private static const DEFAULT_PORT:String = "3000,3001";
        private static const DEFAULT_APP_NAME:String = "NGHWin";
        private static const DEFAULT_VERSION_STRING:String = "0.0.0-beta";
        private static const LOGIN_VERSION_MARGIN_LEFT:int = 16;
        private static const LOGIN_VERSION_MARGIN_BOTTOM:int = 10;
        private static const LOGIN_FOREGROUND_OFFSET_Y:int = 82;
        private static const CONSOLE_MAX_LINES:int = 500;
        private static const F5_KEY_CODE:int = 116;
        private static const F10_KEY_CODE:int = 121;
        private static const F11_KEY_CODE:int = 122;
        private static const F12_KEY_CODE:int = 123;
        private static const CONSOLE_CLOSE_DEFAULT:Rectangle = new Rectangle(140, 10, 19, 20);
        private static const CONSOLE_CLOSE_PRESSED:Rectangle = new Rectangle(170, 10, 19, 20);
        private static const CONSOLE_CLOSE_HOVER:Rectangle = new Rectangle(200, 10, 19, 20);
        private static const AIR_USER_AGENT:String = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0 Safari/537.36";
        private static const UBUNTU_REGULAR_FONT:Class = _Str_10940;
        private static const UBUNTU_BOLD_FONT:Class = _Str_11970;

        private static var _instance:HabboAir;

        private var _startTime:int;
        private var _stageReady:Boolean = false;
        private var _argumentsReady:Boolean = false;
        private var _parameters:Dictionary;
        private var _loadingScreen:IHabboLoadingScreen;
        private var _main:HabboMain;
        private var _loginBackgroundData:BitmapData;
        private var _loginForegroundData:BitmapData;
        private var _loginBackgroundLayer:Sprite;
        private var _loginBackgroundBitmap:Bitmap;
        private var _loginForegroundBitmap:Bitmap;
        private var _loginVersionText:TextField;
        private var _loginBackgroundVisible:Boolean = false;
        private var _errorOverlayLayer:Sprite;
        private var _errorTitle:String;
        private var _errorMessage:String;
        private var _errorDetails:String;
        private var _consoleLayer:Sprite;
        private var _consoleText:TextField;
        private var _consoleCloseButton:Sprite;
        private var _consoleCloseBitmap:Bitmap;
        private var _consoleCloseDefaultData:BitmapData;
        private var _consoleCloseHoverData:BitmapData;
        private var _consoleClosePressedData:BitmapData;
        private var _consoleVisible:Boolean = false;
        private var _changelogLayer:Sprite;
        private var _changelogText:TextField;
        private var _changelogCloseButton:Sprite;
        private var _changelogCloseBitmap:Bitmap;
        private var _changelogVisible:Boolean = false;
        private var _changelogLoader:URLLoader;
        private var _changelogHtml:String;
        private var _logBuffer:Array;
        private var _configBaseUrl:String = DEFAULT_BASE_URL;
        private var _configGordonPath:String = GORDON_PATH;
        private var _reloadInProgress:Boolean = false;

        public function HabboAir()
        {
            super();
            _instance = this;
            HabboWebTools.showAirLoginBackgroundCallback = showLoginBackground;
            HabboWebTools.hideAirLoginBackgroundCallback = hideLoginBackground;
            HabboWebTools.renderAirLoginBackgroundCallback = renderLoginBackground;
            HabboWebTools.setAirLoadingScreenVisibleCallback = setLoadingScreenVisible;
            HabboWebTools.reloadAirClientCallback = reloadClientFromCallback;
            HabboWebTools.showAirErrorCallback = showError;
            HabboWebTools.setAirWindowTitleCallback = setWindowTitleForUser;
            HabboWebTools.airDebugLogCallback = debugLog;
            _startTime = getTimer();
            _parameters = new Dictionary();
            _logBuffer = [];
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

        public static function showError(title:String, message:String, details:String=null):void
        {
            if (_instance != null)
            {
                _instance.showErrorInternal(title, message, details);
            }
        }

        public static function setWindowTitleForUser(userName:String):void
        {
            if (_instance != null)
            {
                _instance.setWindowTitleForUserInternal(userName);
            }
        }

        public static function reloadClientFromCallback():void
        {
            if (_instance != null)
            {
                _instance.reloadClient();
            }
        }

        private function debugLogInternal(message:String):void
        {
            var file:File;
            var stream:FileStream;
            var line:String;
            line = "[" + ((getTimer() - _startTime) / 1000).toFixed(3) + "s] " + message;
            this._logBuffer.push(line);
            while (this._logBuffer.length > CONSOLE_MAX_LINES)
            {
                this._logBuffer.shift();
            }
            if (this._consoleVisible)
            {
                renderConsoleOverlay();
            }
            try
            {
                file = File.applicationStorageDirectory.resolvePath("debug.log");
                stream = new FileStream();
                stream.open(file, FileMode.APPEND);
                stream.writeUTFBytes(line + "\n");
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
            setWindowTitleForUserInternal(null);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onConsoleHotkey);
            root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
            tryInit();
        }

        private function onConsoleHotkey(event:KeyboardEvent):void
        {
            if (event.keyCode == F5_KEY_CODE)
            {
                event.preventDefault();
                reloadClient();
                return;
            }
            if (event.keyCode == F10_KEY_CODE)
            {
                event.preventDefault();
                this._changelogVisible = !this._changelogVisible;
                if (this._changelogVisible)
                {
                    showChangelogOverlay();
                }
                else
                {
                    removeChangelogOverlay();
                }
                return;
            }
            if (event.keyCode == F11_KEY_CODE)
            {
                event.preventDefault();
                toggleFullscreen();
                return;
            }
            if (event.keyCode != F12_KEY_CODE)
            {
                return;
            }
            event.preventDefault();
            this._consoleVisible = !this._consoleVisible;
            if (this._consoleVisible)
            {
                renderConsoleOverlay();
            }
            else
            {
                removeConsoleOverlay();
            }
        }

        private function toggleFullscreen():void
        {
            if (stage == null)
            {
                return;
            }
            if (stage.displayState == StageDisplayState.NORMAL)
            {
                stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            else
            {
                stage.displayState = StageDisplayState.NORMAL;
            }
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
            setDefaultAirParameter("app.name", DEFAULT_APP_NAME);
            setDefaultAirParameter("version.string", DEFAULT_VERSION_STRING);
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

        private function reloadClient():void
        {
            if (this._reloadInProgress)
            {
                return;
            }
            this._reloadInProgress = true;
            try
            {
                resetAirReloadState();
                disposeCurrentClient();
                setTimeout(completeReloadClient, 250);
            }
            catch (error:Error)
            {
                debugLogInternal("AIR reload failed: " + error.message + " | " + error.getStackTrace());
                showErrorInternal("Reload failed", "The client could not reload cleanly.", error.message);
                this._reloadInProgress = false;
            }
        }

        private function completeReloadClient():void
        {
            try
            {
                startClient();
            }
            catch (error:Error)
            {
                debugLogInternal("AIR reload failed: " + error.message + " | " + error.getStackTrace());
                showErrorInternal("Reload failed", "The client could not reload cleanly.", error.message);
            }
            this._reloadInProgress = false;
        }

        private function resetAirReloadState():void
        {
            this._errorTitle = null;
            this._errorMessage = null;
            this._errorDetails = null;
            if (stage != null)
            {
                stage.removeEventListener(Event.RESIZE, renderErrorOverlay);
            }
            if (this._errorOverlayLayer != null && this._errorOverlayLayer.parent != null)
            {
                this._errorOverlayLayer.parent.removeChild(this._errorOverlayLayer);
            }
            this._errorOverlayLayer = null;
            this._consoleVisible = false;
            removeConsoleOverlay();
            hideLoginBackgroundInternal();
            setWindowTitleForUserInternal(null);
            setAirParameter("sso.ticket", "");
            setAirParameter("sso.token", "");
            HabboWebTools.airLoginScreenVisible = false;
            HabboWebTools.airLoginAttemptActive = false;
            HabboWebTools.airLoginErrorShown = false;
            HabboWebTools.enterHomeRoomOnNextAirAuth = false;
            HabboWebTools.lastAirBanMessage = null;
        }

        private function disposeCurrentClient():void
        {
            var loadingDisplay:DisplayObject;
            if (this._main != null)
            {
                this._main.unloading();
            }
            Core.dispose();
            if (this._main != null)
            {
                this._main.disposeForReload();
                this._main = null;
            }
            if (this._loadingScreen != null)
            {
                loadingDisplay = this._loadingScreen as DisplayObject;
                this._loadingScreen.dispose();
                if (loadingDisplay != null && loadingDisplay.parent != null)
                {
                    loadingDisplay.parent.removeChild(loadingDisplay);
                }
                this._loadingScreen = null;
            }
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
            setWindowTitleForUserInternal(null);
            _loginBackgroundVisible = true;
            if (_loginBackgroundLayer == null)
            {
                _loginBackgroundData = new HabboAir_LoginBackground().bitmapData;
                _loginForegroundData = new HabboAir_LoginForeground().bitmapData;
                _loginBackgroundBitmap = new Bitmap(_loginBackgroundData, "auto", true);
                _loginForegroundBitmap = new Bitmap(_loginForegroundData, "auto", true);
                _loginBackgroundLayer = new Sprite();
                _loginBackgroundLayer.mouseEnabled = false;
                _loginBackgroundLayer.mouseChildren = false;
                _loginBackgroundLayer.addChild(_loginBackgroundBitmap);
                _loginBackgroundLayer.addChild(_loginForegroundBitmap);
                _loginVersionText = createLoginVersionText();
                _loginBackgroundLayer.addChild(_loginVersionText);
            }
            if (((_loginVersionText != null) && (_loginVersionText.parent == _loginBackgroundLayer)))
            {
                _loginBackgroundLayer.setChildIndex(_loginVersionText, (_loginBackgroundLayer.numChildren - 1));
            }
            if (_loginBackgroundLayer.parent == null)
            {
                addChildAt(_loginBackgroundLayer, 0);
                stage.addEventListener(Event.RESIZE, onLoginBackgroundResize);
            }
            resizeLoginBackground();
        }

        private function setWindowTitleForUserInternal(userName:String):void
        {
            var title:String = getAirParameter("app.name");
            if (((title == null) || (title.length == 0)))
            {
                title = DEFAULT_APP_NAME;
            }
            if (((userName != null) && (userName.length > 0)))
            {
                title += " - " + userName;
            }
            if (((stage != null) && (stage.nativeWindow != null)))
            {
                stage.nativeWindow.title = title;
            }
        }

        private function renderConsoleOverlay(event:Event=null):void
        {
            var backing:Sprite;
            var header:TextField;
            var logPath:String;
            var appName:String;
            if (((stage == null) || (!this._consoleVisible)))
            {
                return;
            }
            removeConsoleOverlay(false);
            this._consoleLayer = new Sprite();
            backing = new Sprite();
            backing.graphics.beginFill(0x050505, 0.88);
            backing.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            backing.graphics.endFill();
            this._consoleLayer.addChild(backing);

            appName = getAirParameter("app.name");
            if (((appName == null) || (appName.length == 0)))
            {
                appName = DEFAULT_APP_NAME;
            }
            logPath = File.applicationStorageDirectory.resolvePath("debug.log").nativePath;
            header = createConsoleText((appName + " Console - F12 to close - log: " + logPath), 13, 0xB8D8FF, true);
            header.x = 18;
            header.y = 14;
            header.width = Math.max(100, stage.stageWidth - 72);
            header.height = 22;
            this._consoleLayer.addChild(header);

            this._consoleCloseButton = new Sprite();
            ensureConsoleCloseAssets();
            this._consoleCloseBitmap = new Bitmap(this._consoleCloseDefaultData, "auto", true);
            this._consoleCloseButton.addChild(this._consoleCloseBitmap);
            this._consoleCloseButton.x = Math.max(18, stage.stageWidth - this._consoleCloseBitmap.width - 18);
            this._consoleCloseButton.y = 14;
            this._consoleCloseButton.buttonMode = true;
            this._consoleCloseButton.useHandCursor = true;
            this._consoleCloseButton.addEventListener(MouseEvent.CLICK, onConsoleCloseClick);
            this._consoleCloseButton.addEventListener(MouseEvent.MOUSE_OVER, onConsoleCloseOver);
            this._consoleCloseButton.addEventListener(MouseEvent.MOUSE_OUT, onConsoleCloseOut);
            this._consoleCloseButton.addEventListener(MouseEvent.MOUSE_DOWN, onConsoleCloseDown);
            this._consoleCloseButton.addEventListener(MouseEvent.MOUSE_UP, onConsoleCloseOver);
            this._consoleLayer.addChild(this._consoleCloseButton);

            this._consoleText = createConsoleText("", 12, 0xE8E8E8, false);
            this._consoleText.x = 18;
            this._consoleText.y = 44;
            this._consoleText.width = Math.max(100, stage.stageWidth - 36);
            this._consoleText.height = Math.max(80, stage.stageHeight - 62);
            this._consoleText.htmlText = buildConsoleHtml();
            this._consoleText.scrollV = this._consoleText.maxScrollV;
            this._consoleText.addEventListener(MouseEvent.MOUSE_WHEEL, onConsoleMouseWheel);
            this._consoleLayer.addChild(this._consoleText);

            stage.addChild(this._consoleLayer);
            stage.addEventListener(Event.RESIZE, renderConsoleOverlay);
        }

        private function removeConsoleOverlay(removeResize:Boolean=true):void
        {
            if (((removeResize) && (stage != null)))
            {
                stage.removeEventListener(Event.RESIZE, renderConsoleOverlay);
            }
            if (this._consoleText != null)
            {
                this._consoleText.removeEventListener(MouseEvent.MOUSE_WHEEL, onConsoleMouseWheel);
                this._consoleText = null;
            }
            if (this._consoleCloseButton != null)
            {
                this._consoleCloseButton.removeEventListener(MouseEvent.CLICK, onConsoleCloseClick);
                this._consoleCloseButton.removeEventListener(MouseEvent.MOUSE_OVER, onConsoleCloseOver);
                this._consoleCloseButton.removeEventListener(MouseEvent.MOUSE_OUT, onConsoleCloseOut);
                this._consoleCloseButton.removeEventListener(MouseEvent.MOUSE_DOWN, onConsoleCloseDown);
                this._consoleCloseButton.removeEventListener(MouseEvent.MOUSE_UP, onConsoleCloseOver);
                this._consoleCloseButton = null;
            }
            this._consoleCloseBitmap = null;
            if (((this._consoleLayer != null) && (this._consoleLayer.parent != null)))
            {
                this._consoleLayer.parent.removeChild(this._consoleLayer);
            }
            this._consoleLayer = null;
        }

        private function showChangelogOverlay():void
        {
            this._changelogHtml = '<font color="#B8D8FF">Loading latest changelog...</font>';
            renderChangelogOverlay();
            fetchLatestChangelog();
        }

        private function fetchLatestChangelog():void
        {
            var feedUrl:String = getAirParameter("update.feed.url");
            var request:URLRequest;
            if (((feedUrl == null) || (feedUrl.length == 0)))
            {
                this._changelogHtml = '<font color="#FF8080">No update feed is configured.</font>';
                renderChangelogOverlay();
                return;
            }
            try
            {
                if (this._changelogLoader != null)
                {
                    try { this._changelogLoader.close(); } catch (_:Error) {}
                }
                request = new URLRequest(feedUrl + ((feedUrl.indexOf("?") >= 0) ? "&" : "?") + "t=" + getTimer());
                this._changelogLoader = new URLLoader();
                this._changelogLoader.addEventListener(Event.COMPLETE, onChangelogLoaded);
                this._changelogLoader.addEventListener(IOErrorEvent.IO_ERROR, onChangelogLoadError);
                this._changelogLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangelogLoadError);
                this._changelogLoader.load(request);
            }
            catch (error:Error)
            {
                this._changelogHtml = '<font color="#FF8080">Could not load changelog: ' + escapeConsoleHtml(error.message) + "</font>";
                renderChangelogOverlay();
            }
        }

        private function onChangelogLoaded(event:Event):void
        {
            var raw:String;
            var manifest:Object;
            cleanupChangelogLoader();
            try
            {
                raw = String(URLLoader(event.target).data);
                raw = stripManifestPrefix(raw);
                manifest = JSON.parse(raw);
                this._changelogHtml = buildChangelogHtml(manifest);
            }
            catch (error:Error)
            {
                this._changelogHtml = '<font color="#FF8080">Could not parse changelog: ' + escapeConsoleHtml(error.message) + "</font>";
            }
            renderChangelogOverlay();
        }

        private function onChangelogLoadError(event:ErrorEvent):void
        {
            cleanupChangelogLoader();
            this._changelogHtml = '<font color="#FF8080">Could not load changelog: ' + escapeConsoleHtml(event.text) + "</font>";
            renderChangelogOverlay();
        }

        private function cleanupChangelogLoader():void
        {
            if (this._changelogLoader == null)
            {
                return;
            }
            this._changelogLoader.removeEventListener(Event.COMPLETE, onChangelogLoaded);
            this._changelogLoader.removeEventListener(IOErrorEvent.IO_ERROR, onChangelogLoadError);
            this._changelogLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangelogLoadError);
            this._changelogLoader = null;
        }

        private function stripManifestPrefix(value:String):String
        {
            if (value == null)
            {
                return "";
            }
            if (((value.length > 0) && (value.charCodeAt(0) == 0xFEFF)))
            {
                value = value.substr(1);
            }
            if (value.indexOf("ï»¿") == 0)
            {
                value = value.substr(3);
            }
            return value;
        }

        private function buildChangelogHtml(manifest:Object):String
        {
            var html:String = "";
            var version:String = manifest.version != null ? String(manifest.version) : "unknown";
            var notes:String = manifest.notes != null ? String(manifest.notes) : "";
            var item:*;
            html += '<font color="#B8D8FF"><b>Latest version: ' + escapeConsoleHtml(version) + "</b></font><br/><br/>";
            if (((manifest.changelog is Array) && (manifest.changelog.length > 0)))
            {
                for each (item in manifest.changelog)
                {
                    if (item != null && String(item).length > 0)
                    {
                        html += '<font color="#E8E8E8">- ' + escapeConsoleHtml(String(item)) + "</font><br/>";
                    }
                }
            }
            else if (notes.length > 0)
            {
                html += '<font color="#E8E8E8">' + escapeConsoleHtml(notes).split("\n").join("<br/>") + "</font><br/>";
            }
            else
            {
                html += '<font color="#E8E8E8">No changelog has been published for this release.</font><br/>';
            }
            return html;
        }

        private function renderChangelogOverlay(event:Event=null):void
        {
            var backing:Sprite;
            var header:TextField;
            var appName:String;
            if (((stage == null) || (!this._changelogVisible)))
            {
                return;
            }
            removeChangelogOverlay(false);
            this._changelogLayer = new Sprite();
            backing = new Sprite();
            backing.graphics.beginFill(0x050505, 0.88);
            backing.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            backing.graphics.endFill();
            this._changelogLayer.addChild(backing);

            appName = getAirParameter("app.name");
            if (((appName == null) || (appName.length == 0)))
            {
                appName = DEFAULT_APP_NAME;
            }
            header = createConsoleText((appName + " Changelog - F10 to close"), 13, 0xB8D8FF, true);
            header.x = 18;
            header.y = 14;
            header.width = Math.max(100, stage.stageWidth - 72);
            header.height = 22;
            this._changelogLayer.addChild(header);

            this._changelogCloseButton = new Sprite();
            ensureConsoleCloseAssets();
            this._changelogCloseBitmap = new Bitmap(this._consoleCloseDefaultData, "auto", true);
            this._changelogCloseButton.addChild(this._changelogCloseBitmap);
            this._changelogCloseButton.x = Math.max(18, stage.stageWidth - this._changelogCloseBitmap.width - 18);
            this._changelogCloseButton.y = 14;
            this._changelogCloseButton.buttonMode = true;
            this._changelogCloseButton.useHandCursor = true;
            this._changelogCloseButton.addEventListener(MouseEvent.CLICK, onChangelogCloseClick);
            this._changelogCloseButton.addEventListener(MouseEvent.MOUSE_OVER, onChangelogCloseOver);
            this._changelogCloseButton.addEventListener(MouseEvent.MOUSE_OUT, onChangelogCloseOut);
            this._changelogCloseButton.addEventListener(MouseEvent.MOUSE_DOWN, onChangelogCloseDown);
            this._changelogCloseButton.addEventListener(MouseEvent.MOUSE_UP, onChangelogCloseOver);
            this._changelogLayer.addChild(this._changelogCloseButton);

            this._changelogText = createConsoleText("", 12, 0xE8E8E8, false);
            this._changelogText.x = 18;
            this._changelogText.y = 44;
            this._changelogText.width = Math.max(100, stage.stageWidth - 36);
            this._changelogText.height = Math.max(80, stage.stageHeight - 62);
            this._changelogText.htmlText = this._changelogHtml;
            this._changelogText.addEventListener(MouseEvent.MOUSE_WHEEL, onChangelogMouseWheel);
            this._changelogLayer.addChild(this._changelogText);

            stage.addChild(this._changelogLayer);
            stage.addEventListener(Event.RESIZE, renderChangelogOverlay);
        }

        private function removeChangelogOverlay(removeResize:Boolean=true):void
        {
            if (((removeResize) && (stage != null)))
            {
                stage.removeEventListener(Event.RESIZE, renderChangelogOverlay);
            }
            cleanupChangelogLoader();
            if (this._changelogText != null)
            {
                this._changelogText.removeEventListener(MouseEvent.MOUSE_WHEEL, onChangelogMouseWheel);
                this._changelogText = null;
            }
            if (this._changelogCloseButton != null)
            {
                this._changelogCloseButton.removeEventListener(MouseEvent.CLICK, onChangelogCloseClick);
                this._changelogCloseButton.removeEventListener(MouseEvent.MOUSE_OVER, onChangelogCloseOver);
                this._changelogCloseButton.removeEventListener(MouseEvent.MOUSE_OUT, onChangelogCloseOut);
                this._changelogCloseButton.removeEventListener(MouseEvent.MOUSE_DOWN, onChangelogCloseDown);
                this._changelogCloseButton.removeEventListener(MouseEvent.MOUSE_UP, onChangelogCloseOver);
                this._changelogCloseButton = null;
            }
            this._changelogCloseBitmap = null;
            if (((this._changelogLayer != null) && (this._changelogLayer.parent != null)))
            {
                this._changelogLayer.parent.removeChild(this._changelogLayer);
            }
            this._changelogLayer = null;
        }

        private function onChangelogCloseClick(event:MouseEvent):void
        {
            this._changelogVisible = false;
            removeChangelogOverlay();
        }

        private function onChangelogCloseOver(event:MouseEvent):void
        {
            if (this._changelogCloseBitmap != null)
            {
                this._changelogCloseBitmap.bitmapData = this._consoleCloseHoverData;
            }
        }

        private function onChangelogCloseOut(event:MouseEvent):void
        {
            if (this._changelogCloseBitmap != null)
            {
                this._changelogCloseBitmap.bitmapData = this._consoleCloseDefaultData;
            }
        }

        private function onChangelogCloseDown(event:MouseEvent):void
        {
            if (this._changelogCloseBitmap != null)
            {
                this._changelogCloseBitmap.bitmapData = this._consoleClosePressedData;
            }
        }

        private function ensureConsoleCloseAssets():void
        {
            var atlas:BitmapData;
            if (this._consoleCloseDefaultData != null)
            {
                return;
            }
            atlas = new HabboWindowManagerCom_habbo_skin_ubuntu_png().bitmapData;
            this._consoleCloseDefaultData = cropBitmapData(atlas, CONSOLE_CLOSE_DEFAULT);
            this._consoleCloseHoverData = cropBitmapData(atlas, CONSOLE_CLOSE_HOVER);
            this._consoleClosePressedData = cropBitmapData(atlas, CONSOLE_CLOSE_PRESSED);
        }

        private function cropBitmapData(source:BitmapData, rect:Rectangle):BitmapData
        {
            var result:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
            result.copyPixels(source, rect, new Point(0, 0));
            return result;
        }

        private function onConsoleCloseClick(event:MouseEvent):void
        {
            this._consoleVisible = false;
            removeConsoleOverlay();
        }

        private function onConsoleCloseOver(event:MouseEvent):void
        {
            if (this._consoleCloseBitmap != null)
            {
                this._consoleCloseBitmap.bitmapData = this._consoleCloseHoverData;
            }
        }

        private function onConsoleCloseOut(event:MouseEvent):void
        {
            if (this._consoleCloseBitmap != null)
            {
                this._consoleCloseBitmap.bitmapData = this._consoleCloseDefaultData;
            }
        }

        private function onConsoleCloseDown(event:MouseEvent):void
        {
            if (this._consoleCloseBitmap != null)
            {
                this._consoleCloseBitmap.bitmapData = this._consoleClosePressedData;
            }
        }

        private function createConsoleText(text:String, size:int, color:uint, bold:Boolean):TextField
        {
            var field:TextField = new TextField();
            var format:TextFormat = new TextFormat("Ubuntu", size, color, bold);
            field.defaultTextFormat = format;
            field.text = text;
            field.wordWrap = true;
            field.multiline = true;
            field.selectable = true;
            field.embedFonts = true;
            field.antiAliasType = AntiAliasType.ADVANCED;
            return field;
        }

        private function buildConsoleHtml():String
        {
            var html:String = "";
            var line:String;
            var escaped:String;
            var upper:String;
            for each (line in this._logBuffer)
            {
                escaped = escapeConsoleHtml(line);
                upper = line.toUpperCase();
                if (((upper.indexOf("FAIL") >= 0) || (upper.indexOf("ERROR") >= 0)))
                {
                    html += '<font color="#FF8080">' + escaped + "</font><br/>";
                }
                else
                {
                    html += '<font color="#E8E8E8">' + escaped + "</font><br/>";
                }
            }
            return html;
        }

        private function escapeConsoleHtml(value:String):String
        {
            if (value == null)
            {
                return "";
            }
            return value.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
        }

        private function onConsoleMouseWheel(event:MouseEvent):void
        {
            if (this._consoleText == null)
            {
                return;
            }
            this._consoleText.scrollV -= event.delta;
        }

        private function onChangelogMouseWheel(event:MouseEvent):void
        {
            if (this._changelogText == null)
            {
                return;
            }
            this._changelogText.scrollV -= event.delta;
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
            positionLoginForeground();
            positionLoginVersionText();
        }

        private function positionLoginForeground():void
        {
            var scale:Number;
            if (((_loginForegroundBitmap == null) || (stage == null)))
            {
                return;
            }
            scale = Math.min(1, Math.min(stage.stageWidth / _loginForegroundBitmap.bitmapData.width, stage.stageHeight / _loginForegroundBitmap.bitmapData.height));
            _loginForegroundBitmap.width = Math.round(_loginForegroundBitmap.bitmapData.width * scale);
            _loginForegroundBitmap.height = Math.round(_loginForegroundBitmap.bitmapData.height * scale);
            _loginForegroundBitmap.x = Math.round(stage.stageWidth - _loginForegroundBitmap.width);
            _loginForegroundBitmap.y = Math.round((stage.stageHeight - _loginForegroundBitmap.height) + LOGIN_FOREGROUND_OFFSET_Y);
        }

        private function createLoginVersionText():TextField
        {
            var field:TextField = new TextField();
            field.defaultTextFormat = new TextFormat("Ubuntu", 12, 0xFFFFFF, false);
            field.embedFonts = true;
            field.antiAliasType = AntiAliasType.ADVANCED;
            field.selectable = false;
            field.mouseEnabled = false;
            field.autoSize = TextFieldAutoSize.LEFT;
            return field;
        }

        private function positionLoginVersionText():void
        {
            var version:String;
            if (((_loginVersionText == null) || (stage == null)))
            {
                return;
            }
            version = getAirParameter("version.string");
            if (((version == null) || (version.length == 0)))
            {
                version = DEFAULT_VERSION_STRING;
            }
            _loginVersionText.text = version;
            _loginVersionText.x = LOGIN_VERSION_MARGIN_LEFT;
            _loginVersionText.y = Math.max(0, (stage.stageHeight - _loginVersionText.height - LOGIN_VERSION_MARGIN_BOTTOM));
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
            if (_loginForegroundData == null)
            {
                _loginForegroundData = new HabboAir_LoginForeground().bitmapData;
            }
            scale = Math.max(target.width / _loginBackgroundData.width, target.height / _loginBackgroundData.height);
            matrix = new Matrix();
            matrix.scale(scale, scale);
            matrix.translate(Math.round((target.width - (_loginBackgroundData.width * scale)) / 2), Math.round((target.height - (_loginBackgroundData.height * scale)) / 2));
            target.draw(_loginBackgroundData, matrix, null, null, null, true);
            drawLoginForeground(target);
            drawLoginVersionText(target);
            return true;
        }

        private function drawLoginForeground(target:BitmapData):void
        {
            var scale:Number;
            var matrix:Matrix;
            if (((target == null) || (_loginForegroundData == null)))
            {
                return;
            }
            scale = Math.min(1, Math.min(target.width / _loginForegroundData.width, target.height / _loginForegroundData.height));
            matrix = new Matrix();
            matrix.scale(scale, scale);
            matrix.translate(Math.round(target.width - (_loginForegroundData.width * scale)), Math.round((target.height - (_loginForegroundData.height * scale)) + LOGIN_FOREGROUND_OFFSET_Y));
            target.draw(_loginForegroundData, matrix, null, null, null, true);
        }

        private function drawLoginVersionText(target:BitmapData):void
        {
            var field:TextField;
            var version:String;
            var matrix:Matrix;
            if (target == null)
            {
                return;
            }
            version = getAirParameter("version.string");
            if (((version == null) || (version.length == 0)))
            {
                version = DEFAULT_VERSION_STRING;
            }
            field = createLoginVersionText();
            field.text = version;
            matrix = new Matrix(1, 0, 0, 1, LOGIN_VERSION_MARGIN_LEFT, Math.max(0, (target.height - field.height - LOGIN_VERSION_MARGIN_BOTTOM)));
            target.draw(field, matrix, null, null, null, true);
        }

        private function showErrorInternal(title:String, message:String, details:String=null):void
        {
            if ((HabboWebTools.airLoginAttemptActive || HabboWebTools.airLoginErrorShown) && title != "Could not connect to the hotel server")
            {
                debugLogInternal("SUPPRESSED VISIBLE ERROR DURING LOGIN: " + title + " - " + message + ((details != null && details.length > 0) ? (" | " + details) : ""));
                return;
            }
            if (_errorTitle != null && title == "Client error" && _errorTitle != "Client error")
            {
                debugLogInternal("SUPPRESSED VISIBLE ERROR: " + title + " - " + message + ((details != null && details.length > 0) ? (" | " + details) : ""));
                return;
            }
            _errorTitle = (title != null && title.length > 0) ? title : "Client error";
            _errorMessage = (message != null && message.length > 0) ? message : "The client could not continue.";
            _errorDetails = details;
            debugLogInternal("VISIBLE ERROR: " + _errorTitle + " - " + _errorMessage + ((_errorDetails != null && _errorDetails.length > 0) ? (" | " + _errorDetails) : ""));
            renderErrorOverlay();
        }

        private function renderErrorOverlay(event:Event=null):void
        {
            var panel:Sprite;
            var titleField:TextField;
            var messageField:TextField;
            var detailsField:TextField;
            var logField:TextField;
            var panelWidth:Number;
            var panelHeight:Number;
            var y:Number;
            var iconBitmap:Bitmap;
            var iconW:Number = 0;
            var iconH:Number = 0;
            var textX:Number;
            var textWidth:Number;
            var headerBottom:Number;
            if (stage == null || _errorTitle == null)
            {
                return;
            }
            if (_errorOverlayLayer != null && _errorOverlayLayer.parent != null)
            {
                _errorOverlayLayer.parent.removeChild(_errorOverlayLayer);
            }
            _errorOverlayLayer = new Sprite();
            _errorOverlayLayer.graphics.beginFill(0x050505, 0.96);
            _errorOverlayLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            _errorOverlayLayer.graphics.endFill();

            panelWidth = Math.min(680, Math.max(360, stage.stageWidth - 80));
            panel = new Sprite();
            panel.x = Math.round((stage.stageWidth - panelWidth) / 2);
            panel.y = 110;
            panel.graphics.beginFill(0x151515, 1);
            panel.graphics.lineStyle(1, 0x555555, 1);
            panel.graphics.drawRoundRect(0, 0, panelWidth, 260, 8, 8);
            panel.graphics.endFill();

            // error mascot, top-left of the panel; title + message sit to its right
            try
            {
                iconBitmap = new Bitmap(new HabboWindowManagerCom_help_error_state().bitmapData, "auto", true);
                iconBitmap.x = 24;
                iconBitmap.y = 24;
                iconW = iconBitmap.width;
                iconH = iconBitmap.height;
                panel.addChild(iconBitmap);
            }
            catch (iconError:Error)
            {
                iconW = 0;
                iconH = 0;
            }

            textX = (iconW > 0) ? (24 + iconW + 20) : 24;
            textWidth = panelWidth - textX - 24;

            y = 24;
            titleField = createErrorText(_errorTitle, 22, 0xFFFFFF, true, textWidth);
            titleField.x = textX;
            titleField.y = y;
            panel.addChild(titleField);
            y += titleField.height + 14;

            messageField = createErrorText(_errorMessage, 15, 0xE8E8E8, false, textWidth);
            messageField.x = textX;
            messageField.y = y;
            panel.addChild(messageField);
            y += messageField.height;

            // details/diagnostics span the full panel width below the header row
            headerBottom = Math.max(24 + iconH, y);
            y = headerBottom + 16;

            if (_errorDetails != null && _errorDetails.length > 0)
            {
                detailsField = createErrorText(_errorDetails, 12, 0xCFCFCF, false, panelWidth - 48);
                detailsField.x = 24;
                detailsField.y = y;
                panel.addChild(detailsField);
                y += detailsField.height + 16;
            }

            logField = createErrorText("Diagnostics: " + File.applicationStorageDirectory.resolvePath("debug.log").nativePath, 12, 0xB8D8FF, false, panelWidth - 48);
            logField.x = 24;
            logField.y = y;
            panel.addChild(logField);
            y += logField.height + 24;

            panelHeight = Math.max(180, y);
            panel.graphics.clear();
            panel.graphics.beginFill(0x151515, 1);
            panel.graphics.lineStyle(1, 0x555555, 1);
            panel.graphics.drawRoundRect(0, 0, panelWidth, panelHeight, 8, 8);
            panel.graphics.endFill();
            panel.y = Math.max(40, Math.round((stage.stageHeight - panelHeight) / 2));
            _errorOverlayLayer.addChild(panel);
            stage.addChild(_errorOverlayLayer);
            stage.addEventListener(Event.RESIZE, renderErrorOverlay);
        }

        private function createErrorText(text:String, size:int, color:uint, bold:Boolean, width:Number):TextField
        {
            var field:TextField = new TextField();
            var format:TextFormat = new TextFormat("Ubuntu", size, color, bold);
            field.defaultTextFormat = format;
            field.text = text;
            field.width = width;
            field.wordWrap = true;
            field.multiline = true;
            field.selectable = true;
            field.embedFonts = true;
            field.antiAliasType = AntiAliasType.ADVANCED;
            field.autoSize = TextFieldAutoSize.LEFT;
            return field;
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
                showErrorInternal("Required files could not load", "The app could not download one of the files it needs to start. Check that base.url and gordon.path in config.ini point to a working web server.", message);
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
                if (stage != null)
                {
                    stage.removeEventListener(KeyboardEvent.KEY_DOWN, onConsoleHotkey);
                }
                removeConsoleOverlay();
                removeChangelogOverlay();
                HabboWebTools.showAirLoginBackgroundCallback = null;
                HabboWebTools.hideAirLoginBackgroundCallback = null;
                HabboWebTools.renderAirLoginBackgroundCallback = null;
                HabboWebTools.reloadAirClientCallback = null;
                HabboWebTools.showAirErrorCallback = null;
                HabboWebTools.setAirWindowTitleCallback = null;
            }
            if (_main != null)
            {
                _main.unloading();
            }
        }
    }
}
