package com.sulake.core.window.components
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.WindowContext;
    import com.sulake.core.window.WindowController;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.iterators.ContainerIterator;
    import flash.geom.Rectangle;

    public class ShapeController extends WindowController implements IWindowContainer
    {
        public static const SHAPE_RECTANGLE:String = "rectangle";
        public static const SHAPE_ROUND_RECTANGLE:String = "round_rectangle";
        public static const SHAPE_ELLIPSE:String = "ellipse";
        public static const SHAPE_RHOMBUS:String = "rhombus";
        public static const SHAPES:Array = ["rectangle", "round_rectangle", "ellipse", "rhombus"];

        private var _constructed:Boolean = false;
        private var _shape:String = SHAPE_RECTANGLE;
        private var _radius:Number = 0;
        private var _strokeColor:uint = 0xFF000000;
        private var _strokeHsvShade:Number = 0;
        private var _strokeThickness:Number = 0;

        public function ShapeController(k:String, _arg_2:uint, _arg_3:uint, _arg_4:uint, _arg_5:WindowContext, _arg_6:Rectangle, _arg_7:IWindow, _arg_8:Function=null, _arg_9:Array=null, _arg_10:Array=null, _arg_11:uint=0)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _drawable = true;
            this._constructed = true;
        }

        public function get iterator():IIterator
        {
            return new ContainerIterator(this);
        }

        private function safeInvalidate():void
        {
            if (!this._constructed)
            {
                return;
            }
            invalidate();
        }

        public static function normalizeShape(value:String):String
        {
            return ((SHAPES.indexOf(value) >= 0) ? value : SHAPE_RECTANGLE);
        }

        public function get shape():String
        {
            return this._shape;
        }

        public function set shape(value:String):void
        {
            var normalized:String = normalizeShape(value);
            if (this._shape != normalized)
            {
                this._shape = normalized;
                this.safeInvalidate();
            }
        }

        public function get radius():Number
        {
            return this._radius;
        }

        public function set radius(value:Number):void
        {
            var normalized:Number = (isNaN(value) ? 0 : Math.max(0, value));
            if (this._radius != normalized)
            {
                this._radius = normalized;
                this.safeInvalidate();
            }
        }

        public function get strokeColor():uint
        {
            return this._strokeColor;
        }

        public function set strokeColor(value:uint):void
        {
            if (this._strokeColor != value)
            {
                this._strokeColor = value;
                this.safeInvalidate();
            }
        }

        public function get strokeHsvShade():Number
        {
            return this._strokeHsvShade;
        }

        public function set strokeHsvShade(value:Number):void
        {
            var normalized:Number = (isNaN(value) ? 0 : value);
            if (this._strokeHsvShade != normalized)
            {
                this._strokeHsvShade = normalized;
                this.safeInvalidate();
            }
        }

        public function get strokeThickness():Number
        {
            return this._strokeThickness;
        }

        public function set strokeThickness(value:Number):void
        {
            var normalized:Number = (isNaN(value) ? 0 : Math.max(0, value));
            if (this._strokeThickness != normalized)
            {
                this._strokeThickness = normalized;
                this.safeInvalidate();
            }
        }

        override public function get properties():Array
        {
            var props:Array = super.properties;
            props.push(new PropertyStruct("shape", this._shape, PropertyStruct.STRING));
            props.push(new PropertyStruct("radius", this._radius, PropertyStruct.NUMBER));
            props.push(new PropertyStruct("stroke_color", this._strokeColor, PropertyStruct.UINT));
            props.push(new PropertyStruct("stroke_hsv_shade", this._strokeHsvShade, PropertyStruct.NUMBER));
            props.push(new PropertyStruct("stroke_thickness", this._strokeThickness, PropertyStruct.NUMBER));
            return props;
        }

        override public function set properties(k:Array):void
        {
            var stringValue:String;
            var numberValue:Number;
            var uintValue:uint;
            var changed:Boolean;
            for each (var prop:PropertyStruct in k)
            {
                switch (prop.key)
                {
                    case "shape":
                        stringValue = normalizeShape(String(prop.value));
                        if (this._shape != stringValue)
                        {
                            this._shape = stringValue;
                            changed = true;
                        }
                        break;
                    case "radius":
                        numberValue = Number(prop.value);
                        numberValue = (isNaN(numberValue) ? 0 : Math.max(0, numberValue));
                        if (this._radius != numberValue)
                        {
                            this._radius = numberValue;
                            changed = true;
                        }
                        break;
                    case "stroke_color":
                        uintValue = uint(prop.value);
                        if (this._strokeColor != uintValue)
                        {
                            this._strokeColor = uintValue;
                            changed = true;
                        }
                        break;
                    case "stroke_hsv_shade":
                        numberValue = Number(prop.value);
                        numberValue = (isNaN(numberValue) ? 0 : numberValue);
                        if (this._strokeHsvShade != numberValue)
                        {
                            this._strokeHsvShade = numberValue;
                            changed = true;
                        }
                        break;
                    case "stroke_thickness":
                        numberValue = Number(prop.value);
                        numberValue = (isNaN(numberValue) ? 0 : Math.max(0, numberValue));
                        if (this._strokeThickness != numberValue)
                        {
                            this._strokeThickness = numberValue;
                            changed = true;
                        }
                        break;
                }
            }
            if (changed)
            {
                this.safeInvalidate();
            }
            super.properties = k;
        }
    }
}
