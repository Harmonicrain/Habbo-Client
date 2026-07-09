package com.sulake.habbo.window.widgets
{
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IIconWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.habbo.habbicons.assets.HabbiconAssetManager;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import flash.display.BitmapData;
    import flash.events.Event;

    public class ProductIconWidget implements IProductIconWidget, IGetImageListener
    {
        public static const PRODUCT_ICON:String = "product_icon";

        private var _disposed:Boolean;
        private var _widgetWindow:IWidgetWindow;
        private var _windowManager:HabboWindowManagerComponent;
        private var _root:IWindowContainer;
        private var _productInfo:IProductDisplayInfo;
        private var _imageCallbackId:int = -1;
        private var _blend:Number = 1;
        private var _pendingHabbiconId:int = 0;

        public function ProductIconWidget(widgetWindow:IWidgetWindow, windowManager:HabboWindowManagerComponent)
        {
            super();
            this._widgetWindow = widgetWindow;
            this._windowManager = windowManager;
            this._root = (this._windowManager.buildFromXML((this._windowManager.assets.getAssetByName("product_icon_xml").content as XML)) as IWindowContainer);
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
            this.clearPreviewer();
        }

        public function set productInfo(value:IProductDisplayInfo):*
        {
            this._productInfo = value;
            this.previewImage(value);
        }

        public function get productInfo():IProductDisplayInfo
        {
            return this._productInfo;
        }

        public function get properties():Array
        {
            return [];
        }

        public function set properties(value:Array):void
        {
        }

        public function get iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        public function previewImage(info:IProductDisplayInfo):void
        {
            var furniture:IFurnitureData;
            var image:ImageResult;
            var iconStyle:int;

            if (info == null)
            {
                this.setUnknownImage();
                return;
            }

            switch (info.productTypeId)
            {
                case 0:
                    this.setUnknownImage();
                    break;
                case 1:
                    furniture = this._windowManager.sessionDataManager.getWallItemData(parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        break;
                    }
                    this.imageResult = this._windowManager.roomEngine.getWallItemIcon(furniture.id, this, info.extraData);
                    break;
                case 2:
                case 12:
                    furniture = this._windowManager.sessionDataManager.getFloorItemData(parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        break;
                    }
                    this.imageResult = this._windowManager.roomEngine.getFurnitureIcon(furniture.id, this);
                    break;
                case 5:
                    this.badgeResult = info.itemTypeId;
                    break;
                case 9:
                    iconStyle = ActivityPointTypeEnum.getIconStyleFor(parseInt(info.itemTypeId), this._windowManager.context.configuration, true);
                    if (iconStyle == 0)
                    {
                        this.clearPreviewer();
                    }
                    else
                    {
                        this.iconResult = iconStyle;
                    }
                    break;
                case 11:
                    this.petResult = info.petFigureString;
                    break;
                case 7300:
                    HabbiconAssetManager.configure(this._windowManager.context.configuration);
                    this.habbiconResult = parseInt(info.itemTypeId);
                    break;
                default:
                    this.clearPreviewer();
            }
        }

        public function clearPreviewer():void
        {
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._pendingHabbiconId = 0;
            this._imageCallbackId = -1;
            if (this.productPreviewBitmap != null)
            {
                this.productPreviewBitmap.visible = false;
            }
            if (this.badgeImageWidget != null)
            {
                this.badgeImageWidget.visible = false;
            }
            if (this.petImageWidget != null)
            {
                this.petImageWidget.visible = false;
            }
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.visible = false;
            }
            if (this.iconWindow != null)
            {
                this.iconWindow.visible = false;
            }
        }

        private function set imageResult(value:ImageResult):void
        {
            this.clearPreviewer();
            if (value != null)
            {
                this._imageCallbackId = value.id;
                this.setPreviewImage(value.data);
            }
        }

        private function set badgeResult(value:String):void
        {
            var badgeWidget:IBadgeImageWidget;
            this.clearPreviewer();
            if (this.badgeImageWidget != null)
            {
                this.badgeImageWidget.visible = true;
                badgeWidget = this.badgeImageWidget.widget as IBadgeImageWidget;
                if (badgeWidget != null)
                {
                    badgeWidget.badgeId = value;
                }
            }
        }

        private function set petResult(value:String):void
        {
            var petWidget:_Str_18605;
            this.clearPreviewer();
            if (this.petImageWidget != null)
            {
                this.petImageWidget.visible = true;
                petWidget = this.petImageWidget.widget as _Str_18605;
                if (petWidget != null)
                {
                    petWidget.figure = value;
                }
            }
        }

        private function set iconResult(value:int):void
        {
            var icon:IIconWindow;
            this.clearPreviewer();
            if (this.iconWindow != null)
            {
                icon = this.iconWindow;
                icon.visible = true;
                icon.style = value;
                icon.fitToSize();
                if (this._root != null)
                {
                    icon.x = int((this._root.width - icon.width) / 2);
                    icon.y = int((this._root.height - icon.height) / 2);
                }
            }
        }

        private function set habbiconResult(value:int):void
        {
            var bitmap:BitmapData;
            this.clearPreviewer();
            bitmap = HabbiconAssetManager.getPreviewBitmap(value, false);
            if (bitmap == null)
            {
                this._pendingHabbiconId = value;
                HabbiconAssetManager.addEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
                return;
            }
            this.setPreviewImage(bitmap);
        }

        private function onHabbiconAssetsLoaded(event:Event):void
        {
            var habbiconId:int = this._pendingHabbiconId;
            HabbiconAssetManager.removeEventListener(HabbiconAssetManager.ASSETS_LOADED, this.onHabbiconAssetsLoaded);
            this._pendingHabbiconId = 0;
            if (habbiconId > 0)
            {
                this.setPreviewImage(HabbiconAssetManager.getPreviewBitmap(habbiconId, false));
            }
        }

        private function setUnknownImage():void
        {
            this.clearPreviewer();
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.visible = true;
            }
            else
            {
                this.setPlaceholderImage();
            }
        }

        private function setPreviewImage(value:BitmapData):void
        {
            if (this.productPreviewBitmap == null)
            {
                return;
            }
            if (value == null)
            {
                this.productPreviewBitmap.visible = false;
                return;
            }
            this.productPreviewBitmap.bitmap = value.clone();
            this.productPreviewBitmap.disposesBitmap = true;
            this.productPreviewBitmap.visible = true;
        }

        private function setPlaceholderImage():void
        {
            var asset:IAsset = this._windowManager.assets.getAssetByName("placeholder_furni_small_png");
            if (asset != null)
            {
                this.setPreviewImage(asset.content as BitmapData);
            }
        }

        public function imageReady(id:int, data:BitmapData):void
        {
            if (this._imageCallbackId == id)
            {
                this.setPreviewImage(data);
            }
        }

        public function imageFailed(id:int):void
        {
        }

        public function set unknownImageUri(value:String):void
        {
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.assetUri = value;
            }
        }

        public function set blend(value:Number):*
        {
            this._blend = value;
            if (this.productPreviewBitmap != null)
            {
                this.productPreviewBitmap.blend = value;
            }
            if (this.unknownImageWindow != null)
            {
                this.unknownImageWindow.blend = value;
            }
            if (this.badgeImageWidget != null)
            {
                this.badgeImageWidget.blend = value;
            }
            if (this.petImageWidget != null)
            {
                this.petImageWidget.blend = value;
            }
        }

        public function get blend():Number
        {
            return this._blend;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._imageCallbackId = -1;
            this._productInfo = null;
            if (this._root != null)
            {
                this._root.dispose();
                this._root = null;
            }
            if (this._widgetWindow != null)
            {
                this._widgetWindow.rootWindow = null;
                this._widgetWindow = null;
            }
            this._windowManager = null;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        private function get productPreviewBitmap():IBitmapWrapperWindow
        {
            return (this._root == null) ? null : this._root.findChildByName("bitmap") as IBitmapWrapperWindow;
        }

        private function get badgeImageWidget():IWidgetWindow
        {
            return (this._root == null) ? null : this._root.findChildByName("badge_image_widget") as IWidgetWindow;
        }

        private function get petImageWidget():IWidgetWindow
        {
            return (this._root == null) ? null : this._root.findChildByName("pet_image_widget") as IWidgetWindow;
        }

        private function get unknownImageWindow():IStaticBitmapWrapperWindow
        {
            return (this._root == null) ? null : this._root.findChildByName("unknown_image") as IStaticBitmapWrapperWindow;
        }

        private function get iconWindow():IIconWindow
        {
            return (this._root == null) ? null : this._root.findChildByName("icon") as IIconWindow;
        }
    }
}
