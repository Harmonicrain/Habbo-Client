package com.sulake.habbo.window.utils.tableview
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class TableRowView implements IDisposable
    {
        private static const COLOR_SELECTED_FOCUSED:uint = 0xFFB8E2FC;
        private static const COLOR_SELECTED:uint = 0xFFD1D1D1;
        private static const COLOR_EVEN:uint = 0xFFF2F2F2;
        private static const COLOR_ODD:uint = 0xFFF9F9F9;

        private var _disposed:Boolean = false;
        private var _table:TableView;
        private var _container:IItemListWindow;
        private var _cellViews:Vector.<TableCellView>;
        private var _model:TableRowModel;

        public function TableRowView(table:TableView, model:TableRowModel)
        {
            var column:TableColumn;
            var cell:TableCell;
            var cellView:TableCellView;
            this._table = table;
            this._model = model;
            this._container = (table.rowTemplate.clone() as IItemListWindow);
            this._cellViews = new Vector.<TableCellView>();
            this.updateWidth();
            for each (column in table.columns)
            {
                cell = this.object.getTableCell(column.id);
                cellView = new TableCellView(table, this, column.id, cell);
                this._cellViews.push(cellView);
                this._container.addListItem(cellView.container);
            }
            this.updateColor();
            this._container.addEventListener(WindowMouseEvent.DOWN, this.onDown);
            this._container.addEventListener(WindowMouseEvent.OVER, this.onHoverOver);
            this._container.addEventListener(WindowMouseEvent.OUT, this.onHoverOut);
        }

        public static function windowIsChild(parent:IWindow, child:IWindow):Boolean
        {
            var container:IWindowContainer;
            var i:int;
            var selector:ISelectorWindow;
            if (parent == child)
            {
                return true;
            }
            if ((parent is ISelectorWindow))
            {
                selector = (parent as ISelectorWindow);
                i = 0;
                while (i < selector.numSelectables)
                {
                    if (windowIsChild(selector.getSelectableAt(i), child))
                    {
                        return true;
                    }
                    i++;
                }
            }
            else if ((parent is IWindowContainer) || (parent is IItemListWindow))
            {
                container = (parent as IWindowContainer);
                i = 0;
                while (i < container.numChildren)
                {
                    if (windowIsChild(container.getChildAt(i), child))
                    {
                        return true;
                    }
                    i++;
                }
            }
            return false;
        }

        public function indexUpdated():void
        {
            this.updateColor();
        }

        public function objectUpdated(previous:ITableObject, current:ITableObject):void
        {
            var column:TableColumn;
            var cell:TableCell;
            var cellView:TableCellView;
            var index:int;
            for each (column in this._table.columns)
            {
                if (current.isPropertyUpdated(column.id, previous))
                {
                    cell = current.getTableCell(column.id);
                    cellView = this._cellViews[index];
                    cellView.update(cell);
                }
                index++;
            }
        }

        public function reuse(model:TableRowModel):void
        {
            var column:TableColumn;
            var cell:TableCell;
            var cellView:TableCellView;
            var index:int;
            this._model = model;
            for each (column in this._table.columns)
            {
                cell = this.object.getTableCell(column.id);
                cellView = this._cellViews[index];
                cellView.reuse(cell);
                index++;
            }
            this.updateColor();
        }

        public function updateWidth():void
        {
            var cellView:TableCellView;
            if (this._container.width == this._table.rowWidth)
            {
                return;
            }
            this._container.width = this._table.rowWidth;
            for each (cellView in this._cellViews)
            {
                cellView.updateWidth();
            }
        }

        public function onDown(k:WindowMouseEvent):void
        {
            if (this._model == null)
            {
                return;
            }
            this._model.hasFocus = true;
            this._table.trySelect(this.object, true);
            this.updateColor();
        }

        public function onHoverOver(k:WindowMouseEvent):void
        {
            if (((this._model == null) || (this._model.hovered)))
            {
                return;
            }
            this._table.onHover(this.object);
        }

        public function onHoverOut(k:WindowMouseEvent):void
        {
            if (((this._model == null) || (!(this._model.hovered))))
            {
                return;
            }
            this._table.onHover(null);
        }

        public function selectedUpdated():void
        {
            this.updateColor();
        }

        public function hoveredUpdated():void
        {
        }

        public function get object():ITableObject
        {
            return ((this._model != null) ? this._model.object : null);
        }

        public function get container():IItemListWindow
        {
            return this._container;
        }

        public function recycle():void
        {
            var cellView:TableCellView;
            for each (cellView in this._cellViews)
            {
                cellView.recycle();
            }
            this._model = null;
        }

        public function dispose():void
        {
            var cellView:TableCellView;
            if (this._disposed)
            {
                return;
            }
            for each (cellView in this._cellViews)
            {
                cellView.dispose();
            }
            this._cellViews = null;
            if (this._container != null)
            {
                this._container.removeEventListener(WindowMouseEvent.DOWN, this.onDown);
                this._container.removeEventListener(WindowMouseEvent.OVER, this.onHoverOver);
                this._container.removeEventListener(WindowMouseEvent.OUT, this.onHoverOut);
                this._container.dispose();
                this._container = null;
            }
            this._table = null;
            this._model = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        private function updateColor():void
        {
            var color:uint;
            if (this._model == null)
            {
                return;
            }
            if (this._model.selected)
            {
                color = ((this._model.hasFocus) ? COLOR_SELECTED_FOCUSED : COLOR_SELECTED);
            }
            else
            {
                color = (((this._model.i % 2) == 0) ? COLOR_EVEN : COLOR_ODD);
            }
            this._container.color = color;
        }
    }
}
