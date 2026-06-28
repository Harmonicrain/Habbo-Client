package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.utils.FontEnum;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import fonts._Str_10339;
    import fonts._Str_10363;

    public class GamehallFonts
    {
        private static const VOLTER_FONT_FACE:String = "Volter";
        private static const VOLTER_BOLD_FONT_FACE:String = "Volter Bold";
        private static const VOLTER_FONT:Class = _Str_10363;
        private static const VOLTER_BOLD_FONT:Class = _Str_10339;

        private static var _registered:Boolean = false;

        public static function registerVolter():void
        {
            if (_registered)
            {
                return;
            }
            try
            {
                if (!FontEnum.isEmbeddedFont(VOLTER_FONT_FACE))
                {
                    FontEnum.registerFont(VOLTER_FONT);
                }
                if (!FontEnum.isEmbeddedFont(VOLTER_BOLD_FONT_FACE))
                {
                    FontEnum.registerFont(VOLTER_BOLD_FONT);
                }
            }
            catch(error:Error)
            {
            }
            _registered = true;
        }

        public static function createPanelText(caption:String, x:int, y:int, width:int, height:int, size:int, color:uint, align:String, underline:Boolean, bold:Boolean = false):TextField
        {
            registerVolter();
            var field:TextField = new TextField();
            var fontFace:String = bold ? VOLTER_BOLD_FONT_FACE : VOLTER_FONT_FACE;
            var format:TextFormat = new TextFormat(fontFace, size, color, false, false, underline, null, null, align);
            field.x = x;
            field.y = y;
            field.width = width;
            field.height = height;
            field.defaultTextFormat = format;
            field.setTextFormat(format);
            field.embedFonts = FontEnum.isEmbeddedFont(fontFace);
            field.antiAliasType = AntiAliasType.NORMAL;
            field.autoSize = TextFieldAutoSize.NONE;
            field.selectable = false;
            field.mouseEnabled = false;
            field.text = caption == null ? "" : caption;
            field.setTextFormat(format);
            return field;
        }
    }
}
