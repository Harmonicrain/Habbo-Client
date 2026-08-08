package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.window.widgets.IProductDisplayInfo;

    public class ChestItemTypeRenderableWrapper implements IProductDisplayInfo
    {
        private var _type:ChestItemType;
        public function ChestItemTypeRenderableWrapper(type:ChestItemType) { this._type = type; }
        public function get productTypeId():int
        {
            // July's chest protocol uses 0/1 for wall/floor, while this
            // client's product widgets use the legacy 1/2 identifiers.
            return this._type.isWallItem ? 1 : 2;
        }
        public function get itemTypeId():String { return String(this._type.typeId); }
        public function get extraData():String { return this._type.legacyPosterId; }
        public function get petFigureString():String { return ""; }
        public function get botFigureString():String { return ""; }
        public function get figureSetIds():Vector.<int> { return null; }
    }
}
