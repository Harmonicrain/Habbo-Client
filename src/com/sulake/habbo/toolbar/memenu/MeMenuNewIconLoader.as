package com.sulake.habbo.toolbar.memenu
{
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.enum.AvatarScaleType;
    import com.sulake.habbo.avatar.enum.AvatarSetType;
    import com.sulake.habbo.communication.messages.incoming.avatar.FigureUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.utils.HabboFaceFocuser;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class MeMenuNewIconLoader implements IAvatarImageListener 
    {
        private static const ICON_WIDTH:int = 44;
        private static const ICON_HEIGHT:int = 41;
        private static const ICON_CIRCLE_RADIUS:int = 22;
        private static const PORTRAIT_OFFSET_X:Number = 0;
        private static const PORTRAIT_OFFSET_Y:Number = 2;

        private var _toolbar:HabboToolbar;
        private var _lastFigure:String;
        private var _lastFocusedFace:BitmapData;
        private var _userObjectEvent:UserObjectEvent;
        private var _figureUpdateEvent:FigureUpdateEvent;

        public function MeMenuNewIconLoader(k:HabboToolbar)
        {
            this._toolbar = k;
            this._userObjectEvent = new UserObjectEvent(this.onUserObject);
            this._figureUpdateEvent = new FigureUpdateEvent(this.onFigureUpdate);
            this._toolbar.communicationManager.addHabboConnectionMessageEvent(this._userObjectEvent);
            this._toolbar.communicationManager.addHabboConnectionMessageEvent(this._figureUpdateEvent);
            this.renderAvatar();
        }

        private function renderAvatar(k:String=null):void
        {
            var _local_2:BitmapData;
            var _local_3:String;
            var _local_4:String;
            var _local_5:IAvatarImage;
            if (this._toolbar.avatarRenderManager != null)
            {
                _local_3 = ((k == null) ? this._toolbar.sessionDataManager.figure : k);
                if (_local_3 != this._lastFigure)
                {
                    _local_4 = this._toolbar.sessionDataManager.gender;
                    _local_5 = this._toolbar.avatarRenderManager.createAvatarImage(_local_3, AvatarScaleType.LARGE, _local_4, this);
                    if (((!(_local_5 == null)) && (!(_local_5.isPlaceholder()))))
                    {
                        _local_5.setDirection(AvatarSetType.FULL, 4);
                        _local_5.setDirection(AvatarSetType.HEAD, 3);
                        var _local_6:BitmapData = HabboFaceFocuser.focusUserFace(_local_5, AvatarSetType.FULL, 3, 1);
                        _local_2 = this.renderPortraitIntoIcon(_local_6);
                        if (_local_6 != null)
                        {
                            _local_6.dispose();
                        }
                        _local_5.dispose();
                    }
                    this._lastFigure = _local_3;
                    if (this._lastFocusedFace != null)
                    {
                        this._lastFocusedFace.dispose();
                    }
                    this._lastFocusedFace = _local_2;
                }
                else
                {
                    _local_2 = this._lastFocusedFace;
                }
            }
            if (this._toolbar != null)
            {
                if (_local_2 != null)
                {
                    this._toolbar.setAssetUri(HabboToolbarIconEnum.MEMENU, _local_2.clone());
                }
            }
        }

        private function renderPortraitIntoIcon(k:BitmapData):BitmapData
        {
            if (k == null)
            {
                return null;
            }
            var _local_2:BitmapData = new BitmapData(ICON_WIDTH, ICON_HEIGHT, true, 0);
            var _local_3:int = Math.round(((k.width - ICON_WIDTH) / 2) - PORTRAIT_OFFSET_X);
            var _local_4:int = Math.round(((k.height - ICON_HEIGHT) / 2) - PORTRAIT_OFFSET_Y);
            if (_local_3 < 0)
            {
                _local_3 = 0;
            }
            if (_local_4 < 0)
            {
                _local_4 = 0;
            }
            if ((_local_3 + ICON_WIDTH) > k.width)
            {
                _local_3 = (k.width - ICON_WIDTH);
            }
            if ((_local_4 + ICON_HEIGHT) > k.height)
            {
                _local_4 = (k.height - ICON_HEIGHT);
            }
            _local_2.copyPixels(k, new Rectangle(_local_3, _local_4, ICON_WIDTH, ICON_HEIGHT), new Point(0, 0));
            var _local_5:BitmapData = HabboFaceFocuser.cutCircleFromBitmap(_local_2, ICON_CIRCLE_RADIUS);
            _local_2.dispose();
            return _local_5;
        }

        public function avatarImageReady(k:String):void
        {
            this._lastFigure = "";
            this.renderAvatar();
        }

        private function onUserObject(k:UserObjectEvent):void
        {
            this.renderAvatar(k.getParser().figure);
        }

        private function onFigureUpdate(k:FigureUpdateEvent):void
        {
            if (this.disposed)
            {
                return;
            }
            this.renderAvatar(k.figure);
        }

        public function dispose():void
        {
            if (this.disposed)
            {
                return;
            }
            if (this._userObjectEvent != null)
            {
                this._toolbar.communicationManager.removeHabboConnectionMessageEvent(this._userObjectEvent);
                this._userObjectEvent = null;
            }
            if (this._figureUpdateEvent != null)
            {
                this._toolbar.communicationManager.removeHabboConnectionMessageEvent(this._figureUpdateEvent);
                this._figureUpdateEvent = null;
            }
            if (this._lastFocusedFace != null)
            {
                this._lastFocusedFace.dispose();
                this._lastFocusedFace = null;
            }
            this._toolbar = null;
        }

        public function get disposed():Boolean
        {
            return this._toolbar == null;
        }
    }
}
