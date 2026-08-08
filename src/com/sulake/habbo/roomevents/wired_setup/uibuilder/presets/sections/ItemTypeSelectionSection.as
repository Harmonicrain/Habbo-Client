package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.ChestItemIconPreviewerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.ItemTypeSelectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.session.furniture.IFurnitureData;

    public class ItemTypeSelectionSection extends AbstractSectionPreset
    {
        private var _selection:ItemTypeSelectionPreset;
        private var _preview:ChestItemIconPreviewerPreset;

        public function ItemTypeSelectionSection(roomEvents:HabboUserDefinedRoomEvents,
            presetManager:PresetManager, style:WiredStyle)
        {
            super(roomEvents, presetManager, style);
            this._selection = presetManager.createItemTypeSelectionPreset();
            this._preview = presetManager.createChestItemIconPreviewerPreset();
            var params:SectionParam = new SectionParam();
            params.addHeaderOption(this._preview.floatVertically());
            this.initializeSection("${wiredcontracts.element.itemtype.selection}",
                this._selection, params);
            this._selection.addListener(this.onChangeItemType);
        }

        private function onChangeItemType(value:ChestItemType):void
        {
            this._preview.item = value;
        }

        public function get selectedItem():ChestItemType { return this._selection.selectedItem; }
        public function get furniDataForSelectedItem():IFurnitureData { return this._selection.furniDataForSelectedItem; }
        public function resetInteractions():void { this._selection.resetInteractions(); }
        public function set selectedItem(value:ChestItemType):void { this._selection.selectedItem = value; }

        override public function dispose():void
        {
            if (disposed) return;
            super.dispose();
            this._selection = null;
            this._preview = null;
        }
    }
}
