package com.sulake.habbo.roomevents.wired_trading.reward_notification
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.WiredTransactionSuccessContents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.HtmlTextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.HtmlPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.PaddedContainerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.NodeOverviewPreset;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;

    public class RewardNotificationView extends AbstractUbuntuWiredUI
    {
        private var _parent:RewardNotificationController;
        private var _contents:WiredTransactionSuccessContents;
        private var _description:TextPreset;
        private var _overview:NodeOverviewPreset;
        private var _earnings:HtmlPreset;
        private var _okButton:ButtonPreset;
        private var _viewIndex:int;

        public function RewardNotificationView(
            parent:RewardNotificationController, presetManager:PresetManager)
        {
            super(parent.roomEvents, presetManager);
            this._parent = parent;
            this._description = presetManager.createText("", TextParam.DEFAULT);
            this._overview = presetManager.createNodeOverviewPreset(
                "${wiredrewards.title}", this.onClickNode);
            this._earnings = presetManager.createHtml(
                this.localization.getLocalization("wiredrewards.earnings"),
                HtmlTextParam.DEFAULT);
            this._okButton = presetManager.createButton(
                "${wiredrewards.ok}", this.onClickButton);
            var contents:SimpleListViewPreset =
                presetManager.createSimpleListView(true,
                    [this._description, this._overview,
                        this._earnings, this._okButton]);
            var padded:PaddedContainerPreset =
                presetManager.createPaddedContainerPreset(
                    contents, 7, 7, 7, 7);
            this.framePreset = presetManager.createFramePreset(
                [padded], this.onCloseClicked);
            this.framePreset.resizeToWidth(276);
            this.framePreset.title = "${wiredrewards.title}";
        }

        private static function hasCreditNode(rule:TradeRequirementRule):Boolean
        {
            for each (var node:TradeRequirementNode in rule.nodes)
                if (node.type == TradeRequirementNode.TYPE_COIN) return true;
            return false;
        }

        private function onClickNode(node:TradeRequirementNode):void
        {
            this._parent.openLink(node.type == TradeRequirementNode.TYPE_COIN
                ? "habboUI/open/vault" : "inventory/open");
        }

        private function onClickButton():void { this.onCloseClicked(); }

        override protected function hideFrame():void
        {
            super.hideFrame();
            this._parent.closeRewardView(this);
        }

        override protected function get isBoundToParentRect():Boolean { return true; }

        public function show(contents:WiredTransactionSuccessContents,
            xOffset:int, yOffset:int, viewIndex:int):void
        {
            this._contents = contents;
            this._description.text = contents.rewardText.length == 0
                ? "${wiredrewards.desc_default}" : contents.rewardText;
            this._overview.rule = contents.rewardContents;
            this._earnings.visible = hasCreditNode(contents.rewardContents);
            this.showFrame();
            this.window.x += xOffset;
            this.window.y += yOffset;
            this._viewIndex = viewIndex;
        }

        public function get viewIndex():int { return this._viewIndex; }
        public function get contents():WiredTransactionSuccessContents
        {
            return this._contents;
        }

        override public function dispose():void
        {
            if (disposed) return;
            if (isShowing()) hide();
            this._okButton = null;
            this._overview = null;
            this._description = null;
            this._earnings = null;
            this._contents = null;
            this._parent = null;
            super.dispose();
        }
    }
}
