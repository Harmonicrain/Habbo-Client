package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ResetRewardTrackActionElement extends DefaultElement
    {
        private var _trackId:NamedTextInputPreset;

        override public function get code():int { return ActionTypeCodes.RESET_REWARD_TRACK; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._trackId = manager.createNamedTextInput(
                new TextInputParam("", 100, null, -1, "^\t"),
                "${wiredfurni.params.reward_track.track_id}");
            builder.addElements(manager.createSection(
                "${wiredfurni.params.reward_track.reset.track}", this._trackId));
        }

        override public function onEditStart(data:Triggerable):void
        {
            this._trackId.text = data.stringData;
        }
        override public function readStringParamFromForm():String { return this._trackId.text; }
        override public function advancedAlwaysVisible():Boolean { return true; }
        override public function get forceHidePickFurniInstructions():Boolean { return true; }
    }
}
