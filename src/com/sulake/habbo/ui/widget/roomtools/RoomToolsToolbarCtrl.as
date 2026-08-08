package com.sulake.habbo.ui.widget.roomtools
{
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
    import flash.geom.Point;
    import com.sulake.core.window.motion.Motion;
    import com.sulake.core.window.motion.Queue;
    import com.sulake.core.window.motion.EaseOut;
    import com.sulake.core.window.motion.MoveTo;
    import com.sulake.core.window.motion.Callback;
    import com.sulake.core.window.motion.Motions;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetZoomToggleMessage;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.tracking.HabboTracking;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import flash.system.System;

    public class RoomToolsToolbarCtrl extends RoomToolsCtrlBase implements IUpdateReceiver
    {
        private static const _Str_18592:int = 1;
        private static const _Str_12959:int = -130;
        private static const ANIMATION_DURATION_MS:int = 140;

        private var _roomToolsHistory:RoomToolsHistory;
        private var _disposed:Boolean = false;
        private var _isAnimating:Boolean = false;
        private var _isRegisteredForUpdates:Boolean = false;
        private var _expandedBranchOffset:Number = 0;
        private var _animationStartOffset:Number = 0;
        private var _animationTargetOffset:int = 0;
        private var _animationElapsed:int = 0;
        private var _lastZoomText:String = "";
        private var _lastCanZoomIn:Boolean = false;
        private var _lastCanZoomOut:Boolean = false;

        public function RoomToolsToolbarCtrl(k:RoomToolsWidget, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
            _window = (_arg_2.buildFromXML((_arg_3.getAssetByName("room_tools_toolbar_xml").content as XML)) as IWindowContainer);
            _window.procedure = this.onWindowEvent;
            _window.addEventListener(WindowMouseEvent.OVER, this.onWindowEvent);
            _window.addEventListener(WindowMouseEvent.OUT, this.onWindowEvent);
            this._expandedBranchOffset = this.getCollapsedExpandedOffsetX();
            this._Str_17459();
            this.ensureUpdateRegistration();
        }

        override public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.removeUpdateRegistration();
            if (this._roomToolsHistory)
            {
                this._roomToolsHistory.dispose();
                this._roomToolsHistory = null;
            }
            var k:IWindowContainer = (_widget.windowManager.getWindowByName("share_room_link") as IWindowContainer);
            if (k)
            {
                k.dispose();
            }
            super.dispose();
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function update(k:uint):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (this._isAnimating)
            {
                this._animationElapsed = (this._animationElapsed + k);
                _local_2 = Math.min(1, (this._animationElapsed / ANIMATION_DURATION_MS));
                _local_3 = (1 - Math.pow((1 - _local_2), 3));
                this.applyExpandedBranchOffset((this._animationStartOffset + ((this._animationTargetOffset - this._animationStartOffset) * _local_3)));
                this.updatePosition();
                if (_local_2 >= 1)
                {
                    this._isAnimating = false;
                    this.applyExpandedBranchOffset(this._animationTargetOffset);
                    this._Str_17459();
                }
            }
            this.updateZoomControls();
        }

        public function _Str_20713():void
        {
            if (_widget.currentRoomIndex >= (_widget.visitedRooms.length - 1))
            {
                _window.findChildByName("button_history_forward").disable();
            }
            else
            {
                _window.findChildByName("button_history_forward").enable();
            }
            if (_widget.currentRoomIndex == 0)
            {
                _window.findChildByName("button_history_back").disable();
            }
            else
            {
                _window.findChildByName("button_history_back").enable();
            }
            if (_widget.visitedRooms.length <= 1)
            {
                _window.findChildByName("button_history").disable();
            }
            else
            {
                _window.findChildByName("button_history").enable();
            }
        }

        public function _Str_18755():void
        {
            _window.findChildByName("button_history_forward").disable();
            _window.findChildByName("button_history_back").disable();
        }

        private function _Str_24287():void
        {
            if (this._roomToolsHistory)
            {
                this._roomToolsHistory.dispose();
                this._roomToolsHistory = null;
            }
            else
            {
                this._roomToolsHistory = new RoomToolsHistory(_windowManager, _assets, handler);
                this._roomToolsHistory.populate(_widget.visitedRooms);
                this.updatePosition();
            }
        }

        public function _Str_24545(k:Boolean):void
        {
            this.setElementVisible("button_chat_history", k);
        }

        public function _Str_23347(k:Boolean):void
        {
            this.setElementVisible("button_camera", k);
        }

        public function _Str_21132(k:Boolean):void
        {
            this.setElementVisible("button_like", k);
        }

        override public function setElementVisible(k:String, _arg_2:Boolean):void
        {
            if (!window)
            {
                return;
            }
            window.visible = true;
            super.setElementVisible(k, _arg_2);
            this.updatePosition();
        }

        private function ensureUpdateRegistration():void
        {
            var k:Component = this.getUpdateComponent();
            if (((!(this._isRegisteredForUpdates)) && (!(k == null))))
            {
                k.registerUpdateReceiver(this, 1);
                this._isRegisteredForUpdates = true;
            }
        }

        private function removeUpdateRegistration():void
        {
            var k:Component = this.getUpdateComponent();
            if (((this._isRegisteredForUpdates) && (!(k == null))))
            {
                k.removeUpdateReceiver(this);
            }
            this._isRegisteredForUpdates = false;
        }

        private function getUpdateComponent():Component
        {
            if ((((!(_widget)) || (!(_widget.handler))) || (!(_widget.handler.container))))
            {
                return null;
            }
            return (_widget.handler.container.roomEngine as Component);
        }

        private function updateZoomControls():void
        {
            var k:ITextWindow;
            var _local_2:IWindow;
            var _local_3:IWindow;
            if (!window)
            {
                return;
            }
            var _local_4:Boolean = _widget.canZoomRoom(1);
            var _local_5:Boolean = _widget.canZoomRoom(-1);
            var _local_6:String = _widget.getCurrentRoomZoomText();
            if (((((this._lastZoomText == _local_6) && (this._lastCanZoomIn == _local_4)) && (this._lastCanZoomOut == _local_5)) && (!(this._lastZoomText == ""))))
            {
                return;
            }
            k = (window.findChildByName("zoom_text") as ITextWindow);
            if (k != null)
            {
                k.caption = _widget.localizations.registerParameter("room.zoom.text", "zoom_level", _local_6);
            }
            _local_2 = window.findChildByName("zoom_in_btn");
            if (_local_2 != null)
            {
                if (_local_4)
                {
                    _local_2.enable();
                }
                else
                {
                    _local_2.disable();
                }
            }
            _local_3 = window.findChildByName("zoom_out_btn");
            if (_local_3 != null)
            {
                if (_local_5)
                {
                    _local_3.enable();
                }
                else
                {
                    _local_3.disable();
                }
            }
            this._lastZoomText = _local_6;
            this._lastCanZoomIn = _local_4;
            this._lastCanZoomOut = _local_5;
        }

        public function updatePosition():void
        {
            var k:IWindow;
            var _local_2:IWindow;
            var _local_3:IItemListWindow;
            var _local_4:IWindow;
            var _local_5:int;
            var _local_6:int;
            var _local_7:IWindow;
            var _local_8:IWindow;
            var _local_9:IWindow;
            var _local_10:IWindow;
            if (!window)
            {
                return;
            }
            _local_3 = (window.findChildByName("itemlist_buttons") as IItemListWindow);
            _local_2 = window.findChildByName("window_bg");
            _local_4 = window.findChildByName("side_bar_collapse");
            k = window.findChildByName("side_bar_expand");
            _local_8 = window.findChildByName("button_collapse");
            _local_9 = window.findChildByName("button_expand");
            _local_10 = window.findChildByName("arrow_collapse");
            if ((((!(_local_3 == null)) && (!(_local_2 == null))) && (!(_local_4 == null))))
            {
                _local_5 = 0;
                _local_6 = 0;
                while (_local_6 < _local_3.numListItems)
                {
                    _local_7 = _local_3.getListItemAt(_local_6);
                    if (_local_7.visible)
                    {
                        _local_5 = (_local_5 + _local_7.height);
                    }
                    _local_6++;
                }
                _local_4.height = _local_5;
                _local_4.x = 0;
                if (k != null)
                {
                    k.height = _local_5;
                    k.x = 0;
                    k.y = 0;
                }
                window.height = (_local_3.height = (_local_2.height = _local_5));
                if (_local_8 != null)
                {
                    _local_8.height = _local_5;
                }
                if (_local_9 != null)
                {
                    _local_9.height = _local_5;
                }
                if (_local_10 != null)
                {
                    _local_10.y = ((_local_5 * 0.5) - (_local_10.height * 0.5));
                }
                _local_7 = window.findChildByName("arrow_expand");
                if (_local_7 != null)
                {
                    _local_7.y = ((_local_5 * 0.5) - (_local_7.height * 0.5));
                }
            }
            window.position = new Point(TOOLBAR_X, ((window.desktop.height - DISTANCE_FROM_BOTTOM) - window.height));
            if (this._roomToolsHistory)
            {
                this._roomToolsHistory.window.position = new Point((this.right - this._roomToolsHistory.window.width), (window.position.y - this._roomToolsHistory.window.height));
            }
        }

        override public function setCollapsed(k:Boolean):void
        {
            if (((_isCollapsed == k) || (!(window))))
            {
                return;
            }
            _isCollapsed = k;
            this.beginAnimation((_isCollapsed) ? this.getCollapsedExpandedOffsetX() : 0);
        }

        private function _Str_17459():void
        {
            if (((!(window)) || (!(window.findChildByName("window_bg")))))
            {
                return;
            }
            window.findChildByName("window_bg").visible = ((!(_isCollapsed)) || this._isAnimating);
            window.findChildByName("side_bar_collapse").visible = (!(_isCollapsed));
            window.findChildByName("side_bar_expand").visible = _isCollapsed;
            this.applyExpandedBranchOffset(this._expandedBranchOffset);
            this.updatePosition();
            this.updateZoomControls();
        }

        private function beginAnimation(k:int):void
        {
            this._animationStartOffset = this._expandedBranchOffset;
            this._animationTargetOffset = k;
            this._animationElapsed = 0;
            this._isAnimating = (this._animationStartOffset != this._animationTargetOffset);
            this._Str_17459();
            if (!this._isAnimating)
            {
                return;
            }
            this.ensureUpdateRegistration();
            if (!this._isRegisteredForUpdates)
            {
                this._isAnimating = false;
                this.applyExpandedBranchOffset(k);
                this._Str_17459();
            }
        }

        private function applyExpandedBranchOffset(k:Number):void
        {
            var _local_2:IWindow;
            if (!window)
            {
                return;
            }
            _local_2 = window.findChildByName("window_bg");
            if (_local_2 == null)
            {
                return;
            }
            this._expandedBranchOffset = k;
            _local_2.x = (1 + k);
        }

        private function getCollapsedExpandedOffsetX():int
        {
            var k:IWindow;
            var _local_2:IWindow;
            if (!window)
            {
                return 0;
            }
            k = window.findChildByName("window_bg");
            _local_2 = window.findChildByName("side_bar_expand");
            if (((k == null) || (_local_2 == null)))
            {
                return 0;
            }
            return ((_local_2.width - k.width) - 1);
        }

        private function onWindowEvent(event:WindowEvent, target:IWindow):void
        {
            var link:String;
            var shareWindow:IWindowContainer;
            var openCameraEvent:HabboToolbarEvent;
            var message:RoomWidgetZoomToggleMessage;
            var asset:XML;
            if (((((event.type == WindowEvent.WINDOW_EVENT_PARENT_RESIZED) && (this.window)) && (this.window.parent)) && (event.target == this.window.parent)))
            {
                return this.updatePosition();
            }
            switch (event.type)
            {
                case WindowMouseEvent.CLICK:
                    clearCollapseTimer();
                    switch (target.name)
                    {
                        case "button_settings":
                            handler.toggleRoomInfoWindow();
                            break;
                        case "button_zoom":
                            if (_widget.messageListener)
                            {
                                message = new RoomWidgetZoomToggleMessage();
                                _widget.messageListener.processWidgetMessage(message);
                            }
                            break;
                        case "zoom_in_btn":
                            _widget.zoomRoom(1);
                            this.updateZoomControls();
                            break;
                        case "zoom_out_btn":
                            _widget.zoomRoom(-1);
                            this.updateZoomControls();
                            break;
                        case "button_collapse":
                        case "button_expand":
                            _widget.setCollapsed((!(_isCollapsed)));
                            handler.sessionDataManager.setRoomToolsState((!(_isCollapsed)));
                            break;
                        case "button_history_back":
                            _widget.goToPreviousRoom();
                            break;
                        case "button_history_forward":
                            _widget.goToNextRoom();
                            break;
                        case "button_history":
                            this._Str_24287();
                            break;
                        case "button_chat_history":
                            if (_widget.freeFlowChat)
                            {
                                _widget.freeFlowChat.toggleVisibility();
                                _widget.setCollapsed(true);
                            }
                            break;
                        case "button_like":
                            handler.rateRoom();
                            window.findChildByName("button_like").disable();
                            break;
                        case "button_share":
                            link = this.getEmbedData();
                            shareWindow = (_widget.windowManager.getWindowByName("share_room_link") as IWindowContainer);
                            if (shareWindow == null)
                            {
                                asset = (_assets.getAssetByName("share_room_xml").content as XML);
                                if (asset)
                                {
                                    shareWindow = (_widget.windowManager.buildFromXML(asset) as IWindowContainer);
                                }
                            }
                            if (shareWindow)
                            {
                                HabboTracking.getInstance().trackEventLog("RoomLink", "click", "client.room_link.clicked");
                                shareWindow.name = "share_room_link";
                                shareWindow.center();
                                shareWindow.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, function (k:WindowMouseEvent, _arg_2:IWindow=null):void
                                {
                                    shareWindow.dispose();
                                });
                                shareWindow.findChildByName("embed_src_txt").caption = this.getEmbedData();
                                shareWindow.findChildByName("embed_src_direct_txt").caption = this.getEmbedData("embed_src_direct_txt", "${url.prefix}/room/%roomId%");
                                IStaticBitmapWrapperWindow(shareWindow.findChildByName("thumbnail_image")).assetUri = this._Str_24878();
                            }
                            try
                            {
                                System.setClipboard(this.getEmbedData());
                            }
                            catch(error:Error)
                            {
                            }
                            break;
                        case "button_camera":
                            openCameraEvent = new HabboToolbarEvent(HabboToolbarEvent.HTE_ICON_CAMERA);
                            openCameraEvent.iconName = HabboToolbarEvent.ROOMTOOLSMENU;
                            handler.container.toolbar.events.dispatchEvent(openCameraEvent);
                            break;
                    }
                    return;
            }
        }

        private function getEmbedData(k:String="navigator.embed.src", _arg_2:String=""):String
        {
            var _local_3:String;
            var _local_4:String;
            if (_widget.handler.navigator.enteredGuestRoomData != null)
            {
                _local_3 = "private";
                _local_4 = ("" + _widget.handler.navigator.enteredGuestRoomData.flatId);
            }
            var _local_5:String = _widget.handler.container.config.getProperty("user.hash");
            if (_widget.localizations.hasLocalization(k))
            {
                _widget.localizations.registerParameter(k, "roomType", _local_3);
                _widget.localizations.registerParameter(k, "embedCode", _local_5);
                _widget.localizations.registerParameter(k, "roomId", _local_4);
            }
            else
            {
                if (_arg_2 != "")
                {
                    _arg_2 = _arg_2.replace("${url.prefix}", _widget.handler.container.config.getProperty("url.prefix"));
                    _arg_2 = _arg_2.replace("%roomId%", _local_4);
                    return _arg_2;
                }
            }
            return _widget.localizations.getLocalization(k, _arg_2);
        }

        private function _Str_24878():String
        {
            var _local_2:String;
            var k:String = "";
            if (_widget.handler.navigator.enteredGuestRoomData.officialRoomPicRef != null)
            {
                if (_widget.handler.container.config.getBoolean("new.navigator.official.room.thumbnails.in.amazon"))
                {
                    _local_2 = _widget.handler.container.config.getProperty("navigator.thumbnail.url_base");
                    k = ((_local_2 + _widget.handler.navigator.enteredGuestRoomData.flatId) + ".png");
                }
                else
                {
                    k = (_widget.handler.container.config.getProperty("image.library.url") + _widget.handler.navigator.enteredGuestRoomData.officialRoomPicRef);
                }
            }
            else
            {
                _local_2 = _widget.handler.container.config.getProperty("navigator.thumbnail.url_base");
                k = ((_local_2 + _widget.handler.navigator.enteredGuestRoomData.flatId) + ".png");
            }
            return k;
        }

        public function get right():int
        {
            var k:IWindow;
            var _local_2:IWindow;
            var _local_3:IWindow;
            var _local_4:int;
            if (!window)
            {
                return 0;
            }
            if (((_isCollapsed) && (!(this._isAnimating))))
            {
                k = window.findChildByName("side_bar_expand");
                return (k) ? (k.width + TOOLBAR_X) : 0;
            }
            k = window.findChildByName("window_bg");
            _local_2 = window.findChildByName("side_bar_expand");
            _local_3 = window.findChildByName("side_bar_collapse");
            if (((k != null) && (k.visible)))
            {
                _local_4 = Math.max(_local_4, Math.round((k.x + k.width)));
            }
            if (((_local_2 != null) && (_local_2.visible)))
            {
                _local_4 = Math.max(_local_4, Math.round((_local_2.x + _local_2.width)));
            }
            if (((_local_3 != null) && (_local_3.visible)))
            {
                _local_4 = Math.max(_local_4, Math.round((_local_3.x + _local_3.width)));
            }
            return (_local_4 + TOOLBAR_X);
        }

        public function get collapsedRight():int
        {
            var k:IWindow;
            if (!window)
            {
                return 0;
            }
            k = window.findChildByName("side_bar_expand");
            return (k) ? (k.width + TOOLBAR_X) : 0;
        }

        public function get top():int
        {
            // Computed desktop-anchored resting top (same formula as updatePosition's window.position),
            // NOT the live window.y. The room info box positions itself relative to this on window
            // resize; its WINDOW_EVENT_PARENT_RESIZED handler can run before this toolbar's own
            // updatePosition repositions window.y, so returning the stale live y jumped the info box
            // to the top-left. Deriving it from the current desktop height makes it resize-order safe.
            return (window) ? ((window.desktop.height - DISTANCE_FROM_BOTTOM) - window.height) : 0;
        }
    }
}
