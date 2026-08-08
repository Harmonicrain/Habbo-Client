package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.room.IRoomAreaSelectionManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ButtonRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class AreaSelectorElement extends DefaultElement
    {
        private var _code:int;
        private var _areaSelectionManager:IRoomAreaSelectionManager;
        private var _x:int = 0;
        private var _y:int = 0;
        private var _width:int = 0;
        private var _height:int = 0;
        private var _active:Boolean = false;
        private var _selectButton:ButtonPreset;
        private var _clearButton:ButtonPreset;
        private var _selectWindow:IButtonWindow;
        private var _clearWindow:IButtonWindow;

        public function AreaSelectorElement(k:int)
        {
            super();
            this._code = k;
        }

        private static function enableButton(k:IButtonWindow, _arg_2:Boolean):void
        {
            if (k == null)
            {
                return;
            }
            if (_arg_2)
            {
                k.enable();
            }
            else
            {
                k.disable();
            }
        }

        override public function get code():int
        {
            return this._code;
        }

        override public function onInit(k:HabboUserDefinedRoomEvents):void
        {
            super.onInit(k);
            this._areaSelectionManager = k.roomEngine.areaSelectionManager;
        }

        override public function onEditStart(k:Triggerable):void
        {
            if ((!this._active) && (this._areaSelectionManager != null))
            {
                this._active = this._areaSelectionManager.activate(this.onAreaSelected, "highlight_brighten");
            }
            this._x = (k.intData.length > 0) ? k.intData[0] : 0;
            this._y = (k.intData.length > 1) ? k.intData[1] : 0;
            this._width = (k.intData.length > 2) ? k.intData[2] : 0;
            this._height = (k.intData.length > 3) ? k.intData[3] : 0;
            if (this._active)
            {
                this._areaSelectionManager.setHighlight(this._x, this._y, this._width, this._height);
                enableButton(this._selectWindow, true);
                enableButton(this._clearWindow, true);
            }
            else
            {
                enableButton(this._selectWindow, false);
                enableButton(this._clearWindow, false);
            }
        }

        override public function onEditEnd():void
        {
            super.onEditEnd();
            if ((this._active) && (this._areaSelectionManager != null))
            {
                this._areaSelectionManager.deactivate();
                this._active = false;
            }
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._x, this._y, this._width, this._height];
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(k:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
            var _local_4:TextParam = new TextParam(1);
            _local_4.textColor = _arg_2.softTextColor;
            var _local_5:TextPreset = k.createText(l("area_selection.info"), _local_4);
            this._selectButton = k.createButton(l("area_selection.select"), this.onSelect);
            this._clearButton = k.createButton(l("area_selection.clear"), this.onClear);
            var _local_6:ButtonRowPreset = k.createButtonRow([this._selectButton, this._clearButton]);
            var _local_7:SectionPreset = k.createSection(l("area_selection"), k.createSimpleListView(true, [_local_5, _local_6]));
            _arg_3.addElements(_local_7);
            this._selectWindow = this._selectButton.window as IButtonWindow;
            this._clearWindow = this._clearButton.window as IButtonWindow;
        }

        private function onSelect():void
        {
            enableButton(this._selectWindow, false);
            if (this._areaSelectionManager != null)
            {
                this._areaSelectionManager.startSelecting();
            }
        }

        private function onClear():void
        {
            if (this._areaSelectionManager != null)
            {
                this._areaSelectionManager.clearHighlight();
            }
        }

        private function onAreaSelected(k:int, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            enableButton(this._selectWindow, true);
            this._x = k;
            this._y = _arg_2;
            this._width = _arg_3;
            this._height = _arg_4;
        }
    }
}
