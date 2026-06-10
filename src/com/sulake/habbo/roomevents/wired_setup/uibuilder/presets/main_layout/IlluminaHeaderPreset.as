package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
{
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.IWiredTypeHolder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class IlluminaHeaderPreset extends HeaderPreset
    {
        private var _name1Preset:TextPreset;
        private var _name2Preset:TextPreset;

        public function IlluminaHeaderPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:IWiredTypeHolder, _arg_6:int, _arg_7:Function, _arg_8:Function, _arg_9:Function)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
        }

        override protected function createTopHeaderElement(_arg_1:String, _arg_2:IWiredTypeHolder):WiredUIPreset
        {
            var _local_5:Array = this.getNameParts(_arg_1);
            var _local_3:TextParam = new TextParam(1, true);
            _local_3.fontSize = 11;
            this._name1Preset = _presetManager.createText(_local_5[0], _local_3);
            _local_3 = new TextParam(1, true);
            _local_3.fontSize = _style.headerNameFontSize;
            _local_3.textColor = 0x494949;
            this._name2Preset = _presetManager.createText(_local_5[1], _local_3);
            var _local_4:SimpleListViewPreset = _presetManager.createSimpleListView(true, [_presetManager.createSpacing(true, 3), this._name1Preset, this._name2Preset]);
            _local_4.spacing = -2;
            _local_4.window.x = 3;
            return _local_4;
        }

        private function getNameParts(_arg_1:String):Array
        {
            var _local_2:Array = _arg_1.split(":", 2);
            while (_local_2.length < 2)
            {
                _local_2.push("");
            }
            while (_local_2[1].indexOf(" ") == 0)
            {
                _local_2[1] = _local_2[1].substring(1);
            }
            _local_2[0] = _local_2[0].toUpperCase();
            return _local_2;
        }

        override public function updateName(_arg_1:String):void
        {
            var _local_2:Array = this.getNameParts(_arg_1);
            this._name1Preset.text = _local_2[0];
            this._name2Preset.text = _local_2[1];
            resizeToWidth(_width);
        }

        override public function dispose():void
        {
            super.dispose();
            this._name1Preset = null;
            this._name2Preset = null;
        }
    }
}
