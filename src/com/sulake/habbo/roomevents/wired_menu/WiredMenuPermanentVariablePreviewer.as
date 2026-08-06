package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets._Str_18605;

    /**
     * July's permanent-variable holder preview used by the management detail
     * window. User and bot figures use the avatar widget; pets use the pet
     * widget. Clicking an avatar opens its profile, as it does in July.
     */
    public final class WiredMenuPermanentVariablePreviewer
        implements IDisposable
    {
        private var _container:IWindowContainer;
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _userId:int = -1;
        private var _disposed:Boolean;

        public function WiredMenuPermanentVariablePreviewer(
            container:IWindowContainer,
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._container = container;
            this._roomEvents = roomEvents;
            this.clear();
            var region:IRegionWindow = this.avatarRegion;
            if (region != null)
            {
                region.addEventListener(WindowMouseEvent.CLICK,
                    this.onAvatarClicked);
            }
        }

        public function clear():void
        {
            this._userId = -1;
            this.hide("avatar_preview");
            this.hide("pet_preview");
            this.hide("avatar_preview_region");
        }

        public function showPet(figure:String):void
        {
            this.clear();
            var preview:IWidgetWindow =
                this.find("pet_preview") as IWidgetWindow;
            if (preview != null && preview.widget is _Str_18605)
            {
                (_Str_18605(preview.widget)).figure = figure;
                preview.visible = true;
                center(preview);
            }
        }

        public function showUser(figure:String, userId:int=-1):void
        {
            this.clear();
            var preview:IWidgetWindow =
                this.find("avatar_preview") as IWidgetWindow;
            if (preview != null && preview.widget is IAvatarImageWidget)
            {
                (IAvatarImageWidget(preview.widget)).figure = figure;
                preview.visible = true;
                center(preview);
            }
            this._userId = userId;
            var region:IRegionWindow = this.avatarRegion;
            if (region != null)
            {
                region.visible = userId != -1;
            }
        }

        private function onAvatarClicked(event:WindowMouseEvent):void
        {
            if (this._roomEvents != null && this._userId != -1)
            {
                this._roomEvents.send(
                    new GetExtendedProfileMessageComposer(this._userId, true));
            }
        }

        private static function center(window:IWindow):void
        {
            if (window != null && window.parent != null)
            {
                window.x = int((window.parent.width - window.width) / 2);
                window.y = int((window.parent.height - window.height) / 2);
            }
        }

        private function find(name:String):IWindow
        {
            return this._container == null ? null :
                this._container.findChildByName(name);
        }

        private function hide(name:String):void
        {
            var window:IWindow = this.find(name);
            if (window != null)
            {
                window.visible = false;
            }
        }

        private function get avatarRegion():IRegionWindow
        {
            return this.find("avatar_preview_region") as IRegionWindow;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            var region:IRegionWindow = this.avatarRegion;
            if (region != null)
            {
                region.removeEventListener(WindowMouseEvent.CLICK,
                    this.onAvatarClicked);
            }
            this.clear();
            this._container = null;
            this._roomEvents = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }
    }
}
