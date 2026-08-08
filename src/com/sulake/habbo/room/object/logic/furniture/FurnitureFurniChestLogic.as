package com.sulake.habbo.room.object.logic.furniture
{
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.events.RoomObjectFurniIconAssetEvent;
    import com.sulake.habbo.room.messages.RoomObjectDataUpdateMessage;
    import com.sulake.habbo.room.messages.RoomObjectFurniIconUpdateMessage;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.habbo.room.object.data.MapStuffData;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import flash.utils.getTimer;

    public class FurnitureFurniChestLogic extends FurnitureChestLogic
    {
        private static const LOADING_ICON_PLACEHOLDER:String = "loading_icon";
        private static const VISUALS_KEY:String = "visuals";

        private var _visuals:String = "";
        private var _assetNamesForVisuals:Map = new Map();

        private static function itemTypeToString(wallItem:Boolean, typeId:int, extra:String):String
        {
            var value:String = wallItem + "," + typeId;
            if (extra != null && extra != "")
            {
                value += "," + extra;
            }
            return value;
        }

        private static function stringToItemType(value:String):Object
        {
            var parts:Array = value.split(",");
            if (parts.length < 2)
            {
                return null;
            }
            return {
                "isWallItem": parts[0] == "true",
                "typeId": int(parts[1]),
                "extra": parts.length > 2 ? parts[2] : ""
            };
        }

        override public function dispose():void
        {
            if (this._assetNamesForVisuals != null)
            {
                this._assetNamesForVisuals.dispose();
                this._assetNamesForVisuals = null;
            }
            super.dispose();
        }

        override public function getEventTypes():Array
        {
            return getAllEventTypes(super.getEventTypes(), [RoomObjectFurniIconAssetEvent.LOAD_FURNI_ICON]);
        }

        override public function processUpdateMessage(message:RoomObjectUpdateMessage):void
        {
            super.processUpdateMessage(message);

            var dataUpdate:RoomObjectDataUpdateMessage = message as RoomObjectDataUpdateMessage;
            if (dataUpdate != null)
            {
                var mapData:MapStuffData = dataUpdate.data as MapStuffData;
                if (mapData != null)
                {
                    var visuals:String = mapData.getValue(VISUALS_KEY);
                    if (dataUpdate.state % 2 != 1)
                    {
                        visuals = "";
                    }
                    if (visuals != null && visuals != this._visuals)
                    {
                        this._visuals = visuals;
                        this.onVisualsChange();
                        this.storeShownAssets();
                    }
                }
            }

            var iconUpdate:RoomObjectFurniIconUpdateMessage = message as RoomObjectFurniIconUpdateMessage;
            if (iconUpdate == null || iconUpdate.assetName == null || iconUpdate.assetName.length == 0 || iconUpdate.assetName == LOADING_ICON_PLACEHOLDER)
            {
                return;
            }

            var itemType:String = itemTypeToString(iconUpdate.wallItem, iconUpdate.typeId, iconUpdate.extra);
            if (this._assetNamesForVisuals.hasKey(itemType) && this._assetNamesForVisuals.getValue(itemType) == LOADING_ICON_PLACEHOLDER)
            {
                this._assetNamesForVisuals[itemType] = iconUpdate.assetName;
                this.storeShownAssets();
            }
        }

        private function onVisualsChange():void
        {
            this._assetNamesForVisuals.dispose();
            this._assetNamesForVisuals = new Map();

            for each (var itemTypeString:String in this._visuals.split(";"))
            {
                if (itemTypeString == "")
                {
                    continue;
                }

                var itemType:Object = stringToItemType(itemTypeString);
                if (itemType == null)
                {
                    continue;
                }

                this._assetNamesForVisuals.add(itemTypeString, LOADING_ICON_PLACEHOLDER);
                if (eventDispatcher != null && object != null)
                {
                    eventDispatcher.dispatchEvent(new RoomObjectFurniIconAssetEvent(RoomObjectFurniIconAssetEvent.LOAD_FURNI_ICON, object, itemType.isWallItem, itemType.typeId, itemType.extra));
                }
            }
        }

        private function storeShownAssets():void
        {
            if (object == null || object.getModelController() == null)
            {
                return;
            }
            object.getModelController().setString(RoomObjectVariableEnum.FURNITURE_FURNI_CHEST_SHOWN_ASSET_NAMES, this.shownAssetsString);
            update(getTimer());
        }

        private function get shownAssetsString():String
        {
            var assetNames:Array = [];
            for each (var itemTypeString:String in this._visuals.split(";"))
            {
                if (itemTypeString != "" && this._assetNamesForVisuals.hasKey(itemTypeString))
                {
                    var assetName:String = this._assetNamesForVisuals.getValue(itemTypeString);
                    assetNames.push(assetName == null ? "" : assetName);
                }
            }
            return assetNames.join(",");
        }
    }
}
