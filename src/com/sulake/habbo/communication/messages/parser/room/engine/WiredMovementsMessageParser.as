package com.sulake.habbo.communication.messages.parser.room.engine
{
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredUserMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredFurniMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredWallItemMovementData;
    import com.sulake.habbo.communication.messages.incoming.room.engine.WiredUserDirectionData;

    public class WiredMovementsMessageParser implements IMessageParser
    {
        private var _userMoves:Array;
        private var _furniMoves:Array;
        private var _wallItemMoves:Array;
        private var _userDirectionUpdates:Array;

        public function flush():Boolean
        {
            this._userMoves = [];
            this._furniMoves = [];
            this._wallItemMoves = [];
            this._userDirectionUpdates = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Boolean
        {
            var _local_3:int;
            this._userMoves = [];
            this._furniMoves = [];
            this._wallItemMoves = [];
            this._userDirectionUpdates = [];
            if (k == null)
            {
                return false;
            }
            var _local_2:int = k.readInteger();
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_3 = k.readInteger();
                switch (_local_3)
                {
                    case 0:
                        this._userMoves.push(this.parseUserMove(k));
                        break;
                    case 1:
                        this._furniMoves.push(this.parseFurniMove(k));
                        break;
                    case 2:
                        this._wallItemMoves.push(this.parseWallItemMove(k));
                        break;
                    case 3:
                        this._userDirectionUpdates.push(this.parseUserDirUpdate(k));
                        break;
                }
                _local_4++;
            }
            return true;
        }

        private function parseFurniMove(k:IMessageDataWrapper):WiredFurniMovementData
        {
            var _local_2:int = k.readInteger();
            var _local_3:int = k.readInteger();
            var _local_4:int = k.readInteger();
            var _local_5:int = k.readInteger();
            var _local_6:Number = Number(k.readString());
            var _local_7:Number = Number(k.readString());
            var _local_8:int = k.readInteger();
            var _local_9:int = k.readInteger();
            var _local_10:int = k.readInteger();
            var _local_11:Number = NaN;
            if (k.readBoolean())
            {
                _local_11 = k.readInteger();
            }
            var _local_12:Number = NaN;
            if (k.readBoolean())
            {
                _local_12 = k.readInteger();
            }
            return new WiredFurniMovementData(_local_8, new Vector3d(_local_2, _local_3, _local_6), new Vector3d(_local_4, _local_5, _local_7), _local_10, _local_9, _local_11, _local_12);
        }

        private function parseUserMove(k:IMessageDataWrapper):WiredUserMovementData
        {
            var _local_2:int = k.readInteger();
            var _local_3:int = k.readInteger();
            var _local_4:int = k.readInteger();
            var _local_5:int = k.readInteger();
            var _local_6:Number = Number(k.readString());
            var _local_7:Number = Number(k.readString());
            var _local_8:int = k.readInteger();
            var _local_9:int = k.readInteger();
            var _local_10:int = k.readInteger();
            var _local_11:int = k.readInteger();
            var _local_12:int = k.readInteger();
            var _local_13:Number = NaN;
            if (k.readBoolean())
            {
                _local_13 = k.readInteger();
            }
            return new WiredUserMovementData(_local_8, new Vector3d(_local_2, _local_3, _local_6), new Vector3d(_local_4, _local_5, _local_7), ((_local_9 == 0) ? "mv" : "sld"), _local_10, _local_11, _local_12, _local_13);
        }

        private function parseWallItemMove(k:IMessageDataWrapper):WiredWallItemMovementData
        {
            var _local_2:int = k.readInteger();
            var _local_3:Boolean = k.readBoolean();
            var _local_4:int = k.readInteger();
            var _local_5:int = k.readInteger();
            var _local_6:int = k.readInteger();
            var _local_7:int = k.readInteger();
            var _local_8:int = k.readInteger();
            var _local_9:int = k.readInteger();
            var _local_10:int = k.readInteger();
            var _local_11:int = k.readInteger();
            var _local_12:int = k.readInteger();
            return new WiredWallItemMovementData(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10, _local_11, _local_12);
        }

        private function parseUserDirUpdate(k:IMessageDataWrapper):WiredUserDirectionData
        {
            var _local_2:int = k.readInteger();
            var _local_3:int = k.readInteger();
            var _local_4:int = k.readInteger();
            return new WiredUserDirectionData(_local_2, _local_3, _local_4);
        }

        public function get userMoves():Array
        {
            return this._userMoves;
        }

        public function get furniMoves():Array
        {
            return this._furniMoves;
        }

        public function get wallItemMoves():Array
        {
            return this._wallItemMoves;
        }

        public function get userDirectionUpdates():Array
        {
            return this._userDirectionUpdates;
        }
    }
}
