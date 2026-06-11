package com.sulake.habbo.roomevents.wired_setup
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
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
