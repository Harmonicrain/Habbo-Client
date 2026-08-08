package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
 import com.sulake.core.communication.messages.IMessageDataWrapper;
 public class TradeRequirementRulesDefinition { private static const MAX_RULES:int=64;private var _youGiveRule:Vector.<TradeRequirementRule>;private var _youGetRule:TradeRequirementRule;public function TradeRequirementRulesDefinition(give:Vector.<TradeRequirementRule>,get:TradeRequirementRule){_youGiveRule=give;_youGetRule=get;}
  public static function readFromMessage(data:IMessageDataWrapper):TradeRequirementRulesDefinition{var give:Vector.<TradeRequirementRule>;if(data.readBoolean()){var count:int=WiredMessageDataValidator.readCount(data,4,MAX_RULES,"TradeRequirementRulesDefinition give rules");give=new Vector.<TradeRequirementRule>();for(var i:int=0;i<count;i++)give.push(TradeRequirementRule.readFromMessage(data));}var get:TradeRequirementRule=data.readBoolean()?TradeRequirementRule.readFromMessage(data):null;return new TradeRequirementRulesDefinition(give,get);}public function get youGiveRule():Vector.<TradeRequirementRule>{return _youGiveRule;}public function get youGetRule():TradeRequirementRule{return _youGetRule;}public function addToComposer(out:Array):void{out.push(_youGiveRule!=null);if(_youGiveRule!=null){out.push(_youGiveRule.length);for each(var r:TradeRequirementRule in _youGiveRule)r.addToComposer(out);}out.push(_youGetRule!=null);if(_youGetRule!=null)_youGetRule.addToComposer(out);}
 }
}
