package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
{
 import com.sulake.core.communication.messages.IMessageDataWrapper; import com.sulake.core.communication.util.Byte;
 import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredMessageDataValidator;
 public class TradeRequirementNode { public static const TYPE_COIN:int=0;public static const TYPE_FURNI:int=1;private var _type:int;private var _amount:int;private var _itemType:ChestItemType;
  public function TradeRequirementNode(type:int,amount:int,itemType:ChestItemType=null){this._type=type;this._amount=amount;this._itemType=type==TYPE_FURNI?itemType:null;}
  public static function readFromMessage(data:IMessageDataWrapper):TradeRequirementNode{WiredMessageDataValidator.requireBytes(data,5,"TradeRequirementNode");var type:int=data.readByte();var amount:int=data.readInteger();return new TradeRequirementNode(type,amount,type==TYPE_FURNI?ChestItemType.readFromMessage(data):null);}
  public function get type():int{return _type;}public function get amount():int{return _amount;}public function get itemType():ChestItemType{return _itemType;}public function addToComposer(out:Array):void{out.push(new Byte(_type),_amount);if(_type==TYPE_FURNI)_itemType.addToComposer(out);}public function deepCopy():TradeRequirementNode{return new TradeRequirementNode(_type,_amount,_itemType);}
 }
}
