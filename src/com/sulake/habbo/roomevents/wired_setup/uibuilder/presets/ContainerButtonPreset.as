package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class ContainerButtonPreset extends PaddedContainerPreset
    {
        private var _onClick:Function;

        public function ContainerButtonPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:WiredUIPreset, _arg_5:Function, _arg_6:Boolean = true)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_3.containerButtonPaddingLeft, _arg_3.containerButtonPaddingTop, _arg_3.containerButtonPaddingLeft, _arg_3.containerButtonPaddingTop, _arg_3.createContainerButton(), _arg_6);
            this._onClick = _arg_5;
            this.button.addEventListener(WindowMouseEvent.CLICK, this.buttonClicked);
        }

        private function buttonClicked(_arg_1:WindowMouseEvent):void
        {
            if (this._onClick != null)
            {
                this._onClick();
            }
        }

        private function get button():IContainerButtonWindow
        {
            return _window as IContainerButtonWindow;
        }
    }
}
