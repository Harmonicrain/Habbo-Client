package com.sulake.habbo.ui.widget.chatinput.styleselector
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.ui.widget.chatinput.RoomChatInputView;
    import com.sulake.core.window.IWindowContainer;
    import __AS3__.vec.Vector;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.assets.XmlAsset;
    import flash.display.Shape;
    import com.sulake.habbo.session.ISessionDataManager;
    import flash.display.BitmapData;
    import com.sulake.habbo.freeflowchat.style.IChatStyle;
    import flash.display.Sprite;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import __AS3__.vec.*;

    public class ChatStyleSelector implements IDisposable 
    {
        private static const _Str_17267:int = 1;
        private static const _Str_16506:int = 6;
        private static const FONT_SIZE_LABELS:Array = ["S", "M", "L", "XL", "XXL"];
        private static var _Str_1007:ChatStyleGridEntry = null;
        private static var _Str_6012:Boolean = false;
        private static var _fontSizeMode:int = 0;

        private var _roomChatInputView:RoomChatInputView;
        private var _container:IWindowContainer;
        private var _Str_3334:ChatStyleGridView;
        private var _Str_2514:Vector.<ChatStyleGridEntry>;
        private var _Str_11421:IWindow;
        private var _fontSizeTemplate:IWindow;
        private var _Str_4357:Shape;

        public function ChatStyleSelector(k:RoomChatInputView, _arg_2:IWindowContainer, _arg_3:ISessionDataManager)
        {
            this._Str_2514 = new Vector.<ChatStyleGridEntry>();
            super();
            this._roomChatInputView = k;
            this._Str_3334 = new ChatStyleGridView(this, this._roomChatInputView.sessionDataManager);
            this._Str_11421 = this.buildTemplateWindow("chatinput_chatstyle_template_xml");
            this._fontSizeTemplate = this.buildTemplateWindow("chatinput_chatfontsize_template_xml");
            this._container = _arg_2;
            this._container.procedure = this._Str_12416;
            if (((this._Str_3334.window) && (this._roomChatInputView._Str_22667)))
            {
                this._roomChatInputView._Str_22667.addChild(this._Str_3334.window);
                this._Str_3334.window.x = 0;
                this._Str_3334.window.y = 0;
            }
            this._roomChatInputView._Str_22667.visible = false;
            this.createFontSizeOptions();
        }

        public function dispose():void
        {
            while (this._Str_2514.length > 1)
            {
                this._Str_2514.pop();
            }
            this._Str_2514 = null;
            this._Str_3334.dispose();
            this._Str_3334 = null;
            this._fontSizeTemplate = null;
            if (((this._Str_4357) && (this._Str_4357.parent)))
            {
                this._Str_4357.parent.removeChild(this._Str_4357);
            }
        }

        public function get disposed():Boolean
        {
            return this._Str_3334 == null;
        }

        public function get _Str_20286():RoomChatInputView
        {
            return this._roomChatInputView;
        }

        public function addItem(k:int, _arg_2:BitmapData):void
        {
            if (((this._Str_3334 == null) || (this._Str_3334.grid == null)) || (this._Str_11421 == null))
            {
                return;
            }
            this._Str_2514.push(new ChatStyleGridEntry(k, _arg_2));
            var _local_3:IWindowContainer = this._Str_22807(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            this._Str_3334.grid.addGridItem(_local_3);
            _local_3.findChildByName("background_color").visible = false;
        }

        public function get _Str_22824():int
        {
            if (((_Str_6012) && (this.selected)))
            {
                _Str_6012 = false;
                return this.selected.id;
            }
            return -1;
        }

        public function get _Str_26237():BitmapData
        {
            if (this.selected)
            {
                return this.selected.bitmap;
            }
            return null;
        }

        public function _Str_24820():void
        {
            this.selected = this.selected;
            _Str_6012 = false;
            if (this._roomChatInputView.widget.handler.container.freeFlowChat)
            {
                this.initFontSizeSelection(this._roomChatInputView.widget.handler.container.freeFlowChat.chatFontSizeMode);
            }
        }

        public function set _Str_22746(k:int):void
        {
            if (((this._Str_3334 == null) || (this._Str_3334.grid == null)) || (this._Str_11421 == null))
            {
                return;
            }
            k = Math.min(k, _Str_16506);
            var _local_2:int = (((k - 1) * (this._Str_11421.width + _Str_17267)) + this._Str_11421.width);
            if (k > 1)
            {
                this._Str_3334.grid.width = _local_2;
            }
            else
            {
                this._Str_3334.grid.width = (this._Str_11421.width + 16);
            }
        }

        private function set selected(k:ChatStyleGridEntry):void
        {
            if (k == null)
            {
                return;
            }
            _Str_1007 = k;
            _Str_6012 = true;
            var _local_2:IChatStyle = this._roomChatInputView.widget._Str_13265.chatStyleLibrary.getStyle(k.id);
            if (this._roomChatInputView.window.findChildByName("chat_bg_preview") == null)
            {
                return;
            }
            var _local_3:Sprite = _local_2.getNewBackgroundSprite(0xFFFFFF);
            var _local_4:IDisplayObjectWrapper = IDisplayObjectWrapper(this._roomChatInputView.window.findChildByName("chat_bg_preview"));
            _local_3.width = (_local_4.width + _local_2.overlap.width);
            _local_3.height = ((_local_4.height + _local_2.overlap.y) + _local_2.overlap.height);
            _local_3.y = (_local_3.y - _local_2.overlap.y);
            if (!this._Str_4357)
            {
                this._Str_4357 = new Shape();
            }
            else
            {
                this._Str_4357.graphics.clear();
            }
            this._Str_4357.graphics.beginFill(0xFF0000);
            this._Str_4357.graphics.drawRect(0, 0, (_local_3.width - 28), _local_3.height);
            _local_4.setDisplayObject(_local_3);
            if (_local_3.parent)
            {
                _local_3.parent.addChild(this._Str_4357);
                this._Str_4357.x = (_local_3.x + 28);
                this._Str_4357.y = _local_3.y;
                _local_3.mask = this._Str_4357;
            }
            this._roomChatInputView._Str_24855((_local_2.textFormat.color as uint));
        }

        private function get selected():ChatStyleGridEntry
        {
            if (((_Str_1007 == null) && (this._Str_2514.length > 0)))
            {
                _Str_1007 = this._Str_2514[(this._Str_2514.length - 1)];
            }
            return _Str_1007;
        }

        private function _Str_22807(k:BitmapData):IWindowContainer
        {
            if (this._Str_11421 == null)
            {
                return null;
            }
            var _local_2:IWindowContainer = IWindowContainer(this._Str_11421.clone());
            var _local_3:IBitmapWrapperWindow = IBitmapWrapperWindow(_local_2.findChildByName("bubble_preview"));
            _local_3.bitmap = k;
            _local_3.center();
            _local_2.procedure = this._Str_25202;
            return _local_2;
        }

        public function _Str_19515():void
        {
            if (((this._Str_3334) && (this._Str_3334.window)) && (this._Str_3334.window.visible))
            {
                this._Str_3334._Str_25385(this._container);
            }
        }

        private function _Str_12416(k:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:Boolean;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _fontSizeMode = this.clampFontSize(this._roomChatInputView.widget.handler.container.freeFlowChat.chatFontSizeMode);
                this.updateFontSizeSelectionHighlight();
                _local_3 = (!(this._roomChatInputView._Str_22667.visible));
                this._roomChatInputView._Str_22667.visible = _local_3;
                this._Str_3334.window.visible = _local_3;
                this._Str_19515();
            }
        }

        private function _Str_25202(k:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:int;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = this._Str_3334.grid.getGridItemIndex(_arg_2);
                this._Str_23446(_arg_2);
                this.selected = this._Str_2514[_local_3];
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                IWindowContainer(_arg_2).findChildByName("background_color").color = 4291875024;
            }
            if (k.type == WindowMouseEvent.OUT)
            {
                IWindowContainer(_arg_2).findChildByName("background_color").color = 0xFFFFFFFF;
            }
        }

        private function _Str_23446(k:IWindow):void
        {
            var _local_2:int;
            while (_local_2 < this._Str_3334.grid.numGridItems)
            {
                IWindowContainer(this._Str_3334.grid.getGridItemAt(_local_2)).findChildByName("background_color").visible = false;
                _local_2++;
            }
            IWindowContainer(k).findChildByName("background_color").visible = true;
        }

        private function buildTemplateWindow(k:String):IWindow
        {
            var _local_2:XmlAsset = this._roomChatInputView.widget.assets.getAssetByName(k) as XmlAsset;
            if (((_local_2 == null) || (_local_2.content == null)))
            {
                return null;
            }
            return this._roomChatInputView.widget.windowManager.buildFromXML(_local_2.content as XML);
        }

        private function createFontSizeOptions():void
        {
            var k:int;
            if (((this._Str_3334 == null) || (this._Str_3334.fontSizeList == null)) || (this._fontSizeTemplate == null))
            {
                return;
            }
            while (k < FONT_SIZE_LABELS.length)
            {
                this._Str_3334.fontSizeList.addListItem(this.getFontSizeItemWindowWrapper(FONT_SIZE_LABELS[k], k));
                k++;
            }
            this.updateFontSizeSelectionHighlight();
        }

        private function getFontSizeItemWindowWrapper(k:String, _arg_2:int):IWindowContainer
        {
            var _local_3:IWindowContainer = IWindowContainer(this._fontSizeTemplate.clone());
            _local_3.id = _arg_2;
            ITextWindow(_local_3.findChildByName("label")).caption = k;
            _local_3.procedure = this.fontSizeItemWindowProc;
            return _local_3;
        }

        private function initFontSizeSelection(k:int):void
        {
            _fontSizeMode = this.clampFontSize(k);
            this.updateFontSizeSelectionHighlight();
        }

        private function fontSizeItemWindowProc(k:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:IWindowContainer = this.resolveFontSizeItem(_arg_2);
            if (_local_3 == null)
            {
                return;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                _fontSizeMode = this.clampFontSize(_local_3.id);
                this._roomChatInputView.widget.handler.container.freeFlowChat.chatFontSizeMode = _fontSizeMode;
                this.updateFontSizeSelectionHighlight();
            }
            if (k.type == WindowMouseEvent.OVER)
            {
                _local_3.findChildByName("background_color").color = 4291875024;
            }
            if (k.type == WindowMouseEvent.OUT)
            {
                _local_3.findChildByName("background_color").color = 0xFFFFFFFF;
            }
        }

        private function updateFontSizeSelectionHighlight():void
        {
            var _local_2:int;
            var _local_3:IWindowContainer;
            var _local_4:ITextWindow;
            if (((this._Str_3334 == null) || (this._Str_3334.fontSizeList == null)))
            {
                return;
            }
            var _local_1:IItemListWindow = this._Str_3334.fontSizeList;
            while (_local_2 < _local_1.numListItems)
            {
                _local_3 = IWindowContainer(_local_1.getListItemAt(_local_2));
                _local_3.findChildByName("background_color").visible = _local_3.id == _fontSizeMode;
                _local_4 = _local_3.findChildByName("label") as ITextWindow;
                if (_local_4)
                {
                    _local_4.textColor = _local_3.id == _fontSizeMode ? 0x333333 : 0x999999;
                }
                _local_2++;
            }
        }

        private function resolveFontSizeItem(k:IWindow):IWindowContainer
        {
            var _local_2:IWindow = k;
            while ((((_local_2 != null) && (_local_2.parent != null)) && (_local_2.parent.parent != this._Str_3334.fontSizeList)))
            {
                _local_2 = _local_2.parent;
            }
            return _local_2 as IWindowContainer;
        }

        private function clampFontSize(k:int):int
        {
            if (k < 0)
            {
                return 0;
            }
            if (k > 4)
            {
                return 4;
            }
            return k;
        }
    }
}
