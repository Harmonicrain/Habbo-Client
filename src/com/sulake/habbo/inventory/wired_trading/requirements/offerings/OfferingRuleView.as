package com.sulake.habbo.inventory.wired_trading.requirements.offerings
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;

    public class OfferingRuleView implements IDisposable
    {
        private static const MAX_COLUMNS:int = 2;

        private var _window:IWindowContainer;
        private var _rowTemplate:IItemListWindow;
        private var _nodeTemplate:IItemListWindow;
        private var _rowX:int;
        private var _nodes:Vector.<OfferingNodeView>;
        private var _disposed:Boolean;

        public function OfferingRuleView(template:IWindowContainer)
        {
            this._window = template.clone() as IWindowContainer;
            this._rowTemplate =
                this.rows.removeListItemAt(0) as IItemListWindow;
            this._nodeTemplate =
                this._rowTemplate.removeListItemAt(0) as IItemListWindow;
            this._rowX = this.rows.x;
        }

        public function initialize(rule:TradeRequirementRule, index:int):void
        {
            this.clearRows();
            this._nodes = new Vector.<OfferingNodeView>();
            var row:IItemListWindow;
            var nodeIndex:int = 0;
            for each (var node:TradeRequirementNode in rule.nodes)
            {
                if (row == null || row.numListItems >= MAX_COLUMNS)
                {
                    row = this._rowTemplate.clone() as IItemListWindow;
                    this.rows.addListItem(row);
                }
                var nodeView:OfferingNodeView =
                    new OfferingNodeView(this._nodeTemplate);
                nodeView.initialize(node, nodeIndex);
                this._nodes.push(nodeView);
                row.addListItem(nodeView.window);
                nodeIndex++;
            }
            this.orText.visible = index > 0;
            this._window.height = this.rows.height;
        }

        public function center(width:int):void
        {
            var columnsWidth:int = 0;
            for (var i:int = 0; i < this.rows.numListItems; i++)
            {
                var row:IItemListWindow =
                    this.rows.getListItemAt(i) as IItemListWindow;
                columnsWidth = Math.max(columnsWidth, row.width);
            }
            this.rows.x = width / 2 - columnsWidth / 2;
        }

        private function clearRows():void
        {
            this.rows.x = this._rowX;
            while (this.rows.numListItems > 0)
            {
                var row:IItemListWindow =
                    this.rows.removeListItemAt(0) as IItemListWindow;
                row.removeListItems();
                row.dispose();
            }
            if (this._nodes != null)
            {
                for each (var node:OfferingNodeView in this._nodes)
                {
                    node.dispose();
                }
            }
            this._nodes = null;
        }

        public function get window():IWindowContainer { return this._window; }

        public function dispose():void
        {
            if (this._disposed) { return; }
            this.clearRows();
            this._rowTemplate.dispose();
            this._nodeTemplate.dispose();
            this._rowTemplate = null;
            this._nodeTemplate = null;
            this._window.dispose();
            this._window = null;
            this._disposed = true;
        }

        public function get disposed():Boolean { return this._disposed; }
        private function get orText():ITextWindow
        { return this._window.findChildByName("or_text") as ITextWindow; }
        private function get rows():IItemListWindow
        { return this._window.findChildByName("rule_nodes_rows") as IItemListWindow; }
    }
}
