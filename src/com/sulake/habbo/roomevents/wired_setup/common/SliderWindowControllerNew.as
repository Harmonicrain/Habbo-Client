package com.sulake.habbo.roomevents.wired_setup.common
{
    import com.sulake.core.runtime.events.EventDispatcherWrapper;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.events.Event;

    /**
     * Builder slider controller (May SliderWindowControllerNew). Drives the
     * slider_button child inside a style-provided slider container.
     */
    public class SliderWindowControllerNew extends EventDispatcherWrapper
    {
        private var _value:Number = 0;
        private var _sliderContainer:IWindowContainer;
        private var _dragging:Boolean = false;
        private var _min:Number = 0;
        private var _max:Number = 1;
        private var _step:Number = 0;

        public function SliderWindowControllerNew(_arg_1:IWindowContainer, _arg_2:Number = 0, _arg_3:Number = 1, _arg_4:Number = 0)
        {
            super();
            this._sliderContainer = _arg_1;
            this._min = _arg_2;
            this._max = _arg_3;
            this._step = _arg_4;
            this._value = 0;
            this.sliderButton.procedure = this.sliderProcedure;
        }

        override public function dispose():void
        {
            super.dispose();
            this._sliderContainer.dispose();
            this._sliderContainer = null;
        }

        public function setValue(_arg_1:Number, _arg_2:Boolean = true, _arg_3:Boolean = true):void
        {
            _arg_1 = Math.max(this._min, _arg_1);
            _arg_1 = Math.min(this._max, _arg_1);
            this._value = _arg_1;
            if (_arg_2)
            {
                this.updateSliderPosition();
            }
            if (_arg_3)
            {
                dispatchEvent(new Event(Event.CHANGE));
            }
        }

        public function getValue():Number
        {
            return this._value;
        }

        public function set min(_arg_1:Number):void
        {
            this._min = _arg_1;
        }

        public function set max(_arg_1:Number):void
        {
            this._max = _arg_1;
        }

        private function updateSliderPosition():void
        {
            if (this._sliderContainer == null)
            {
                return;
            }
            var _local_1:IWindow = this._sliderContainer.findChildByName("slider_button");
            if (_local_1 != null)
            {
                _local_1.x = this.getSliderPosition(this._value);
                _local_1.parent.invalidate();
            }
        }

        private function getSliderPosition(_arg_1:Number):int
        {
            return int(this.referenceWidth * ((_arg_1 - this._min) / (this._max - this._min)));
        }

        private function getValueAtPosition(_arg_1:Number):Number
        {
            return (((_arg_1 / this.referenceWidth) * (this._max - this._min)) + this._min);
        }

        private function sliderProcedure(_arg_1:WindowEvent, _arg_2:IWindow):void
        {
            var _local_4:Number;
            var _local_3:Number;
            if (_arg_1.type == WindowMouseEvent.DOWN)
            {
                this._dragging = true;
            }
            if (this._dragging)
            {
                if ((_arg_1.type == WindowMouseEvent.UP) || (_arg_1.type == WindowMouseEvent.UP_OUTSIDE))
                {
                    this._dragging = false;
                }
            }
            if ((!this._dragging) || (_arg_1.type != WindowEvent.WINDOW_EVENT_RELOCATED))
            {
                return;
            }
            if (this._step != 0)
            {
                _local_4 = this.getValueAtPosition(_arg_2.x);
                _local_3 = (Math.round(_local_4 / this._step) * this._step);
                this.setValue(_local_3, false);
            }
        }

        public function moveSliderToRight():void
        {
            this._dragging = false;
            if (this._step != 0)
            {
                this.setValue(this._value + this._step);
            }
        }

        public function moveSliderToLeft():void
        {
            this._dragging = false;
            if (this._step != 0)
            {
                this.setValue(this._value - this._step);
            }
        }

        private function get referenceWidth():int
        {
            return (this.sliderMovementArea.width - this.sliderButton.width);
        }

        private function get sliderBase():IStaticBitmapWrapperWindow
        {
            return this._sliderContainer.findChildByName("slider_base") as IStaticBitmapWrapperWindow;
        }

        private function get sliderMovementArea():IWindowContainer
        {
            return this._sliderContainer.findChildByName("slider_movement_area") as IWindowContainer;
        }

        private function get sliderButton():IStaticBitmapWrapperWindow
        {
            return this._sliderContainer.findChildByName("slider_button") as IStaticBitmapWrapperWindow;
        }
    }
}
