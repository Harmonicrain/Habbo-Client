package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.components.IHTMLTextWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.HtmlTextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class HtmlPreset extends TextPreset
    {
        private var _htmlParam:HtmlTextParam;

        public function HtmlPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:HtmlTextParam)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
            this._htmlParam = _arg_5;
            (window as IHTMLTextWindow).selectable = this._htmlParam.selectable;
        }

        override protected function createView():ITextWindow
        {
            return _style.createHtmlView();
        }

        override protected function initializeMode(_arg_1:TextParam):void
        {
            super.initializeMode(_arg_1);
            this._window.multiline = false;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._htmlParam = null;
        }
    }
}
