package com.sulake.habbo.ui.widget.chooser
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.UserChooserWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import com.sulake.habbo.ui.widget.events._Str_4178;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.events.IEventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class UserChooserWidget extends ChooserWidgetBase
    {
        private const STATE_USER_CHOOSER_CLOSED:int = 0;
        private const STATE_USER_CHOOSER_OPEN:int = 1;

        private var _userChooser:UserChooserView;
        private var _items:Array;

        public function UserChooserWidget(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary = null, _arg_4:IHabboLocalizationManager = null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function get state():int
        {
            if (((this._userChooser != null) && (this._userChooser.isOpen())))
            {
                return this.STATE_USER_CHOOSER_OPEN;
            }
            return this.STATE_USER_CHOOSER_CLOSED;
        }

        public function get items():Array
        {
            return this._items;
        }

        override public function initialize(k:int = 0):void
        {
            super.initialize(k);
            var handler:UserChooserWidgetHandler =
                this._handler as UserChooserWidgetHandler;
            if (handler != null && handler.isChooserDisabled())
            {
                return;
            }
            if (k == this.STATE_USER_CHOOSER_OPEN && messageListener != null)
            {
                messageListener.processWidgetMessage(new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_USER_CHOOSER));
            }
        }

        override public function dispose():void
        {
            if (this._userChooser != null)
            {
                this._userChooser.dispose();
                this._userChooser = null;
            }
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher):void
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_4178.RWCCE_USER_CHOOSER_CONTENT, this.onChooserContent);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.onUserChooserUpdated);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.USER_ADDED, this.onUserChooserUpdated);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher):void
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_4178.RWCCE_USER_CHOOSER_CONTENT, this.onChooserContent);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.USER_REMOVED, this.onUserChooserUpdated);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.USER_ADDED, this.onUserChooserUpdated);
        }

        private function onChooserContent(k:_Str_4178):void
        {
            var item:_Str_3405;
            if ((k == null) || (k.items == null))
            {
                return;
            }
            if (this._userChooser == null)
            {
                this._userChooser = new UserChooserView(this, "${widget.chooser.user.title}");
            }
            this._items = [];
            for each (item in k.items)
            {
                this._items.push(item);
            }
            this._items.sort(this.sortItems);
            this._userChooser.onItemsChanged();
        }

        private function onUserChooserUpdated(event:RoomWidgetRoomObjectUpdateEvent):void
        {
            if (((this._userChooser == null) || (!(this._userChooser.isOpen()))))
            {
                return;
            }
            var delayedAction:Timer = new Timer(100, 1);
            delayedAction.addEventListener(TimerEvent.TIMER, function (k:TimerEvent):void
            {
                if (disposed)
                {
                    return;
                }
                messageListener.processWidgetMessage(new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_USER_CHOOSER));
            });
            delayedAction.start();
        }

        private function sortItems(k:_Str_3405, _arg_2:_Str_3405):int
        {
            if ((k == null) || (_arg_2 == null))
            {
                return 0;
            }
            if (k.lowerCaseName < _arg_2.lowerCaseName)
            {
                return -1;
            }
            if (k.lowerCaseName > _arg_2.lowerCaseName)
            {
                return 1;
            }
            if (k.id < _arg_2.id)
            {
                return -1;
            }
            if (k.id > _arg_2.id)
            {
                return 1;
            }
            return 0;
        }
    }
}
