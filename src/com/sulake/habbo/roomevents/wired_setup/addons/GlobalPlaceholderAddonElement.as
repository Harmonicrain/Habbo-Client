package com.sulake.habbo.roomevents.wired_setup.addons
{
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedGlobalPlaceholder;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.SharedGlobalPlaceholderList;
 import com.sulake.habbo.roomevents.WiredCapabilityCodes;
 import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
 import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedDropdownPreset;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderNameSection;
 import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
 /** July addon 2000 global-placeholder editor; context reference list is parsed by WiredContext. */
 public class GlobalPlaceholderAddonElement extends DefaultElement {
  private var _name:PlaceholderNameSection;private var _mode:RadioGroupPreset;private var _value:TextInputPreset;private var _rooms:NamedDropdownPreset;private var _placeholders:NamedDropdownPreset;private var _references:SharedGlobalPlaceholderList;
  override public function get code():int{return AddonCodes.GLOBAL_PLACEHOLDER;}override public function get inputMode():int{return INPUTS_TYPE_UI_BUILDER;}override public function get requiredCapability():int{return WiredCapabilityCodes.ADDONS|WiredCapabilityCodes.VARIABLES|WiredCapabilityCodes.VARIABLE_SYNC;}
  override public function buildInputs(m:PresetManager,s:WiredStyle,b:WiredUIBuilder):void{this._name=m.createPlaceholderNameSection(this.l("texts.placeholder_name"),"$");this._value=m.createTextInput(new TextInputParam("",100));this._rooms=m.createNamedDropdown(new DropdownParam(this.l("room_selection.tooltip"),null,this.onRoom),this.l("room_selection"));this._placeholders=m.createNamedDropdown(new DropdownParam(this.l("placeholder_selection.tooltip"),null),this.l("placeholder_selection"));this._mode=m.createRadioGroup([new RadioButtonParam(0,this.l("from_value"),null,this._value),new RadioButtonParam(1,this.l("from_another_room"),null,m.createSimpleListView(true,[this._rooms,this._placeholders]))]);b.addElements(this._name,m.createSection(this.l("choose_type"),this._mode));}
  override public function onEditStart(d:Triggerable):void{var p:Array=d.stringData.split("\t");var mode:int=d.intData.length>0?int(d.intData[0]):0;this._name.placeholderName=p.length>0?String(p[0]):"";this._references=d.wiredContext.referencePlaceholderList;this._mode.setOptionDisabled(1,this._references==null);this._mode.setOptionDisabled(0,this._references==null&&mode==1);this._mode.selected=mode;var rooms:Vector.<ExpandableDropdownOption>=this.roomOptions();this._rooms.reinit(rooms,d.intData.length>2?int(d.intData[2]):-1);if(mode==0)this._value.text=p.length>1?String(p[1]):"";else this.initPlaceholders(p.length>1?String(p[1]):null);}
  private function roomOptions():Vector.<ExpandableDropdownOption>{var out:Vector.<ExpandableDropdownOption>=new Vector.<ExpandableDropdownOption>();var seen:Object={};if(this._references!=null)for each(var x:SharedGlobalPlaceholder in this._references.sharedPlaceholders)if(!seen[x.roomId]){seen[x.roomId]=true;out.push(new ExpandableDropdownOption(x.roomId,x.roomName));}return out;}
  private function onRoom(x:ExpandableDropdownOption):void{this.initPlaceholders(null);} private function initPlaceholders(selected:String):void{var out:Vector.<ExpandableDropdownOption>=new Vector.<ExpandableDropdownOption>();var idx:int=-1;var room:int=this._rooms.selectedId;if(this._references!=null)for each(var x:SharedGlobalPlaceholder in this._references.sharedPlaceholders)if(x.roomId==room){if(x.placeholderName==selected)idx=out.length;out.push(new ExpandableDropdownOption(out.length,x.placeholderName));}this._placeholders.reinit(out,idx);}
  override public function readIntParamsFromForm():Array{return [this._mode.selected,0,this._mode.selected==0?0:this._rooms.selectedId];}override public function readStringParamFromForm():String{return this._name.placeholderName+"\t"+(this._mode.selected==0?this._value.text:(this._placeholders.selected==null?"":this._placeholders.selected.displayString));}
 }
}
