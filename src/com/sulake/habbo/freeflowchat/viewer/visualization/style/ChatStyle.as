package com.sulake.habbo.freeflowchat.viewer.visualization.style
{
    import com.sulake.habbo.freeflowchat.style.IChatStyle;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.geom.Point;
    import flash.text.StyleSheet;
    import flash.geom.ColorTransform;
    import flash.display.BlendMode;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import flash.display.Sprite;

    public class ChatStyle implements IChatStyle, IChatStyleInternal 
    {
        private var _background:BitmapData;
        private var _scale9Grid:Rectangle;
        private var _pointer:BitmapData;
        private var _pointerY:int;
        private var _pointerXMargins:Array;
        private var _textFieldMargins:Rectangle;
        private var _textFormat:TextFormat;
        private var _emblemImage:BitmapData;
        private var _emblemOffset:Point;
        private var _multilineEmblemImage:BitmapData;
        private var _multilineEmblemOffset:Point;
        private var _iconImage:BitmapData;
        private var _iconOffset:Point;
        private var _selectorPreview:BitmapData;
        private var _color:BitmapData;
        private var _colorOffset:Point;
        private var _overlap:Rectangle;
        private var _isSystemStyle:Boolean;
        private var _isHcOnly:Boolean;
        private var _isAmbassadorOnly:Boolean;
        private var _isStaffOverrideable:Boolean;
        private var _purchasable:Boolean;
        private var _isNotification:Boolean;
        private var _isAnonymous:Boolean;
        private var _allowHTML:Boolean;
        private var _styleSheet:StyleSheet;
        private var _usePixelPerfectNineSlice:Boolean;

        public function ChatStyle(k:BitmapData, _arg_2:Rectangle, _arg_3:BitmapData, _arg_4:int, _arg_5:Array, _arg_6:Rectangle, _arg_7:TextFormat, _arg_8:Boolean, _arg_9:BitmapData, _arg_10:Point, _arg_11:BitmapData, _arg_12:Point, _arg_13:Point, _arg_14:BitmapData, _arg_15:BitmapData, _arg_16:Boolean, _arg_17:Boolean, _arg_18:Boolean, _arg_19:Boolean, _arg_20:Boolean, _arg_21:Boolean, _arg_22:BitmapData=null, _arg_23:Point=null, _arg_24:Rectangle=null, _arg_25:Boolean=false, _arg_26:StyleSheet=null, _arg_27:Boolean=false)
        {
            this._background = k;
            this._scale9Grid = _arg_2;
            this._pointer = _arg_3;
            this._pointerY = _arg_4;
            this._pointerXMargins = _arg_5;
            this._textFieldMargins = _arg_6;
            this._textFormat = _arg_7;
            this._isAnonymous = _arg_8;
            this._emblemImage = _arg_9;
            this._emblemOffset = _arg_10;
            this._multilineEmblemImage = _arg_11;
            this._multilineEmblemOffset = _arg_12;
            this._iconOffset = _arg_13;
            this._iconImage = _arg_14;
            this._selectorPreview = _arg_15;
            this._isSystemStyle = _arg_16;
            this._purchasable = _arg_17;
            this._isHcOnly = _arg_18;
            this._isStaffOverrideable = _arg_19;
            this._isAmbassadorOnly = _arg_20;
            this._isNotification = _arg_21;
            this._color = _arg_22;
            this._colorOffset = _arg_23;
            this._overlap = _arg_24;
            this._allowHTML = _arg_25;
            this._styleSheet = _arg_26;
            this._usePixelPerfectNineSlice = _arg_27;
        }

        public function getNewBackgroundSprite(k:uint=0xFFFFFF):Sprite
        {
            var _local_2:BitmapData;
            var _local_3:uint;
            var _local_4:uint;
            var _local_5:uint;
            if (this._color != null)
            {
                _local_2 = new BitmapData(this._background.width, this._background.height, this._background.transparent, 0);
                _local_2.copyPixels(this._background, this._background.rect, new Point(0, 0));
                _local_3 = ((k >> 16) & 0xFF);
                _local_4 = ((k >> 8) & 0xFF);
                _local_5 = ((k >> 0) & 0xFF);
                _local_2.draw(this._color, null, new ColorTransform((_local_3 / 0xFF), (_local_4 / 0xFF), (_local_5 / 0xFF)), BlendMode.DARKEN);
            }
            else
            {
                _local_2 = this._background;
            }
            return this._usePixelPerfectNineSlice ? HabboFreeFlowChat.createPixelPerfect9SliceSprite(this._scale9Grid, _local_2) : HabboFreeFlowChat.create9SliceSprite(this._scale9Grid, _local_2);
        }

        public function get textFormat():TextFormat
        {
            return this._textFormat;
        }

        public function get styleSheet():StyleSheet
        {
            return this._styleSheet;
        }

        public function get pointer():BitmapData
        {
            return this._pointer;
        }

        public function get _Str_8470():int
        {
            return this._background.height - this._pointerY;
        }

        public function get pointerOffsetToBubbleBottom():int
        {
            return this._Str_8470;
        }

        public function getPointerLeftMargin(k:int):int
        {
            if (this._pointerXMargins == null || this._pointerXMargins.length < 1)
            {
                return k;
            }
            return int(this._pointerXMargins[0]);
        }

        public function getPointerRightMargin(k:int):int
        {
            if (this._pointerXMargins == null || this._pointerXMargins.length < 2)
            {
                return k;
            }
            return int(this._pointerXMargins[1]);
        }

        public function get _Str_4931():Boolean
        {
            return this._isAnonymous;
        }

        public function get isAnonymous():Boolean
        {
            return this._isAnonymous;
        }

        public function get _Str_5505():Point
        {
            return this._iconOffset;
        }

        public function get faceOffset():Point
        {
            return this._iconOffset;
        }

        public function getEmblem(k:Boolean=false):BitmapData
        {
            if (k && this._multilineEmblemImage != null && this._multilineEmblemOffset != null)
            {
                return this._multilineEmblemImage;
            }
            return this._emblemOffset != null ? this._emblemImage : null;
        }

        public function getEmblemOffset(k:Boolean=false):Point
        {
            if (k && this._multilineEmblemImage != null && this._multilineEmblemOffset != null)
            {
                return this._multilineEmblemOffset;
            }
            return this._emblemOffset;
        }

        public function get icon():BitmapData
        {
            return this._iconImage;
        }

        public function get iconImage():BitmapData
        {
            return this._iconImage;
        }

        public function get textFieldMargins():Rectangle
        {
            return this._textFieldMargins;
        }

        public function get overlap():Rectangle
        {
            return this._overlap;
        }

        public function get selectorPreview():BitmapData
        {
            return this._selectorPreview;
        }

        public function get isSystemStyle():Boolean
        {
            return this._isSystemStyle;
        }

        public function get isHcOnly():Boolean
        {
            return this._isHcOnly;
        }

        public function get purchasable():Boolean
        {
            return this._purchasable;
        }

        public function get isAmbassadorOnly():Boolean
        {
            return this._isAmbassadorOnly;
        }

        public function get isStaffOverrideable():Boolean
        {
            return this._isStaffOverrideable;
        }

        public function get allowHTML():Boolean
        {
            return this._allowHTML;
        }

        public function get isNotification():Boolean
        {
            return this._isNotification;
        }
    }
}
