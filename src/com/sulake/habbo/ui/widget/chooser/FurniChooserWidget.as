package com.sulake.habbo.ui.widget.chooser
{
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events._Str_4178;
    import com.sulake.habbo.ui.widget.events.RoomWidgetRoomObjectUpdateEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetRequestWidgetMessage;
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import flash.utils.Dictionary;

    public class FurniChooserWidget extends ChooserWidgetBase
    {
        private var _furniChooser:FurniChooserView;
        private var _items:Array;
        private var _itemIds:Dictionary;

        public function FurniChooserWidget(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function dispose():void
        {
            if (this._furniChooser != null)
            {
                this._furniChooser.dispose();
                this._furniChooser = null;
            }
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher):void
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT, this.onChooserContent);
            k.addEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT_ADD, this.onChooserContentAdded);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this.onFurniUpdated);
            k.addEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED, this.onFurniUpdated);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher):void
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT, this.onChooserContent);
            k.removeEventListener(_Str_4178.RWCCE_FURNI_CHOOSER_CONTENT_ADD, this.onChooserContentAdded);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED, this.onFurniUpdated);
            k.removeEventListener(RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED, this.onFurniUpdated);
        }

        private function onChooserContent(k:_Str_4178):void
        {
            if (k == null || k.items == null)
            {
                return;
            }
            if (this._furniChooser == null)
            {
                this._furniChooser = new FurniChooserView(this);
            }
            this._items = [];
            this._itemIds = new Dictionary();
            var _local_2:_Str_3405;
            for each (_local_2 in k.items)
            {
                if (_local_2.id != 0)
                {
                    this._items.push(_local_2);
                    this._itemIds[(_local_2.category + "_" + _local_2.id)] = true;
                }
            }
            this._items.sort(this._Str_22274);
            this._furniChooser.onItemsChanged();
        }

        private function onChooserContentAdded(k:_Str_4178):void
        {
            var _local_3:_Str_3405;
            var _local_2:Boolean;
            if (((((k == null) || (k.items == null)) || (this._furniChooser == null)) || (this._items == null)))
            {
                return;
            }
            _local_2 = false;
            for each (_local_3 in k.items)
            {
                if (((_local_3.id != 0) && (!(this._itemIds[(_local_3.category + "_" + _local_3.id)]))))
                {
                    this._items.push(_local_3);
                    this._itemIds[(_local_3.category + "_" + _local_3.id)] = true;
                    _local_2 = true;
                }
            }
            if (_local_2)
            {
                this._items.sort(this._Str_22274);
                this._furniChooser.onItemsChanged();
            }
        }

        private function onFurniUpdated(k:RoomWidgetRoomObjectUpdateEvent):void
        {
            var _local_2:int;
            var _local_3:_Str_3405;
            if (this._furniChooser == null || !this._furniChooser.isOpen())
            {
                return;
            }
            if (k.type == RoomWidgetRoomObjectUpdateEvent.FURNI_REMOVED)
            {
                if (this._items == null)
                {
                    return;
                }
                _local_2 = 0;
                while (_local_2 < this._items.length)
                {
                    _local_3 = (this._items[_local_2] as _Str_3405);
                    if (((_local_3.id == k.id) && (_local_3.category == k.category)))
                    {
                        this._items.splice(_local_2, 1);
                        delete this._itemIds[(_local_3.category + "_" + _local_3.id)];
                        this._furniChooser.onItemsChanged();
                        return;
                    }
                    _local_2++;
                }
                return;
            }
            if (k.type == RoomWidgetRoomObjectUpdateEvent.FURNI_ADDED)
            {
                messageListener.processWidgetMessage(new RoomWidgetRequestWidgetMessage(RoomWidgetRequestWidgetMessage.RWRWM_FURNI_CHOOSER_ADD, k.id, k.category));
            }
        }

        public function get items():Array
        {
            return this._items;
        }

        private function _Str_22274(k:_Str_3405, _arg_2:_Str_3405):int
        {
            if (((k == null) || (_arg_2 == null)))
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
