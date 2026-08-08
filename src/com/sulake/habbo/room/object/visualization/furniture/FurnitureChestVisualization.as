package com.sulake.habbo.room.object.visualization.furniture
{
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;

    public class FurnitureChestVisualization extends FurnitureAnimatedVisualization
    {
        private static const WIRED_EMBLEM_SPRITE_TAG:String = "wired_emblem";

        private var _isWiredEnabled:Boolean = false;

        override protected function updateModel(scale:Number):Boolean
        {
            var changed:Boolean = super.updateModel(scale);
            if (object == null || object.getModel() == null)
            {
                return changed;
            }

            var isWiredEnabled:Boolean = object.getModel().getNumber(RoomObjectVariableEnum.FURNITURE_CHEST_IS_WIRED_ENABLED) == 1;
            if (isWiredEnabled != this._isWiredEnabled)
            {
                this._isWiredEnabled = isWiredEnabled;
                changed = true;
            }
            return changed;
        }

        override protected function getSpriteAlpha(size:int, direction:int, spriteIndex:int):int
        {
            if (!this._isWiredEnabled && getSpriteTag(size, direction, spriteIndex) == WIRED_EMBLEM_SPRITE_TAG)
            {
                return 0;
            }
            return super.getSpriteAlpha(size, direction, spriteIndex);
        }
    }
}
