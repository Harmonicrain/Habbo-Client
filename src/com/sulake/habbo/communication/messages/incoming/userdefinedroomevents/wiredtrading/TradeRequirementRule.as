package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
 import com.sulake.core.communication.messages.IMessageDataWrapper;
 public class TradeRequirementRule { private static const MAX_NODES:int=256;private var _nodes:Vector.<TradeRequirementNode>;public function TradeRequirementRule(nodes:Vector.<TradeRequirementNode>){_nodes=nodes;}
  public static function readFromMessage(data:IMessageDataWrapper):TradeRequirementRule{var count:int=WiredMessageDataValidator.readCount(data,4,MAX_NODES,"TradeRequirementRule nodes");var nodes:Vector.<TradeRequirementNode>=new Vector.<TradeRequirementNode>();for(var i:int=0;i<count;i++)nodes.push(TradeRequirementNode.readFromMessage(data));return new TradeRequirementRule(nodes);}public function get nodes():Vector.<TradeRequirementNode>{return _nodes;}public function addToComposer(out:Array):void{out.push(_nodes.length);for each(var n:TradeRequirementNode in _nodes)n.addToComposer(out);}public function deepCopy():TradeRequirementRule{var nodes:Vector.<TradeRequirementNode>=new Vector.<TradeRequirementNode>();for each(var n:TradeRequirementNode in _nodes)nodes.push(n.deepCopy());return new TradeRequirementRule(nodes);}
 }
}
