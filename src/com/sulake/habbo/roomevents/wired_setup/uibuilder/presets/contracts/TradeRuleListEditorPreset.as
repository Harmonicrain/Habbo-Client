package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TradeRuleListEditorPreset extends WiredUIPreset
    {
        public static const MAX_RULES:int = 3;

        private var _list:IItemListWindow;
        private var _editors:Vector.<TradeRuleEditorPreset>;
        private var _addButton:ButtonPreset;
        private var _onEdit:Function;
        private var _onAdd:Function;

        public function TradeRuleListEditorPreset(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle,
            onEdit:Function, onAdd:Function)
        {
            super(roomEvents, presetManager, style);
            this._onEdit = onEdit;
            this._onAdd = onAdd;
            this._list = presetManager.createLayout("vertical_list_view") as IItemListWindow;
            this._list.spacing = style.genericVerticalSpacing;
            this._addButton = presetManager.createButton(
                "${wiredcontracts.payment_add_more}", this.onAddMore);
            this._editors = new Vector.<TradeRuleEditorPreset>();
            this._list.addListItem(this._addButton.window);
            this.refreshAddMoreVisibility();
        }

        public function set rules(value:Vector.<TradeRequirementRule>):void
        {
            this.removeAllRules();
            if (value.length == 0)
            {
                value = new Vector.<TradeRequirementRule>();
                value.push(new TradeRequirementRule(new Vector.<TradeRequirementNode>()));
            }
            var index:int = 1;
            for each (var rule:TradeRequirementRule in value)
            {
                var editor:TradeRuleEditorPreset = this._presetManager.createRuleEditorPreset(
                    "-", this._onEdit, this._onAdd,
                    index == 1 ? null : this.onRuleRemoved);
                editor.rule = rule.deepCopy();
                this._editors.push(editor);
                this._list.addListItemAt(editor.window, this._list.numListItems - 1);
                editor.resizeToWidth(this._list.width);
                index++;
            }
            this.fixNames();
            this.refreshAddMoreVisibility();
        }

        public function finalizeRules():Vector.<TradeRequirementRule>
        {
            var result:Vector.<TradeRequirementRule> = new Vector.<TradeRequirementRule>();
            for each (var editor:TradeRuleEditorPreset in this._editors)
            {
                var rule:TradeRequirementRule = editor.finalizeRule();
                if (rule.nodes.length > 0) result.push(rule);
            }
            return result;
        }

        private function onAddMore():void
        {
            if (this._editors.length >= MAX_RULES) return;
            var editor:TradeRuleEditorPreset = this._presetManager.createRuleEditorPreset(
                "", this._onEdit, this._onAdd,
                this._editors.length == 0 ? null : this.onRuleRemoved);
            editor.rule = new TradeRequirementRule(new Vector.<TradeRequirementNode>());
            this._editors.push(editor);
            this._list.addListItemAt(editor.window, this._list.numListItems - 1);
            editor.resizeToWidth(this._list.width);
            this.fixNames();
            this.refreshAddMoreVisibility();
        }

        private function refreshAddMoreVisibility():void
        {
            this._addButton.disabled = this._editors.length >= MAX_RULES;
        }

        private function onRuleRemoved(editor:TradeRuleEditorPreset):void
        {
            var index:int = this._editors.indexOf(editor);
            if (index == -1) return;
            this._list.removeListItemAt(index);
            this._editors.removeAt(index);
            editor.dispose();
            this.fixNames();
            this.refreshAddMoreVisibility();
        }

        private function removeAllRules():void
        {
            while (this._list.numListItems > 1) this._list.removeListItemAt(0);
            for each (var editor:TradeRuleEditorPreset in this._editors)
                editor.dispose();
            this._editors = new Vector.<TradeRuleEditorPreset>();
            this.refreshAddMoreVisibility();
        }

        private function fixNames():void
        {
            var index:int = 0;
            for each (var editor:TradeRuleEditorPreset in this._editors)
            {
                index++;
                editor.updateTitle(this.localizations.getLocalizationWithParams(
                    "wiredcontracts.payment_rule", "", "i", index));
            }
        }

        override public function get window():IWindow { return this._list; }
        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._list.width = width;
            for each (var editor:TradeRuleEditorPreset in this._editors)
                editor.resizeToWidth(width);
            this._addButton.resizeToWidth(width);
        }
        override protected function get childPresets():Array
        {
            var children:Array = [];
            for each (var editor:TradeRuleEditorPreset in this._editors)
                children.push(editor);
            children.push(this._addButton);
            return children;
        }
        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._editors = null;
            this._addButton = null;
            this._onEdit = null;
            this._onAdd = null;
            this._list.dispose();
            this._list = null;
        }
    }
}
