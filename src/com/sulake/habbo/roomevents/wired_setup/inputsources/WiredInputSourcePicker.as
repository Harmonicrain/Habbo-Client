package com.sulake.habbo.roomevents.wired_setup.inputsources
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.InputSourcesConf;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.IWiredElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import flash.utils.Dictionary;

    public class WiredInputSourcePicker implements ISourceTypeListener
    {
        public static const FURNI_SOURCE:int = 0;
        public static const USER_SOURCE:int = 1;
        public static const MERGED_SOURCE:int = 2;

        public static const STUFF_PICKING_MODE_NONE:int = 0;
        public static const STUFF_PICKING_MODE_1:int = 1;
        public static const STUFF_PICKING_MODE_2:int = 2;

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _sourceType:int;
        private var _id:int;
        private var _definition:Triggerable;
        private var _element:IWiredElement;
        private var _selectionCache:Dictionary;
        private var _selectedText:String = "";
        private var _stuffPickingSpecialMode:int = 0;
        private var _buttonsDisabled:Boolean = false;
        private var _disabled:Boolean = false;
        private var _disposed:Boolean = false;

        public function WiredInputSourcePicker(k:HabboUserDefinedRoomEvents, _arg_2:int, _arg_3:int)
        {
            super();
            this._roomEvents = k;
            this._sourceType = _arg_2;
            this._id = _arg_3;
            if (this._sourceType == MERGED_SOURCE)
            {
                this._selectionCache = new Dictionary();
            }
        }

        public static function getTypeNameForSource(k:int):String
        {
            if (k == FURNI_SOURCE) { return "furni"; }
            if (k == USER_SOURCE) { return "users"; }
            if (k == VariableExtraSourceTypes.CONTEXT_SOURCE) { return "context"; }
            if (k == VariableExtraSourceTypes.GLOBAL_SOURCE) { return "global"; }
            return "";
        }

        public function onChangeInputSource(k:Boolean):void
        {
            var allowed:Array = currentAllowedSources();
            if (allowed == null || allowed.length == 0)
            {
                return;
            }
            var current:int = currentSelectedValue();
            var index:int = allowed.indexOf(current);
            if (index == -1)
            {
                index = 0;
            }
            else if (k)
            {
                index = (index + 1) % allowed.length;
            }
            else
            {
                index = (index - 1 + allowed.length) % allowed.length;
            }
            setCurrentSelectedValue(int(allowed[index]));
            refreshContainer(this._definition, this._element);
        }

        public function set sourceType(k:int):void
        {
            if (this._sourceType != MERGED_SOURCE || this._definition == null || this._element == null)
            {
                return;
            }
            var oldType:int = this._element.getMergedType(this._id);
            var merged:Array = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return;
            }
            if (oldType == FURNI_SOURCE)
            {
                this._selectionCache[oldType] = this._definition.furniSourceTypes[int(merged[0])];
            }
            else if (oldType == USER_SOURCE)
            {
                this._selectionCache[oldType] = this._definition.userSourceTypes[int(merged[1])];
            }
            this._element.setMergedType(this._id, k);
            var conf:InputSourcesConf = this._definition.inputSourcesConf;
            if (k == FURNI_SOURCE)
            {
                this._definition.furniSourceTypes[int(merged[0])] = (k in this._selectionCache) ? this._selectionCache[k] : firstOrZero(conf.getAllowedFurniSources(int(merged[0])));
            }
            else if (k == USER_SOURCE)
            {
                this._definition.userSourceTypes[int(merged[1])] = (k in this._selectionCache) ? this._selectionCache[k] : firstOrZero(conf.getAllowedUserSources(int(merged[1])));
            }
            refreshContainer(this._definition, this._element);
        }

        public function refreshContainer(k:Triggerable, _arg_2:IWiredElement):void
        {
            if (this._definition != k || this._element != _arg_2)
            {
                this._definition = k;
                this._element = _arg_2;
                if (this._sourceType == MERGED_SOURCE)
                {
                    this._selectionCache = new Dictionary();
                }
            }
            var typeName:String = currentTypeName();
            var selectedValue:int = currentSelectedValue();
            var custom:Boolean = isCustomSource();
            var key:String = custom ? ("wiredfurni.params.sources." + typeName) : ("wiredfurni.params.sources." + typeName + "." + selectedValue);
            var text:String = this._roomEvents.localization.getLocalization(key, key);
            this._stuffPickingSpecialMode = STUFF_PICKING_MODE_NONE;
            if (typeName == "furni")
            {
                var ids:Array = null;
                if (selectedValue == InputSourcesConf.FURNI_SOURCE_FURNI_PICKS_1 || selectedValue == InputSourcesConf.FURNI_SOURCE_DUAL_MODE)
                {
                    ids = this._roomEvents.wiredCtrl.getStuffIds();
                    this._stuffPickingSpecialMode = STUFF_PICKING_MODE_1;
                }
                else if (selectedValue == InputSourcesConf.FURNI_SOURCE_FURNI_PICKS_2)
                {
                    ids = this._roomEvents.wiredCtrl.getStuffIds2();
                    this._stuffPickingSpecialMode = STUFF_PICKING_MODE_2;
                }
                if (ids != null && (k.inputSourcesConf.isDualFurniPickingMode() || this._roomEvents.wiredCtrl.hidePickFurniInstructions))
                {
                    text += " [" + ids.length + "/" + k.maximumItemSelectionCount + "]";
                }
            }
            this._buttonsDisabled = custom;
            this._selectedText = text;
            this._disabled = _arg_2.isInputSourceDisabled(this._id, this._sourceType);
        }

        private function currentAllowedSources():Array
        {
            var conf:InputSourcesConf = this._definition.inputSourcesConf;
            if (this._sourceType == FURNI_SOURCE)
            {
                return conf.getAllowedFurniSources(this._id);
            }
            if (this._sourceType == USER_SOURCE)
            {
                return conf.getAllowedUserSources(this._id);
            }
            var merged:Array = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return [];
            }
            return this._element.getMergedType(this._id) == FURNI_SOURCE
                ? conf.getAllowedFurniSources(int(merged[0]))
                : conf.getAllowedUserSources(int(merged[1]));
        }

        private function currentSelectedValue():int
        {
            if (this._sourceType == FURNI_SOURCE)
            {
                return int(this._definition.furniSourceTypes[this._id]);
            }
            if (this._sourceType == USER_SOURCE)
            {
                return int(this._definition.userSourceTypes[this._id]);
            }
            var merged:Array = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return 0;
            }
            return this._element.getMergedType(this._id) == FURNI_SOURCE
                ? int(this._definition.furniSourceTypes[int(merged[0])])
                : int(this._definition.userSourceTypes[int(merged[1])]);
        }

        private function setCurrentSelectedValue(k:int):void
        {
            if (this._sourceType == FURNI_SOURCE)
            {
                this._definition.furniSourceTypes[this._id] = k;
                return;
            }
            if (this._sourceType == USER_SOURCE)
            {
                this._definition.userSourceTypes[this._id] = k;
                return;
            }
            var merged:Array = this._element.mergedSelections()[this._id];
            if (merged == null)
            {
                return;
            }
            if (this._element.getMergedType(this._id) == FURNI_SOURCE)
            {
                this._definition.furniSourceTypes[int(merged[0])] = k;
            }
            else
            {
                this._definition.userSourceTypes[int(merged[1])] = k;
            }
        }

        private function currentTypeName():String
        {
            if (this._sourceType == FURNI_SOURCE)
            {
                return "furni";
            }
            if (this._sourceType == USER_SOURCE)
            {
                return "users";
            }
            return getTypeNameForSource(this._element.getMergedType(this._id));
        }

        private function isCustomSource():Boolean
        {
            return this._sourceType == MERGED_SOURCE
                && this._element.getMergedType(this._id) != FURNI_SOURCE
                && this._element.getMergedType(this._id) != USER_SOURCE;
        }

        private static function firstOrZero(k:Array):int
        {
            return (k != null && k.length > 0) ? int(k[0]) : 0;
        }

        public function get sourceType():int { return this._sourceType; }
        public function get id():int { return this._id; }
        public function get selectedText():String { return this._selectedText; }
        public function get isButtonsDisabled():Boolean { return this._buttonsDisabled; }
        public function get stuffPickingSpecialMode():int { return this._stuffPickingSpecialMode; }
        public function get disabled():Boolean { return this._disabled; }
        public function get disposed():Boolean { return this._disposed; }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._roomEvents = null;
            this._definition = null;
            this._element = null;
            this._selectionCache = null;
            this._disposed = true;
        }
    }
}
