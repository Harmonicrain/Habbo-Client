package com.sulake.habbo.window.utils.tableview
{
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IScrollableListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.utils.Dictionary;

    public class TableView implements IDisposable
    {
        private static const SCROLLBAR_OFFSET:int = 21;

        private var _disposed:Boolean;
        private var _initialized:Boolean;

        private var _windowManager:IHabboWindowManager;
        private var _parent:IWindowContainer;
        private var _container:IWindowContainer;

        private var _tableTitleRow:IItemListWindow;
        private var _splitter:IWindow;
        private var _titleTemplate:ITextWindow;
        private var _tableItems:IScrollableListWindow;
        private var _rowTemplate:IItemListWindow;
        private var _cellTemplate:CellTemplate;

        private var _columns:Vector.<TableColumn>;
        private var _rowModels:Vector.<TableRowModel>;
        private var _rowViews:Vector.<TableRowView>;
        private var _rowByIdentifier:Dictionary;

        private var _selected:TableRowModel;
        private var _hovered:TableRowModel;
        private var _canSelect:Boolean;
        private var _showHeader:Boolean;

        private var _onRowClickedCallback:Function;
        private var _onRowSelectedCallback:Function;
        private var _onRowHoverCallback:Function;
        private var _onCellEditCallback:Function;

        public function TableView(windowManager:IHabboWindowManager, parent:IWindowContainer, clip:Boolean=false, minimalResourcesMode:Boolean=false, layoutAsset:XmlAsset=null)
        {
            var xml:XML;
            this._windowManager = windowManager;
            this._parent = parent;
            this._columns = new Vector.<TableColumn>();
            this._rowModels = new Vector.<TableRowModel>();
            this._rowViews = new Vector.<TableRowView>();
            this._rowByIdentifier = new Dictionary();
            if (layoutAsset != null)
            {
                xml = (layoutAsset.content as XML);
            }
            else
            {
                if (((windowManager.assets == null) || (windowManager.assets.getAssetByName("table_view_xml") == null)))
                {
                    return;
                }
                xml = (windowManager.assets.getAssetByName("table_view_xml").content as XML);
            }
            this._container = (windowManager.buildFromXML(xml) as IWindowContainer);
            if (this._container == null)
            {
                return;
            }
            parent.addChild(this._container);

            this._tableTitleRow = (this._container.findChildByName("table_titlerow") as IItemListWindow);
            this._splitter = this._container.findChildByName("splitter");
            this.tableContents.removeListItem(this._tableTitleRow);
            this.tableContents.removeListItem(this._splitter);

            this._titleTemplate = (this._tableTitleRow.removeListItemAt(0) as ITextWindow);

            this._tableItems = (this._container.findChildByName("table_items") as IScrollableListWindow);
            this._rowTemplate = (this._tableItems.removeListItemAt(1) as IItemListWindow);
            this._cellTemplate = new CellTemplate((this._rowTemplate.removeListItemAt(0) as IRegionWindow));

            this._container.width = parent.width;
            this._container.height = parent.height;
            this.updateTableItemsHeight();
            this.resizeHorizontally();
            this.updateEmptyText();

            if (clip)
            {
                this._container.setParamFlag(2048, true);
            }

            this.tableContents.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResized);
            this._tableItems.addEventListener(WindowEvent.WINDOW_EVENT_SCROLL, this.onScrolled);
        }

        public function initialize(columns:Vector.<TableColumn>, showHeader:Boolean=true, canSelect:Boolean=true):void
        {
            if (this._initialized)
            {
                return;
            }
            this._canSelect = canSelect;
            this._columns = columns;
            this._rowModels = new Vector.<TableRowModel>();
            this._rowViews = new Vector.<TableRowView>();
            this._rowByIdentifier = new Dictionary();
            this._showHeader = showHeader;

            if (showHeader)
            {
                this.tableContents.addListItemAt(this._tableTitleRow, 0);
                this.tableContents.addListItemAt(this._splitter, 1);
            }
            else
            {
                this.updateTableItemsHeight();
                this.updateEmptyText();
            }

            this.initializeColumns(columns);
            this._initialized = true;
        }

        public function setObjects(objects:Vector.<ITableObject>, resetScroll:Boolean=false):void
        {
            var obj:ITableObject;
            var model:TableRowModel;
            var index:int;
            if (!(this._initialized))
            {
                return;
            }

            var sameStructure:Boolean =
                objects.length == this._rowModels.length;
            if (sameStructure)
            {
                index = 0;
                while (index < objects.length)
                {
                    if (this._rowModels[index].object.identifier
                        != objects[index].identifier)
                    {
                        sameStructure = false;
                        break;
                    }
                    index++;
                }
            }
            if (sameStructure)
            {
                index = 0;
                while (index < objects.length)
                {
                    this._rowModels[index].update(objects[index]);
                    index++;
                }
                if (resetScroll)
                {
                    this._tableItems.scrollV = 0;
                }
                this.updateEmptyText();
                this.onScrollBarVisibilityMayHaveChanged();
                return;
            }

            this.clear(false);
            if (objects.length == 0)
            {
                this.updateEmptyText();
                return;
            }

            index = 0;
            for each (obj in objects)
            {
                model = new TableRowModel(obj, index);
                this._rowModels.push(model);
                this._rowByIdentifier[obj.identifier] = model;
                index++;
            }

            this.rebuildRowViews();
            this.updateEmptyText();
            this.onScrollBarVisibilityMayHaveChanged();

            if (resetScroll)
            {
                this._tableItems.scrollV = 0;
            }
        }

        public function clear(disposeModels:Boolean=true):void
        {
            var view:TableRowView;
            var model:TableRowModel;
            if (!(this._initialized))
            {
                return;
            }

            for each (view in this._rowViews)
            {
                view.dispose();
            }
            this._rowViews = new Vector.<TableRowView>();
            this._tableItems.removeListItems();

            if ((disposeModels) && (this._rowModels != null))
            {
                for each (model in this._rowModels)
                {
                    model.dispose();
                }
            }
            this._rowModels = new Vector.<TableRowModel>();
            this._rowByIdentifier = new Dictionary();

            if (this._selected != null)
            {
                this._selected = null;
                if (this._onRowSelectedCallback != null)
                {
                    this._onRowSelectedCallback(null);
                }
            }
            if (this._hovered != null)
            {
                this._hovered = null;
                if (this._onRowHoverCallback != null)
                {
                    this._onRowHoverCallback(null);
                }
            }
        }

        public function trySelect(obj:ITableObject, fireClick:Boolean=false):void
        {
            var model:TableRowModel;
            if ((this._onRowClickedCallback != null) && (fireClick))
            {
                this._onRowClickedCallback(obj);
            }
            if (!(this._canSelect))
            {
                return;
            }
            if (((this._selected != null) && (obj != null)) && (this._selected.object == obj))
            {
                return;
            }
            if (this._selected != null)
            {
                this._selected.selected = false;
                this._selected = null;
            }
            if (obj != null)
            {
                model = this.getRowForObject(obj);
                if (model != null)
                {
                    model.selected = true;
                    this._selected = model;
                }
            }
            if (this._onRowSelectedCallback != null)
            {
                this._onRowSelectedCallback(((this._selected != null) ? this._selected.object : null));
            }
        }

        public function onHover(obj:ITableObject):void
        {
            var model:TableRowModel;
            if (((this._hovered != null) && (obj != null)) && (this._hovered.object == obj))
            {
                return;
            }
            if (this._hovered != null)
            {
                this._hovered.hovered = false;
                this._hovered = null;
            }
            if (obj != null)
            {
                model = this.getRowForObject(obj);
                if (model != null)
                {
                    model.hovered = true;
                    this._hovered = model;
                }
            }
            if (this._onRowHoverCallback != null)
            {
                this._onRowHoverCallback(((this._hovered != null) ? this._hovered.object : null));
            }
        }

        public function resizeHorizontally():void
        {
            var i:int;
            var header:ITextWindow;
            var model:TableRowModel;
            if (((this._disposed) || (this._container == null)) || (this._tableTitleRow == null))
            {
                return;
            }
            this._container.width = this._parent.width;
            this._tableTitleRow.width = this.rowWidth;
            this._splitter.width = this.rowWidth;

            i = 0;
            while (i < this._tableTitleRow.numListItems)
            {
                header = (this._tableTitleRow.getListItemAt(i) as ITextWindow);
                header.width = this.getCellWidth(this._columns[i].id);
                i++;
            }

            for each (model in this._rowModels)
            {
                if (model.view != null)
                {
                    model.view.updateWidth();
                }
            }
        }

        public function getColumnById(id:String):TableColumn
        {
            var column:TableColumn;
            for each (column in this._columns)
            {
                if (column.id == id)
                {
                    return column;
                }
            }
            return null;
        }

        public function getCellWidth(columnId:String):int
        {
            var column:TableColumn = this.getColumnById(columnId);
            return ((column != null) ? (this.rowWidth * column.widthFactor) : 0);
        }

        public function onEnterNewCellValue(value:String, obj:ITableObject, columnId:String):void
        {
            if (this._onCellEditCallback != null)
            {
                this._onCellEditCallback(obj, columnId, value);
            }
        }

        public function get rowWidth():int
        {
            var scrollbarVisible:Boolean;
            scrollbarVisible = (this._tableItems.maxScrollV > 0);
            return (this.tableContents.width - ((scrollbarVisible) ? SCROLLBAR_OFFSET : 0));
        }

        public function get columns():Vector.<TableColumn>
        {
            return this._columns;
        }

        public function get rowTemplate():IItemListWindow
        {
            return this._rowTemplate;
        }

        public function get cellTemplate():CellTemplate
        {
            return this._cellTemplate;
        }

        public function set onRowSelectedCallback(value:Function):void
        {
            this._onRowSelectedCallback = value;
        }

        public function set onRowClickedCallback(value:Function):void
        {
            this._onRowClickedCallback = value;
        }

        public function set onRowHoveredCallback(value:Function):void
        {
            this._onRowHoverCallback = value;
        }

        public function set onCellEditCallback(value:Function):void
        {
            this._onCellEditCallback = value;
        }

        public function get rowCount():int
        {
            return ((this._rowModels != null) ? this._rowModels.length : 0);
        }

        public function dispose():void
        {
            var model:TableRowModel;
            if (this._disposed)
            {
                return;
            }
            if (this.tableContents != null)
            {
                this.tableContents.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.onResized);
            }
            if (this._tableItems != null)
            {
                this._tableItems.removeEventListener(WindowEvent.WINDOW_EVENT_SCROLL, this.onScrolled);
            }
            this.clear();
            for each (model in this._rowModels)
            {
                model.dispose();
            }
            this._rowModels = null;
            this._rowByIdentifier = null;
            this._columns = null;
            this._onRowHoverCallback = null;
            this._onRowSelectedCallback = null;
            this._onRowClickedCallback = null;
            this._onCellEditCallback = null;
            if (this._container != null)
            {
                this._container.dispose();
                this._container = null;
            }
            this._tableTitleRow = null;
            this._splitter = null;
            this._titleTemplate = null;
            this._tableItems = null;
            this._rowTemplate = null;
            this._cellTemplate = null;
            this._windowManager = null;
            this._parent = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        private function initializeColumns(columns:Vector.<TableColumn>):void
        {
            var column:TableColumn;
            var header:ITextWindow;
            var width:int;
            for each (column in columns)
            {
                header = (this._titleTemplate.clone() as ITextWindow);
                header.text = column.columnName;
                width = this.getCellWidth(column.id);
                header.width = width;
                header.autoSize = column.alignment;
                this._tableTitleRow.addListItem(header);
            }
        }

        private function rebuildRowViews():void
        {
            var model:TableRowModel;
            var rowView:TableRowView;
            for each (model in this._rowModels)
            {
                rowView = new TableRowView(this, model);
                model.view = rowView;
                this._rowViews.push(rowView);
                this._tableItems.addListItem(rowView.container);
            }
            this.onScrollBarVisibilityMayHaveChanged();
            this.resizeHorizontally();
        }

        private function getRowForObject(obj:ITableObject):TableRowModel
        {
            return ((obj != null) ? this._rowByIdentifier[obj.identifier] : null);
        }

        private function updateTableItemsHeight():void
        {
            if (((this._tableItems == null) || (this.tableContents == null)) || (this._disposed))
            {
                return;
            }
            this._tableItems.height = (this.tableContents.height - ((this._showHeader) ? (this._tableTitleRow.height + this._splitter.height) : 0));
            this.onScrollBarVisibilityMayHaveChanged();
        }

        private function updateEmptyText():void
        {
            if (((this._disposed) || (this.emptyTextContainer == null)) || (this.tableContents == null))
            {
                return;
            }
            if (this._showHeader)
            {
                this.emptyTextContainer.y = (this._tableTitleRow.height + this._splitter.height);
                this.emptyTextContainer.height = (this.tableContents.height - this.emptyTextContainer.y);
            }
            else
            {
                this.emptyTextContainer.y = 0;
                this.emptyTextContainer.height = this.tableContents.height;
            }
            this.emptyTextContainer.visible = ((this._rowModels == null) || (this._rowModels.length == 0));
        }

        private function onResized(k:WindowEvent):void
        {
            if (this._disposed)
            {
                return;
            }
            this.updateTableItemsHeight();
            this.resizeHorizontally();
        }

        private function onScrolled(k:WindowEvent):void
        {
            if (this._disposed)
            {
                return;
            }
            this.onScrollBarVisibilityMayHaveChanged();
        }

        private function onScrollBarVisibilityMayHaveChanged():void
        {
            this.resizeHorizontally();
        }

        private function get tableContents():IItemListWindow
        {
            return (this._container.findChildByName("table_contents") as IItemListWindow);
        }

        private function get emptyTextContainer():IWindowContainer
        {
            return (this._container.findChildByName("empty_container") as IWindowContainer);
        }
    }
}
