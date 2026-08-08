package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    /** July addon 1001 progression editor.  The existing server bitmask is preserved verbatim. */
    public class VariableLevelUpAddonElement extends DefaultElement
    {
        private var _mask:NumberInputPreset; private var _mode:RadioGroupPreset; private var _manual:TextAreaPreset;
        private var _linearStep:NumberInputPreset; private var _linearMax:NumberInputPreset; private var _base:NumberInputPreset; private var _factor:NumberInputPreset; private var _expMax:NumberInputPreset;
        override public function get code():int { return AddonCodes.VARIABLE_LEVEL_UP; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC; }
        override public function buildInputs(m:PresetManager,s:WiredStyle,b:WiredUIBuilder):void
        {
            this._mask=m.createNumberInput(new NumberInputParam(0,0,2147483647,80));
            this._manual=m.createTextArea(new TextAreaParam(60,-1,-1,30,1000,"",this.l("levelup.interpolation_placeholder"),"0123456789=\r"));
            this._linearStep=m.createNumberInput(new NumberInputParam(100,1,100000,50)); this._linearMax=m.createNumberInput(new NumberInputParam(50,2,100000,50));
            this._base=m.createNumberInput(new NumberInputParam(100,1,100000,50)); this._factor=m.createNumberInput(new NumberInputParam(20,1,100000,50)); this._expMax=m.createNumberInput(new NumberInputParam(50,2,100000,50));
            this._mode=m.createRadioGroup([new RadioButtonParam(1,this.l("levelup.mode.1")),new RadioButtonParam(2,this.l("levelup.mode.2")),new RadioButtonParam(0,this.l("levelup.mode.0"))]);
            b.addElements(m.createSection(this.l("create_subvariables"),this._mask),m.createSection(this.l("levelup.mode"),this._mode),m.createSection(this.l("levelup.interpolation_placeholder"),this._manual),m.createSection(this.l("levelup.step_size"),this._linearStep),m.createSection(this.l("levelup.max_level"),this._linearMax),m.createSection(this.l("levelup.first_level_xp"),this._base),m.createSection(this.l("levelup.increase_factor"),this._factor),m.createSection(this.l("levelup.max_level"),this._expMax));
        }
        override public function onEditStart(d:Triggerable):void { var v:Array=d.intData; var mode:int=v.length>1?int(v[1]):0; this._mask.value=v.length>0?int(v[0]):0; this._mode.selected=mode; this._manual.text=mode==0?d.stringData:""; this._linearStep.value=mode==1&&v.length>2?int(v[2]):100; this._linearMax.value=mode==1&&v.length>3?int(v[3]):50; this._base.value=mode==2&&v.length>2?int(v[2]):100; this._factor.value=mode==2&&v.length>3?int(v[3]):20; this._expMax.value=mode==2&&v.length>4?int(v[4]):50; }
        override public function readIntParamsFromForm():Array { var mode:int=this._mode.selected; var r:Array=[this._mask.value,mode]; if(mode==1) r.push(this._linearStep.value,this._linearMax.value); else if(mode==2) r.push(this._base.value,this._factor.value,this._expMax.value); return r; }
        override public function readStringParamFromForm():String { return this._mode.selected==0?this._manual.text:""; }
    }
}
