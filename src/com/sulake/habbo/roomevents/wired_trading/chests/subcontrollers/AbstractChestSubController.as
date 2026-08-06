package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestWrapperView;
    import __AS3__.vec.Vector;

    public class AbstractChestSubController implements IChestSubController
    {
        private var _disposed:Boolean;
        private var _parent:WiredChestController;
        private var _messageEvents:Vector.<IMessageEvent> = new Vector.<IMessageEvent>();

        public function AbstractChestSubController(parent:WiredChestController)
        {
            this._parent = parent;
        }
        public function get parentController():WiredChestController { return this._parent; }
        public function get roomEvents():HabboUserDefinedRoomEvents { return this._parent.roomEvents; }
        public function localize(key:String):String
        {
            return this.localization.getLocalization(key, key);
        }
        public function get localization():IHabboLocalizationManager
        {
            return this._parent.localization;
        }
        protected function addMessageEvent(event:IMessageEvent):void
        {
            this._messageEvents.push(event);
            this._parent.addMessageEvent(event);
        }
        public function get canEdit():Boolean { return this.wrapperView.canEdit; }
        public function get canRead():Boolean { return this.wrapperView.canRead; }
        public function get canWithdraw():Boolean { return this.wrapperView.canWithdraw; }
        public function get wrapperView():WiredChestWrapperView { return this._parent.chestWrapperView; }
        public function get viewingChestId():int { return this.wrapperView.viewingChestId; }
        public function get type():int { return -1; }
        public function get view():IWindowContainer { return null; }
        public function get title():String { return ""; }
        public function get isEmpty():Boolean { return true; }
        public function clear():void {}
        public function get itemCount():int { return 0; }
        public function updateUI():void {}
        public function get allowResizing():Boolean { return true; }
        public function dispose():void
        {
            if (this._disposed) { return; }
            for each (var event:IMessageEvent in this._messageEvents)
            {
                this._parent.removeMessageEvent(event);
                event.dispose();
            }
            this._messageEvents = null;
            this._parent = null;
            this._disposed = true;
        }
        public function get disposed():Boolean { return this._disposed; }
    }
}
