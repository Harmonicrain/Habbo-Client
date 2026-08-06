package com.sulake.habbo.window.widgets
{
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;

    /**
     * July product-image widget. The clean client already has the same
     * furniture rendering path in ProductIconWidget; this larger widget uses
     * that path and lets the XML size its root to the preview panel.
     */
    public class ProductImageWidget extends ProductIconWidget
    {
        public static const PRODUCT_IMAGE:String = "product_image";
        public function ProductImageWidget(window:IWidgetWindow,
            manager:HabboWindowManagerComponent)
        {
            super(window, manager);
        }
    }
}
