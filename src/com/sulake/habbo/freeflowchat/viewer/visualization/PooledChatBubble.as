package com.sulake.habbo.freeflowchat.viewer.visualization
{
    import flash.display.Sprite;
    import com.sulake.habbo.freeflowchat.HabboFreeFlowChat;
    import com.sulake.habbo.freeflowchat.data.ChatItem;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import com.sulake.habbo.freeflowchat.viewer.visualization.style.IChatStyleInternal;
    import flash.events.Event;
    import com.sulake.habbo.freeflowchat.viewer.enum.ChatBubbleWidth;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.events.TextEvent;
    import com.sulake.habbo.session.events.RoomSessionChatEvent;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;

    public class PooledChatBubble extends Sprite 
    {
        public static const _Str_7976:uint = 300;

        private const _Str_10527:int = 85;
        private const _Str_16997:int = 190;
        private const _Str_6907:uint = 150;
        private const MAX_HEIGHT:uint = 108;
        private const _Str_10539:int = 28;
        private const _Str_11116:int = 15;
        private const _Str_25378:int = 2000;

        private var _component:HabboFreeFlowChat;
        private var _chatItem:ChatItem;
        private var _background:Sprite;
        private var _pointer:Bitmap;
        private var _emblem:Bitmap;
        private var _face:Bitmap;
        private var _faceBitmapData:BitmapData;
        private var _textField:TextField;
        private var _style:IChatStyleInternal;
        private var _timeMs:uint = 0;
        private var _moveBeginMs:uint;
        private var _moveTargetX:int;
        private var _moveTargetY:int;
        private var _moveOriginX:int;
        private var _moveOriginY:int;
        private var _moveDeltaXPerMs:Number;
        private var _moveDeltaYPerMs:Number;
        private var _readyToRecycle:Boolean = false;
        private var _roomPanOffsetX:int = 0;
        private var _proxyX:int;
        private var _useDesktopMargins:Boolean = false;
        private var _hasHitDesktopMargin:Boolean = false;
        private var _clipMask:Sprite;
        private var _timePointerPositionUpdateMs:uint = 0;
        private var _minHeight:int = -1;

        public function PooledChatBubble(k:HabboFreeFlowChat)
        {
            this._component = k;
            this._pointer = new Bitmap();
            this._emblem = new Bitmap();
            this._face = new Bitmap();
            this._textField = new TextField();
            this._clipMask = new Sprite();
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        public function set chatItem(k:ChatItem):void
        {
            this._chatItem = k;
        }

        public function set face(k:BitmapData):void
        {
            this._faceBitmapData = k;
        }

        public function set style(k:IChatStyleInternal):void
        {
            this._style = k;
        }

        public function _Str_19209(k:String, _arg_2:uint, _arg_3:Boolean=false, _arg_4:int=-1):void
        {
            var _local_13:int;
            var _local_14:int;
            var _local_15:Array;
            var _local_16:String;
            var _local_17:String;
            var _local_18:String;
            var _local_19:int;
            var _local_20:BitmapData;
            this._background = this._style.getNewBackgroundSprite(_arg_2);
            this._pointer.bitmapData = this._style.pointer;
            this._useDesktopMargins = _arg_3;
            var _local_21:int = int(this.MAX_HEIGHT * this._component.chatFontSizeScale);
            var _local_5:int = ((this._component.roomChatSettings) ? ChatBubbleWidth.fromValue(this._component.roomChatSettings.bubbleWidth) : _Str_7976);
            var _local_6:int = ((_local_5 - this._style.textFieldMargins.x) - this._style.textFieldMargins.width);
            this._textField.width = _local_6;
            this._textField.multiline = true;
            this._textField.wordWrap = true;
            this._textField.selectable = false;
            this._textField.thickness = -15;
            this._textField.sharpness = 80;
            this._textField.antiAliasType = AntiAliasType.ADVANCED;
            this._textField.embedFonts = true;
            this._textField.gridFitType = GridFitType.PIXEL;
            this._textField.cacheAsBitmap = (!(this._style.allowHTML));
            this._textField.styleSheet = null;
            this._textField.defaultTextFormat = this.createScaledTextFormat(this._style.textFormat, this._component.chatFontSizeScale);
            this._textField.styleSheet = this._style.styleSheet;
            this._textField.addEventListener(TextEvent.LINK, this._Str_10834);
            var _local_7:* = (this._chatItem.chatType == RoomSessionChatEvent.CHAT_TYPE_SPEAK);
            var _local_8:* = (this._chatItem.chatType == RoomSessionChatEvent.CHAT_TYPE_SHOUT);
            var _local_9:Boolean = (((!(_local_7)) && (!(_local_8))) && (!(this._style._Str_4931)));
            if (_local_9)
            {
                this._textField.alpha = 0.6;
            }
            else
            {
                this._textField.alpha = 1;
            }
            var _local_10:String = (((_local_9) ? "<i>" : "") + ((this._style._Str_4931) ? "" : (("<b>" + k) + ": </b>")));
            _local_10 = (((_local_10 + ((_local_8) ? "<b>" : "")) + this._chatItem.text) + ((_local_8) ? "</b>" : ""));
            _local_10 = (_local_10 + ((_local_9) ? "</i>" : ""));
            if (((this._chatItem.links == null) || (this._chatItem.links[0] == null)))
            {
                this._textField.htmlText = _local_10;
            }
            else
            {
                _local_14 = -1;
                _local_15 = new Array();
                _local_13 = 0;
                while (_local_13 < this._chatItem.links.length)
                {
                    _local_16 = this._chatItem.links[_local_13][0][1];
                    _local_17 = (((('<a href="' + _local_16) + '">') + _local_16) + "</a>");
                    _local_18 = (("{" + _local_13) + "}");
                    _local_19 = this._chatItem.text.indexOf(_local_18);
                    _local_14 = (_local_19 + _local_17.length);
                    _local_15.push([_local_19, _local_14]);
                    _local_10 = _local_10.replace(_local_18, _local_17);
                    _local_13++;
                }
                this._textField.htmlText = _local_10;
            }
            this._minHeight = _arg_4;
            var _local_11:int = Math.min(_local_5, ((this._textField.textWidth + this._style.textFieldMargins.x) + this._style.textFieldMargins.width));
            var _local_12:int = ((this._textField.textHeight + this._style.textFieldMargins.y) + this._style.textFieldMargins.height);
            var _local_22:Boolean = this._textField.numLines > 1;
            if (!this._style.isSystemStyle)
            {
                _local_12 = Math.min(_local_21, _local_12);
            }
            if (_arg_4 != -1)
            {
                _local_12 = Math.max(_arg_4, _local_12);
            }
            _local_11 = Math.max(_local_11, this._background.width);
            _local_12 = Math.max(_local_12, this._background.height);
            this._background.width = _local_11;
            this._background.height = _local_12;
            this._background.x = 0;
            this._background.y = 0;
            this._background.cacheAsBitmap = true;
            addChild(this._background);
            var _local_23:BitmapData = this._style.getEmblem(_local_22);
            var _local_24:Point = this._style.getEmblemOffset(_local_22);
            if (((_local_23 != null) && (_local_24 != null)))
            {
                this._emblem.bitmapData = _local_23;
                this._emblem.x = _local_24.x;
                this._emblem.y = _local_24.y;
                addChild(this._emblem);
            }
            else
            {
                this._emblem.bitmapData = null;
            }
            if (!this._style._Str_4931)
            {
                this._pointer.x = Math.max(this._style.getPointerLeftMargin(this._Str_10539), Math.min((_local_11 - this._style.getPointerRightMargin(this._Str_11116)), this._Str_10783));
                this._pointer.y = (_local_12 - this._style.pointerOffsetToBubbleBottom);
                addChild(this._pointer);
            }
            if (((!(this._faceBitmapData == null)) && (!(this._style.faceOffset == null))))
            {
                if (this._faceBitmapData.height > _local_12)
                {
                    _local_20 = new BitmapData(this._faceBitmapData.width, _local_12);
                    _local_20.copyPixels(this._faceBitmapData, new Rectangle(0, (this._faceBitmapData.height - _local_12), this._faceBitmapData.width, _local_12), new Point(0, 0));
                }
                else
                {
                    _local_20 = this._faceBitmapData;
                }
                this._face.bitmapData = _local_20;
                this._face.x = (this._style.faceOffset.x - (_local_20.width / 2));
                this._face.y = Math.max(1, (this._style.faceOffset.y - (_local_20.height / 2)));
                addChild(this._face);
            }
            this._textField.width = Math.min(_local_6, (this._textField.textWidth + this._style.textFieldMargins.width));
            this._textField.height = (this._textField.textHeight + this._style.textFieldMargins.height);
            this._textField.x = this._style.textFieldMargins.x;
            this._textField.y = this._style.textFieldMargins.y;
            addChild(this._textField);
            if (((!(this._style.isSystemStyle)) && (this._textField.textHeight > _local_21)))
            {
                this._clipMask.graphics.clear();
                this._clipMask.graphics.beginFill(0xFFFFFF);
                this._clipMask.graphics.drawRect(0, 0, (this._textField.textWidth + 5), (_local_21 - this._style.textFieldMargins.height));
                this._clipMask.graphics.endFill();
                this._textField.mask = this._clipMask;
                addChild(this._clipMask);
                this._clipMask.x = this._textField.x;
                this._clipMask.y = this._textField.y;
            }
            else
            {
                this._clipMask.graphics.clear();
                this._textField.mask = null;
            }
            if (((this._style.isNotification) && (!(this._face == null))) && (!(this._face.bitmapData == null)))
            {
                this._face.y = Math.max(1, (height / 2) - (this._face.bitmapData.height / 2));
                this._face.x = (this._face.x - 0.5);
                if (!this._style.isAnonymous)
                {
                    this._face.y = (this._face.y - ((this._pointer.height / 2) - 1));
                }
            }
            this.cacheAsBitmap = (!(this._style.allowHTML));
            this._readyToRecycle = false;
            this._timeMs = 0;
            this._timePointerPositionUpdateMs = 0;
            visible = false;
        }

        public function _Str_23848():void
        {
            this.cacheAsBitmap = false;
            this.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
            if (this._clipMask.parent == this)
            {
                this._Str_26452(this._clipMask);
            }
            this._Str_26452(this._textField);
            if (((!(this._style.faceOffset == null)) && (this._face.parent == this)))
            {
                this._Str_26452(this._face);
                this._face.bitmapData = null;
            }
            if (this._emblem.parent == this)
            {
                this._Str_26452(this._emblem);
                this._emblem.bitmapData = null;
            }
            if (((this._pointer) && (this._pointer.parent)))
            {
                this._Str_26452(this._pointer);
            }
            this._Str_26452(this._background);
            if (this._textField)
            {
                this._textField.removeEventListener(TextEvent.LINK, this._Str_10834);
            }
        }

        private function _Str_10834(k:TextEvent):void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:TextField;
            var _local_5:Point;
            var _local_6:Rectangle;
            var _local_7:String;
            if (((k.text) && (k.text.length > 0)))
            {
                _local_2 = k.text;
                _local_3 = "highlight/";
                if (_local_2.indexOf(_local_3) > -1)
                {
                    _local_4 = (k.target as TextField);
                    _local_5 = new Point(_local_4.mouseX, _local_4.mouseY);
                    _local_5 = _local_4.localToGlobal(_local_5);
                    _local_6 = new Rectangle(_local_5.x, _local_5.y);
                    _local_7 = _local_2.substr((_local_2.indexOf(_local_3) + _local_3.length), _local_2.length);
                    this._component.windowManager.hideHint();
                    this._component.windowManager.showHint(_local_7.toLocaleUpperCase(), _local_6);
                }
                else
                {
                    this._component.context.createLinkEvent(k.text);
                }
            }
        }

        private function _Str_26452(child:DisplayObject):void
        {
            try
            {
                removeChild(child);
            }
            catch(error:ArgumentError)
            {
            }
        }

        public function get _Str_22234():Number
        {
            return (this._style.isSystemStyle) ? height : Math.min(int(this.MAX_HEIGHT * this._component.chatFontSizeScale), height);
        }

        private function onAddedToStage(k:Event):void
        {
            this.addEventListener(MouseEvent.CLICK, this.onMouseClick);
        }

        private function onRemovedFromStage(k:Event):void
        {
            this.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
        }

        public function moveTo(k:int, _arg_2:int):void
        {
            if (((!(this._moveTargetX == k)) || (!(this._moveTargetY == _arg_2))))
            {
                this._moveBeginMs = this._timeMs;
                this._moveOriginX = this._Str_3980;
                this._moveOriginY = y;
                this._moveTargetX = k;
                this._moveTargetY = _arg_2;
                this._moveDeltaXPerMs = ((k - this._Str_3980) / Number(this._Str_6907));
                this._moveDeltaYPerMs = ((_arg_2 - y) / Number(this._Str_6907));
            }
        }

        public function _Str_12023(k:int, _arg_2:int):void
        {
            this._moveTargetX = k;
            this._moveTargetY = _arg_2;
            this._Str_3980 = k;
            y = _arg_2;
        }

        public function update(k:uint):void
        {
            var _local_2:uint;
            this._timeMs = (this._timeMs + k);
            if (((!(this._Str_3980 == this._moveTargetX)) || (!(y == this._moveTargetY))))
            {
                _local_2 = (this._timeMs - this._moveBeginMs);
                if (((_local_2 < this._Str_6907) && (_local_2 > 0)))
                {
                    this._Str_3980 = int((this._moveOriginX + (_local_2 * this._moveDeltaXPerMs)));
                    y = int((this._moveOriginY + (_local_2 * this._moveDeltaYPerMs)));
                }
                else
                {
                    this._Str_3980 = this._moveTargetX;
                    y = this._moveTargetY;
                }
            }
            if (this._timeMs > (this._timePointerPositionUpdateMs + this._Str_25378))
            {
                this._Str_12210();
                this._timePointerPositionUpdateMs = this._timeMs;
            }
            if (((this._timeMs > this._Str_6907) && (!(visible))))
            {
                visible = true;
            }
        }

        public function get _Str_3980():int
        {
            return this._proxyX;
        }

        public function set _Str_3980(k:int):void
        {
            var _local_2:int;
            var _local_3:int;
            this._proxyX = k;
            if (((this._useDesktopMargins) && (stage)))
            {
                _local_2 = (this._proxyX + this._roomPanOffsetX);
                this._hasHitDesktopMargin = false;
                _local_3 = ((stage.stageWidth - this._Str_16997) - width);
                if (_local_2 > _local_3)
                {
                    _local_2 = _local_3;
                    this._hasHitDesktopMargin = true;
                }
                if (_local_2 < this._Str_10527)
                {
                    _local_2 = this._Str_10527;
                    this._hasHitDesktopMargin = true;
                }
                x = _local_2;
            }
            else
            {
                x = (this._proxyX + this._roomPanOffsetX);
            }
        }

        public function _Str_12210():void
        {
            if (((this._pointer) && (this._pointer.parent)))
            {
                this._pointer.x = Math.max(this._style.getPointerLeftMargin(this._Str_10539), Math.min((this._background.width - this._style.getPointerRightMargin(this._Str_11116)), this._Str_10783));
                this._pointer.y = (this._background.height - this._style.pointerOffsetToBubbleBottom);
            }
        }

        private function createScaledTextFormat(k:TextFormat, _arg_2:Number):TextFormat
        {
            var _local_3:TextFormat = new TextFormat();
            _local_3.align = k.align;
            _local_3.blockIndent = k.blockIndent;
            _local_3.bold = k.bold;
            _local_3.bullet = k.bullet;
            _local_3.color = k.color;
            _local_3.display = k.display;
            _local_3.font = k.font;
            _local_3.indent = k.indent;
            _local_3.italic = k.italic;
            _local_3.kerning = k.kerning;
            _local_3.leading = k.leading;
            _local_3.leftMargin = k.leftMargin;
            _local_3.letterSpacing = k.letterSpacing;
            _local_3.rightMargin = k.rightMargin;
            _local_3.size = int(Number(k.size) * _arg_2);
            _local_3.tabStops = k.tabStops;
            _local_3.target = k.target;
            _local_3.underline = k.underline;
            _local_3.url = k.url;
            return _local_3;
        }

        public function get _Str_4702():Boolean
        {
            return this._readyToRecycle;
        }

        public function set _Str_4702(k:Boolean):void
        {
            this._readyToRecycle = k;
            if (k)
            {
                this.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
            }
        }

        public function get timeStamp():uint
        {
            return this._chatItem.timeStamp;
        }

        public function set component(k:HabboFreeFlowChat):void
        {
            this._component = k;
        }

        private function get _Str_10783():int
        {
            return this._Str_11643.x - this.x;
        }

        public function get _Str_11643():Point
        {
            if (this._chatItem._Str_12917)
            {
                return new Point(((this._component.displayObject.stage.stageWidth / 2) + Number(this._chatItem._Str_12917)), 500);
            }
            return this._component.getScreenPointFromRoomLocation(this._chatItem.roomId, this._chatItem._Str_20712);
        }

        public function get roomId():int
        {
            return this._chatItem.roomId;
        }

        public function set _Str_18364(k:int):void
        {
            if (this._roomPanOffsetX != k)
            {
                this._roomPanOffsetX = k;
                this._Str_12023(this._moveTargetX, this._moveTargetY);
            }
        }

        private function onMouseClick(k:MouseEvent):void
        {
            if (((this._style) && (this._style._Str_4931)))
            {
                return;
            }
            if (!this._component.clickHasToPropagate(k))
            {
                this._component.selectAvatarWithChatItem(this._chatItem);
                k.stopImmediatePropagation();
            }
        }

        public function get overlap():Rectangle
        {
            return this._style.overlap;
        }

        public function get _Str_19538():Boolean
        {
            return this._hasHitDesktopMargin;
        }

        public function get minHeight():int
        {
            return this._minHeight;
        }
    }
}
