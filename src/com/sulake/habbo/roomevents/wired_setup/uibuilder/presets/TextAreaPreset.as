package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class TextAreaPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _inputView:IWindow;
        private var _field:ITextFieldWindow;
        private var _placeholderPreset:TextPreset;
        private var _param:TextAreaParam;
        private var _fieldWidthDelta:int;

        public function TextAreaPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:TextAreaParam)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("growing_container_view") as IWindowContainer;
            this._inputView = _arg_3.createTextInputView();
            this._field = (this._inputView as IWindowContainer).findChildByName("field") as ITextFieldWindow;
            this._fieldWidthDelta = (this._inputView.width - this._field.width);
            this._param = _arg_4;
            if (_arg_4.maxCharacters > 0)
            {
                this._field.maxChars = _arg_4.maxCharacters;
            }
            this._field.text = this._param.initialText;
            this._field.multiline = true;
            this._field.wordWrap = _arg_4.wordwrap;
            if (_arg_4.width >= 0)
            {
                this._inputView.width = (_arg_4.width + this._fieldWidthDelta);
            }
            this._inputView.height = _arg_4.height;
            if (_arg_4.maxLines >= 0)
            {
                this._field.maxLines = _arg_4.maxLines;
            }
            this._field.editable = _arg_4.editable;
            this._field.restrict = _arg_4.restrict;
            if (_arg_4.tooltip != null)
            {
                this._field.toolTipCaption = _arg_4.tooltip;
            }
            this._container.addChild(this._inputView);
            if (_arg_4.placeholder != null)
            {
                this._placeholderPreset = _arg_2.createText(_arg_4.placeholder, new TextParam(1));
                this._placeholderPreset.window.blend = 0.5;
                this._placeholderPreset.window.tags.push("HALF_BLEND");
                this._placeholderPreset.window.x = this._field.x;
                this._placeholderPreset.window.y = this._field.y;
                this._container.addChild(this._placeholderPreset.window);
            }
            this._field.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.textHasChanged);
            this.textHasChanged(null);
        }

        private function textHasChanged(_arg_1:WindowEvent):void
        {
            if (this._placeholderPreset)
            {
                this._placeholderPreset.visible = (this._field.length == 0);
            }
            this.updateWarn();
        }

        public function get text():String
        {
            return this._field.text.replace(/\n\r/g, "\n").replace(/\r/g, "\n");
        }

        public function set text(_arg_1:String):void
        {
            this._field.text = _arg_1.replace(/\n/g, "\r");
            this.textHasChanged(null);
        }

        public function reset():void
        {
            this._field.text = "";
            this.textHasChanged(null);
        }

        private function shouldShowWarn():Boolean
        {
            var _local_2:int = this._param.maxCharacters;
            if (_local_2 <= 10)
            {
                return false;
            }
            var _local_1:int = Math.min(30, Math.max(6, _local_2 / 5));
            return this._field.text.length > (_local_2 - _local_1);
        }

        private function updateWarn():void
        {
            if (this.charLimitWarnArea == null)
            {
                return;
            }
            var _local_1:Boolean = this.shouldShowWarn();
            this.charLimitWarnArea.visible = _local_1;
            if (_local_1)
            {
                this.limitText.text = (this._field.text.length + "/" + this._param.maxCharacters);
            }
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            var _local_2:int = int((this._param.width >= 0) ? (this._param.width + this._fieldWidthDelta) : _arg_1);
            this._inputView.width = _local_2;
            if (this._placeholderPreset != null)
            {
                this._placeholderPreset.resizeToWidth(_local_2 - this._fieldWidthDelta);
            }
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override protected function get childPresets():Array
        {
            return (this._placeholderPreset == null) ? [] : [this._placeholderPreset];
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
            this._placeholderPreset = null;
            this._param = null;
        }

        private function get charLimitWarnArea():IWindowContainer
        {
            return this._container.findChildByName("char_limit_warn") as IWindowContainer;
        }

        private function get limitText():ITextWindow
        {
            return this._container.findChildByName("limit_text") as ITextWindow;
        }
    }
}
