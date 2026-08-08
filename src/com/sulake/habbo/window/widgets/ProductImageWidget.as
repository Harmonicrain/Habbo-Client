package com.sulake.habbo.window.widgets
{
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.room.utils.Vector3d;

    public class ProductImageWidget extends ProductIconWidget
    {
        public static const PRODUCT_IMAGE:String = "product_image";
        public function ProductImageWidget(window:IWidgetWindow,
            manager:HabboWindowManagerComponent)
        {
            super(window, manager, "product_image_xml");
        }

        override protected function get productPreviewBitmap():IBitmapWrapperWindow
        {
            return this._root == null ? null : this._root.findChildByName("product_preview") as IBitmapWrapperWindow;
        }

        override public function previewImage(info:IProductDisplayInfo):void
        {
            var furniture:IFurnitureData;
            var image:ImageResult;

            if (info == null)
            {
                super.previewImage(info);
                return;
            }

            switch (info.productTypeId)
            {
                case 1:
                    furniture = this._windowManager.sessionDataManager.getWallItemData(parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        return;
                    }
                    image = this._windowManager.roomEngine.getWallItemImage(furniture.id, new Vector3d(90), 64, this, 0, info.extraData);
                    break;
                case 2:
                    furniture = this._windowManager.sessionDataManager.getFloorItemData(parseInt(info.itemTypeId));
                    if (furniture == null)
                    {
                        this.clearPreviewer();
                        return;
                    }
                    image = this._windowManager.roomEngine.getFurnitureImage(furniture.id, new Vector3d(90, 0, 0), 64, this);
                    break;
                default:
                    super.previewImage(info);
                    return;
            }

            this.imageResult = image;
        }
    }
}
