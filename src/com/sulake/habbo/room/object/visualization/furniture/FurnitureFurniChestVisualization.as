package com.sulake.habbo.room.object.visualization.furniture
{
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.visualization.utils.IGraphicAsset;
    import com.sulake.room.utils.IRoomGeometry;
    import flash.filters.GlowFilter;

    public class FurnitureFurniChestVisualization extends FurnitureChestVisualization
    {
        private static const FLOATING_ICON_TAG_PREFIX:String = "floating_icon_";
        private static const MAX_FLOATING_ICONS:int = 4;
        private static const FLOATING_PIXELS:int = 2;
        private static const FLOAT_STEP_MILLISECONDS:int = 300;
        private static const FLOATING_ICON_GLOW_FILTER:Array = [new GlowFilter(0xFFFFFF, 1, 2, 2, 10, 1, false, false)];
        private static const ICON_POSITIONING:Array = [
            [],
            [[0, -68, 17, 17]],
            [[16, -70, 4, 4], [-14, -59, 4, 4]],
            [[12, -52, 2, 2], [-17, -70, 3, 2], [17, -87, 7, 2]],
            [[14, -50, 2, 2], [-14, -59, 2, 2], [19, -78, 4, 2], [-20, -90, 4, 2]]
        ];

        private var _iconAssets:Vector.<IGraphicAsset>;
        private var _lastAssetsString:String = "";
        private var _assetNames:Array = [];
        private var _flippedLayout:Boolean = false;
        private var _iconData:Array = [];
        private var _floatStep:int = 0;
        private var _lastFloatUpdate:int = -1;
        private var _lastUpdateTime:int = -1000;

        override public function update(geometry:IRoomGeometry, time:int, update:Boolean, skipAnimation:Boolean):void
        {
            if (time < this._lastUpdateTime + 41)
            {
                return;
            }
            this._lastUpdateTime += 41;
            if (this._lastUpdateTime + 41 < time)
            {
                this._lastUpdateTime = time - 41;
            }
            super.update(geometry, time, update, skipAnimation);
        }

        override protected function updateModel(scale:Number):Boolean
        {
            var changed:Boolean = super.updateModel(scale);
            if (object == null || object.getModel() == null)
            {
                return changed;
            }

            var assetsString:String = object.getModel().getString(RoomObjectVariableEnum.FURNITURE_FURNI_CHEST_SHOWN_ASSET_NAMES);
            if (assetsString == null || scale != 64)
            {
                assetsString = "";
            }
            if (this._lastAssetsString != assetsString)
            {
                this._lastAssetsString = assetsString;
                this._assetNames = assetsString.length == 0 ? [] : assetsString.split(",");
                this.createIconAssets();
                changed = true;
            }
            return changed;
        }

        override protected function updateObject(scale:Number, cameraAngle:Number):Boolean
        {
            var changed:Boolean = super.updateObject(scale, cameraAngle);
            if (this._lastUpdateTime - this._lastFloatUpdate > FLOAT_STEP_MILLISECONDS)
            {
                changed = true;
                this._lastFloatUpdate = this._lastUpdateTime;
                this._floatStep++;
                if (this._floatStep >= FLOATING_PIXELS * 2)
                {
                    this._floatStep = 0;
                }
            }
            return changed;
        }

        override protected function getAdditionalSpriteCount():int
        {
            return super.getAdditionalSpriteCount() + MAX_FLOATING_ICONS;
        }

        override protected function getSpriteAssetName(size:int, spriteIndex:int):String
        {
            if (!this.isFloatingIcon(spriteIndex) || size != 64)
            {
                return super.getSpriteAssetName(size, spriteIndex);
            }
            var iconIndex:int = spriteIndex - spriteCount + MAX_FLOATING_ICONS;
            if (iconIndex < 0 || iconIndex >= this._assetNames.length)
            {
                return super.getSpriteAssetName(size, spriteIndex);
            }
            return this._assetNames[iconIndex];
        }

        private function isFloatingIcon(spriteIndex:int):Boolean
        {
            var iconIndex:int = spriteIndex - spriteCount + MAX_FLOATING_ICONS;
            return iconIndex >= 0 && iconIndex < this._iconData.length;
        }

        override protected function reset():void
        {
            super.reset();
            this.clearIconAssets();
            this._iconData = [];
            this._assetNames = [];
            this._lastAssetsString = "";
        }

        private function clearIconAssets():void
        {
            this._iconAssets = null;
        }

        private function createIconAssets():void
        {
            this._iconAssets = new Vector.<IGraphicAsset>();
            this._iconData = [];
            this._flippedLayout = Math.random() < 0.5;
            this._floatStep = 0;
            this._lastFloatUpdate = this._lastUpdateTime;

            var iconCount:int = Math.min(MAX_FLOATING_ICONS, this._assetNames.length);
            for (var iconIndex:int = 0; iconIndex < iconCount; iconIndex++)
            {
                var assetName:String = this._assetNames[iconIndex];
                var asset:IGraphicAsset = assetCollection == null || assetName == null || assetName == "" ? null : assetCollection.getAsset(assetName);
                this._iconAssets.push(asset);

                var positioning:Array = ICON_POSITIONING[iconCount][iconIndex];
                var x:int = int(positioning[0] + Math.random() * (positioning[2] + 1) - positioning[2] / 2);
                var y:int = int(positioning[1] + Math.random() * (positioning[3] + 1) - positioning[3] / 2);
                var flip:Boolean = Math.random() < 0.5;
                var width:int = asset == null ? 0 : asset.width;
                var height:int = asset == null ? 0 : asset.height;
                var alpha:Number = this.calculateAlphaForYOffset(y);
                var z:Number = 0.001 + y / 10000;
                this._iconData.push([x, y, flip, width, height, alpha, z, 0]);
            }
        }

        private function calculateAlphaForYOffset(y:int):Number
        {
            var progress:Number = (y - -40) / (-100 - -40);
            var alpha:Number = 0.9 + (0.4 - 0.9) * progress;
            return Math.min(Math.max(alpha, 0.4), 0.9);
        }

        override protected function getAsset(name:String, spriteIndex:int=-1):IGraphicAsset
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                var iconIndex:int = spriteIndex - spriteCount + MAX_FLOATING_ICONS;
                if (this._iconAssets == null)
                {
                    this.createIconAssets();
                }
                if (iconIndex < this._iconAssets.length && this._iconAssets[iconIndex] != null)
                {
                    return this._iconAssets[iconIndex];
                }
            }
            return super.getAsset(name, spriteIndex);
        }

        override protected function getSpriteTag(size:int, direction:int, spriteIndex:int):String
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                return FLOATING_ICON_TAG_PREFIX + (spriteIndex - spriteCount + MAX_FLOATING_ICONS);
            }
            return super.getSpriteTag(size, direction, spriteIndex);
        }

        override protected function getSpriteAlpha(size:int, direction:int, spriteIndex:int):int
        {
            var alpha:int = super.getSpriteAlpha(size, direction, spriteIndex);
            if (this.isFloatingIcon(spriteIndex))
            {
                return int(Number(this._iconData[spriteIndex - spriteCount + MAX_FLOATING_ICONS][5]) * alpha);
            }
            return alpha;
        }

        override protected function getSpriteMouseCapture(size:int, direction:int, spriteIndex:int):Boolean
        {
            return this.isFloatingIcon(spriteIndex) ? false : super.getSpriteMouseCapture(size, direction, spriteIndex);
        }

        override protected function getSpriteXOffset(size:int, direction:int, spriteIndex:int):int
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                var iconIndex:int = spriteIndex - spriteCount + MAX_FLOATING_ICONS;
                var directionFlipped:Boolean = direction / 2 % 2 == 1;
                var x:int = int(this._iconData[iconIndex][0]);
                var width:int = int(this._iconData[iconIndex][3]);
                if (this._flippedLayout != directionFlipped)
                {
                    x = -x;
                }
                return x - width / 2;
            }
            return super.getSpriteXOffset(size, direction, spriteIndex);
        }

        override protected function getSpriteYOffset(size:int, direction:int, spriteIndex:int):int
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                var iconIndex:int = spriteIndex - spriteCount + MAX_FLOATING_ICONS;
                var y:int = int(this._iconData[iconIndex][1]);
                var height:int = int(this._iconData[iconIndex][4]);
                var phase:int = int(this._iconData[iconIndex][7]);
                var bob:int = (this._floatStep + phase) % (FLOATING_PIXELS * 2);
                if (bob > FLOATING_PIXELS)
                {
                    bob = FLOATING_PIXELS - (bob - FLOATING_PIXELS);
                }
                return y + height / 2 - bob;
            }
            return super.getSpriteYOffset(size, direction, spriteIndex);
        }

        override protected function getSpriteZOffset(size:int, direction:int, spriteIndex:int):Number
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                return Number(this._iconData[spriteIndex - spriteCount + MAX_FLOATING_ICONS][6]);
            }
            return super.getSpriteZOffset(size, direction, spriteIndex);
        }

        override protected function getSpriteInk(size:int, direction:int, spriteIndex:int):int
        {
            return this.isFloatingIcon(spriteIndex) ? 0 : super.getSpriteInk(size, direction, spriteIndex);
        }

        override protected function getSpriteFilters(size:int, direction:int, spriteIndex:int):Array
        {
            return this.isFloatingIcon(spriteIndex) ? FLOATING_ICON_GLOW_FILTER : super.getSpriteFilters(size, direction, spriteIndex);
        }

        override protected function getSpriteFlipH(size:int, direction:int, spriteIndex:int):Boolean
        {
            if (this.isFloatingIcon(spriteIndex))
            {
                var iconIndex:int = spriteIndex - spriteCount + MAX_FLOATING_ICONS;
                var directionFlipped:Boolean = direction / 2 % 2 == 1;
                var iconFlip:Boolean = Boolean(this._iconData[iconIndex][2]);
                return (this._flippedLayout != directionFlipped) != iconFlip;
            }
            return super.getSpriteFlipH(size, direction, spriteIndex);
        }
    }
}
