package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class SectionPreset extends WiredUIPreset
    {
        private var _container:IItemListWindow;
        private var _contentList:IItemListWindow;
        private var _headerContainer:IWindowContainer;
        private var _headerOptionsRightList:IItemListWindow;
        private var _headerLeft:IItemListWindow;
        private var _expectedWidth:int;
        private var _splitter:SplitterPreset;
        private var _titlePreset:TextPreset;
        private var _headerOptionsRight:Vector.<WiredUIPreset>;
        private var _subPreset:WiredUIPreset;
        private var _headerOptionLeft:WiredUIPreset;

        public function SectionPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:WiredUIPreset, _arg_6:SectionParam = null)
        {
            var _local_9:CollapseExpandSectionButtonPreset;
            super(_arg_1, _arg_2, _arg_3);
            if (_arg_6 == null)
            {
                _arg_6 = SectionParam.DEFAULT;
            }
            this._container = _arg_2.createLayout("vertical_list_view") as IItemListWindow;
            this._contentList = _arg_2.createLayout("vertical_list_view") as IItemListWindow;
            this._container.spacing = _arg_3.sectionSpacing;
            this._contentList.spacing = _arg_3.sectionSpacing;
            this._contentList.x = _arg_3.sectionLeftRightMargin;
            this._headerOptionsRight = new Vector.<WiredUIPreset>();
            this._headerContainer = _arg_2.createLayout("container_view") as IWindowContainer;
            this._headerLeft = _arg_2.createLayout("horizontal_list_view") as IItemListWindow;
            this._headerLeft.spacing = _arg_3.genericHorizontalSpacing;
            this._headerOptionsRightList = _arg_2.createLayout("horizontal_list_view") as IItemListWindow;
            this._headerOptionsRightList.spacing = _arg_3.genericHorizontalSpacing;
            this._splitter = _arg_2.createSplitter();
            this._subPreset = _arg_5;
            this._headerOptionLeft = _arg_6.headerOptionLeft;
            var _local_7:TextParam = new TextParam((this._headerOptionLeft == null) ? 1 : 0, true);
            this._titlePreset = _arg_2.createText(_arg_4, _local_7);
            if (_arg_6.titleYOffset > 0)
            {
                this._titlePreset.window.y = _arg_6.titleYOffset;
            }
            this._headerLeft.addListItem(this._titlePreset.window);
            if (this._headerOptionLeft != null)
            {
                this._headerLeft.addListItem(this._headerOptionLeft.window);
            }
            this._headerContainer.addChild(this._headerLeft);
            this._headerContainer.addChild(this._headerOptionsRightList);
            this._container.addListItem(this._splitter.window);
            this._contentList.addListItem(this._headerContainer);
            if (_arg_6.expandMode != SectionParam.EXPAND_MODE_COLLAPSED)
            {
                this._contentList.addListItem(this._subPreset.window);
            }
            this._container.addListItem(this._contentList);
            for each (var _local_10:WiredUIPreset in _arg_6.miscHeaderOptions)
            {
                this.addHeaderOption(_local_10);
            }
            // Phase 2: SourceTypeSelectorPreset is deferred (Phase 4/6); the
            // sourceTypeSelectorParam branch is intentionally omitted.
            if (_arg_6.expandMode != SectionParam.EXPAND_MODE_EXPANDED)
            {
                _local_9 = _arg_2.createCollapseExpandSectionButton(this.onExpandCollapseClicked, (_arg_6.expandMode == SectionParam.EXPAND_MODE_EXPANDED_WITH_TOGGLE));
                this.addHeaderOption(_local_9);
            }
        }

        public function addHeaderOption(_arg_1:WiredUIPreset):void
        {
            this._headerOptionsRightList.addListItem(_arg_1.window);
            this._headerOptionsRight.push(_arg_1);
        }

        public function onExpandCollapseClicked(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._contentList.addListItem(this._subPreset.window);
            }
            else
            {
                this._contentList.removeListItem(this._subPreset.window);
            }
        }

        public function refreshAlignments():void
        {
            this.resizeToWidth(this._expectedWidth);
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            if (disposed || (this._container == null))
            {
                return;
            }
            super.resizeToWidth(_arg_1);
            this._expectedWidth = _arg_1;
            var _local_4:int = (_arg_1 - (2 * _style.sectionLeftRightMargin));
            this._splitter.resizeToWidth(_arg_1);
            this._subPreset.resizeToWidth(_local_4);
            var _local_3:int = 0;
            for each (var _local_5:WiredUIPreset in this._headerOptionsRight)
            {
                _local_5.resizeToWidth(_local_5.staticWidth);
                if (_local_5.window.bottom > _local_3)
                {
                    _local_3 = _local_5.window.bottom;
                }
            }
            this._headerOptionsRightList.x = (_local_4 - this._headerOptionsRightList.width);
            this._headerOptionsRightList.height = _local_3;
            var _local_2:int = this._titlePreset.window.height;
            if (this._headerOptionLeft != null)
            {
                this._headerOptionLeft.resizeToWidth(this._headerOptionLeft.staticWidth);
                this._titlePreset.resizeToWidth(this._titlePreset.staticWidth);
                if (this._headerOptionLeft.window.height > _local_2)
                {
                    _local_2 = this._headerOptionLeft.window.height;
                }
            }
            else
            {
                this._titlePreset.resizeToWidth((_local_4 - this._headerOptionsRightList.width) - _style.genericHorizontalSpacing);
                _local_2 = this._titlePreset.window.height;
            }
            this._headerLeft.height = _local_2;
            this._headerContainer.width = _local_4;
            this._headerContainer.height = Math.max(_local_3, _local_2);
            this._container.width = _arg_1;
        }

        public function set titleText(_arg_1:String):void
        {
            this._titlePreset.text = _arg_1;
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override protected function get childPresets():Array
        {
            var _local_1:Array = [this._splitter, this._titlePreset, this._subPreset];
            if (this._headerOptionLeft != null)
            {
                _local_1.push(this._headerOptionLeft);
            }
            if (this._headerOptionsRight != null)
            {
                return _local_1.concat(toArray(this._headerOptionsRight));
            }
            return _local_1;
        }

        public function set splitterVisible(_arg_1:Boolean):void
        {
            this._splitter.visible = _arg_1;
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
            this._contentList = null;
            this._headerContainer = null;
            this._headerOptionsRightList = null;
            this._splitter = null;
            this._titlePreset = null;
            this._subPreset = null;
            this._headerLeft = null;
            this._headerOptionLeft = null;
        }
    }
}
