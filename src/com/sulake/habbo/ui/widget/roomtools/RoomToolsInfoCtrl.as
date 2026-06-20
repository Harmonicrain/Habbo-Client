package com.sulake.habbo.ui.widget.roomtools
{
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.geom.Point;
    import com.sulake.core.window.motion.Motion;
    import com.sulake.core.window.motion.Queue;
    import com.sulake.core.window.motion.EaseOut;
    import com.sulake.core.window.motion.MoveTo;
    import com.sulake.core.window.motion.Callback;
    import com.sulake.core.window.motion.Motions;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

    public class RoomToolsInfoCtrl extends RoomToolsCtrlBase 
    {
        private static const MARGIN:int = 12;
        private static const COLLAPSED_INFO_LIFT:int = 28;
        private static const TAG_COLOR:uint = 1800619;
        private static const TAG_COLOR_HOVER:uint = 4696294;

        private var _roomTags:Array;

        public function RoomToolsInfoCtrl(k:RoomToolsWidget, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
            this._roomTags = new Array();
        }

        public function showRoomInfo(k:Boolean, _arg_2:String, _arg_3:String, _arg_4:Array):void
        {
            if (!window)
            {
                _window = (_widget.windowManager.buildFromXML((_assets.getAssetByName("room_tools_info_xml").content as XML)) as IWindowContainer);
                _window.procedure = this.onWindowEvent;
                _window.addEventListener(WindowMouseEvent.OVER, this.onWindowEvent);
                _window.addEventListener(WindowMouseEvent.OUT, this.onWindowEvent);
            }
            this.updatePosition();
            _window.findChildByName("room_name").caption = _arg_2;
            _window.findChildByName("room_owner").caption = _arg_3;
            if (_arg_4 == null)
            {
                return;
            }
            this._roomTags = _arg_4;
            _window.findChildByName("tag1_border").visible = (_arg_4.length >= 1);
            _window.findChildByName("tag2_border").visible = (_arg_4.length >= 2);
            if (_arg_4.length >= 1)
            {
                _window.findChildByName("tag1").caption = ("#" + this.trimTag(_arg_4[0]));
            }
            if (_arg_4.length >= 2)
            {
                _window.findChildByName("tag2").caption = ("#" + this.trimTag(_arg_4[1]));
            }
            this.setCollapsed(false);
        }

        public function updatePosition():void
        {
            if (!_window)
            {
                return;
            }
            var k:int = this.getTargetX();
            var _local_2:int = this.getTargetY(_widget.isRoomToolbarCollapsed);
            _window.position = new Point(k, _local_2);
        }

        override public function setCollapsed(k:Boolean):void
        {
            var _local_3:Motion;
            if (_isCollapsed == k)
            {
                return;
            }
            _isCollapsed = k;
            if (!_isCollapsed)
            {
                collapseAfterDelay();
            }
            if (!_window)
            {
                return;
            }
            _window.visible = true;
            var _local_2:int = this.getTargetX();
            if (_isCollapsed)
            {
                _local_3 = new Queue(new EaseOut(new MoveTo(_window, WINDOW_ANIM_SPEED, _local_2, this.getTargetY(_widget.isRoomToolbarCollapsed)), 1), new Callback(this.motionComplete));
            }
            else
            {
                _local_3 = new Queue(new EaseOut(new MoveTo(_window, WINDOW_ANIM_SPEED, _local_2, this.getTargetY(_widget.isRoomToolbarCollapsed)), 1), new Callback(this.motionComplete));
            }
            Motions._Str_4598(_local_3);
        }

        public function setToolbarCollapsed(k:Boolean):void
        {
            var _local_2:Motion;
            var _local_3:int;
            if (!_window)
            {
                return;
            }
            if (!k)
            {
                if (((this._isCollapsed) || (!(this._window.visible))))
                {
                    this.setCollapsed(false);
                    return;
                }
                this.collapseAfterDelay();
            }
            if (((this._isCollapsed) || (!(this._window.visible))))
            {
                return;
            }
            _local_3 = this.getTargetX();
            _local_2 = new EaseOut(new MoveTo(_window, WINDOW_ANIM_SPEED, _local_3, this.getTargetY(k)), 1);
            Motions._Str_4598(_local_2);
        }

        private function getTargetX():int
        {
            var k:int;
            if (!_window)
            {
                return 0;
            }
            k = (_widget.getRoomToolbarCollapsedRight() + MARGIN);
            return (((_isCollapsed) ? -(_window.width) : 0) + k);
        }

        private function getTargetY(k:Boolean):int
        {
            var _local_2:int;
            if (!_window)
            {
                return 0;
            }
            var _local_4:int = _widget.getRoomToolbarTop();
            // getRoomToolbarTop() returns 0 as a "not laid out yet" sentinel (toolbar window null).
            // During a window resize the geometry queried here can be transiently unavailable; anchor
            // to the bottom of the desktop in that case instead of to a bogus toolbar top, otherwise
            // the info box flickers to the top-left for a frame.
            if (k || _local_4 <= 0)
            {
                _local_2 = (((_window.desktop.height - DISTANCE_FROM_BOTTOM) - _window.height) - COLLAPSED_INFO_LIFT);
            }
            else
            {
                _local_2 = ((_local_4 - _window.height) - MARGIN);
            }
            if (_local_2 < MARGIN)
            {
                _local_2 = MARGIN;
            }
            // No chat-input overlap lift: the info box sits in the bottom-LEFT column (above the room
            // toolbar) and never overlaps the bottom-centre chat input / chat-bubble picker. The old
            // getChatInputY() clamp lifted the box by the chat-input container's height, so opening the
            // bubble picker (which makes that container tall) shoved the info box to the top-left on the
            // next resize. The toolbar itself coexists with the chat input without any such lift.
            return _local_2;
        }

        private function motionComplete(k:Motion):void
        {
            if (((_isCollapsed) && (_window)))
            {
                _window.visible = false;
            }
        }

        private function trimTag(k:String):String
        {
            var _local_2:String = k;
            if (_local_2.length > 16)
            {
                _local_2 = (_local_2.substr(0, 16) + "...");
            }
            return _local_2;
        }

        private function onWindowEvent(k:WindowEvent, _arg_2:IWindow):void
        {
            var _local_3:ITextWindow;
            var _local_4:String;
            if (k.type == WindowEvent.WINDOW_EVENT_PARENT_RESIZED)
            {
                return this.updatePosition();
            }
            switch (k.type)
            {
                case WindowMouseEvent.CLICK:
                    this.setCollapsed(true);
                    break;
                case WindowMouseEvent.OVER:
                    cancelWindowCollapse();
                    break;
                case WindowMouseEvent.OUT:
                    collapseIfPending();
                    break;
            }
            if ((k as WindowMouseEvent) == null)
            {
                return;
            }
            if (_arg_2.name == "tag1_region")
            {
                _local_3 = (_window.findChildByName("tag1") as ITextWindow);
                _local_4 = ((this._roomTags[0] == null) ? "" : this._roomTags[0]);
            }
            if (_arg_2.name == "tag2_region")
            {
                _local_3 = (_window.findChildByName("tag2") as ITextWindow);
                _local_4 = ((this._roomTags[1] == null) ? "" : this._roomTags[1]);
            }
            if (_local_3 != null)
            {
                switch (k.type)
                {
                    case WindowMouseEvent.HOVERING:
                    case WindowMouseEvent.OVER:
                        _local_3.textColor = TAG_COLOR_HOVER;
                        return;
                    case WindowMouseEvent.OUT:
                        _local_3.textColor = TAG_COLOR;
                        return;
                    case WindowMouseEvent.CLICK:
                        handler.navigator.performTagSearch(_local_4);
                        return;
                }
            }
        }

        public function get right():int
        {
            return (_window) ? (_window.width + window.x) : 0;
        }
    }
}
