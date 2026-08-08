package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.common.SliderWindowControllerNew;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class SliderPreset extends WiredUIPreset
    {
        private var _container:IWindowContainer;
        private var _listPreset:SimpleListViewPreset;
        private var _sliderController:SliderWindowControllerNew;

        public function SliderPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:Number = 0, _arg_5:Number = 1, _arg_6:Number = 0)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = _arg_2.createLayout("container_view") as IWindowContainer;
            var _local_7:IWindowContainer = _arg_3.createSlider();
            this._sliderController = new SliderWindowControllerNew(_local_7, _arg_4, _arg_5, _arg_6);
            this._listPreset = _arg_2.createSimpleListView(false, [_arg_2.createIconButtonPreset("left", this._sliderController.moveSliderToLeft), wrapWindow(_local_7), _arg_2.createIconButtonPreset("right", this._sliderController.moveSliderToRight)], true);
            this._listPreset.spacing = _arg_3.LRContainerSpacing;
            this._container.addChild(this._listPreset.window);
            this._listPreset.window.x = _arg_3.LRContainerMargin;
            this._listPreset.window.y = _arg_3.LRContainerTopBottomPadding;
        }

        public function set value(_arg_1:int):void
        {
            this._sliderController.setValue(_arg_1);
        }

        public function get value():int
        {
            return this._sliderController.getValue();
        }

        public function addEventListener(_arg_1:String, _arg_2:Function):void
        {
            this._sliderController.addEventListener(_arg_1, _arg_2);
        }

        override public function get window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            this._container.width = _arg_1;
            this._listPreset.resizeToWidth(_arg_1 - (_style.LRContainerMargin * 2));
            this._container.height = (this._listPreset.window.height + (2 * _style.LRContainerTopBottomPadding));
        }

        override protected function get childPresets():Array
        {
            return [this._listPreset];
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._listPreset = null;
            this._sliderController.dispose();
            this._sliderController = null;
        }
    }
}
