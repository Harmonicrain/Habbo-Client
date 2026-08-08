package com.sulake.habbo.quest.rewardtrack.view.premium
{
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.quest.rewardtrack.RewardTrackController;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class RewardTrackPremiumPurchaseConfirmationView implements IDisposable
    {
        private static const RETRY_ENABLE_DELAY_MS:int = 500;

        private var _controller:RewardTrackController;
        private var _track:RewardTrack;
        private var _window:IFrameWindow;
        private var _retryTimer:Timer;
        private var _pending:Boolean = false;
        private var _disposed:Boolean = false;

        public function RewardTrackPremiumPurchaseConfirmationView(controller:RewardTrackController, track:RewardTrack)
        {
            this._controller = controller;
            this._track = track;
            this.createWindow();
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function show():void
        {
            if (this._window == null || this._disposed)
            {
                return;
            }
            this._window.visible = true;
            this._window.center();
            this._window.activate();
        }

        public function purchaseFailed():void
        {
            if (this._retryTimer != null)
            {
                this._retryTimer.stop();
                this._retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onRetryTimerComplete);
            }
            this._retryTimer = new Timer(RETRY_ENABLE_DELAY_MS, 1);
            this._retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onRetryTimerComplete);
            this._retryTimer.start();
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._retryTimer != null)
            {
                this._retryTimer.stop();
                this._retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onRetryTimerComplete);
                this._retryTimer = null;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._controller = null;
            this._track = null;
        }

        private function createWindow():void
        {
            var assets:IAssetLibrary = this._controller != null ? this._controller.assets : null;
            var asset:IAsset = assets != null ? assets.getAssetByName("reward_track_premium_purchase_confirmation_xml") : null;
            if (asset == null || this._controller.windowManager == null)
            {
                return;
            }
            this._window = this._controller.windowManager.buildFromXML(asset.content as XML, 1) as IFrameWindow;
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.onWindowEvent;
            this.initializeUI();
        }

        private function initializeUI():void
        {
            var benefitText:ITextWindow;
            if (this._track == null || this._window == null)
            {
                return;
            }

            benefitText = this.findText("benefit_boost_txt");
            if (benefitText != null)
            {
                benefitText.caption = this.textWithParam("reward_track.premium.confirm.benefit.boost", "%percent%% faster progression", "percent", Math.round((this._track.taskPointsBoost - 1) * 100));
            }
            benefitText = this.findText("benefit_instant_points_txt");
            if (benefitText != null)
            {
                benefitText.caption = this.textWithParam("reward_track.premium.confirm.benefit.instant_points", "%points% instant points", "points", this._track.instantPoints);
            }

            this.setVisible("benefit_boost_row", this._track.taskPointsBoost > 1);
            this.setVisible("benefit_rewards_row", this._track.hasPremiumPrizes);
            this.setVisible("benefit_instant_points_row", this._track.instantPoints > 0);
            this.setVisible("benefit_tasks_row", this._track.hasPremiumTasks);
            this.setVisible("benefit_levels_row", this._track.hasPremiumLevels);

            this.setText("price_credits", String(this._track.costCredits));
            this.setText("price_diamonds", String(this._track.costPoints));
            this.setVisible("price_credits", this._track.costCredits > 0);
            this.setVisible("credits_icon", this._track.costCredits > 0);
            this.setVisible("price_diamonds", this._track.costPoints > 0);
            this.setVisible("diamonds_icon", this._track.costPoints > 0);
            this.setPointsIconStyle();
            this.setVisible("plus_txt", this._track.costCredits > 0 && this._track.costPoints > 0);

            this.arrangeBenefits();
        }

        private function onWindowEvent(event:WindowEvent, window:IWindow):void
        {
            if (event.type != WindowMouseEvent.CLICK || window == null)
            {
                return;
            }
            if (window.name == "confirm_button")
            {
                this.onConfirmClicked();
                return;
            }
            if (window.name == "cancel_button" || window.name == "header_button_close")
            {
                this.onWindowClose();
            }
        }

        private function onConfirmClicked():void
        {
            if (this._pending || this._controller == null || this._track == null)
            {
                return;
            }
            this.setPending(true);
            this._controller.purchasePremium(this._track.id);
        }

        private function onWindowClose():void
        {
            if (this._pending || this._controller == null)
            {
                return;
            }
            this._controller.closePremiumPurchaseConfirmation();
        }

        private function onRetryTimerComplete(event:TimerEvent):void
        {
            if (this._retryTimer != null)
            {
                this._retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onRetryTimerComplete);
                this._retryTimer = null;
            }
            this.setPending(false);
        }

        private function setPending(value:Boolean):void
        {
            this._pending = value;
            this.setEnabled("confirm_button", !value);
            this.setEnabled("cancel_button", !value);
            this.setEnabled("header_button_close", !value);
        }

        private function arrangeBenefits():void
        {
            var list:IItemListWindow = this._window != null ? this._window.findChildByName("benefits") as IItemListWindow : null;
            if (list != null)
            {
                list.arrangeListItems();
            }
        }

        private function setPointsIconStyle():void
        {
            var icon:IIconWindow = this._window != null ? this._window.findChildByName("diamonds_icon") as IIconWindow : null;
            if (icon != null && this._controller != null && this._controller.configuration != null)
            {
                icon.style = ActivityPointTypeEnum.getIconStyleFor(this._track.costPointsType, this._controller.configuration, true);
            }
        }

        private function setText(name:String, value:String):void
        {
            var text:ITextWindow = this.findText(name);
            if (text != null)
            {
                text.caption = value != null ? value : "";
            }
        }

        private function findText(name:String):ITextWindow
        {
            return this._window != null ? this._window.findChildByName(name) as ITextWindow : null;
        }

        private function setVisible(name:String, visible:Boolean):void
        {
            var window:IWindow = this._window != null ? this._window.findChildByName(name) : null;
            if (window != null)
            {
                window.visible = visible;
            }
        }

        private function setEnabled(name:String, enabled:Boolean):void
        {
            var window:IWindow = this._window != null ? this._window.findChildByName(name) : null;
            if (window == null)
            {
                return;
            }
            if (enabled)
            {
                window.enable();
            }
            else
            {
                window.disable();
            }
        }

        private function get localization():IHabboLocalizationManager
        {
            return this._controller != null ? this._controller.localization : null;
        }

        private function textWithParam(key:String, fallback:String, parameter:String, value:Object):String
        {
            return this.localization != null ? this.localization.getLocalizationWithParams(key, fallback, parameter, value) : fallback.split("%" + parameter + "%").join(String(value));
        }
    }
}
