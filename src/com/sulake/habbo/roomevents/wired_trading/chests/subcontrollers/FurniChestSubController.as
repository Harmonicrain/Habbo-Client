package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestStorage;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsUpdateMessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsMessageParser;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestFurniContentsUpdateMessageParser;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.WithdrawChestFurniMessageComposer;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views.FurniChestView;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;

    public class FurniChestSubController extends AbstractChestSubController
    {
        private var _view:FurniChestView;
        private var _storages:Vector.<ChestStorage> = new Vector.<ChestStorage>();
        private var _receivedFragments:Dictionary;
        private var _expectedFragments:int;

        public function FurniChestSubController(parent:WiredChestController)
        {
            super(parent);
            this.addMessageEvent(new ChestFurniContentsUpdateMessageEvent(this.onItemsUpdated));
            this.addMessageEvent(new ChestFurniContentsMessageEvent(this.onItemsChunk));
            this._view = new FurniChestView(this);
        }
        private function onItemsUpdated(event:ChestFurniContentsUpdateMessageEvent):void
        {
            var parser:ChestFurniContentsUpdateMessageParser = event.getParser();
            if (parentController.activeChestId != parser.chestId
                || parentController.status != WiredChestController.STATUS_OPEN)
            {
                return;
            }
            var removedById:Dictionary = new Dictionary();
            for each (var removedId:int in parser.removedIds) { removedById[removedId] = true; }
            var retained:Vector.<ChestStorage> = new Vector.<ChestStorage>();
            var removed:Vector.<ChestStorage> = new Vector.<ChestStorage>();
            var known:Dictionary = new Dictionary();
            for each (var existing:ChestStorage in this._storages)
            {
                if (removedById[existing.inventoryId]) { removed.push(existing); }
                else
                {
                    retained.push(existing);
                    known[existing.inventoryId] = true;
                }
            }
            var added:Vector.<ChestStorage> = new Vector.<ChestStorage>();
            for each (var incoming:ChestStorage in parser.addedStorage)
            {
                if (!known[incoming.inventoryId])
                {
                    retained.push(incoming);
                    added.push(incoming);
                    known[incoming.inventoryId] = true;
                }
            }
            this._storages = retained;
            this._view.itemsUpdated(removed, added);
        }
        private function onItemsChunk(event:ChestFurniContentsMessageEvent):void
        {
            var parser:ChestFurniContentsMessageParser = event.getParser();
            if (parser.fragmentNo == 0)
            {
                if (parentController.requestedChestId != parser.chestId) { return; }
                this._view.clear();
                this._storages = new Vector.<ChestStorage>();
                this._receivedFragments = new Dictionary();
                this._expectedFragments = parser.totalFragments;
                parentController.setOpeningStatus(parser.chestId);
            }
            if (parentController.activeChestId != parser.chestId
                || parentController.status != WiredChestController.STATUS_OPENING
                || parser.totalFragments != this._expectedFragments
                || this._receivedFragments[parser.fragmentNo])
            {
                return;
            }
            /*
             * July sends ordered fragments. Reject a gap rather than opening a
             * silently incomplete chest when packets are malformed/replayed.
             */
            if (parser.fragmentNo > 0 && !this._receivedFragments[parser.fragmentNo - 1])
            {
                parentController.close();
                return;
            }
            this._receivedFragments[parser.fragmentNo] = true;
            for each (var storage:ChestStorage in parser.storageChunk)
            {
                this._storages.push(storage);
            }
            if (parser.fragmentNo == parser.totalFragments - 1)
            {
                parentController.setOpenStatus(parser.chestId, this);
                this._view.itemsInitialize(this._storages);
                this._receivedFragments = null;
            }
        }
        public function withdrawItemsWithType(type:ChestItemType, amount:int):void
        {
            parentController.send(new WithdrawChestFurniMessageComposer(
                viewingChestId, type, amount));
        }
        public function viewLogsWithType(type:ChestItemType):void
        {
            /* Activated when the July chest-log packet family is registered. */
        }
        override public function get type():int { return ChestType.FURNI; }
        override public function get title():String { return localize("wiredchests.furni_chest"); }
        override public function get view():IWindowContainer { return this._view.container; }
        override public function get isEmpty():Boolean { return this._storages.length == 0; }
        override public function get itemCount():int { return this._storages.length; }
        override public function clear():void
        {
            this._storages = new Vector.<ChestStorage>();
            this._receivedFragments = null;
            this._expectedFragments = 0;
            this._view.clear();
        }
        override public function updateUI():void { this._view.updateUI(); }
        override public function dispose():void
        {
            if (disposed) { return; }
            this._view.dispose();
            this._view = null;
            super.dispose();
        }
    }
}
