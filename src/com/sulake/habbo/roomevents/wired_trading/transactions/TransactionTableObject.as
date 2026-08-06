package com.sulake.habbo.roomevents.wired_trading.transactions
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionInfo;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions.RequestTransactionDetailsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    public final class TransactionTableObject implements ITableObject
    {
        private var _controller:WiredTransactionLogsController;
        private var _info:WiredTransactionInfo;

        public function TransactionTableObject(
            controller:WiredTransactionLogsController, info:WiredTransactionInfo)
        {
            this._controller = controller;
            this._info = info;
        }

        public function get identifier():String { return String(this._info.transactionId); }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "type":
                    return new TableCell(TableCell.TYPE_TEXT,
                        this.loc("wired_transactions.type." + this._info.transactionType));
                case "timestamp":
                    return new TableCell(TableCell.TYPE_TEXT,
                        this._info.readableTimestamp);
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
                case "chests":
                    return new TableCell(TableCell.TYPE_TEXT,
                        String(this._info.chestCount));
                case "details":
                    return new TableCell(TableCell.TYPE_LINK,
                        this.loc("wiredchests.logs.details_text"), false, false,
                        null, this.onDetails);
            }
            return null;
        }

        private function onUsername():void
        {
            this._controller.send(
                new GetExtendedProfileMessageComposer(this._info.userId));
        }

        private function onDetails():void
        {
            this._controller.send(
                new RequestTransactionDetailsMessageComposer(
                    this._info.transactionId));
        }

        private function summarize(furni:int, coins:int):String
        {
            if (furni <= 0 && coins <= 0) { return "-"; }
            if (furni > 0 && coins == 0)
            {
                return this._controller.localization.getLocalizationWithParams(
                    "wiredchests.logs.only_furni", "", "amount", furni);
            }
            if (furni == 0)
            {
                return this._controller.localization.getLocalizationWithParams(
                    "wiredchests.logs.only_coins", "", "amount", coins);
            }
            return this._controller.localization.getLocalizationWithParams(
                "wiredchests.logs.furni_and_coins", "", "amount", furni,
                "amount2", coins);
        }

        private function loc(key:String):String
        {
            return this._controller.localization.getLocalization(key, key);
        }

        public function isPropertyUpdated(columnId:String, previous:Object):Boolean
        {
            return false;
        }
        public function isUpdated(previous:Object):Boolean { return false; }
    }
}
