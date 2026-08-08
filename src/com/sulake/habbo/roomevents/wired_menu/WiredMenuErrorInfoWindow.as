package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;

    /**
     * July's monitor error detail popup. Known official error codes use the
     * July localization; local runtime diagnostics fall back to their bounded
     * name/category rather than exposing exception internals.
     */
    public final class WiredMenuErrorInfoWindow implements IDisposable
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _window:IFrameWindow;
        private var _disposed:Boolean;

        public function WiredMenuErrorInfoWindow(
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = roomEvents;
        }

        public function show(error:Object):void
        {
            if (error == null || this._disposed)
            {
                return;
            }
            this.ensureWindow();
            if (this._window == null)
            {
                return;
            }
            var name:ITextWindow =
                this._window.findChildByName("error_name") as ITextWindow;
            var text:ITextWindow =
                this._window.findChildByName("error_text") as ITextWindow;
            if (name != null)
            {
                name.text = String(error.name);
            }
            if (text != null)
            {
                var key:String = "wiredmenu.error_info." + int(error.id);
                text.text = this._roomEvents.localization.getLocalization(
                    key, String(error.category) + ": " + String(error.name));
            }
            if (this._window.parent == null)
            {
                this._roomEvents.windowManager.getDesktop(1)
                    .addChild(this._window);
            }
            this._window.center();
            this._window.activate();
        }

        public function hide():void
        {
            if (this._window != null && this._window.parent != null)
            {
                (this._window.parent as IWindowContainer)
                    .removeChild(this._window);
            }
        }

        private function ensureWindow():void
        {
            if (this._window != null)
            {
                return;
            }
            this._window = this._roomEvents.getXmlWindow(
                "wired_menu_error_info_view") as IFrameWindow;
            if (this._window == null)
            {
                return;
            }
            var close:IWindow = this._window.findChildByTag("close");
            if (close != null)
            {
                close.addEventListener(
                    WindowMouseEvent.CLICK, this.onClose);
            }
        }

        private function onClose(event:WindowMouseEvent):void
        {
            this.hide();
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.hide();
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._roomEvents = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }
    }
}
