package com.sulake.habbo.inventory.wired_trading.requirements
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.catalog.enum.ProductTypeEnum;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.inventory.items.GroupItem;
    import com.sulake.habbo.inventory.wired_trading.WiredTradingModel;
    import com.sulake.habbo.session.furniture.IFurnitureData;

    public class WiredTradeRequirementsModel implements IDisposable
    {
        private var _tradingModel:WiredTradingModel;
        private var _wrapper:TradeRequirementWrapper;
        private var _view:WiredTradeRequirementsView;
        private var _disposed:Boolean;

        public function WiredTradeRequirementsModel(tradingModel:WiredTradingModel)
        {
            this._tradingModel = tradingModel;
            this._view = new WiredTradeRequirementsView(this);
        }

        public function setRequirements(requirement:TradeRequirement, showImmediate:Boolean):void
        {
            this._wrapper = new TradeRequirementWrapper(requirement);
            this._view.requirementsUpdated(requirement, showImmediate);
        }

        public function requirementsStateUpdated():void
        {
            this._view.requirementsStateUpdated();
        }

        public function highlightRefresh():void
        {
            this._view.highlightRefresh();
        }

        public function get tradingModel():WiredTradingModel
        {
            return this._tradingModel;
        }

        public function get requirement():TradeRequirement
        {
            return this._wrapper == null ? null : this._wrapper.requirement;
        }

        public function canOfferFurni(group:GroupItem):Boolean
        {
            if (this._wrapper == null)
            {
                return true;
            }
            if (group._Str_25861(1).length == 0)
            {
                return false;
            }

            var item:FurnitureItem = group._Str_3205();
            if (item == null)
            {
                return false;
            }
            var productType:String = item.isWallItem
                ? ProductTypeEnum.WALL : ProductTypeEnum.FLOOR;
            var data:IFurnitureData =
                this._tradingModel.inventory.getFurnitureData(item.type, productType);
            var className:String = data == null ? "" : data.className;
            var isCreditFurni:Boolean = className.indexOf("CF_") == 0;

            switch (this._wrapper.requirement.type)
            {
                case TradeRequirement.TYPE_ANY_FURNI:
                    return true;
                case TradeRequirement.TYPE_NORMAL_FURNI:
                    return !isCreditFurni;
                case TradeRequirement.TYPE_CREDIT_FURNI:
                    return isCreditFurni;
                case TradeRequirement.TYPE_RULES:
                    return isCreditFurni
                        ? this._wrapper.canOfferCreditFurni()
                        : this._wrapper.canOfferNormalFurni(group);
            }
            return true;
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._view.dispose();
            this._view = null;
            this._tradingModel = null;
            this._wrapper = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }
    }
}
