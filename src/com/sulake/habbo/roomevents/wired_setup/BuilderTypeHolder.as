package com.sulake.habbo.roomevents.wired_setup
{
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;

    /**
     * Per-category registry of builder elements. The accept check is delegated
     * to the category predicate supplied by the controller.
     */
    public class BuilderTypeHolder implements IWiredTypeHolder
    {
        private var _key:String;
        private var _elements:Map = new Map();
        private var _acceptCheck:Function;

        public function BuilderTypeHolder(_arg_1:String, _arg_2:Function)
        {
            super();
            this._key = _arg_1;
            this._acceptCheck = _arg_2;
        }

        public function register(_arg_1:IWiredElement):void
        {
            this._elements.add(_arg_1.code, _arg_1);
            if (_arg_1.negativeCode != -1)
            {
                this._elements.add(_arg_1.negativeCode, _arg_1);
            }
        }

        public function getElementByCode(_arg_1:int):IWiredElement
        {
            return this._elements.getValue(_arg_1) as IWiredElement;
        }

        public function getKey():String
        {
            return this._key;
        }

        public function acceptTriggerable(_arg_1:Triggerable):Boolean
        {
            return this._acceptCheck(_arg_1);
        }
    }
}
