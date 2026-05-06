package com.sulake.habbo.window.utils.tableview
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.ui.Keyboard;

    public class TableCellView implements IDisposable
    {
        private var _disposed:Boolean = false;
        private var _table:TableView;
        private var _row:TableRowView;
        private var _columnId:String;
        private var _cell:TableCell;
        private var _container:IRegionWindow;

        public function TableCellView(table:TableView, row:TableRowView, columnId:String, cell:TableCell)
        {
            this._table = table;
            this._row = row;
            this._columnId = columnId;
            this._cell = cell;
            this._container = this.template.clone();
            this.updateWidth();
            this.initializeView();
            this._container.addEventListener(WindowMouseEvent.DOUBLE_CLICK, this.onDoubleClick);
            this._container.addEventListener(WindowMouseEvent.DOWN, this._row.onDown);
            this._container.addEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
            this._container.mouseThreshold = 0;
        }

        public function reuse(cell:TableCell):void
        {
            this._cell = cell;
            this.initializeView();
            this.updateWidth();
        }

        public function update(cell:TableCell):void
        {
            this._cell = cell;
            this.initializeView();
            this.updateWidth();
        }

        public function updateWidth():void
        {
            var text:ITextWindow;
            var input:ITextFieldWindow;
            var linkRegion:IRegionWindow;
            var linkText:ITextWindow;
            var width:int = this._table.getCellWidth(this._columnId);
            this._container.width = width;
            text = this.getTextElement(false);
            if (text != null)
            {
                text.width = width;
            }
            input = this.getInputElement(false);
            if (input != null)
            {
                input.width = width;
            }
            linkRegion = this.getLinkRegion(false);
            if (linkRegion != null)
            {
                linkRegion.width = width;
                linkText = this.getLinkElement(false);
                if (linkText != null)
                {
                    linkText.width = width;
                }
            }
        }

        public function get container():IRegionWindow
        {
            return this._container;
        }

        public function recycle():void
        {
            this._cell = null;
        }

        public function dispose():void
        {
            var input:ITextFieldWindow;
            var linkRegion:IRegionWindow;
            var extraRegion:IRegionWindow;
            if (this._disposed)
            {
                return;
            }
            if (this._container != null)
            {
                this._container.removeEventListener(WindowMouseEvent.DOUBLE_CLICK, this.onDoubleClick);
                this._container.removeEventListener(WindowMouseEvent.DOWN, this._row.onDown);
                this._container.removeEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                this._container.removeEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                input = this.getInputElement(false);
                if (input != null)
                {
                    input.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this.onInputEdit);
                    input.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onInputEdit);
                    input.removeEventListener(WindowEvent.WINDOW_EVENT_UNFOCUS, this.onInputFocusOut);
                }
                linkRegion = this.getLinkRegion(false);
                if (linkRegion != null)
                {
                    linkRegion.removeEventListener(WindowMouseEvent.DOWN, this._row.onDown);
                    linkRegion.removeEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                    linkRegion.removeEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                    linkRegion.removeEventListener(WindowMouseEvent.CLICK, this.onLinkClick);
                }
                extraRegion = this.getExtraButtonRegion(false);
                if (extraRegion != null)
                {
                    extraRegion.removeEventListener(WindowMouseEvent.CLICK, this.onExtraButtonClick);
                    extraRegion.removeEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                    extraRegion.removeEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                }
                this._container.dispose();
                this._container = null;
            }
            this._row = null;
            this._table = null;
            this._cell = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        private function initializeView():void
        {
            this.setAllInvisible();
            if (this._cell == null)
            {
                return;
            }
            if (this._cell.type == TableCell.TYPE_LINK)
            {
                this.getLinkRegion(true).visible = true;
            }
            else
            {
                this.getTextElement(true).visible = true;
            }
            this.updateContents();
            this.updateWidth();
        }

        private function updateContents():void
        {
            var text:ITextWindow;
            var tooltip:String;
            var extraRegion:IRegionWindow;
            if (this._cell.type == TableCell.TYPE_LINK)
            {
                this.getLinkElement(true).text = (this._cell.contents as String);
            }
            else
            {
                text = this.getTextElement(true);
                if (text != null)
                {
                    if (this._cell.textColor != 0)
                    {
                        text.textColor = this._cell.textColor;
                    }
                    text.autoSize = this.column.alignment;
                    text.text = (this._cell.contents as String);
                }
            }

            tooltip = "";
            if (this._cell.tooltipText != null)
            {
                tooltip = this._cell.tooltipText;
            }
            this._container.toolTipCaption = tooltip;

            extraRegion = this.getExtraButtonRegion(false);
            if (this._cell.extraBtn != null)
            {
                extraRegion = this.getExtraButtonRegion(true);
                extraRegion.visible = true;
                this.getExtraButton(true).assetUri = this._cell.extraBtn;
            }
            else if (extraRegion != null)
            {
                extraRegion.visible = false;
            }
        }

        private function setAllInvisible():void
        {
            this.turnInvisible(this.getTextElement(false));
            this.turnInvisible(this.getInputElement(false));
            this.turnInvisible(this.getLinkRegion(false));
            this.turnInvisible(this.getExtraButtonRegion(false));
        }

        private function turnInvisible(window:IWindow):void
        {
            if (window != null)
            {
                window.visible = false;
            }
        }

        private function onLinkClick(k:WindowMouseEvent):void
        {
            if (((this._cell != null) && (!(this._cell.linkClickCallback == null))))
            {
                this._cell.linkClickCallback();
            }
        }

        private function onExtraButtonClick(k:WindowMouseEvent):void
        {
            if (((this._cell != null) && (!(this._cell.extraBtnCallback == null))))
            {
                this._cell.extraBtnCallback();
            }
        }

        private function onDoubleClick(k:WindowMouseEvent):void
        {
            var input:ITextFieldWindow;
            if (((this._cell == null) || ((!this._cell.isInspectable) && (!this._cell.isEditable))))
            {
                return;
            }
            this.setAllInvisible();
            input = this.getInputElement(true);
            input.visible = true;
            input.text = this._cell.textFieldValue;
            input.editable = this._cell.isEditable;
            input.focus();
        }

        private function onInputEdit(k:WindowKeyboardEvent):void
        {
            var input:ITextFieldWindow;
            if (this._cell == null)
            {
                return;
            }
            input = this.getInputElement(false);
            if (((k.keyCode == Keyboard.ENTER) && (this._cell.isEditable)))
            {
                this._table.onEnterNewCellValue(input.text, this._row.object, this._columnId);
                this.initializeView();
            }
            else if (k.keyCode == Keyboard.ESCAPE)
            {
                this.initializeView();
            }
        }

        private function onInputFocusOut(k:WindowEvent):void
        {
            this.initializeView();
        }

        private function get column():TableColumn
        {
            return this._table.getColumnById(this._columnId);
        }

        private function getTextElement(create:Boolean):ITextWindow
        {
            var text:ITextWindow = (this._container.findChildByName("element_text") as ITextWindow);
            if (((text == null) && (create)))
            {
                text = this.template.createElementText(this._container);
            }
            return text;
        }

        private function getInputElement(create:Boolean):ITextFieldWindow
        {
            var input:ITextFieldWindow;
            input = (this._container.findChildByName("element_input") as ITextFieldWindow);
            if (((input == null) && (create)))
            {
                input = this.template.createElementInput(this._container);
                input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_DOWN, this.onInputEdit);
                input.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this.onInputEdit);
                input.addEventListener(WindowEvent.WINDOW_EVENT_UNFOCUS, this.onInputFocusOut);
            }
            return input;
        }

        private function getLinkRegion(create:Boolean):IRegionWindow
        {
            var region:IRegionWindow;
            region = (this._container.findChildByName("link_container") as IRegionWindow);
            if (((region == null) && (create)))
            {
                region = this.template.createLinkContainer(this._container);
                region.addEventListener(WindowMouseEvent.DOWN, this._row.onDown);
                region.addEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                region.addEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
                region.addEventListener(WindowMouseEvent.CLICK, this.onLinkClick);
                region.mouseThreshold = 0;
            }
            return region;
        }

        private function getLinkElement(create:Boolean):ITextWindow
        {
            var region:IRegionWindow = this.getLinkRegion(create);
            if (region == null)
            {
                return null;
            }
            return (region.findChildByName("element_link") as ITextWindow);
        }

        private function getExtraButtonRegion(create:Boolean):IRegionWindow
        {
            var region:IRegionWindow;
            region = (this._container.findChildByName("extra_button") as IRegionWindow);
            if (((region == null) && (create)))
            {
                region = this.template.createExtraButton(this._container);
                region.addEventListener(WindowMouseEvent.CLICK, this.onExtraButtonClick);
                region.addEventListener(WindowMouseEvent.OVER, this._row.onHoverOver);
                region.addEventListener(WindowMouseEvent.OUT, this._row.onHoverOut);
            }
            return region;
        }

        private function getExtraButton(create:Boolean):IStaticBitmapWrapperWindow
        {
            var region:IRegionWindow = this.getExtraButtonRegion(create);
            if (region == null)
            {
                return null;
            }
            return (region.findChildByName("extra_button_bitmap") as IStaticBitmapWrapperWindow);
        }

        private function get template():CellTemplate
        {
            return this._table.cellTemplate;
        }
    }
}
