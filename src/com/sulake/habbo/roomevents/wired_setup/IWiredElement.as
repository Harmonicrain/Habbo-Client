package com.sulake.habbo.roomevents.wired_setup
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /**
     * Wired 2.0 builder element contract (May §_-N2q§, trimmed for Phase 2).
     * Source-type / merged-selection / guild / custom-advanced methods are deferred
     * to their owning phases (4/6) and will extend this interface then.
     */
    public interface IWiredElement
    {
        function get code():int;
        function get negativeCode():int;
        function get inputMode():int;

        function setRoomEvents(_arg_1:HabboUserDefinedRoomEvents):void;
        function onInit(_arg_1:HabboUserDefinedRoomEvents):void;
        function get roomEvents():HabboUserDefinedRoomEvents;

        function onEditStart(_arg_1:Triggerable):void;
        function onEditInitialized():void;
        function onEditEnd():void;

        function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder):void;

        function readIntParamsFromForm():Array;
        function readVariableIdsFromForm():Array;
        function readFurniSourceTypesFromForm():Array;
        function readUserSourceTypesFromForm():Array;
        function readFurniIds2FromForm():Array;
        function readStringParamFromForm():String;

        function get hasStateSnapshot():Boolean;
        function get requiresFurniSelection():Boolean;
        function onGuildMemberships(_arg_1:Array):void;
        function validate():String; // null = valid
        function get requireConfirmation():Object;

        function get widthModifier():Number;
        function get allowScrolling():Boolean;
    }
}
