package com.sulake.habbo.habbicons.assets
{
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;

    public class HabbiconAssetManager
    {
        private static const ASSET_ROOT_KEY:String = "habbicons.asset.root";
        private static const ASSET_HASH_KEY:String = "habbicons.asset.hash";
        private static const METADATA_FILE:String = "habbicons.json";
        private static const PREVIEW_SHEET_FILE:String = "habbicons_spritesheet.png";
        private static const COLLECTION_SHEET_FILE:String = "collection_icons_spritesheet.png";
        private static const ANIMATION_PATH:String = "animation/";
        private static const DEFAULT_FRAME_SIZE:int = 40;
        private static const DEFAULT_COLLECTION_ICON_SIZE:int = 18;
        private static const COLLECTION_ICON_OUTLINE_SIZE:int = 2;
        private static const COLLECTION_ICON_OUTLINE_COLOR:uint = 0xFFFFFFFF;

        public static const ASSETS_LOADED:String = "habbicon_assets_loaded";

        private static var _instance:HabbiconAssetManager;
        private static var _configuration:IHabboConfigurationManager;
        private static var _events:EventDispatcher = new EventDispatcher();

        private var _loading:Boolean = false;
        private var _jsonLoaded:Boolean = false;
        private var _sheetLoaded:Boolean = false;
        private var _collectionSheetLoaded:Boolean = false;
        private var _failed:Boolean = false;

        private var _previewFrames:Dictionary;
        private var _collectionFrames:Dictionary;
        private var _previewBitmaps:Dictionary;
        private var _previewBitmapsSmall:Dictionary;
        private var _collectionBitmaps:Dictionary;
        private var _outlinedCollectionBitmaps:Dictionary;
        private var _nameKeys:Dictionary;
        private var _definitions:Dictionary;
        private var _fallbackRuntimeAssets:Dictionary;
        private var _animatedRuntimeAssets:Dictionary;
        private var _runtimeAssetLoading:Dictionary;

        private var _previewSheet:BitmapData;
        private var _collectionSheet:BitmapData;
        private var _assetRoot:String;

        public function HabbiconAssetManager()
        {
            this.resetLoadedAssets();
        }

        public static function configure(configuration:IHabboConfigurationManager):void
        {
            _configuration = configuration;
            getInstance().refreshAssetRoot();
        }

        public static function preload():void
        {
            getInstance().ensureLoaded();
        }

        public static function getPreviewBitmap(habbiconId:int, small:Boolean):BitmapData
        {
            return getInstance().resolvePreviewBitmap(habbiconId, small);
        }

        public static function getHabbiconNameKey(habbiconId:int):String
        {
            return getInstance().resolveNameLocalizationKey(habbiconId);
        }

        public static function getCollectionIconBitmap(collectionId:int):BitmapData
        {
            return getInstance().resolveCollectionIconBitmap(collectionId);
        }

        public static function getOutlinedCollectionIconBitmap(collectionId:int):BitmapData
        {
            return getInstance().resolveOutlinedCollectionIconBitmap(collectionId);
        }

        public static function getRuntimeAsset(habbiconId:int):Object
        {
            return getInstance().resolveRuntimeAsset(habbiconId);
        }

        public static function getDirection(habbiconId:int):int
        {
            return getInstance().resolveDirection(habbiconId);
        }

        public static function addEventListener(type:String, listener:Function):void
        {
            _events.addEventListener(type, listener);
        }

        public static function removeEventListener(type:String, listener:Function):void
        {
            _events.removeEventListener(type, listener);
        }

        private static function getInstance():HabbiconAssetManager
        {
            if (_instance == null)
            {
                _instance = new HabbiconAssetManager();
            }
            return _instance;
        }

        private static function resampleBitmapData(source:BitmapData, scale:Number):BitmapData
        {
            if (source == null)
            {
                return null;
            }
            var result:BitmapData = new BitmapData(Math.max(1, int(source.width * scale)), Math.max(1, int(source.height * scale)), true, 0);
            var matrix:Matrix = new Matrix();
            matrix.scale(scale, scale);
            result.draw(source, matrix, null, null, null, true);
            return result;
        }

        private static function createOutlinedBitmap(source:BitmapData, size:int, color:uint):BitmapData
        {
            var dx:int;
            var dy:int;
            var result:BitmapData = new BitmapData(source.width + size * 2, source.height + size * 2, true, 0);
            var mask:BitmapData = new BitmapData(source.width, source.height, true, color);
            var point:Point = new Point();
            mask.copyChannel(source, source.rect, point, 8, 8);
            for (dx = -size; dx <= size; dx++)
            {
                for (dy = -size; dy <= size; dy++)
                {
                    if (dx != 0 || dy != 0)
                    {
                        point.x = size + dx;
                        point.y = size + dy;
                        result.copyPixels(mask, mask.rect, point, null, null, true);
                    }
                }
            }
            result.copyPixels(source, source.rect, new Point(size, size), null, null, true);
            mask.dispose();
            return result;
        }

        private function refreshAssetRoot():String
        {
            var root:String;
            var hash:String;
            if (_configuration == null)
            {
                return this._assetRoot;
            }
            root = _configuration.getProperty(ASSET_ROOT_KEY);
            hash = _configuration.getProperty(ASSET_HASH_KEY);
            if (root == null || root == "")
            {
                return this._assetRoot;
            }
            root = this.stripTrailingSlash(root);
            if (hash != null && hash != "" && (root.indexOf("{hash}") > -1 || root.indexOf("%hash%") > -1))
            {
                root = root.split("{hash}").join(hash);
                root = root.split("%hash%").join(hash);
            }
            else if (hash != null && hash != "" && !this.endsWithPathSegment(root, hash))
            {
                root += "/" + hash;
            }
            root += "/";
            if (this._assetRoot != root)
            {
                this.resetLoadedAssets();
                this._assetRoot = root;
            }
            return this._assetRoot;
        }

        private function resetLoadedAssets():void
        {
            this._loading = false;
            this._jsonLoaded = false;
            this._sheetLoaded = false;
            this._collectionSheetLoaded = false;
            this._failed = false;
            this._previewFrames = new Dictionary();
            this._collectionFrames = new Dictionary();
            this._previewBitmaps = new Dictionary();
            this._previewBitmapsSmall = new Dictionary();
            this._collectionBitmaps = new Dictionary();
            this._outlinedCollectionBitmaps = new Dictionary();
            this._nameKeys = new Dictionary();
            this._definitions = new Dictionary();
            this._fallbackRuntimeAssets = new Dictionary();
            this._animatedRuntimeAssets = new Dictionary();
            this._runtimeAssetLoading = new Dictionary();
            this._previewSheet = null;
            this._collectionSheet = null;
        }

        private function stripTrailingSlash(value:String):String
        {
            while (value.length > 0 && value.charAt(value.length - 1) == "/")
            {
                value = value.substr(0, value.length - 1);
            }
            return value;
        }

        private function endsWithPathSegment(value:String, segment:String):Boolean
        {
            return value == segment || value.lastIndexOf("/" + segment) == value.length - segment.length - 1;
        }

        private function resolvePreviewBitmap(habbiconId:int, small:Boolean):BitmapData
        {
            var frame:Object;
            var bitmap:BitmapData;
            this.ensureLoaded();
            bitmap = small ? this._previewBitmapsSmall[habbiconId] as BitmapData : this._previewBitmaps[habbiconId] as BitmapData;
            if (bitmap != null)
            {
                return bitmap;
            }
            if (!this._jsonLoaded || !this._sheetLoaded || this._previewSheet == null)
            {
                return null;
            }
            frame = this._previewFrames[habbiconId];
            if (frame == null)
            {
                return null;
            }
            bitmap = this.extractFrameBitmap(frame);
            if (bitmap == null)
            {
                return null;
            }
            this._previewBitmaps[habbiconId] = bitmap;
            if (small)
            {
                bitmap = resampleBitmapData(bitmap, 0.5);
                this._previewBitmapsSmall[habbiconId] = bitmap;
            }
            return bitmap;
        }

        private function resolveCollectionIconBitmap(collectionId:int):BitmapData
        {
            var frame:Object;
            var bitmap:BitmapData;
            this.ensureLoaded();
            bitmap = this._collectionBitmaps[collectionId] as BitmapData;
            if (bitmap != null)
            {
                return bitmap;
            }
            if (!this._jsonLoaded || !this._collectionSheetLoaded || this._collectionSheet == null)
            {
                return null;
            }
            frame = this._collectionFrames[collectionId];
            if (frame == null)
            {
                return null;
            }
            bitmap = this.extractFrameBitmapFromSheet(this._collectionSheet, frame);
            if (bitmap != null)
            {
                this._collectionBitmaps[collectionId] = bitmap;
            }
            return bitmap;
        }

        private function resolveOutlinedCollectionIconBitmap(collectionId:int):BitmapData
        {
            var bitmap:BitmapData = this._outlinedCollectionBitmaps[collectionId] as BitmapData;
            if (bitmap != null)
            {
                return bitmap;
            }
            var icon:BitmapData = this.resolveCollectionIconBitmap(collectionId);
            if (icon == null)
            {
                return null;
            }
            bitmap = createOutlinedBitmap(icon, COLLECTION_ICON_OUTLINE_SIZE, COLLECTION_ICON_OUTLINE_COLOR);
            this._outlinedCollectionBitmaps[collectionId] = bitmap;
            return bitmap;
        }

        private function resolveNameLocalizationKey(habbiconId:int):String
        {
            this.ensureLoaded();
            return this._nameKeys[habbiconId];
        }

        private function resolveDirection(habbiconId:int):int
        {
            this.ensureLoaded();
            var definition:HabbiconDefinition = this._definitions[habbiconId] as HabbiconDefinition;
            return definition != null ? definition.direction : 0;
        }

        private function resolveRuntimeAsset(habbiconId:int):Object
        {
            var definition:HabbiconDefinition;
            var asset:Object;
            this.ensureLoaded();
            asset = this._animatedRuntimeAssets[habbiconId];
            if (asset != null)
            {
                return asset;
            }
            definition = this._definitions[habbiconId] as HabbiconDefinition;
            if (definition == null)
            {
                return null;
            }
            if (definition.animated)
            {
                this.loadRuntimeAsset(habbiconId, definition);
            }
            asset = this._fallbackRuntimeAssets[habbiconId];
            if (asset == null)
            {
                asset = this.buildFallbackRuntimeAsset(habbiconId, definition);
                if (asset != null)
                {
                    this._fallbackRuntimeAssets[habbiconId] = asset;
                }
            }
            return asset;
        }

        private function ensureLoaded():void
        {
            var root:String;
            var metadata:URLLoader;
            var preview:Loader;
            var collection:Loader;
            if (this._loading || (this._jsonLoaded && this._sheetLoaded && this._collectionSheetLoaded) || this._failed)
            {
                return;
            }
            root = this.refreshAssetRoot();
            if (root == null || root == "")
            {
                this.markLoadFailed();
                return;
            }
            this._loading = true;
            metadata = new URLLoader();
            metadata.dataFormat = "text";
            metadata.addEventListener(Event.COMPLETE, this.onMetadataLoaded);
            metadata.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            metadata.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            metadata.load(new URLRequest(root + METADATA_FILE));

            preview = new Loader();
            preview.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onSpritesheetLoaded);
            preview.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            preview.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
            preview.load(new URLRequest(root + PREVIEW_SHEET_FILE));

            collection = new Loader();
            collection.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onCollectionSpritesheetLoaded);
            collection.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onCollectionLoadError);
            collection.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onCollectionSecurityError);
            collection.load(new URLRequest(root + COLLECTION_SHEET_FILE));
        }

        private function onMetadataLoaded(event:Event):void
        {
            var data:Object;
            var item:Object;
            var habbicons:Array;
            var collections:Array;
            var width:int;
            var height:int;
            var loader:URLLoader = event.currentTarget as URLLoader;
            this.removeTextLoaderListeners(loader);
            try
            {
                data = JSON.parse(loader.data as String);
                habbicons = data != null && data.habbicons is Array ? data.habbicons as Array : [];
                for each (item in habbicons)
                {
                    if (item != null && item.id != null)
                    {
                        width = this.normalizeDimension(item.width);
                        height = this.normalizeDimension(item.height);
                        this._previewFrames[int(item.id)] = {"x":int(item.x), "y":int(item.y), "width":width, "height":height};
                        if (item.name != null)
                        {
                            this._nameKeys[int(item.id)] = String(item.name);
                        }
                        this._definitions[int(item.id)] = this.buildDefinition(item, width, height);
                    }
                }
                collections = data != null && data.collectionIcons is Array ? data.collectionIcons as Array : [];
                for each (item in collections)
                {
                    if (item != null && item.id != null)
                    {
                        this._collectionFrames[int(item.id)] = {"x":int(item.x), "y":int(item.y), "width":this.normalizeDimension(item.width, DEFAULT_COLLECTION_ICON_SIZE), "height":this.normalizeDimension(item.height, DEFAULT_COLLECTION_ICON_SIZE)};
                    }
                }
                this._jsonLoaded = true;
                this.checkLoadCompletion();
            }
            catch (error:Error)
            {
                Logger.log("[HabbiconAssetManager] Failed to parse habbicon metadata: " + error.message);
                this.markLoadFailed();
            }
        }

        private function onSpritesheetLoaded(event:Event):void
        {
            var loader:Loader = event.currentTarget.loader as Loader;
            var bitmap:Bitmap = loader != null ? loader.content as Bitmap : null;
            this.removeImageLoaderListeners(loader);
            if (bitmap == null || bitmap.bitmapData == null)
            {
                Logger.log("[HabbiconAssetManager] Loaded habbicon spritesheet without bitmap data.");
                this.markLoadFailed();
                return;
            }
            this._previewSheet = bitmap.bitmapData;
            this._sheetLoaded = true;
            this.checkLoadCompletion();
        }

        private function onCollectionSpritesheetLoaded(event:Event):void
        {
            var loader:Loader = event.currentTarget.loader as Loader;
            var bitmap:Bitmap = loader != null ? loader.content as Bitmap : null;
            this.removeImageLoaderListeners(loader, this.onCollectionSpritesheetLoaded, this.onCollectionLoadError, this.onCollectionSecurityError);
            if (bitmap != null && bitmap.bitmapData != null)
            {
                this._collectionSheet = bitmap.bitmapData;
            }
            this._collectionSheetLoaded = true;
            this.checkLoadCompletion();
        }

        private function onLoadError(event:IOErrorEvent):void
        {
            Logger.log("[HabbiconAssetManager] Failed to load habbicon asset: " + event.text);
            this.markLoadFailed();
        }

        private function onCollectionLoadError(event:IOErrorEvent):void
        {
            var loader:Loader = event.currentTarget.loader as Loader;
            this.removeImageLoaderListeners(loader, this.onCollectionSpritesheetLoaded, this.onCollectionLoadError, this.onCollectionSecurityError);
            Logger.log("[HabbiconAssetManager] Failed to load habbicon collection icon asset: " + event.text);
            this._collectionSheetLoaded = true;
            this.checkLoadCompletion();
        }

        private function onSecurityError(event:SecurityErrorEvent):void
        {
            Logger.log("[HabbiconAssetManager] Security error while loading habbicon asset: " + event.text);
            this.markLoadFailed();
        }

        private function onCollectionSecurityError(event:SecurityErrorEvent):void
        {
            var loader:Loader = event.currentTarget.loader as Loader;
            this.removeImageLoaderListeners(loader, this.onCollectionSpritesheetLoaded, this.onCollectionLoadError, this.onCollectionSecurityError);
            Logger.log("[HabbiconAssetManager] Security error while loading habbicon collection icon asset: " + event.text);
            this._collectionSheetLoaded = true;
            this.checkLoadCompletion();
        }

        private function markLoadFailed():void
        {
            this._loading = false;
            this._failed = true;
        }

        private function checkLoadCompletion():void
        {
            if (this._jsonLoaded && this._sheetLoaded && this._collectionSheetLoaded)
            {
                this._loading = false;
                _events.dispatchEvent(new Event(ASSETS_LOADED));
            }
        }

        private function buildDefinition(data:Object, width:int, height:int):HabbiconDefinition
        {
            var animation:Object = data.animation;
            var frameData:Array = data.frameData is Array ? data.frameData as Array : [];
            var steps:Array = animation != null && animation.steps is Array ? animation.steps as Array : [];
            var speed:Number = animation != null && animation.playbackSpeed != null ? Number(animation.playbackSpeed) : 1;
            if (isNaN(speed) || speed <= 0)
            {
                speed = 1;
            }
            var animated:Boolean = int(data.frameCount) > 1 && frameData.length > 0 && steps.length > 0;
            return new HabbiconDefinition(width, height, this.normalizeDirection(data.dir), animated, data != null && data.loop, this.buildRuntimeFrameDefinitions(frameData, width, height), this.buildRuntimeAnimationSteps(steps, speed));
        }

        private function buildRuntimeFrameDefinitions(frameData:Array, width:int, height:int):Array
        {
            var result:Array = [];
            var frame:Object;
            if (frameData == null)
            {
                return result;
            }
            for each (frame in frameData)
            {
                if (frame != null)
                {
                    result.push({"id":int(frame.id), "x":int(frame.x), "y":int(frame.y), "width":this.normalizeDimension(frame.width, width), "height":this.normalizeDimension(frame.height, height)});
                }
            }
            result.sortOn("id", Array.NUMERIC);
            return result;
        }

        private function buildRuntimeAnimationSteps(steps:Array, speed:Number):Array
        {
            var result:Array = [];
            var step:Object;
            var duration:int;
            if (steps == null)
            {
                return result;
            }
            for each (step in steps)
            {
                if (step != null && step.enabled !== false)
                {
                    duration = Math.max(1, int(step.durationMs));
                    duration = Math.max(1, int(duration / speed));
                    result.push({"sourceFrame":Math.max(0, int(step.sourceFrame)), "durationMs":duration});
                }
            }
            return result;
        }

        private function buildFallbackRuntimeAsset(habbiconId:int, definition:HabbiconDefinition):Object
        {
            var bitmap:BitmapData = this.resolvePreviewBitmap(habbiconId, false);
            var smallBitmap:BitmapData = this.resolvePreviewBitmap(habbiconId, true);
            if (bitmap == null)
            {
                return null;
            }
            return {"animated":false, "loop":false, "direction":definition.direction, "baseWidth":bitmap.width, "baseHeight":bitmap.height, "frames":[{"bitmap":bitmap, "smallBitmap":smallBitmap != null ? smallBitmap : bitmap, "width":bitmap.width, "height":bitmap.height}], "steps":[{"sourceFrame":0, "durationMs":0}], "playbackDurationMs":0};
        }

        private function loadRuntimeAsset(habbiconId:int, definition:HabbiconDefinition):void
        {
            var root:String;
            var loader:Loader;
            if (definition == null || !definition.animated || this._runtimeAssetLoading[habbiconId] || this._animatedRuntimeAssets[habbiconId] != null)
            {
                return;
            }
            root = this.refreshAssetRoot();
            if (root == null || root == "")
            {
                return;
            }
            this._runtimeAssetLoading[habbiconId] = true;
            loader = new Loader();
            loader.name = String(habbiconId);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onRuntimeSheetLoaded);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onRuntimeLoadError);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onRuntimeSecurityError);
            loader.load(new URLRequest(root + ANIMATION_PATH + habbiconId + ".png"));
        }

        private function onRuntimeSheetLoaded(event:Event):void
        {
            var loader:Loader = event.currentTarget.loader as Loader;
            var bitmap:Bitmap = loader != null ? loader.content as Bitmap : null;
            var habbiconId:int = int(loader != null ? loader.name : "0");
            var definition:HabbiconDefinition = this._definitions[habbiconId] as HabbiconDefinition;
            this.removeImageLoaderListeners(loader, this.onRuntimeSheetLoaded, this.onRuntimeLoadError, this.onRuntimeSecurityError);
            delete this._runtimeAssetLoading[habbiconId];
            if (bitmap == null || bitmap.bitmapData == null || definition == null)
            {
                return;
            }
            this._animatedRuntimeAssets[habbiconId] = this.buildAnimatedRuntimeAsset(definition, bitmap.bitmapData);
        }

        private function onRuntimeLoadError(event:IOErrorEvent):void
        {
            var loader:Loader = event.currentTarget.loader as Loader;
            if (loader != null)
            {
                this.removeImageLoaderListeners(loader, this.onRuntimeSheetLoaded, this.onRuntimeLoadError, this.onRuntimeSecurityError);
                delete this._runtimeAssetLoading[int(loader.name)];
            }
            Logger.log("[HabbiconAssetManager] Failed to load habbicon runtime asset: " + event.text);
        }

        private function onRuntimeSecurityError(event:SecurityErrorEvent):void
        {
            var loader:Loader = event.currentTarget.loader as Loader;
            if (loader != null)
            {
                this.removeImageLoaderListeners(loader, this.onRuntimeSheetLoaded, this.onRuntimeLoadError, this.onRuntimeSecurityError);
                delete this._runtimeAssetLoading[int(loader.name)];
            }
            Logger.log("[HabbiconAssetManager] Security error while loading habbicon runtime asset: " + event.text);
        }

        private function buildAnimatedRuntimeAsset(definition:HabbiconDefinition, sheet:BitmapData):Object
        {
            var frames:Array = [];
            var frame:Object;
            var bitmap:BitmapData;
            var totalDuration:int = 0;
            var step:Object;
            if (definition == null || sheet == null || definition.frames == null || definition.frames.length == 0)
            {
                return null;
            }
            for each (frame in definition.frames)
            {
                bitmap = this.extractFrameBitmapFromSheet(sheet, frame);
                if (bitmap != null)
                {
                    frames.push({"bitmap":bitmap, "smallBitmap":resampleBitmapData(bitmap, 0.5), "width":bitmap.width, "height":bitmap.height});
                }
            }
            if (frames.length == 0)
            {
                return null;
            }
            for each (step in definition.steps)
            {
                totalDuration += Math.max(1, int(step.durationMs));
            }
            return {"animated":true, "loop":definition.loop, "direction":definition.direction, "baseWidth":definition.previewWidth, "baseHeight":definition.previewHeight, "frames":frames, "steps":definition.steps != null && definition.steps.length > 0 ? definition.steps : [{"sourceFrame":0, "durationMs":0}], "playbackDurationMs":totalDuration};
        }

        private function extractFrameBitmap(frame:Object):BitmapData
        {
            return this.extractFrameBitmapFromSheet(this._previewSheet, frame);
        }

        private function extractFrameBitmapFromSheet(sheet:BitmapData, frame:Object):BitmapData
        {
            var rect:Rectangle = this.createValidRectForSheet(sheet, int(frame.x), int(frame.y), int(frame.width), int(frame.height));
            if (rect == null)
            {
                return null;
            }
            var bitmap:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
            bitmap.copyPixels(sheet, rect, new Point(0, 0), null, null, true);
            return bitmap;
        }

        private function createValidRectForSheet(sheet:BitmapData, x:int, y:int, width:int, height:int):Rectangle
        {
            var rect:Rectangle;
            if (sheet == null)
            {
                return null;
            }
            rect = new Rectangle(x, sheet.height - y - height, width, height);
            if (this.isRectWithinBitmap(sheet, rect))
            {
                return rect;
            }
            rect = new Rectangle(x, y, width, height);
            if (this.isRectWithinBitmap(sheet, rect))
            {
                return rect;
            }
            return null;
        }

        private function isRectWithinBitmap(sheet:BitmapData, rect:Rectangle):Boolean
        {
            return sheet != null && rect.x >= 0 && rect.y >= 0 && rect.right <= sheet.width && rect.bottom <= sheet.height;
        }

        private function normalizeDimension(value:*, defaultValue:int = DEFAULT_FRAME_SIZE):int
        {
            var dimension:int = int(value);
            return dimension > 0 ? dimension : defaultValue;
        }

        private function normalizeDirection(value:*):int
        {
            if (value == null)
            {
                return 0;
            }
            var direction:int = int(value);
            if (direction < 0)
            {
                return -1;
            }
            if (direction > 0)
            {
                return 1;
            }
            return 0;
        }

        private function removeTextLoaderListeners(loader:URLLoader):void
        {
            if (loader == null)
            {
                return;
            }
            loader.removeEventListener(Event.COMPLETE, this.onMetadataLoaded);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
        }

        private function removeImageLoaderListeners(loader:Loader, complete:Function = null, ioError:Function = null, securityError:Function = null):void
        {
            if (loader == null || loader.contentLoaderInfo == null)
            {
                return;
            }
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete != null ? complete : this.onSpritesheetLoaded);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError != null ? ioError : this.onLoadError);
            loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError != null ? securityError : this.onSecurityError);
        }
    }
}
