package com.sulake.core.window.utils
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBackgroundWindow;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.enum.WindowParam;

    public class WindowUtils
    {
        public static function disableButton(window:IWindow, disabled:Boolean):void
        {
            if (disabled)
            {
                window.disable();
            }
            else
            {
                window.enable();
            }
        }

        private static function getBlend(window:IWindow):Number
        {
            if (window is IBackgroundWindow)
            {
                return (((window.color >>> 24) & 0xFF) / 0xFF);
            }
            return window.blend;
        }

        private static function setBlend(window:IWindow, value:Number):void
        {
            var alpha:int;
            if (window is IBackgroundWindow)
            {
                alpha = Math.max(0, Math.min(0xFF, int(value * 0xFF)));
                window.color = ((window.color & 0xFFFFFF) | (alpha << 24));
            }
            else
            {
                window.blend = value;
            }
        }

        public static function disableSection(window:IWindow, disabled:Boolean=true, factor:Number=0.5):void
        {
            var tag:String;
            var targetBlend:Number;
            var container:IWindowContainer;
            var i:int;
            if (window.tags.indexOf("DO_NOT_DISABLE") != -1)
            {
                return;
            }
            var originalBlend:Number = -1;
            for each (tag in window.tags)
            {
                if (tag.indexOf("BLEND=") == 0)
                {
                    originalBlend = Number(tag.substring(6, tag.length));
                }
            }
            if (originalBlend == -1)
            {
                originalBlend = getBlend(window);
                tag = ("BLEND=" + originalBlend);
                if (window.tags.indexOf(tag) == -1)
                {
                    window.tags.push(tag);
                }
            }
            if (((disabled) && (window.tags.indexOf("INVIS_ON_DISABLE") != -1)))
            {
                targetBlend = 0;
            }
            else
            {
                targetBlend = ((disabled) ? (originalBlend * factor) : originalBlend);
            }
            var isIcon:Boolean = (window.tags.indexOf("#icon") != -1);
            var hasOwnGraphics:Boolean = (!(window.getParamFlag(WindowParam.WINDOW_PARAM_USE_PARENT_GRAPHIC_CONTEXT)));
            if (!(window is IButtonWindow))
            {
                if (((window is IWindowContainer) || (window is IItemListWindow) || (window is ISelectorWindow)))
                {
                    container = (window as IWindowContainer);
                    if (container != null)
                    {
                        i = 0;
                        while (i < container.numChildren)
                        {
                            disableSection(container.getChildAt(i), disabled, ((hasOwnGraphics) ? 1 : factor));
                            i++;
                        }
                    }
                    if (((window is IBorderWindow) || (window is IBackgroundWindow) || (hasOwnGraphics)))
                    {
                        setBlend(window, targetBlend);
                    }
                }
                else
                {
                    if (!isIcon)
                    {
                        setBlend(window, targetBlend);
                    }
                }
            }
            if (disabled)
            {
                window.disable();
            }
            else
            {
                window.enable();
            }
        }
    }
}
