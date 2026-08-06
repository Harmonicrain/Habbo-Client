package com.sulake.habbo.inventory.wired_trading.requirements
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirement;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementNode;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRule;
    import com.sulake.habbo.inventory.items.FurnitureItem;
    import com.sulake.habbo.inventory.items.GroupItem;
    import flash.utils.Dictionary;

    /**
     * Precomputed July rule filter for the local user's inventory.
     */
    public class TradeRequirementWrapper
    {
        private var _requirement:TradeRequirement;
        private var _canOfferCreditFurni:Boolean;
        private var _floorTypes:Dictionary;
        private var _wallTypes:Dictionary;
        private var _posterIds:Dictionary;

        public function TradeRequirementWrapper(requirement:TradeRequirement)
        {
            this._requirement = requirement;
            if (requirement.rules != null && requirement.rules.youGiveRule != null)
            {
                this._floorTypes = new Dictionary();
                this._wallTypes = new Dictionary();
                this._posterIds = new Dictionary();
                for each (var rule:TradeRequirementRule in requirement.rules.youGiveRule)
                {
                    for each (var node:TradeRequirementNode in rule.nodes)
                    {
                        if (node.type == TradeRequirementNode.TYPE_COIN)
                        {
                            this._canOfferCreditFurni = true;
                        }
                        else if (node.type == TradeRequirementNode.TYPE_FURNI)
                        {
                            var itemType:ChestItemType = node.itemType;
                            if (itemType == null)
                            {
                                continue;
                            }
                            if (itemType.isWallItem)
                            {
                                this._wallTypes[itemType.typeId] = true;
                                if (itemType.legacyPosterId.length > 0)
                                {
                                    this._posterIds[itemType.legacyPosterId] = true;
                                }
                            }
                            else
                            {
                                this._floorTypes[itemType.typeId] = true;
                            }
                        }
                    }
                }
            }
        }

        public function get requirement():TradeRequirement
        {
            return this._requirement;
        }

        public function canOfferCreditFurni():Boolean
        {
            return this._canOfferCreditFurni;
        }

        public function canOfferNormalFurni(group:GroupItem):Boolean
        {
            if (this._floorTypes == null || this._wallTypes == null || this._posterIds == null)
            {
                return false;
            }
            var item:FurnitureItem = group._Str_3205();
            if (item == null)
            {
                return false;
            }
            if (!item.isWallItem)
            {
                return item.type in this._floorTypes;
            }
            if (item.category == 6
                && !(item.stuffData.getLegacyString() in this._posterIds))
            {
                return false;
            }
            return item.type in this._wallTypes;
        }
    }
}
