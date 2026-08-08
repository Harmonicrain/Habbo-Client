package com.sulake.habbo.room.object.visualization.avatar.additions
{
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.room.object.visualization.avatar.AvatarVisualization;
    import com.sulake.room.object.visualization.IRoomObjectSprite;
    import flash.display.BitmapData;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;

    public class HabbiconBubble implements IAvatarAddition
    {
        private static const DEFAULT_VISIBLE_DURATION_MS:int = 3000;
        private static const INTRO_DURATION_MS:int = 180;
        private static const INTRO_START_OFFSET_Y:int = 12;
        private static const FADE_IN_DURATION_MS:int = 150;
        private static const FADE_OUT_DURATION_MS:int = 350;
        private static const BACKGROUND_VISIBLE_DURATION_MS:int = 3350;
        private static const BACKGROUND_FADE_OUT_DURATION_MS:int = 530;
        private static const ROOM_LARGE_OFFSET_X:int = -20;
        private static const ROOM_LARGE_OFFSET_Y:int = -126;
        private static const ROOM_SMALL_OFFSET_X:int = -10;
        private static const ROOM_SMALL_OFFSET_Y:int = -65;
        private static const DEFAULT_RELATIVE_DEPTH:Number = -0.2;
        private static const OUTLINE_SIZE:int = 2;
        private static const OUTLINE_COLOR:uint = 0xFFFFFFFF;
        private static const BACKGROUND_SHADOW_PADDING:int = 5;
        private static const BACKGROUND_CONTENT_INSET:int = 7;
        private static const BACKGROUND_SHADOW_OFFSET_X:Number = 1.5;
        private static const BACKGROUND_SHADOW_OFFSET_Y:Number = 2;
        private static const BACKGROUND_SHADOW_BLUR:int = 6;
        private static const BACKGROUND_SHADOW_ALPHA:Number = 0.55;
        private static const BACKGROUND_SHADOW_QUALITY:int = 2;
        private static const BACKGROUND_SHADOW_COLOR:uint = 0;

        private static const _outlineCache:Object = {};
        private static const _mirrorCache:Object = {};
        private static const _shadowCache:Object = {};

        private var _id:int = -1;
        private var _habbiconId:int;
        private var _triggerSequence:int;
        private var _avatar:AvatarVisualization;
        private var _scale:Number = 64;
        private var _startTime:int = 0;
        private var _sourceFadeStart:int = 0;
        private var _sourceHiddenAt:int = 0;
        private var _backgroundFadeStart:int = 0;
        private var _backgroundHiddenAt:int = 0;
        private var _hideAt:int = 0;
        private var _runtimeAsset:Object;
        private var _animated:Boolean = false;
        private var _currentFrameIndex:int = -1;
        private var _bitmap:BitmapData;
        private var _bitmapShared:Boolean = false;
        private var _bitmapHasSource:Boolean = false;
        private var _bitmapBaseDimension:int = 0;
        private var _lastSourceAlpha:int = -1;
        private var _lastBackgroundAlpha:int = -1;
        private var _mirroringResolved:Boolean = false;
        private var _mirror:Boolean = false;
        private var _initialized:Boolean = false;
        private var _hidden:Boolean = false;
        private var _relativeDepth:Number = DEFAULT_RELATIVE_DEPTH;

        public function HabbiconBubble(id:int, habbiconId:int, triggerSequence:int, avatar:AvatarVisualization)
        {
            this._id = id;
            this._habbiconId = habbiconId;
            this._triggerSequence = triggerSequence;
            this._avatar = avatar;
        }

        public function get id():int
        {
            return this._id;
        }

        public function get habbiconId():int
        {
            return this._habbiconId;
        }

        public function get triggerSequence():int
        {
            return this._triggerSequence;
        }

        public function get disposed():Boolean
        {
            return this._avatar == null;
        }

        public function set relativeDepth(value:Number):void
        {
            this._relativeDepth = value;
        }

        public function dispose():void
        {
            if (this._bitmap != null && !this._bitmapShared)
            {
                this._bitmap.dispose();
            }
            this._bitmap = null;
            this._runtimeAsset = null;
            this._avatar = null;
            this._bitmapShared = false;
            this._bitmapHasSource = false;
            this._initialized = false;
            this._hidden = false;
        }

        public function update(sprite:IRoomObjectSprite, scale:Number):void
        {
            var firstUpdate:Boolean;
            var elapsed:int;
            var baseSize:int;

            if (sprite == null)
            {
                return;
            }

            if (this._hidden || (this._hideAt > 0 && getTimer() >= this._hideAt))
            {
                this._hidden = true;
                sprite.alpha = 0;
                sprite.visible = false;
                return;
            }

            this._scale = scale;
            firstUpdate = !this._initialized;
            if (firstUpdate)
            {
                this._runtimeAsset = HabbiconAssetManager.getRuntimeAsset(this._habbiconId);
                this._animated = this._runtimeAsset != null && Boolean(this._runtimeAsset.animated);
                this._startTime = getTimer();
                this._currentFrameIndex = this.resolveFrameIndex(0);
                this.configureTiming();
                this.applyFrame(this.resolveBitmap(scale, this.resolveSourceAlpha(this._startTime), this.resolveBackgroundAlpha(this._startTime)));
                this._initialized = true;
            }

            elapsed = getTimer() - this._startTime;
            baseSize = scale < 48 ? 32 : 64;
            sprite.asset = this._bitmap;
            sprite.offsetX = (scale < 48 ? ROOM_SMALL_OFFSET_X : ROOM_LARGE_OFFSET_X) + this.resolveFrameAnchorCompensationX();
            sprite.offsetY = (scale < 48 ? ROOM_SMALL_OFFSET_Y : ROOM_LARGE_OFFSET_Y) + this.getIntroOffsetY(elapsed) + this.resolveFrameAnchorCompensationY();

            if (this._avatar != null)
            {
                if (this._avatar.posture == "sit")
                {
                    sprite.offsetY += baseSize / 2;
                }
                else if (this._avatar.posture == "lay")
                {
                    sprite.offsetY += baseSize;
                }
            }

            sprite.relativeDepth = this._relativeDepth;
            if (firstUpdate)
            {
                sprite.visible = true;
                sprite.alpha = 255;
            }
        }

        public function animate(sprite:IRoomObjectSprite):Boolean
        {
            var previousAsset:Object;
            var now:int;
            var elapsed:int;
            var frameIndex:int;
            var sourceAlpha:int;
            var backgroundAlpha:int;
            var dirty:Boolean = false;
            var baseSize:int = 64;
            var maxAlpha:int;

            if (sprite == null)
            {
                return false;
            }

            now = getTimer();
            elapsed = now - this._startTime;
            previousAsset = this._runtimeAsset;
            this._runtimeAsset = HabbiconAssetManager.getRuntimeAsset(this._habbiconId);
            if (this._runtimeAsset != previousAsset)
            {
                this._animated = this._runtimeAsset != null && Boolean(this._runtimeAsset.animated);
                this.configureTiming();
                dirty = true;
            }

            frameIndex = this.resolveFrameIndex(elapsed);
            if (this._runtimeAsset != null && frameIndex != this._currentFrameIndex)
            {
                this._currentFrameIndex = frameIndex;
                dirty = true;
            }

            sourceAlpha = this.resolveSourceAlpha(now);
            backgroundAlpha = this.resolveBackgroundAlpha(now);
            if (sourceAlpha != this._lastSourceAlpha || backgroundAlpha != this._lastBackgroundAlpha)
            {
                dirty = true;
            }

            if (dirty)
            {
                this.applyFrame(this.resolveBitmap(this._scale, sourceAlpha, backgroundAlpha));
            }

            if (this._bitmap != null)
            {
                sprite.asset = this._bitmap;
            }

            baseSize = this._scale < 48 ? 32 : 64;
            sprite.relativeDepth = this._relativeDepth;
            sprite.offsetX = (this._scale < 48 ? ROOM_SMALL_OFFSET_X : ROOM_LARGE_OFFSET_X) + this.resolveFrameAnchorCompensationX();
            sprite.offsetY = (this._scale < 48 ? ROOM_SMALL_OFFSET_Y : ROOM_LARGE_OFFSET_Y) + this.getIntroOffsetY(elapsed) + this.resolveFrameAnchorCompensationY();
            if (this._avatar != null)
            {
                if (this._avatar.posture == "sit")
                {
                    sprite.offsetY += baseSize / 2;
                }
                else if (this._avatar.posture == "lay")
                {
                    sprite.offsetY += baseSize;
                }
            }

            if (now >= this._hideAt)
            {
                this._hidden = true;
                sprite.alpha = 0;
                sprite.visible = false;
                return true;
            }

            maxAlpha = Math.max(sourceAlpha, backgroundAlpha);
            sprite.alpha = 255;
            sprite.visible = maxAlpha > 0;
            return true;
        }

        private static function getOutlineBitmap(source:BitmapData, key:String):BitmapData
        {
            var bitmap:BitmapData = _outlineCache[key] as BitmapData;
            if (bitmap != null)
            {
                return bitmap;
            }
            bitmap = createOutlineBitmap(source);
            _outlineCache[key] = bitmap;
            return bitmap;
        }

        private static function createOutlineBitmap(source:BitmapData):BitmapData
        {
            var dx:int;
            var dy:int;
            var result:BitmapData = new BitmapData(source.width + OUTLINE_SIZE * 2, source.height + OUTLINE_SIZE * 2, true, 0);
            var mask:BitmapData = new BitmapData(source.width, source.height, true, OUTLINE_COLOR);
            var point:Point = new Point();
            mask.copyChannel(source, source.rect, point, 8, 8);
            for (dy = -OUTLINE_SIZE; dy <= OUTLINE_SIZE; dy++)
            {
                for (dx = -OUTLINE_SIZE; dx <= OUTLINE_SIZE; dx++)
                {
                    if (dx != 0 || dy != 0)
                    {
                        point.x = OUTLINE_SIZE + dx;
                        point.y = OUTLINE_SIZE + dy;
                        result.copyPixels(mask, mask.rect, point, null, null, true);
                    }
                }
            }
            mask.dispose();
            return result;
        }

        private static function getMirroredBitmap(source:BitmapData, key:String):BitmapData
        {
            var bitmap:BitmapData = _mirrorCache[key] as BitmapData;
            if (bitmap != null)
            {
                return bitmap;
            }
            bitmap = createMirroredBitmap(source);
            _mirrorCache[key] = bitmap;
            return bitmap;
        }

        private static function createMirroredBitmap(source:BitmapData):BitmapData
        {
            var bitmap:BitmapData = new BitmapData(source.width, source.height, true, 0);
            var matrix:Matrix = new Matrix();
            matrix.scale(-1, 1);
            matrix.translate(source.width, 0);
            bitmap.draw(source, matrix, null, null, null, false);
            return bitmap;
        }

        private static function getBackgroundShadowBitmap(outline:BitmapData, key:String):BitmapData
        {
            var bitmap:BitmapData = _shadowCache[key] as BitmapData;
            if (bitmap != null)
            {
                return bitmap;
            }
            bitmap = createBackgroundShadowBitmap(outline);
            _shadowCache[key] = bitmap;
            return bitmap;
        }

        private static function createBackgroundShadowBitmap(outline:BitmapData):BitmapData
        {
            var result:BitmapData = new BitmapData(outline.width + BACKGROUND_SHADOW_PADDING * 2, outline.height + BACKGROUND_SHADOW_PADDING * 2, true, 0);
            var shadowLayer:BitmapData = new BitmapData(result.width, result.height, true, 0);
            var alphaMask:BitmapData = new BitmapData(outline.width, outline.height, true, 0xFF000000 | BACKGROUND_SHADOW_COLOR);
            var filter:BlurFilter = new BlurFilter(BACKGROUND_SHADOW_BLUR, BACKGROUND_SHADOW_BLUR, BACKGROUND_SHADOW_QUALITY);
            alphaMask.copyChannel(outline, outline.rect, new Point(), 8, 8);
            shadowLayer.copyPixels(alphaMask, alphaMask.rect, new Point(BACKGROUND_SHADOW_PADDING + BACKGROUND_SHADOW_OFFSET_X, BACKGROUND_SHADOW_PADDING + BACKGROUND_SHADOW_OFFSET_Y), null, null, true);
            shadowLayer.colorTransform(shadowLayer.rect, new ColorTransform(1, 1, 1, BACKGROUND_SHADOW_ALPHA));
            result.applyFilter(shadowLayer, shadowLayer.rect, new Point(), filter);
            alphaMask.dispose();
            shadowLayer.dispose();
            return result;
        }

        private static function drawBitmapLayer(target:BitmapData, source:BitmapData, x:int, y:int, alpha:int):void
        {
            var matrix:Matrix;
            if (alpha <= 0)
            {
                return;
            }
            if (alpha >= 255)
            {
                target.copyPixels(source, source.rect, new Point(x, y), null, null, true);
                return;
            }
            matrix = new Matrix();
            matrix.translate(x, y);
            target.draw(source, matrix, new ColorTransform(1, 1, 1, alpha / 255));
        }

        private function configureTiming():void
        {
            this._sourceHiddenAt = this._startTime + DEFAULT_VISIBLE_DURATION_MS;
            this._sourceFadeStart = this._sourceHiddenAt - FADE_OUT_DURATION_MS;
            this._backgroundHiddenAt = this._startTime + BACKGROUND_VISIBLE_DURATION_MS;
            this._backgroundFadeStart = this._backgroundHiddenAt - BACKGROUND_FADE_OUT_DURATION_MS;
            this._hideAt = Math.max(this._sourceHiddenAt, this._backgroundHiddenAt);
        }

        private function resolveFrameIndex(elapsed:int):int
        {
            var step:Object = this.getCurrentStep(elapsed);
            if (this._runtimeAsset == null || this._runtimeAsset.frames == null || this._runtimeAsset.frames.length == 0 || step == null)
            {
                return 0;
            }
            return Math.max(0, Math.min(int(step.sourceFrame), this._runtimeAsset.frames.length - 1));
        }

        private function getCurrentStep(elapsed:int):Object
        {
            var steps:Array;
            var total:int = 0;
            var step:Object;
            var cursor:int = 0;
            if (this._runtimeAsset == null || !(this._runtimeAsset.steps is Array) || this._runtimeAsset.steps.length == 0)
            {
                return null;
            }
            steps = this._runtimeAsset.steps as Array;
            if (steps.length == 1)
            {
                return steps[0];
            }
            for each (step in steps)
            {
                total += Math.max(1, int(step.durationMs));
            }
            if (total <= 0)
            {
                return steps[0];
            }
            if (this._animated)
            {
                elapsed %= total;
            }
            else if (elapsed >= total)
            {
                return steps[steps.length - 1];
            }
            for each (step in steps)
            {
                cursor += Math.max(1, int(step.durationMs));
                if (elapsed < cursor)
                {
                    return step;
                }
            }
            return steps[steps.length - 1];
        }

        private function getIntroOffsetY(elapsed:int):int
        {
            var progress:Number = Math.min(1, Math.max(0, elapsed / INTRO_DURATION_MS));
            return int(Math.round((1 - progress) * INTRO_START_OFFSET_Y));
        }

        private function resolveSourceAlpha(now:int):int
        {
            var fadeIn:Number = Math.min(1, Math.max(0, (now - this._startTime) / FADE_IN_DURATION_MS));
            var fadeOut:Number = now < this._sourceFadeStart ? 1 : 1 - Math.min(1, Math.max(0, (now - this._sourceFadeStart) / FADE_OUT_DURATION_MS));
            if (this._sourceHiddenAt > 0 && now >= this._sourceHiddenAt)
            {
                return 0;
            }
            return int(Math.round(255 * Math.min(fadeIn, fadeOut)));
        }

        private function resolveBackgroundAlpha(now:int):int
        {
            var fadeIn:Number = Math.min(1, Math.max(0, (now - this._startTime) / FADE_IN_DURATION_MS));
            var fadeOut:Number = now < this._backgroundFadeStart ? 1 : 1 - Math.min(1, Math.max(0, (now - this._backgroundFadeStart) / BACKGROUND_FADE_OUT_DURATION_MS));
            return int(Math.round(255 * Math.min(fadeIn, fadeOut)));
        }

        private function resolveBitmap(scale:Number, sourceAlpha:int = -1, backgroundAlpha:int = -1):BitmapData
        {
            var source:BitmapData;
            var frames:Array;
            var cacheKey:String;
            var outline:BitmapData;
            var frame:Object;
            var baseDimension:int = scale < 48 ? 20 : 40;
            var small:Boolean = scale < 48;
            if (sourceAlpha < 0)
            {
                sourceAlpha = this.resolveSourceAlpha(getTimer());
            }
            if (backgroundAlpha < 0)
            {
                backgroundAlpha = this.resolveBackgroundAlpha(getTimer());
            }
            this._bitmapShared = false;
            this._bitmapHasSource = false;
            this._bitmapBaseDimension = baseDimension;
            if (this._runtimeAsset != null && this._runtimeAsset.frames is Array && this._runtimeAsset.frames.length > 0)
            {
                frames = this._runtimeAsset.frames as Array;
                if (this._currentFrameIndex < 0 || this._currentFrameIndex >= frames.length)
                {
                    this._currentFrameIndex = 0;
                }
                frame = frames[this._currentFrameIndex];
                source = small ? frame.smallBitmap as BitmapData : frame.bitmap as BitmapData;
            }
            else
            {
                source = HabbiconAssetManager.getPreviewBitmap(this._habbiconId, small);
            }
            if (source != null)
            {
                this._bitmapHasSource = true;
                this._bitmapBaseDimension = source.width + OUTLINE_SIZE * 2 + BACKGROUND_SHADOW_PADDING * 2;
                this._lastSourceAlpha = sourceAlpha;
                this._lastBackgroundAlpha = backgroundAlpha;
                cacheKey = this.createOutlineBitmapCacheKey(small);
                if (this.shouldMirrorHabbicon())
                {
                    cacheKey += ":mirrored";
                    source = getMirroredBitmap(source, cacheKey);
                }
                outline = getOutlineBitmap(source, cacheKey);
                return this.composeBitmap(source, outline, getBackgroundShadowBitmap(outline, cacheKey), this._bitmap, sourceAlpha, backgroundAlpha);
            }
            if (this._bitmap != null && !this._bitmapShared && this._bitmapBaseDimension == baseDimension)
            {
                return this._bitmap;
            }
            return this.createFallbackBitmap(baseDimension, this.seededColor(this._habbiconId * 37));
        }

        private function applyFrame(bitmap:BitmapData):void
        {
            this.setBitmap(bitmap, this._bitmapShared, this._bitmapBaseDimension, this._bitmapHasSource);
        }

        private function setBitmap(bitmap:BitmapData, shared:Boolean, baseDimension:int, hasSource:Boolean):void
        {
            if (this._bitmap === bitmap)
            {
                this._bitmapShared = shared;
                this._bitmapBaseDimension = baseDimension;
                this._bitmapHasSource = hasSource;
                return;
            }
            if (this._bitmap != null && !this._bitmapShared)
            {
                this._bitmap.dispose();
            }
            this._bitmap = bitmap;
            this._bitmapShared = shared;
            this._bitmapBaseDimension = baseDimension;
            this._bitmapHasSource = hasSource;
        }

        private function resolveFrameAnchorCompensationX():int
        {
            var baseWidth:int;
            if (this._bitmap == null)
            {
                return 0;
            }
            if (this._runtimeAsset == null)
            {
                return this._bitmapHasSource ? -BACKGROUND_CONTENT_INSET : 0;
            }
            baseWidth = this.resolveBaseDimension("baseWidth");
            return int(Math.round((baseWidth - this._bitmap.width) * 0.5));
        }

        private function resolveFrameAnchorCompensationY():int
        {
            var baseHeight:int;
            if (this._bitmap == null)
            {
                return 0;
            }
            if (this._runtimeAsset == null)
            {
                return this._bitmapHasSource ? -BACKGROUND_CONTENT_INSET : 0;
            }
            baseHeight = this.resolveBaseDimension("baseHeight");
            return baseHeight - this._bitmap.height + (this._bitmapHasSource ? BACKGROUND_CONTENT_INSET : 0);
        }

        private function resolveBaseDimension(propertyName:String):int
        {
            var value:int = int(this._runtimeAsset[propertyName]);
            if (this._scale < 48)
            {
                return Math.max(1, int(Math.round(value * 0.5)));
            }
            return Math.max(1, value);
        }

        private function createFallbackBitmap(size:int, color:uint):BitmapData
        {
            var bitmap:BitmapData = new BitmapData(size, size, true, 0);
            var outer:int = Math.max(2, size / 8);
            var inner:int = Math.max(1, size / 4);
            bitmap.fillRect(bitmap.rect, 0);
            bitmap.fillRect(new Rectangle(outer, outer, size - outer * 2, size - outer * 2), 0xFF000000 | color);
            bitmap.fillRect(new Rectangle(inner, inner, size - inner * 2, size - inner * 2), OUTLINE_COLOR);
            return bitmap;
        }

        private function createOutlineBitmapCacheKey(small:Boolean):String
        {
            var hasRuntime:Boolean = this._runtimeAsset != null && this._runtimeAsset.frames is Array && this._runtimeAsset.frames.length > 0;
            var sourceType:String = hasRuntime ? (this._runtimeAsset.animated ? "animated" : "runtime") : "preview";
            return this._habbiconId + ":" + sourceType + ":" + (small ? "small" : "large") + ":" + this._currentFrameIndex;
        }

        private function shouldMirrorHabbicon():Boolean
        {
            var avatarDirection:int;
            var habbiconDirection:int;
            if (!this._mirroringResolved)
            {
                avatarDirection = int(this._avatar != null ? this._avatar.habbiconFacingDirection : 0);
                habbiconDirection = HabbiconAssetManager.getDirection(this._habbiconId);
                this._mirror = avatarDirection != 0 && habbiconDirection != 0 && avatarDirection != habbiconDirection;
                this._mirroringResolved = true;
            }
            return this._mirror;
        }

        private function composeBitmap(source:BitmapData, outline:BitmapData, shadow:BitmapData, reuse:BitmapData, sourceAlpha:int, backgroundAlpha:int):BitmapData
        {
            var result:BitmapData;
            if (reuse != null && !this._bitmapShared && reuse.width == shadow.width && reuse.height == shadow.height)
            {
                result = reuse;
                result.fillRect(result.rect, 0);
            }
            else
            {
                result = new BitmapData(shadow.width, shadow.height, true, 0);
            }
            drawBitmapLayer(result, shadow, 0, 0, backgroundAlpha);
            drawBitmapLayer(result, outline, BACKGROUND_SHADOW_PADDING, BACKGROUND_SHADOW_PADDING, backgroundAlpha);
            drawBitmapLayer(result, source, BACKGROUND_CONTENT_INSET, BACKGROUND_CONTENT_INSET, sourceAlpha);
            return result;
        }

        private function seededColor(value:int):uint
        {
            switch (value % 6)
            {
                case 0:
                    return 0xF9C92F;
                case 1:
                    return 0xF39E2F;
                case 2:
                    return 0xEF822F;
                case 3:
                    return 0x8EDBFF;
                case 4:
                    return 0x4DC5A8;
                default:
                    return 0xC37DF5;
            }
        }
    }
}
