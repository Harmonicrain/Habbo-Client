package com.sulake.habbo.roomevents.wired_setup.common.utils
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class SpiralUtils
    {
        public static function parseSpiralVector(values:Array, radius:int):Array
        {
            var mask:Array = intParamsToBoolMask(values);
            var dimension:int = radius * 2 + 1;
            var floor:Array = [];
            for (var x:int = 0; x < dimension; x++)
            {
                floor[x] = [];
                for (var y:int = 0; y < dimension; y++) floor[x][y] = false;
            }
            for each (var cell:Object in walkSpiral(radius))
            {
                if (cell.rank < mask.length && mask[cell.rank])
                {
                    floor[cell.x + radius][cell.y + radius] = true;
                }
            }
            return floor;
        }

        public static function createSpiralVector(floor:Array, radius:int):Array
        {
            var dimension:int = radius * 2 + 1;
            var mask:Array = [];
            for (var i:int = 0; i < dimension * dimension; i++) mask.push(false);
            for each (var cell:Object in walkSpiral(radius))
            {
                if (floor[cell.x + radius][cell.y + radius]) mask[cell.rank] = true;
            }
            return boolMaskToIntParams(mask);
        }

        private static function walkSpiral(radius:int):Array
        {
            var dimension:int = radius * 2 + 1;
            var count:int = dimension * dimension;
            var result:Array = [];
            var rank:int = 0;
            var x:int = 0;
            var y:int = 0;
            var direction:Array = [1, 0];
            for (var runLength:int = 1; runLength <= dimension; runLength++)
            {
                for (var turn:int = 0; turn < 2; turn++)
                {
                    for (var step:int = 0; step < runLength; step++)
                    {
                        result.push({rank:rank, x:x, y:y});
                        x += direction[0];
                        y += direction[1];
                        rank++;
                        if (rank == count) return result;
                    }
                    direction = nextDirection(direction);
                }
            }
            return result;
        }

        private static function nextDirection(direction:Array):Array
        {
            if (direction[0] == 0 && direction[1] == -1) return [-1, 0];
            if (direction[0] == 1 && direction[1] == 0) return [0, -1];
            if (direction[0] == 0 && direction[1] == 1) return [1, 0];
            return [0, 1];
        }

        private static function intParamsToBoolMask(values:Array):Array
        {
            var bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            for each (var value:int in values) bytes.writeInt(value);
            bytes.position = 0;
            var result:Array = [];
            while (bytes.bytesAvailable)
            {
                var octet:int = bytes.readByte();
                for (var bit:int = 0; bit < 8; bit++) result.push((octet & (1 << bit)) > 0);
            }
            return result;
        }

        private static function boolMaskToIntParams(mask:Array):Array
        {
            var bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            var index:int = 0;
            while (index < mask.length)
            {
                for (var byteIndex:int = 0; byteIndex < 4; byteIndex++)
                {
                    var octet:int = 0;
                    for (var bit:int = 0; bit < 8; bit++)
                    {
                        if (index < mask.length && mask[index]) octet |= 1 << bit;
                        index++;
                    }
                    bytes.writeByte(octet);
                }
            }
            bytes.position = 0;
            var result:Array = [];
            while (bytes.bytesAvailable >= 4) result.push(bytes.readInt());
            return result;
        }
    }
}
