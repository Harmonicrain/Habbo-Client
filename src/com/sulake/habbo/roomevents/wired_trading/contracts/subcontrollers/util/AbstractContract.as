package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.util
{
    import com.sulake.core.communication.util.Short;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.TradeRequirementRulesDefinition;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.contracts.WiredContractController;
    import com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers.IContractView;

    public class AbstractContract extends AbstractUbuntuWiredUI implements IContractView
    {
        private var _contractId:int = -1;
        private var _parent:WiredContractController;

        public function AbstractContract(parent:WiredContractController,
            presetManager:PresetManager)
        {
            super(parent.roomEvents, presetManager);
            this._parent = parent;
        }

        override protected function get isBoundToParentRect():Boolean { return true; }
        public function get contractId():int { return this._contractId; }
        public function set contractId(value:int):void { this._contractId = value; }
        protected function get parentController():WiredContractController { return this._parent; }
        override public function onSaveClicked():void { this._parent.saveContract(this); }

        override protected function hideFrame():void
        {
            if (isShowing())
            {
                this._parent.cacheWindowLocation(window);
                this._parent.addEditContractElement.hide();
            }
            super.hideFrame();
        }

        public function show(contents:ChestContractContentsMessageParser):void
        {
            this.contractId = contents.contractId;
            this.footerPreset.saveButtonDisabled =
                !this.roomEvents.wiredMenu.hasWritePermission;
        }

        protected function createNewDefinitionFromUI():TradeRequirementRulesDefinition
        {
            return null;
        }

        public function addContentsToComposer(data:Array):void
        {
            data.push(this.contractId);
            data.push(new Short(this.contractType()));
            this.createNewDefinitionFromUI().addToComposer(data);
        }

        public function contractType():int { return 0; }
        public function validate():String { return null; }

        override public function dispose():void
        {
            if (disposed) return;
            this._parent = null;
            super.dispose();
        }
    }
}
