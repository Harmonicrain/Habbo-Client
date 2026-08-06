package com.sulake.habbo.roomevents.wired_trading.reward_notification
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.WiredTransactionSuccessContents;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade.WiredTransactionSuccessMessageEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.UbuntuPresetManager;

    public class RewardNotificationController
        implements ILinkEventTracker, IDisposable
    {
        private static const MAX_OPEN_REWARD_NOTIFICATIONS:int = 10;

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _messageEvents:Vector.<IMessageEvent>;
        private var _contentsById:Map;
        private var _views:Vector.<RewardNotificationView>;
        private var _presetManager:PresetManager;
        private var _disposed:Boolean;

        public function RewardNotificationController(
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
            this._messageEvents = new Vector.<IMessageEvent>();
            this._messageEvents.push(new WiredTransactionSuccessMessageEvent(
                this.onTransactionSuccess));
            for each (var event:IMessageEvent in this._messageEvents)
                roomEvents.communication.addHabboConnectionMessageEvent(event);
            this._contentsById = new Map();
            this._views = new Vector.<RewardNotificationView>();
            this._presetManager = new UbuntuPresetManager(roomEvents);
        }

        public function get linkPattern():String { return "wiredrewards/"; }

        public function linkReceived(link:String):void
        {
            var parts:Array = link.split("/");
            if (parts.length >= 3 && parts[1] == "open")
                this.openRewardView(int(parts[2]));
        }

        private function onTransactionSuccess(
            event:WiredTransactionSuccessMessageEvent):void
        {
            var contents:WiredTransactionSuccessContents =
                event.getParser().contents;
            if (contents.rewardContents == null) return;
            this._contentsById.add(contents.internalId, contents);
            if (contents.openByDefault)
                this.openRewardView(contents.internalId);
        }

        public function openRewardView(internalId:int):void
        {
            if (this._disposed) return;
            for each (var existing:RewardNotificationView in this._views)
            {
                if (existing.contents != null &&
                    existing.contents.internalId == internalId)
                {
                    existing.window.activate();
                    return;
                }
            }
            var contents:WiredTransactionSuccessContents =
                this._contentsById.getValue(internalId) as
                    WiredTransactionSuccessContents;
            if (contents == null) return;
            while (this._views.length >= MAX_OPEN_REWARD_NOTIFICATIONS)
                this.closeRewardView(this._views[0]);

            var viewIndex:int = this._views.length == 0 ? 0 :
                (this._views[this._views.length - 1].viewIndex + 1) %
                    MAX_OPEN_REWARD_NOTIFICATIONS;
            var xOffset:int = 0;
            var yOffset:int = 0;
            if (viewIndex > 0)
            {
                var distance:int = 25;
                var step:int = int((viewIndex + 1) / 2);
                if ((viewIndex + 1) % 2 == 0)
                {
                    xOffset = distance * step;
                    yOffset = distance * step;
                }
                else
                {
                    xOffset = -distance * step;
                    yOffset = -distance * step;
                }
            }
            var view:RewardNotificationView =
                new RewardNotificationView(this, this._presetManager);
            view.show(contents, xOffset, yOffset, viewIndex);
            this._views.push(view);
        }

        public function closeRewardView(view:RewardNotificationView):void
        {
            var index:int = this._views.indexOf(view);
            if (index != -1) this._views.removeAt(index);
            view.dispose();
        }

        public function closeAllViews():void
        {
            var views:Vector.<RewardNotificationView> = this._views;
            this._views = new Vector.<RewardNotificationView>();
            for each (var view:RewardNotificationView in views) view.dispose();
        }

        public function openLink(link:String):void
        {
            this._roomEvents.context.createLinkEvent(link);
        }

        public function get roomEvents():HabboUserDefinedRoomEvents
        {
            return this._roomEvents;
        }

        public function dispose():void
        {
            if (this._disposed) return;
            this._disposed = true;
            for each (var event:IMessageEvent in this._messageEvents)
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
            this._messageEvents = null;
            this.closeAllViews();
            this._views = null;
            this._contentsById.dispose();
            this._contentsById = null;
            this._presetManager = null;
            this._roomEvents = null;
        }

        public function get disposed():Boolean { return this._disposed; }
    }
}
