package com.sulake.core.window.components
{
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window.enum.WindowState;
    import com.sulake.core.window.enum.WindowType;
    import com.sulake.core.window.graphics.renderer.BitmapSkinRenderer;
    import com.sulake.core.window.graphics.renderer.ISkinLayout;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;
    import flash.geom.Rectangle;
    import com.sulake.core.window.IWindow;

    public class IconController extends WindowController implements IIconWindow
    {
        public function IconController(k:String, _arg_2:uint, _arg_3:uint, _arg_4:uint, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:Function=null, _arg_9:Array=null, _arg_10:Array=null, _arg_11:uint=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
        }

        public function fitToSize():void
        {
            if (_context == null)
            {
                return;
            }
            var renderer:ISkinRenderer = _context.getWindowFactory().getRendererByTypeAndStyle(WindowType.WINDOW_TYPE_ICON, style);
            var bitmapRenderer:BitmapSkinRenderer = (renderer as BitmapSkinRenderer);
            if (bitmapRenderer == null)
            {
                return;
            }
            var layout:ISkinLayout = bitmapRenderer._Str_22661(state);
            if (layout == null)
            {
                layout = bitmapRenderer._Str_22661(WindowState.DEFAULT);
            }
            if (layout == null)
            {
                return;
            }
            var layoutWidth:int = int(layout.width);
            var layoutHeight:int = int(layout.height);
            if (((!(layoutWidth == _w)) || (!(layoutHeight == _h))))
            {
                this.setRectangle(_x, _y, layoutWidth, layoutHeight);
            }
        }
    }
}
