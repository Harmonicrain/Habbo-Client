package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /** July's compact four-column room transaction preview row. */
    public final class WiredMenuChestTransactionTableObject implements ITableObject
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _info:WiredTransactionInfo;

        public function WiredMenuChestTransactionTableObject(
            roomEvents:HabboUserDefinedRoomEvents, info:WiredTransactionInfo)
        {
            this._roomEvents = roomEvents;
            this._info = info;
        }

        public function get identifier():String { return String(this._info.transactionId); }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "type":
                    return new TableCell(TableCell.TYPE_TEXT, this.localize(
                        "transaction.type." + this._info.transactionType,
                        "wired_transactions.type." + this._info.transactionType));
                case "username":
                    return new TableCell(TableCell.TYPE_LINK, this._info.username,
                        false, true, null, this.onUsername);
                case "withdraws":
                    return new TableCell(TableCell.TYPE_TEXT, this.summarize(
                        this._info.withdrawFurniCount,
                        this._info.withdrawCoinsCount));
                case "deposits":
                    return new TableCell(TableCell.TYPE_TEXT, this.summarize(
                        this._info.depositFurniCount,
                        this._info.depositCoinsCount));
            }
            return null;
        }

        private function onUsername():void
        {
            this._roomEvents.send(
                new GetExtendedProfileMessageComposer(this._info.userId));
        }

        private function summarize(furni:int, coins:int):String
        {
            if (furni <= 0 && coins <= 0) { return "-"; }
            var exact:String;
            var fallback:String;
            if (furni > 0 && coins == 0)
            {
                exact = "wiredmenu.chests.room_logs.only_furni";
                fallback = "wiredchests.logs.only_furni";
            }
            else if (furni == 0)
            {
                exact = "wiredmenu.chests.room_logs.only_coins";
                fallback = "wiredchests.logs.only_coins";
            }
            else
            {
                exact = "wiredmenu.chests.room_logs.furni_and_coins";
                fallback = "wiredchests.logs.furni_and_coins";
            }
            var template:String = this._roomEvents.localization.getLocalization(
                exact, this._roomEvents.localization.getLocalization(fallback, exact));
            return template.replace("%amount%", furni)
                .replace("%amount2%", coins);
        }

        private function localize(key:String, fallback:String):String
        {
            return this._roomEvents.localization.getLocalization(
                "wiredmenu.chests." + key,
                this._roomEvents.localization.getLocalization(fallback, fallback));
        }

        public function isPropertyUpdated(columnId:String, previous:Object):Boolean
        {
            return false;
        }
        public function isUpdated(previous:Object):Boolean { return false; }
    }
}
