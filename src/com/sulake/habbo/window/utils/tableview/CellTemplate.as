package com.sulake.habbo.window.utils.tableview
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBorderWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;

    public class CellTemplate
    {
        private var _template:IRegionWindow;
        private var _highlightBorderTemplate:IBorderWindow;
        private var _textTemplate:ITextWindow;
        private var _inputTemplate:ITextFieldWindow;
        private var _linkTemplate:IRegionWindow;
        private var _extraButtonTemplate:IRegionWindow;

        public function CellTemplate(template:IRegionWindow)
        {
            this._template = template;
            this._highlightBorderTemplate = (template.findChildByName("highlight_border") as IBorderWindow);
            this._textTemplate = (template.findChildByName("element_text") as ITextWindow);
            this._inputTemplate = (template.findChildByName("element_input") as ITextFieldWindow);
            this._linkTemplate = (template.findChildByName("link_container") as IRegionWindow);
            this._extraButtonTemplate = (template.findChildByName("extra_button") as IRegionWindow);

            if (this._extraButtonTemplate != null)
            {
                this._template.removeChild(this._extraButtonTemplate);
            }
            if (this._linkTemplate != null)
            {
                this._template.removeChild(this._linkTemplate);
            }
            if (this._inputTemplate != null)
            {
                this._template.removeChild(this._inputTemplate);
            }
            if (this._textTemplate != null)
            {
                this._template.removeChild(this._textTemplate);
            }
            if (this._highlightBorderTemplate != null)
            {
                this._template.removeChild(this._highlightBorderTemplate);
            }
        }

        public function clone():IRegionWindow
        {
            return (this._template.clone() as IRegionWindow);
        }

        public function createHighlightBorder(parent:IWindowContainer):IBorderWindow
        {
            return (this.fixAlignmentsAndAdd(this._highlightBorderTemplate, parent) as IBorderWindow);
        }

        public function createElementText(parent:IWindowContainer):ITextWindow
        {
            return (this.fixAlignmentsAndAdd(this._textTemplate, parent) as ITextWindow);
        }

        public function createElementInput(parent:IWindowContainer):ITextFieldWindow
        {
            return (this.fixAlignmentsAndAdd(this._inputTemplate, parent) as ITextFieldWindow);
        }

        public function createLinkContainer(parent:IWindowContainer):IRegionWindow
        {
            return (this.fixAlignmentsAndAdd(this._linkTemplate, parent) as IRegionWindow);
        }

        public function createExtraButton(parent:IWindowContainer):IRegionWindow
        {
            return (this.fixAlignmentsAndAdd(this._extraButtonTemplate, parent) as IRegionWindow);
        }

        private function cloneAndAdd(template:IWindow, parent:IWindowContainer):IWindow
        {
            var clone:IWindow;
            if (template == null)
            {
                return null;
            }
            clone = template.clone();
            if (clone != null)
            {
                parent.addChild(clone);
            }
            return clone;
        }

        private function fixAlignmentsAndAdd(template:IWindow, parent:IWindowContainer):IWindow
        {
            var widthDelta:int;
            var clone:IWindow;
            var params:uint;
            var x:int;
            var width:int;
            var horizontalFlags:uint;
            if (template == null)
            {
                return null;
            }
            widthDelta = (parent.width - this._template.width);
            clone = template.clone();
            params = template.param;
            x = template.x;
            width = template.width;
            horizontalFlags = (params & 0xC0);
            if (horizontalFlags == 128)
            {
                width = (width + widthDelta);
            }
            else
            {
                if (horizontalFlags == 64)
                {
                    x = (x + widthDelta);
                }
                else
                {
                    if (horizontalFlags == 192)
                    {
                        if (((parent.width < template.width) && (template.getParamFlag(16))))
                        {
                            x = 0;
                        }
                        else
                        {
                            x = (Math.floor((parent.width / 2)) - Math.floor((width / 2)));
                        }
                    }
                }
            }
            clone.x = x;
            clone.width = width;
            parent.addChild(clone);
            return clone;
        }
    }
}
