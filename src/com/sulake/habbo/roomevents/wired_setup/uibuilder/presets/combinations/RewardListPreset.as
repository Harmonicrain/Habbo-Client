package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class RewardListPreset extends WiredUIPreset
    {
        private var _container:IItemListWindow;
        private var _rowsContainer:IItemListWindow;
        private var _header:SimpleListViewPreset;
        private var _probabilityHeader:TextPreset;
        private var _rows:Vector.<RewardRowPreset>;
        private var _displayedRewards:int;
        private var _maxRewards:int;
        private var _probabilityEnabled:Boolean = true;
        private var _expectedWidth:int;

        public function RewardListPreset(roomEvents:HabboUserDefinedRoomEvents,
                                         presetManager:PresetManager,
                                         style:WiredStyle,
                                         maxRewards:int,
                                         displayedRewards:int)
        {
            super(roomEvents, presetManager, style);
            this._maxRewards = maxRewards;
            this._container = presetManager.createLayout("vertical_list_view") as IItemListWindow;
            this._container.spacing = style.genericVerticalSpacing;
            var badgeHeader:TextPreset = presetManager.createText(
                "Badge?", new TextParam(TextParam.MODE_STRETCH, false));
            var codeHeader:TextPreset = presetManager.createText(
                "Product/Badge code", new TextParam(TextParam.MODE_OVERFLOW, false));
            this._probabilityHeader = presetManager.createText(
                "Probability", new TextParam(TextParam.MODE_STRETCH, false));
            this._header = presetManager.createSimpleListView(
                false, [badgeHeader, codeHeader, this._probabilityHeader]);
            this._rowsContainer = presetManager.createLayout(
                "vertical_list_view") as IItemListWindow;
            this._rowsContainer.spacing = style.genericVerticalSpacing;
            this._rows = new Vector.<RewardRowPreset>();
            var index:int;
            while (index < this._maxRewards)
            {
                this._rows.push(presetManager.createRewardRow());
                index++;
            }
            this._container.addListItem(this._header.window);
            this._container.addListItem(this._rowsContainer);
            this.setDisplayedRewards(displayedRewards);
        }

        public function setDisplayedRewards(value:int):void
        {
            var target:int = Math.max(0, Math.min(this._maxRewards, value));
            if (target == this._displayedRewards)
            {
                return;
            }
            var index:int;
            if (target > this._displayedRewards)
            {
                index = this._displayedRewards;
                while (index < target)
                {
                    this._rowsContainer.addListItem(this._rows[index].window);
                    if (this._expectedWidth > 0)
                    {
                        this._rows[index].resizeToWidth(this._expectedWidth);
                    }
                    index++;
                }
            }
            else
            {
                index = this._displayedRewards - 1;
                while (index >= target)
                {
                    this._rowsContainer.removeListItem(this._rows[index].window);
                    index--;
                }
            }
            this._displayedRewards = target;
        }

        public function get displayedRewards():int
        {
            return this._displayedRewards;
        }

        public function getRow(index:int):RewardRowPreset
        {
            return this._rows[index];
        }

        public function setProbabilityEnabled(value:Boolean):void
        {
            if (this._probabilityEnabled == value)
            {
                return;
            }
            this._probabilityEnabled = value;
            this._probabilityHeader.disabled = !value;
            for each (var row:RewardRowPreset in this._rows)
            {
                row.setProbabilityEnabled(value);
            }
        }

        override public function resizeToWidth(width:int):void
        {
            super.resizeToWidth(width);
            this._expectedWidth = width;
            this._container.width = width;
            this._header.resizeToWidth(width);
            this._rowsContainer.width = width;
            var index:int;
            while (index < this._displayedRewards)
            {
                this._rows[index].resizeToWidth(width);
                index++;
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override protected function get childPresets():Array
        {
            var children:Array = [this._header];
            for each (var row:RewardRowPreset in this._rows)
            {
                children.push(row);
            }
            return children;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._rowsContainer = null;
            this._header = null;
            this._probabilityHeader = null;
            this._rows = null;
        }
    }
}
