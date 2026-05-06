package com.sulake.habbo.utils
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class ProjectorParameters
    {
        public static const SETUP_URL:String = "http://127.0.0.1:8080/setup.xml";

        private static var _parameters:Object = {};
        private static var _loading:Boolean = false;
        private static var _loaded:Boolean = false;
        private static var _callbacks:Array = [];

        public function ProjectorParameters()
        {
        }

        public static function initialize(parameters:Object):void
        {
            _parameters = mergeObjects(parameters, null);
            _loaded = true;
        }

        public static function load(parameters:Object, onComplete:Function):void
        {
            if (_loaded)
            {
                if (onComplete != null)
                {
                    onComplete();
                }
                return;
            }
            _callbacks.push(onComplete);
            if (_loading)
            {
                return;
            }
            _loading = true;
            _parameters = mergeObjects(parameters, null);
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function (event:Event):void
            {
                var parsed:Object = parseSetupXml(String(loader.data));
                _parameters = mergeObjects(_parameters, parsed);
                finishLoad();
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent):void
            {
                trace("ProjectorParameters IO error: " + event.text);
                finishLoad();
            });
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (event:SecurityErrorEvent):void
            {
                trace("ProjectorParameters security error: " + event.text);
                finishLoad();
            });
            loader.load(new URLRequest(SETUP_URL));
        }

        public static function get parameters():Object
        {
            return _parameters;
        }

        public static function getValue(key:String, defaultValue:String=null):String
        {
            if (_parameters != null && _parameters[key] !== undefined)
            {
                return String(_parameters[key]);
            }
            return defaultValue;
        }

        private static function finishLoad():void
        {
            var callback:Function;
            _loaded = true;
            _loading = false;
            while (_callbacks.length > 0)
            {
                callback = _callbacks.shift();
                if (callback != null)
                {
                    callback();
                }
            }
        }

        private static function parseSetupXml(rawXml:String):Object
        {
            var xml:XML;
            var result:Object = {};
            var node:XML;
            try
            {
                xml = new XML(rawXml);
            }
            catch (error:Error)
            {
                trace("ProjectorParameters parse error: " + error.message);
                return result;
            }
            for each (node in xml.descendants("var"))
            {
                addParameter(result, String(node.@key), String(node.@value || node.text()));
            }
            for each (node in xml.descendants("param"))
            {
                addParameter(result, String(node.@key || node.@name), String(node.@value || node.text()));
            }
            return result;
        }

        private static function addParameter(result:Object, key:String, value:String):void
        {
            if (key == null || key == "")
            {
                return;
            }
            result[key] = value;
        }

        private static function mergeObjects(primary:Object, secondary:Object):Object
        {
            var result:Object = {};
            var key:String;
            if (primary != null)
            {
                for (key in primary)
                {
                    result[key] = primary[key];
                }
            }
            if (secondary != null)
            {
                for (key in secondary)
                {
                    result[key] = secondary[key];
                }
            }
            return result;
        }
    }
}