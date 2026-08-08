package com.sulake.habbo.roomevents.wired_menu
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.utils.IBitmapDataContainer;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets._Str_18605;
    import com.sulake.room.utils.Vector3d;

    /**
     * July's Inspection preview adapted to the clean client's widget and room
     * image APIs. The selected holder is rendered locally; the inspection
     * packet remains the authority for which holder is currently active.
     */
    public final class WiredMenuInspectionPreviewer implements IDisposable
    {
        private var _container:IWindowContainer;
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _furniId:int;
        private var _userIndex:int = -1;
        private var _disposed:Boolean;

        public function WiredMenuInspectionPreviewer(
            container:IWindowContainer,
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._container = container;
            this._roomEvents = roomEvents;
            this.clear();
        }

        public function clear():void
        {
            this._furniId = 0;
            this._userIndex = -1;
            this.hide("preview_instruction_furni");
            this.hide("preview_instruction_user");
            this.hide("preview_avatar");
            this.hide("preview_pet");
            this.hide("preview_image_bitmap");
            this.hide("global_placeholder");
            var image:IBitmapWrapperWindow = this.previewImage;
            if (image != null)
            {
                image.disposesBitmap = true;
                image.bitmap = null;
            }
        }

        public function showFurniInstruction():void
        {
            this.clear();
            this.show("preview_instruction_furni");
        }

        public function showUserInstruction():void
        {
            this.clear();
            this.show("preview_instruction_user");
        }

        public function showGlobal():void
        {
            this.clear();
            this.show("global_placeholder");
        }

        public function showUser(userIndex:int):void
        {
            if (userIndex == this._userIndex)
            {
                return;
            }
            this.clear();
            if (this._roomEvents == null
                || this._roomEvents.roomSession == null)
            {
                return;
            }
            var data:RoomUserData = this._roomEvents.roomSession
                .userDataManager.getUserDataByIndex(userIndex);
            if (data == null)
            {
                return;
            }
            var widgetWindow:IWidgetWindow;
            if (data.type == 2)
            {
                widgetWindow = this.find("preview_pet") as IWidgetWindow;
                if (widgetWindow != null && widgetWindow.widget is _Str_18605)
                {
                    (_Str_18605(widgetWindow.widget)).figure = data.figure;
                }
            }
            else
            {
                widgetWindow = this.find("preview_avatar") as IWidgetWindow;
                if (widgetWindow != null
                    && widgetWindow.widget is IAvatarImageWidget)
                {
                    (IAvatarImageWidget(widgetWindow.widget)).figure =
                        data.figure;
                }
            }
            if (widgetWindow != null)
            {
                widgetWindow.visible = true;
                center(widgetWindow);
            }
            this._userIndex = userIndex;
        }

        public function showFurni(objectId:int):void
        {
            if (objectId == this._furniId)
            {
                return;
            }
            this.clear();
            if (this._roomEvents == null
                || this._roomEvents.roomEngine == null
                || objectId == 0)
            {
                return;
            }
            var category:int = objectId > 0
                ? RoomObjectCategoryEnum.OBJECT_CATEGORY_FURNITURE
                : RoomObjectCategoryEnum.OBJECT_CATEGORY_WALLITEM;
            var visibleId:int = Math.abs(objectId);
            var result:ImageResult = this._roomEvents.roomEngine
                .getRoomObjectImage(
                    this._roomEvents.roomEngine.activeRoomId,
                    visibleId, category, new Vector3d(180), 64, null);
            if (result == null || result.data == null)
            {
                return;
            }
            var image:IBitmapWrapperWindow = this.previewImage;
            if (image == null)
            {
                return;
            }
            image.disposesBitmap = true;
            image.bitmap = result.data.clone();
            var bitmapContainer:IBitmapDataContainer =
                image as IBitmapDataContainer;
            if (bitmapContainer != null)
            {
                var scale:Number =
                    result.data.width >= this._container.width - 6
                    || result.data.height > this._container.height - 6
                    ? 0.5 : 1;
                bitmapContainer.zoomX = scale;
                bitmapContainer.zoomY = scale;
            }
            image.visible = true;
            center(image);
            this._furniId = objectId;
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

        private function show(name:String):void
        {
            var window:IWindow = this.find(name);
            if (window != null)
            {
                window.visible = true;
            }
        }

        private function hide(name:String):void
        {
            var window:IWindow = this.find(name);
            if (window != null)
            {
                window.visible = false;
            }
        }

        private function get previewImage():IBitmapWrapperWindow
        {
            return this.find("preview_image_bitmap") as IBitmapWrapperWindow;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
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
