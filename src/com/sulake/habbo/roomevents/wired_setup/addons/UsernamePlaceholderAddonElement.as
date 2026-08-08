package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderTypeSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 14: username placeholder definition. */
    public class UsernamePlaceholderAddonElement extends DefaultElement
    {
        private var _name:PlaceholderNameSection;
        private var _type:PlaceholderTypeSection;

        override public function get code():int { return AddonCodes.USERNAME_PLACEHOLDER; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._name = manager.createPlaceholderNameSection(this.l("texts.placeholder_name"), "$");
            this._type = manager.createPlaceholderTypeSection("user");
            builder.addElements(this._name, this._type);
        }

        override public function onEditStart(definition:Triggerable):void
        {
            var text:Array = definition.stringData.split("\t");
            this._name.placeholderName = text.length > 0 ? String(text[0]) : "";
            this._type.isShowMultiple = definition.intData.length > 0 && int(definition.intData[0]) == 1;
            this._type.delimiter = text.length > 1 ? String(text[1]) : "";
        }

        override public function readIntParamsFromForm():Array
        {
            return [this._type.isShowMultiple ? 1 : 0];
        }
        override public function readStringParamFromForm():String
        {
            return this._type.isShowMultiple
                ? this._name.placeholderName + "\t" + this._type.delimiter : this._name.placeholderName;
        }
    }
}
