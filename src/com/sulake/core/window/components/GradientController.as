package com.sulake.core.window.components
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.PropertyStruct;
    import flash.geom.Rectangle;

    public class GradientController extends WindowController
    {
        public static const MODE_LINEAR:String = "linear";
        public static const MODE_RADIAL:String = "radial";
        public static const DIRECTION_UP:String = "up";
        public static const DIRECTION_DOWN:String = "down";
        public static const DIRECTION_LEFT:String = "left";
        public static const DIRECTION_RIGHT:String = "right";
        public static const DIRECTION_UP_LEFT:String = "up_left";
        public static const DIRECTION_UP_RIGHT:String = "up_right";
        public static const DIRECTION_DOWN_LEFT:String = "down_left";
        public static const DIRECTION_DOWN_RIGHT:String = "down_right";

        private static const DEFAULT_COLOR1:uint = 0xFFFFFFFF;
        private static const DEFAULT_COLOR2:uint = 0xFF000000;
        private static const DEFAULT_MODE:String = MODE_LINEAR;
        private static const DEFAULT_DIRECTION:String = DIRECTION_DOWN;

        public static const MODES:Array = [MODE_LINEAR, MODE_RADIAL];
        public static const DIRECTIONS:Array = [DIRECTION_UP, DIRECTION_DOWN, DIRECTION_LEFT, DIRECTION_RIGHT, DIRECTION_UP_LEFT, DIRECTION_UP_RIGHT, DIRECTION_DOWN_LEFT, DIRECTION_DOWN_RIGHT];

        private var _color1:uint = DEFAULT_COLOR1;
        private var _color2:uint = DEFAULT_COLOR2;
        private var _mode:String = DEFAULT_MODE;
        private var _direction:String = DEFAULT_DIRECTION;

        public function GradientController(k:String, type:uint, style:uint, param:uint, context:WindowContext, rectangle:Rectangle, parent:IWindow, procedure:Function = null, properties:Array = null, tags:Array = null, id:uint = 0)
        {
            super(k, type, style, param, context, rectangle, parent, procedure, properties, tags, id);
        }

        public static function normalizeMode(value:String):String
        {
            return value == MODE_RADIAL ? MODE_RADIAL : MODE_LINEAR;
        }

        public static function normalizeDirection(value:String):String
        {
            return DIRECTIONS.indexOf(value) >= 0 ? value : DEFAULT_DIRECTION;
        }

        public function get color1():uint
        {
            return this._color1;
        }

        public function set color1(value:uint):void
        {
            if (this._color1 != value)
            {
                this._color1 = value;
                invalidate();
            }
        }

        public function get color2():uint
        {
            return this._color2;
        }

        public function set color2(value:uint):void
        {
            if (this._color2 != value)
            {
                this._color2 = value;
                invalidate();
            }
        }

        public function get mode():String
        {
            return this._mode;
        }

        public function set mode(value:String):void
        {
            var normalized:String = normalizeMode(value);
            if (this._mode != normalized)
            {
                this._mode = normalized;
                invalidate();
            }
        }

        public function get direction():String
        {
            return this._direction;
        }

        public function set direction(value:String):void
        {
            var normalized:String = normalizeDirection(value);
            if (this._direction != normalized)
            {
                this._direction = normalized;
                invalidate();
            }
        }

        override public function get properties():Array
        {
            var props:Array = super.properties;
            props.push(createProperty("color1", this._color1));
            props.push(createProperty("color2", this._color2));
            props.push(createProperty("mode", this._mode));
            props.push(new PropertyStruct("direction", this._direction, PropertyStruct.STRING, this._direction != DEFAULT_DIRECTION, DIRECTIONS));
            return props;
        }

        override public function set properties(k:Array):void
        {
            var changed:Boolean = false;
            var stringValue:String;
            for each (var prop:PropertyStruct in k)
            {
                switch (prop.key)
                {
                    case "color1":
                        if (this._color1 != uint(prop.value))
                        {
                            this._color1 = uint(prop.value);
                            changed = true;
                        }
                        break;
                    case "color2":
                        if (this._color2 != uint(prop.value))
                        {
                            this._color2 = uint(prop.value);
                            changed = true;
                        }
                        break;
                    case "mode":
                        stringValue = normalizeMode(String(prop.value));
                        if (this._mode != stringValue)
                        {
                            this._mode = stringValue;
                            changed = true;
                        }
                        break;
                    case "direction":
                        stringValue = normalizeDirection(String(prop.value));
                        if (this._direction != stringValue)
                        {
                            this._direction = stringValue;
                            changed = true;
                        }
                        break;
                }
            }
            if (changed)
            {
                invalidate();
            }
            super.properties = k;
        }
    }
}
