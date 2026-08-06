package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.HorizontalSectionListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.TradeRuleEditorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ItemTypeSelectionSection;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.session.furniture.IFurnitureData;

    public class AddEditContractElement extends AbstractUbuntuWiredUI
    {
        public static const MAX_COINS:int = 100000;
        public static const MAX_FURNI:int = 500;

        private var _parent:WiredContractController;
        private var _type:RadioGroupPreset;
        private var _amount:NumberInputPreset;
        private var _itemSelection:ItemTypeSelectionSection;
        private var _isEditMode:Boolean;
        private var _editor:TradeRuleEditorPreset;
        private var _uniqueId:int = -1;

        public function AddEditContractElement(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent.roomEvents, presetManager);
            this._parent = parent;
            this._type = presetManager.createRadioGroup([
                new RadioButtonParam(0, "${wiredcontracts.element.type.0}"),
                new RadioButtonParam(1, "${wiredcontracts.element.type.1}")
            ], this.onElementTypeChange);
            var typeSection:SectionPreset = presetManager.createSection(
                "${wiredcontracts.element.type}", this._type);
            this._amount = presetManager.createNumberInput(
                new NumberInputParam(1, 1, MAX_COINS, 80));
            var amountSection:SectionPreset = presetManager.createSection(
                "${wiredcontracts.element.amount}", this._amount);
            var header:HorizontalSectionListPreset =
                presetManager.createHorizontalSectionListPreset(
                    [typeSection, amountSection]);
            this._itemSelection = presetManager.createItemTypeSelectionSection();
            this.framePreset = presetManager.createFramePreset(
                [header, this._itemSelection, this.footerPreset],
                this.onCloseClicked);
            this.framePreset.resizeToWidth(420);
        }

        override protected function get isRememberLocation():Boolean { return true; }
        override protected function get isBoundToParentRect():Boolean { return true; }
        override public function get xOffsetFromCenter():int { return 375; }

        private function onElementTypeChange(value:int):void
        {
            this._itemSelection.disabled = value != TradeRequirementNode.TYPE_FURNI;
        }

        public function set isEditMode(value:Boolean):void
        {
            this._isEditMode = value;
            this.framePreset.title = value
                ? "${wiredcontracts.edit_element.title}"
                : "${wiredcontracts.add_element.title}";
        }

        public function onEdit(editor:TradeRuleEditorPreset, uniqueId:int,
            node:TradeRequirementNode):void
        {
            this.isEditMode = true;
            this._editor = editor;
            this._uniqueId = uniqueId;
            this.footerPreset.saveButtonDisabled =
                !this.roomEvents.wiredMenu.hasWritePermission;
            this._itemSelection.resetInteractions();
            this._itemSelection.selectedItem = node.itemType;
            this._type.selected = node.type;
            this._amount.value = node.amount;
            this.onElementTypeChange(node.type);
            this.showFrame();
        }

        public function onAdd(editor:TradeRuleEditorPreset):void
        {
            this.isEditMode = false;
            this._editor = editor;
            this._uniqueId = -1;
            this.footerPreset.saveButtonDisabled =
                !this.roomEvents.wiredMenu.hasWritePermission;
            this._itemSelection.resetInteractions();
            this._itemSelection.selectedItem = null;
            this._type.selected = TradeRequirementNode.TYPE_COIN;
            this._amount.value = 1;
            this.onElementTypeChange(TradeRequirementNode.TYPE_COIN);
            this.showFrame();
        }

        private function createNode():TradeRequirementNode
        {
            return new TradeRequirementNode(this._type.selected, this._amount.value,
                this._type.selected == TradeRequirementNode.TYPE_FURNI
                    ? this._itemSelection.selectedItem : null);
        }

        override public function onSaveClicked():void
        {
            var error:String = this.validate();
            if (error != null)
            {
                this.roomEvents.windowManager.alert(
                    "${wiredfurni.error.title}", error, 0, null);
                return;
            }
            if (this._isEditMode)
                this._editor.updateNode(this._uniqueId, this.createNode());
            else
                this._editor.addNode(this.createNode());
            this._editor = null;
            this._uniqueId = -1;
            this.hideFrame();
        }

        private function validate():String
        {
            if (this._type.selected == TradeRequirementNode.TYPE_FURNI &&
                this._amount.value > MAX_FURNI)
            {
                return this.localization.getLocalizationWithParams(
                    "wiredcontracts.element.too_many_items", "",
                    "amount", MAX_FURNI);
            }
            if (this._type.selected == TradeRequirementNode.TYPE_FURNI)
            {
                var data:IFurnitureData =
                    this._itemSelection.furniDataForSelectedItem;
                if (data == null || !data.tradeable)
                    return "${wiredcontracts.element.item_not_allowed}";
            }
            return null;
        }

        override public function dispose():void
        {
            if (disposed) return;
            this._type = null;
            this._amount = null;
            this._itemSelection = null;
            this._editor = null;
            this._parent = null;
            super.dispose();
        }
    }
}
