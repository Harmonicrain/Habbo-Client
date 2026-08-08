package com.sulake.habbo.quest.rewardtrack
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTrackClaimResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTrackPremiumResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTrackProgressMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.rewardtrack.RewardTracksMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.rewardtrack.ClaimRewardTrackRewardMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.rewardtrack.PurchaseRewardTrackPremiumMessageComposer;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackClaimResultMessageParser;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackPremiumResultMessageParser;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTrackProgressMessageParser;
    import com.sulake.habbo.communication.messages.parser.rewardtrack.RewardTracksMessageParser;
    import com.sulake.habbo.quest.HabboQuestEngine;
    import com.sulake.habbo.quest.events.UnseenRewardTrackRewardsCountUpdateEvent;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackPrize;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackTask;
    import com.sulake.habbo.quest.rewardtrack.view.RewardTrackView;
    import com.sulake.habbo.quest.rewardtrack.view.premium.RewardTrackPremiumPurchaseConfirmationView;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import flash.utils.Dictionary;

    public class RewardTrackController implements IRewardTrackController, ILinkEventTracker
    {
        private var _questEngine:HabboQuestEngine;
        private var _tracks:Dictionary;
        private var _trackList:Array;
        private var _enabled:Boolean = true;
        private var _disposed:Boolean = false;
        private var _messagesRegistered:Boolean = false;
        private var _lastClaimableCount:int = -1;
        private var _view:RewardTrackView;
        private var _premiumPurchaseView:RewardTrackPremiumPurchaseConfirmationView;

        public function RewardTrackController(questEngine:HabboQuestEngine)
        {
            this._questEngine = questEngine;
            this._tracks = new Dictionary();
            this._trackList = [];
        }

        public function registerMessages():void
        {
            if (this._messagesRegistered || this._questEngine == null || this._questEngine.communication == null)
            {
                return;
            }
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTracksMessageEvent(this.onRewardTracks));
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTrackProgressMessageEvent(this.onRewardTrackProgress));
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTrackClaimResultMessageEvent(this.onRewardTrackClaimResult));
            this._questEngine.communication.addHabboConnectionMessageEvent(new RewardTrackPremiumResultMessageEvent(this.onRewardTrackPremiumResult));
            this._messagesRegistered = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function dispose():void
        {
            this._disposed = true;
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this.closePremiumPurchaseConfirmation();
            this._tracks = null;
            this._trackList = null;
            this._questEngine = null;
        }

        public function get linkPattern():String
        {
            return "reward_track/";
        }

        public function linkReceived(link:String):void
        {
            var parts:Array = link.split("/");
            if (parts.length >= 3 && parts[1] == "open")
            {
                this.open(parts[2]);
            }
        }

        public function get enabled():Boolean
        {
            return this._enabled;
        }

        public function get tracks():Array
        {
            return this._trackList;
        }

        public function get windowManager():IHabboWindowManager
        {
            return this._questEngine != null ? this._questEngine.windowManager : null;
        }

        public function get assets():IAssetLibrary
        {
            return this._questEngine != null ? this._questEngine.assets : null;
        }

        public function get localization():IHabboLocalizationManager
        {
            return this._questEngine != null ? this._questEngine.localization : null;
        }

        public function get configuration():IHabboConfigurationManager
        {
            return this._questEngine != null ? this._questEngine.configuration : null;
        }

        public function getTrack(trackId:String):RewardTrack
        {
            return this._tracks != null ? this._tracks[trackId] as RewardTrack : null;
        }

        public function open(trackId:String):void
        {
            var track:RewardTrack = this.getTrack(trackId);
            if (!this._enabled)
            {
                return;
            }
            if (track == null)
            {
                return;
            }
            if (this._questEngine != null && this._questEngine.windowManager != null)
            {
                if (this._view == null || this._view.disposed)
                {
                    this._view = new RewardTrackView(this._questEngine.windowManager, this._questEngine.localization, this._questEngine.assets, this, this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.figure : null, this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.userId : 0);
                }
                else
                {
                    this._view.setOwnUser(this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.figure : null, this._questEngine.sessionDataManager != null ? this._questEngine.sessionDataManager.userId : 0);
                }
                this._view.show(track);
            }
        }

        public function claimReward(trackId:String, rewardId:String):void
        {
            if (this._questEngine != null)
            {
                this._questEngine.send(new ClaimRewardTrackRewardMessageComposer(trackId, rewardId));
            }
        }

        public function purchasePremium(trackId:String):void
        {
            if (this._questEngine != null)
            {
                this._questEngine.send(new PurchaseRewardTrackPremiumMessageComposer(trackId));
            }
        }

        public function openPremiumPurchaseConfirmation(track:RewardTrack):void
        {
            if (track == null || !track.hasPremiumConfig || track.premium)
            {
                return;
            }
            this.closePremiumPurchaseConfirmation();
            this._premiumPurchaseView = new RewardTrackPremiumPurchaseConfirmationView(this, track);
            this._premiumPurchaseView.show();
        }

        public function openTaskHintLink(link:String):void
        {
            if (link == null || link == "" || this._questEngine == null)
            {
                return;
            }
            this._questEngine.context.createLinkEvent(link);
        }

        public function closePremiumPurchaseConfirmation():void
        {
            if (this._premiumPurchaseView != null)
            {
                this._premiumPurchaseView.dispose();
                this._premiumPurchaseView = null;
            }
        }

        private function onRewardTracks(event:IMessageEvent):void
        {
            var parser:RewardTracksMessageParser = RewardTracksMessageEvent(event).getParser();
            var track:RewardTrack;
            this._enabled = !parser.disabled;
            this._tracks = new Dictionary();
            this._trackList = [];
            this.closePremiumPurchaseConfirmation();
            for each (track in parser.tracks)
            {
                this._tracks[track.id] = track;
                this._trackList.push(track);
            }
            this.broadcastClaimableCount();
        }

        private function onRewardTrackProgress(event:IMessageEvent):void
        {
            var parser:RewardTrackProgressMessageParser = RewardTrackProgressMessageEvent(event).getParser();
            var track:RewardTrack = this.getTrack(parser.trackId);
            var task:RewardTrackTask = track != null ? track.getTask(parser.taskId) : null;
            var hadProgress:Boolean;
            var wasComplete:Boolean;
            if (track == null || task == null)
            {
                return;
            }
            hadProgress = task.progressCount > 0;
            wasComplete = this.isTaskComplete(task);
            track.points = parser.points;
            task.progressCount = parser.progressCount;
            this.updateProgressView(task, hadProgress, wasComplete);
            this.broadcastClaimableCount();
        }

        private function onRewardTrackClaimResult(event:IMessageEvent):void
        {
            var parser:RewardTrackClaimResultMessageParser = RewardTrackClaimResultMessageEvent(event).getParser();
            var track:RewardTrack = this.getTrack(parser.trackId);
            var prize:RewardTrackPrize = track != null ? track.getPrize(parser.rewardId) : null;
            if (parser.resultCode == RewardTrackClaimResultMessageParser.SUCCESS && prize != null)
            {
                prize.claimed = true;
                this.updatePrizeClaimView(prize);
                this.broadcastClaimableCount();
            }
        }

        private function onRewardTrackPremiumResult(event:IMessageEvent):void
        {
            var parser:RewardTrackPremiumResultMessageParser = RewardTrackPremiumResultMessageEvent(event).getParser();
            var track:RewardTrack = this.getTrack(parser.trackId);
            if (parser.resultCode == RewardTrackPremiumResultMessageParser.SUCCESS && track != null)
            {
                track.premium = true;
                track.points = parser.points;
                this.closePremiumPurchaseConfirmation();
                this.updatePremiumPurchaseView();
                this.broadcastClaimableCount();
            }
            else if (this._premiumPurchaseView != null && !this._premiumPurchaseView.disposed)
            {
                this._premiumPurchaseView.purchaseFailed();
            }
        }

        private function updateProgressView(task:RewardTrackTask, hadProgress:Boolean, wasComplete:Boolean):void
        {
            if (this._view != null && !this._view.disposed)
            {
                this._view.taskProgressUpdated(task, hadProgress, wasComplete);
            }
        }

        private function updatePrizeClaimView(prize:RewardTrackPrize):void
        {
            if (this._view != null && !this._view.disposed)
            {
                this._view.prizeClaimed(prize);
            }
        }

        private function updatePremiumPurchaseView():void
        {
            if (this._view != null && !this._view.disposed)
            {
                this._view.premiumPurchased();
            }
        }

        private function isTaskComplete(task:RewardTrackTask):Boolean
        {
            var level:Object;
            var required:int = 0;
            if (task == null)
            {
                return false;
            }
            for each (level in task.levels)
            {
                if (level != null && level.requiredCount > required)
                {
                    required = level.requiredCount;
                }
            }
            return required > 0 && task.progressCount >= required;
        }

        private function broadcastClaimableCount():void
        {
            var track:RewardTrack;
            var prize:RewardTrackPrize;
            var count:int = 0;
            if (this._trackList == null)
            {
                return;
            }
            for each (track in this._trackList)
            {
                for each (prize in track.prizes)
                {
                    if (prize.isClaimable(track))
                    {
                        count++;
                    }
                }
            }
            if (count != this._lastClaimableCount && this._questEngine != null)
            {
                this._lastClaimableCount = count;
                this._questEngine.events.dispatchEvent(new UnseenRewardTrackRewardsCountUpdateEvent(count));
            }
        }
    }
}
