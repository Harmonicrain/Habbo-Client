package com.sulake.habbo.roomevents.wired_setup.addons
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.applications.SubVariableParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.StaticBitmapAssetWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.SubVariableCreatorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedDropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Exact July AIR add-on 21 editor contract, adapted to clean-client names. */
    public class ProjectileAddonElement extends DefaultElement
    {
        private var _newDirection:CheckboxGroupPreset;
        private var _directionalSystem:NamedDropdownPreset;
        private var _directionImage:StaticBitmapAssetWrapperPreset;
        private var _shooterDirection:CheckboxGroupPreset;
        private var _bunnyHop:CheckboxGroupPreset;
        private var _trajectory:RadioGroupPreset;
        private var _curveStrength:NamedNumberInputPreset;
        private var _distanceMode:RadioGroupPreset;
        private var _distance:ValueOrVariableSection;
        private var _customTime:CheckboxGroupPreset;
        private var _time:ValueOrVariableSection;
        private var _axes:CheckboxGroupPreset;
        private var _speedIncrease:NamedNumberInputPreset;
        private var _rotationOffset:SliderSection;
        private var _internalVariables:SubVariableCreatorPreset;

        override public function get code():int { return AddonCodes.PROJECTILE; }
        override public function get inputMode():int { return INPUTS_TYPE_UI_BUILDER; }
        override public function get requiredCapability():int { return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC; }

        override public function buildInputs(m:PresetManager, style:WiredStyle, builder:WiredUIBuilder):void
        {
            _directionalSystem = m.createNamedDropdown(new DropdownParam(l("projectile.directional_system"), Vector.<ExpandableDropdownOption>([
                new ExpandableDropdownOption(0,l("projectile.directional_system.0")), new ExpandableDropdownOption(1,l("projectile.directional_system.1")),
                new ExpandableDropdownOption(2,l("projectile.directional_system.2")), new ExpandableDropdownOption(3,l("projectile.directional_system.3"))
            ]), onDirectionalSystemChange),l("projectile.directional_system"));
            _directionImage = m.createBitmapWrapperPreset("wired_misc_directional_system_1_png");
            _bunnyHop = m.createCheckboxGroup([new CheckboxOptionParam(l("projectile.bunny_hop"))]);
            _shooterDirection = m.createCheckboxGroup([new CheckboxOptionParam(l("projectile.change_shooter_direction"),0,null,_bunnyHop)],onShooterDirectionChanged);
            var directionDetails:SimpleListViewPreset=m.createSimpleListView(true,[_directionalSystem,_directionImage.alignCenter(),_shooterDirection]); directionDetails.spacing=10;
            var directionOption:CheckboxOptionParam=new CheckboxOptionParam(l("projectile.new_direction_enabled")); directionOption.extra2=directionDetails;
            _newDirection=m.createCheckboxGroup([directionOption],onNewDirectionChanged);
            var directionSection:SectionPreset=m.createSection(l("projectile.direction"),_newDirection,SectionParam.DEFAULT);

            _curveStrength=m.createNamedNumberInput(new NumberInputParam(0,-1000,1000),l("projectile.animation_trajectory.trajectory.1.extra"));
            var infoParam:TextParam=new TextParam(1); infoParam.textColor=style.softTextColor;
            var straightInfo:TextPreset=m.createText(l("projectile.animation_trajectory.trajectory.0.info"),infoParam);
            _trajectory=m.createRadioGroup([new RadioButtonParam(0,l("projectile.animation_trajectory.trajectory.0"),null,straightInfo),new RadioButtonParam(1,l("projectile.animation_trajectory.trajectory.1"),null,_curveStrength)]);
            _distanceMode=m.createRadioGroup([new RadioButtonParam(0,l("projectile.animation_trajectory.distance.0")),new RadioButtonParam(1,l("projectile.animation_trajectory.distance.1")),new RadioButtonParam(2,l("projectile.animation_trajectory.distance.2"))],onDistanceModeChanged);
            _distance=m.createValueOrVariableSection(1,mergedSourceOptions(1),l("projectile.animation_trajectory.distance_selection"),-64,64);
            var trajectoryList:SimpleListViewPreset=m.createSimpleListView(true,[m.createSection(l("projectile.animation_trajectory.trajectory"),_trajectory),m.createSection(l("projectile.animation_trajectory.distance"),_distanceMode),_distance]);
            var trajectorySection:SectionPreset=m.createSection(l("projectile.animation_trajectory"),trajectoryList,SectionParam.COLLAPSED);

            _time=m.createValueOrVariableSection(0,mergedSourceOptions(0),l("projectile.time_per_tile"),1,100000);
            _axes=m.createCheckboxGroup([new CheckboxOptionParam(l("projectile.distance_x"),0),new CheckboxOptionParam(l("projectile.distance_y"),1),new CheckboxOptionParam(l("projectile.distance_z"),2)]);
            _speedIncrease=m.createNamedNumberInput(new NumberInputParam(0,0,100000),l("projectile.increase_speed"));
            var timeDetails:SimpleListViewPreset=m.createSimpleListView(true,[_time,m.createSection(l("projectile.distance_options"),_axes),m.createSection(l("projectile.increase_speed.title"),_speedIncrease)]);
            var timeOption:CheckboxOptionParam=new CheckboxOptionParam(l("projectile.override_animation_time")); timeOption.extra2=timeDetails;
            _customTime=m.createCheckboxGroup([timeOption],onCustomTimeChanged);
            var timeSection:SectionPreset=m.createSection(l("projectile.animation_time"),_customTime,SectionParam.COLLAPSED);
            _rotationOffset=m.createSliderSection("wiredfurni.params.projectile.rotation_offset","offset",SliderSection.CONVERTER_ECHO,0,7,1,false,SectionParam.COLLAPSED);
            _internalVariables=m.createSubVariableCreator("wiredfurni.params.projectile.variable.",[
                new SubVariableParam(0,"animation.tiles_travelled",true),new SubVariableParam(1,"animation.user_collisions",true),new SubVariableParam(2,"animation.furni_collisions",true),
                new SubVariableParam(3,"animation.position.x"),new SubVariableParam(4,"animation.position.y"),new SubVariableParam(5,"animation.position.altitude"),new SubVariableParam(6,"animation.is_travelling",true)
            ]);
            builder.addElements(m.createUsageInfoSection(l("projectile.usage_info")),directionSection,trajectorySection,timeSection,_rotationOffset,m.createSection(l("projectile.projectile.variables"),_internalVariables,SectionParam.COLLAPSED),m.createWrapperPreset(style.createSplitterView()));
        }

        private function onDirectionalSystemChange(o:ExpandableDropdownOption):void { setDirectionalSystem(o.id); }
        private function setDirectionalSystem(id:int):void { _directionImage.assetUri="wired_misc_directional_system_"+id+"_png"; roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.USER_SOURCE,1); }
        private function onNewDirectionChanged(i:int,v:Boolean):void { _rotationOffset.disabled=!v; roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.USER_SOURCE,1); }
        private function onCustomTimeChanged(i:int,v:Boolean):void { roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE,0); }
        private function onDistanceModeChanged(i:int):void { _distance.disabled=i==0; roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE,1); }
        private function onShooterDirectionChanged(i:int,v:Boolean):void { roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.USER_SOURCE,1); }

        override public function onEditStart(d:Triggerable):void
        {
            var a:Array=d.intData; function n(i:int,def:int=0):int{return a.length>i?int(a[i]):def;}
            _newDirection.get(0).selected=n(0)==1; _directionalSystem.selectedId=n(1); _customTime.get(0).selected=n(2)==1;
            _time.init(d.wiredContext.roomVariablesList,d.variableIds[0],n(5),n(3),n(4));
            _axes.get(0).selected=n(6)==1; _axes.get(1).selected=n(7)==1; _axes.get(2).selected=n(8)==1; _speedIncrease.value=n(9); _rotationOffset.value=n(10); _internalVariables.mask=n(11);
            _shooterDirection.get(0).selected=n(12)==1; _bunnyHop.get(0).selected=n(13)==1; _distanceMode.selected=n(14);
            _distance.init(d.wiredContext.roomVariablesList,d.variableIds[1],n(17),n(15),n(16)); _trajectory.selected=n(18)==0?0:1; _curveStrength.value=n(18);
            onNewDirectionChanged(0,n(0)==1); setDirectionalSystem(n(1)); onDistanceModeChanged(n(14));
        }
        override public function onEditInitialized():void { _time.onEditInitialized(); }
        override public function readIntParamsFromForm():Array { return [_newDirection.get(0).selected?1:0,_directionalSystem.selectedId,_customTime.get(0).selected?1:0,_time.option,_time.numberValue,_time.target,_axes.get(0).selected?1:0,_axes.get(1).selected?1:0,_axes.get(2).selected?1:0,_speedIncrease.value,_rotationOffset.value,_internalVariables.mask,_shooterDirection.get(0).selected?1:0,_bunnyHop.get(0).selected?1:0,_distanceMode.selected,_distance.option,_distance.numberValue,_distance.target,_trajectory.selected==1?_curveStrength.value:0]; }
        override public function readVariableIdsFromForm():Array { return [_time.finalizeSelection,_distance.finalizeSelection]; }
        override public function furniSelectionTitle(i:int):String { return "wiredfurni.params.sources.furni.title.projectile"; }
        override public function userSelectionTitle(i:int):String { return "wiredfurni.params.sources.users.title.shooter"; }
        override public function mergedSelectionTitle(i:int):String { return i==0?"wiredfurni.params.sources.merged.title.variable_time_per_tile":"wiredfurni.params.sources.merged.title.variable_animation_distance"; }
        override public function isInputSourceDisabled(i:int,type:int):Boolean { if(type==WiredInputSourcePicker.MERGED_SOURCE)return i==0?(!_customTime.get(0).selected||_time.isSourcePickingDisabled()):(_distanceMode.selected==0||_distance.isSourcePickingDisabled()); if(type==WiredInputSourcePicker.USER_SOURCE)return !_shooterDirection.get(0).selected||!_newDirection.get(0).selected; return false; }
        override public function mergedSelections():Array{return [[1,0],[2,2]];} override public function setMergedType(i:int,v:int):void{if(i==0)_time.target=v;else _distance.target=v;} override public function getMergedType(i:int):int{return i==0?_time.target:_distance.target;}
        override public function getCustomSourcesForMergedType(i:int):Array{return [VariableExtraSourceTypes.GLOBAL_SOURCE,VariableExtraSourceTypes.CONTEXT_SOURCE];} override public function hasCustomTypePicker(i:int):Boolean{return true;}
        override public function get forceHidePickFurniInstructions():Boolean{return true;} override public function get widthModifier():Number{return 1.3;} override public function get allowScrolling():Boolean{return false;}
    }
}
