package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
{
    public class HtmlTextParam extends TextParam
    {
        public static const DEFAULT:HtmlTextParam = new HtmlTextParam(1);

        private var _selectable:Boolean;

        public function HtmlTextParam(_arg_1:int, _arg_2:Boolean = false, _arg_3:int = 0)
        {
            super(_arg_1, false, _arg_3);
            this._selectable = _arg_2;
        }

        public function get selectable():Boolean { return this._selectable; }
    }
}
