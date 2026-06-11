package com.sulake.habbo.roomevents.wired_setup
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Base wired 2.0 builder element (May DefaultElement, trimmed for Phase 2).
     * Provides safe defaults; concrete element types override code/inputMode/buildInputs
     * and the read*FromForm accessors.
     */
    public class DefaultElement implements IWiredElement
    {
        public static var INPUTS_TYPE_NONE:int = 0;
        public static var INPUTS_TYPE_UI_BUILDER:int = 1;

        protected var _roomEvents:HabboUserDefinedRoomEvents;
        private var _initialized:Boolean = false;

        public function DefaultElement()
        {
            super();
        }

        public function get code():int
        {
            return -1;
        }

        public function get negativeCode():int
        {
            return -1;
        }

        public function get inputMode():int
        {
            return INPUTS_TYPE_NONE;
        }

        public function get hasStateSnapshot():Boolean
        {
            return false;
        }

        public function get requiresFurniSelection():Boolean
        {
            return false;
        }

        public function get forceFurniSelection():Boolean
        {
            return this.hasStateSnapshot;
        }

        public function get forceHidePickFurniInstructions():Boolean
        {
            return false;
        }

        public function furniSelectionTitle(_arg_1:int):String
        {
            return "wiredfurni.params.sources.furni.title";
        }

        public function userSelectionTitle(_arg_1:int):String
        {
            return "wiredfurni.params.sources.users.title";
        }

        public function mergedSelections():Array
        {
            return [];
        }

        public function mergedSelectionTitle(_arg_1:int):String
        {
            return "wiredfurni.params.sources.merged.title";
        }

        public function setMergedType(_arg_1:int, _arg_2:int):void
        {
        }

        public function getMergedType(_arg_1:int):int
        {
            return WiredInputSourcePicker.FURNI_SOURCE;
        }

        public function isInputSourceDisabled(_arg_1:int, _arg_2:int):Boolean
        {
            return false;
        }

        public function getCustomSourcesForMergedType(_arg_1:int):Array
        {
            return [];
        }

        public function advancedAlwaysVisible():Boolean
        {
            return false;
        }

        public function get usingCustomAdvancedSettings():Boolean
        {
            return false;
        }

        public function mergedSourceOptions(_arg_1:int):Array
        {
            var result:Array = [WiredInputSourcePicker.FURNI_SOURCE, WiredInputSourcePicker.USER_SOURCE];
            for each (var source:int in this.getCustomSourcesForMergedType(_arg_1))
            {
                result.push(source);
            }
            return result;
        }

        public function hasCustomTypePicker(_arg_1:int):Boolean
        {
            return false;
        }

        protected function createSourceTypeListener(_arg_1:int):ISourceTypeListener
        {
            return new WrappedSourceTypeListener(this, _arg_1);
        }

        public function onGuildMemberships(_arg_1:Array):void
        {
        }

        public function readIntParamsFromForm():Array
        {
            return [];
        }

        public function readVariableIdsFromForm():Array
        {
            return null;
        }

        public function readFurniSourceTypesFromForm():Array
        {
            return null;
        }

        public function readUserSourceTypesFromForm():Array
        {
            return null;
        }

        public function readFurniIds2FromForm():Array
        {
            return null;
        }

        public function readStringParamFromForm():String
        {
            return "";
        }

        public function setRoomEvents(_arg_1:HabboUserDefinedRoomEvents):void
        {
            this._roomEvents = _arg_1;
        }

        public function onInit(_arg_1:HabboUserDefinedRoomEvents):void
        {
            this._roomEvents = _arg_1;
            this._initialized = true;
        }

        public function onEditStart(_arg_1:Triggerable):void
        {
        }

        public function onEditInitialized():void
        {
        }

        public function onEditEnd():void
        {
        }

        public function validate():String
        {
            return null;
        }

        public function get requireConfirmation():Object
        {
            return null;
        }

        public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void
        {
        }

        public function get roomEvents():HabboUserDefinedRoomEvents
        {
            return this._roomEvents;
        }

        protected function loc(_arg_1:String):String
        {
            return this._roomEvents.localization.getLocalization(_arg_1, _arg_1);
        }

        protected function l(_arg_1:String):String
        {
            return "${wiredfurni.params." + _arg_1 + "}";
        }

        public function get widthModifier():Number
        {
            return 1;
        }

        public function get allowScrolling():Boolean
        {
            return false;
        }
    }
}
