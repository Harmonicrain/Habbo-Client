package com.sulake.habbo.utils
{
    import flash.display.BitmapData;
    import flash.display.LoaderInfo;
    import flash.external.ExternalInterface;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.setTimeout;

    public class HabboWebTools
    {
        public static const ADVERTISEMENT:String = "advertisement";
        public static const OPENLINK:String = "openlink";
        public static const OPENROOM:String = "openroom";
        private static const AVATAR_ASSET_DIAGNOSTIC_LIMIT:int = 40;
        private static var _isSpaWeb:Boolean = false;
        private static var _avatarAssetDiagnostics:Array = [];
        public static var rootLoaderInfo:LoaderInfo;
        public static var airParameters:Object;
        public static var isAirDesktop:Boolean = false;
        public static var showAirLoginBackgroundCallback:Function;
        public static var hideAirLoginBackgroundCallback:Function;
        public static var renderAirLoginBackgroundCallback:Function;
        public static var setAirLoadingScreenVisibleCallback:Function;
        public static var reloadAirClientCallback:Function;
        public static var returnToAirLoginCallback:Function;
        public static var showAirLoginErrorCallback:Function;
        public static var showAirErrorCallback:Function;
        public static var setAirWindowTitleCallback:Function;
        public static var airDebugLogCallback:Function;
        public static var enterHomeRoomOnNextAirAuth:Boolean = false;
        public static var airLoginScreenVisible:Boolean = false;
        public static var airLoginAttemptActive:Boolean = false;
        public static var airLoginErrorShown:Boolean = false;
        public static var lastAirBanMessage:String;

        public static function set isSpaWeb(isSpaWeb:Boolean):void
        {
            _isSpaWeb = isSpaWeb;
        }

        public static function logEventLog(data:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.logEventLog", data);
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working, failed to log event log.");
            }
        }

        public static function getParameter(key:String, fallbackLoaderInfo:LoaderInfo=null):String
        {
            var normalizedKey:String = key.replace(/[_]/g, ".");
            if (airParameters != null)
            {
                if (airParameters[key] != null)
                {
                    return String(airParameters[key]);
                }
                if (airParameters[normalizedKey] != null)
                {
                    return String(airParameters[normalizedKey]);
                }
            }
            if (((rootLoaderInfo != null) && (rootLoaderInfo.parameters[key] != null)))
            {
                return String(rootLoaderInfo.parameters[key]);
            }
            if (((rootLoaderInfo != null) && (rootLoaderInfo.parameters[normalizedKey] != null)))
            {
                return String(rootLoaderInfo.parameters[normalizedKey]);
            }
            if (((fallbackLoaderInfo != null) && (fallbackLoaderInfo.parameters[key] != null)))
            {
                return String(fallbackLoaderInfo.parameters[key]);
            }
            if (((fallbackLoaderInfo != null) && (fallbackLoaderInfo.parameters[normalizedKey] != null)))
            {
                return String(fallbackLoaderInfo.parameters[normalizedKey]);
            }
            return null;
        }

        public static function getParameterMap(fallbackLoaderInfo:LoaderInfo=null):Object
        {
            var key:String;
            var parameters:Object = {};
            if (fallbackLoaderInfo != null)
            {
                for (key in fallbackLoaderInfo.parameters)
                {
                    parameters[key] = fallbackLoaderInfo.parameters[key];
                }
            }
            else if (rootLoaderInfo != null)
            {
                for (key in rootLoaderInfo.parameters)
                {
                    parameters[key] = rootLoaderInfo.parameters[key];
                }
            }
            if (airParameters != null)
            {
                for (key in airParameters)
                {
                    parameters[key] = airParameters[key];
                }
            }
            return parameters;
        }

        public static function showAirLoginBackground():void
        {
            airLoginScreenVisible = true;
            if (showAirLoginBackgroundCallback != null)
            {
                showAirLoginBackgroundCallback();
            }
        }

        public static function hideAirLoginBackground():void
        {
            airLoginScreenVisible = false;
            if (hideAirLoginBackgroundCallback != null)
            {
                hideAirLoginBackgroundCallback();
            }
        }

        public static function renderAirLoginBackground(target:BitmapData):Boolean
        {
            if (renderAirLoginBackgroundCallback == null)
            {
                return false;
            }
            return Boolean(renderAirLoginBackgroundCallback(target));
        }

        public static function setAirLoadingScreenVisible(visible:Boolean):void
        {
            if (setAirLoadingScreenVisibleCallback != null)
            {
                setAirLoadingScreenVisibleCallback(visible);
            }
        }

        public static function returnToAirLogin():void
        {
            if (reloadAirClientCallback != null)
            {
                setTimeout(reloadAirClientCallback, 1);
                return;
            }
            if (returnToAirLoginCallback != null)
            {
                returnToAirLoginCallback();
            }
        }

        public static function showAirLoginError(message:String):void
        {
            airLoginAttemptActive = false;
            airLoginErrorShown = true;
            airDebug("LOGIN ERROR: " + message);
            if (showAirLoginErrorCallback != null)
            {
                showAirLoginErrorCallback(message);
            }
            if (showAirErrorCallback != null)
            {
                showAirErrorCallback("Could not connect to the hotel server", message, "Check that the emulator/server is running and that connection.info.host / connection.info.port in config.ini are correct.");
            }
        }

        public static function airDebug(message:String):void
        {
            if (airDebugLogCallback != null)
            {
                airDebugLogCallback(message);
            }
        }

        public static function recordAvatarAssetDiagnostic(state:String, libraryName:String, url:String=null, details:String=null):void
        {
            var message:String = "state=" + state + " lib=" + libraryName;
            if (url != null && url.length > 0)
            {
                message += " url=" + url;
            }
            if (details != null && details.length > 0)
            {
                message += " " + details;
            }
            _avatarAssetDiagnostics.push(message);
            while (_avatarAssetDiagnostics.length > AVATAR_ASSET_DIAGNOSTIC_LIMIT)
            {
                _avatarAssetDiagnostics.shift();
            }
        }

        public static function getAvatarAssetDiagnostics():String
        {
            return _avatarAssetDiagnostics.join(" || ");
        }

        public static function showAirError(title:String, message:String, details:String=null):void
        {
            airDebug("ERROR: " + title + " - " + message + ((details != null && details.length > 0) ? (" | " + details) : ""));
            if (showAirErrorCallback != null)
            {
                showAirErrorCallback(title, message, details);
            }
        }

        public static function rememberAirBanMessage(message:String):void
        {
            lastAirBanMessage = message;
            airDebug("BAN MESSAGE: " + ((message != null && message.length > 0) ? message : "(empty)"));
        }

        public static function setAirWindowTitleForUser(userName:String):void
        {
            if (setAirWindowTitleCallback != null)
            {
                setAirWindowTitleCallback(userName);
            }
        }

        public static function openWebPage(url:String, targetWindow:String=""):void
        {
            var strUserAgent:String;
            if (((targetWindow == null) || (targetWindow == "")))
            {
                targetWindow = ADVERTISEMENT;
            }
            var req:URLRequest = new URLRequest(url);
            if (!ExternalInterface.available)
            {
                flash.net.navigateToURL(req, targetWindow);
            }
            else
            {
                try
                {
                    strUserAgent = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
                    if (strUserAgent.indexOf("firefox") >= 0)
                    {
                        ExternalInterface.call("window.open", req.url, targetWindow);
                    }
                    else
                    {
                        if (strUserAgent.indexOf("msie") >= 0)
                        {
                            ExternalInterface.call((((("function setWMWindow() {window.open('" + req.url) + "', '") + targetWindow) + "');}"));
                        }
                        else
                        {
                            flash.net.navigateToURL(req, targetWindow);
                        }
                    }
                }
                catch(e:Error)
                {
                    Logger.log("External interface not working, failed to open web page.");
                }
            }
        }

        public static function openPage(pageUrl:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.openPage", pageUrl);
                }
                else
                {
                    Logger.log("External interface not available, openPage failed.");
                }
            }
            catch(e:Error)
            {
                Logger.log(("Failed to open web page " + pageUrl));
            }
        }

        public static function sendHeartBeat():void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.heartBeat");
                }
            }
            catch(e:Error)
            {
            }
        }

        public static function openWebPageAndMinimizeClient(pageUrl:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        openPage(pageUrl);
                    }
                    else
                    {
                        ExternalInterface.call("FlashExternalInterface.openWebPageAndMinimizeClient", pageUrl);
                    }
                }
            }
            catch(e:Error)
            {
                Logger.log(("Failed to open web page " + pageUrl));
            }
        }

        public static function closeWebPageAndRestoreClient():void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.closeWebPageAndRestoreClient");
                }
            }
            catch(e:Error)
            {
                Logger.log("Failed to close web page and restore client!");
            }
        }

        public static function openHabblet(name:String, param:String=null):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.openHabblet", name, param);
                }
            }
            catch(e:Error)
            {
                Logger.log(("Failed to open Habblet " + name));
            }
        }

        public static function closeHabblet(name:String, param:String=null):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.closeHabblet", name, param);
                }
            }
            catch(e:Error)
            {
                Logger.log(("Failed to close Habblet " + name));
            }
        }

        public static function send(reasonCode:int, reasonString:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.disconnect", reasonCode, reasonString);
                }
            }
            catch(e:Error)
            {
                Logger.log("Failed to close send ");
            }
        }

        public static function showGame(gameUrl:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalGameInterface.showGame", gameUrl);
                }
            }
            catch(e:Error)
            {
                Logger.log(("Failed to open game: " + e));
            }
        }

        public static function hideGame():void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalGameInterface.hideGame");
                }
            }
            catch(e:Error)
            {
                Logger.log("Failed to hide game");
            }
        }

        public static function navigateToURL(k:String, _arg_2:String=null):void
        {
            var _local_3:URLRequest = new URLRequest(k);
            flash.net.navigateToURL(_local_3, _arg_2);
        }

        public static function open(url:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.openExternalLink", escape(url));
                }
                else
                {
                    Logger.log(("External interface not available. Could not request to open: " + url));
                }
            }
            catch(e:Error)
            {
                Logger.log(("External interface not working. Could not request to open: " + url));
            }
        }

        public static function roomVisited(roomId:int):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("FlashExternalInterface.roomVisited", roomId);
                }
                else
                {
                    Logger.log("External interface not available. Could not store last room visit.");
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working. Could not store last room visit.");
            }
        }

        public static function openMinimail(target:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openMinimail", target);
                    }
                    else
                    {
                        openHabblet("minimail", target);
                    }
                }
                else
                {
                    Logger.log("External interface not available. Could not open minimail.");
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working. Could not open minimail.");
            }
        }

        public static function openNews():void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openNews");
                    }
                    else
                    {
                        openHabblet("news");
                    }
                }
                else
                {
                    Logger.log("External interface not available. Could not open news.");
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working. Could not open news.");
            }
        }

        public static function closeNews():void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.closeNews");
                    }
                    else
                    {
                        closeHabblet("news");
                    }
                }
                else
                {
                    Logger.log("External interface not available. Could not close news.");
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working. Could not close news.");
            }
        }

        public static function openAvatars():void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openAvatars");
                    }
                    else
                    {
                        openHabblet("avatars");
                    }
                }
                else
                {
                    Logger.log("External interface not available. Could not open avatars.");
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working. Could not open avatars.");
            }
        }

        public static function openRoomEnterAd():void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.openRoomEnterAd");
                    }
                    else
                    {
                        openHabblet("roomenterad", "");
                    }
                }
                else
                {
                    Logger.log("External interface not available. Could not open roomenterad.");
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working. Could not open roomenterad.");
            }
        }

        public static function updateFigure(figure:String):void
        {
            try
            {
                if (ExternalInterface.available)
                {
                    if (_isSpaWeb)
                    {
                        ExternalInterface.call("FlashExternalInterface.updateFigure", figure);
                    }
                }
                else
                {
                    Logger.log("External interface not available. Could not update figure.");
                }
            }
            catch(e:Error)
            {
                Logger.log("External interface not working. Could not update figure.");
            }
        }
    }
}
