package com.sulake.habbo.roomevents.wired_setup.inputsources.newpicker
{
    import com.sulake.core.utils.Map;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypePicker;

    public class NewSourceTypePicker implements ISourceTypePicker
    {
        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _container:IItemListWindow;
        private var _listener:ISourceTypeListener;
        private var _options:Map = new Map();
        private var _splitters:Vector.<IWindowContainer> = new Vector.<IWindowContainer>();
        private var _selected:NewSourceTypeOption;
        private var _leftTemplate:IContainerButtonWindow;
        private var _middleTemplate:IContainerButtonWindow;
        private var _rightTemplate:IContainerButtonWindow;
        private var _splitterTemplate:IWindowContainer;
        private var _splitterBaseColor:uint;
        private var _initializing:Boolean = false;
        private var _disposed:Boolean = false;

        public function NewSourceTypePicker(k:HabboUserDefinedRoomEvents, _arg_2:IItemListWindow, _arg_3:ISourceTypeListener)
        {
            super();
            this._roomEvents = k;
            this._container = _arg_2;
            this._listener = _arg_3;
            this._leftTemplate = _arg_2.getListItemAt(0) as IContainerButtonWindow;
            this._splitterTemplate = _arg_2.getListItemAt(1) as IWindowContainer;
            this._splitterBaseColor = this._splitterTemplate.getChildAt(0).color & 0xFFFFFF;
            this._middleTemplate = _arg_2.getListItemAt(2) as IContainerButtonWindow;
            this._rightTemplate = _arg_2.getListItemAt(4) as IContainerButtonWindow;
            _arg_2.removeListItems();
        }

        public function initialize(k:Array, _arg_2:int):void
        {
            var index:int;
            var optionId:int;
            var button:IContainerButtonWindow;
            var splitter:IWindowContainer;
            this._initializing = true;
            if (this._selected != null)
            {
                this._selected.deactivate();
                this._selected = null;
            }
            this.clear();
            this._options = new Map();
            this._splitters = new Vector.<IWindowContainer>();
            for (index = 0; index < k.length; index++)
            {
                optionId = int(k[index]);
                if (index == 0)
                {
                    button = this._leftTemplate.clone() as IContainerButtonWindow;
                }
                else if (index == k.length - 1)
                {
                    button = this._rightTemplate.clone() as IContainerButtonWindow;
                }
                else
                {
                    button = this._middleTemplate.clone() as IContainerButtonWindow;
                }
                var option:NewSourceTypeOption = new NewSourceTypeOption(this, button, optionId);
                this._options.add(optionId, option);
                this._container.addListItem(option.container);
                if (optionId == _arg_2)
                {
                    this._selected = option;
                }
                if (index != k.length - 1)
                {
                    splitter = this._splitterTemplate.clone() as IWindowContainer;
                    this._container.addListItem(splitter);
                    this._splitters.push(splitter);
                }
            }
            if (this._selected != null)
            {
                this._selected.activate();
            }
            else if (k.length > 0)
            {
                this.onClick(this._options.getValue(k[0]));
            }
            this._initializing = false;
            this.updateColorings();
        }

        public function select(k:int):void
        {
            for each (var option:NewSourceTypeOption in this._options.getValues())
            {
                if (k == option.option)
                {
                    this.onClick(option);
                    return;
                }
            }
        }

        internal function onClick(k:NewSourceTypeOption):void
        {
            if (k == this._selected)
            {
                return;
            }
            if (this._selected != null)
            {
                this._selected.deactivate();
            }
            this._selected = k;
            if (this._selected != null)
            {
                this._selected.activate();
                if (this._listener != null)
                {
                    this._listener.sourceType = this._selected.option;
                }
            }
        }

        internal function updateColorings():void
        {
            if (this._initializing)
            {
                return;
            }
            for (var index:int = 0; index < this._splitters.length; index++)
            {
                var left:NewSourceTypeOption = this._options.getWithIndex(index) as NewSourceTypeOption;
                var right:NewSourceTypeOption = this._options.getWithIndex(index + 1) as NewSourceTypeOption;
                var color:uint = 0xFFFFFF;
                if (left.active || (!right.active && left.hovered))
                {
                    color = left.color;
                }
                else if (right.active || right.hovered)
                {
                    color = right.color;
                }
                var splitter:IWindowContainer = this._splitters[index];
                splitter.getChildAt(0).color = (splitter.getChildAt(0).color & 0xFF000000) | multiplyColors(this._splitterBaseColor, color);
            }
        }

        private static function multiplyColors(k:uint, _arg_2:uint):uint
        {
            var r:uint = ((k >> 16) & 0xFF) * ((_arg_2 >> 16) & 0xFF) / 255;
            var g:uint = ((k >> 8) & 0xFF) * ((_arg_2 >> 8) & 0xFF) / 255;
            var b:uint = (k & 0xFF) * (_arg_2 & 0xFF) / 255;
            return (r << 16) | (g << 8) | b;
        }

        private function clear():void
        {
            this._container.removeListItems();
            for each (var option:NewSourceTypeOption in this._options.getValues())
            {
                option.dispose();
            }
            for each (var splitter:IWindowContainer in this._splitters)
            {
                splitter.dispose();
            }
        }

        public function get roomEvents():HabboUserDefinedRoomEvents { return this._roomEvents; }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.clear();
            this._container.dispose();
            this._container = null;
            this._leftTemplate.dispose();
            this._leftTemplate = null;
            this._middleTemplate.dispose();
            this._middleTemplate = null;
            this._rightTemplate.dispose();
            this._rightTemplate = null;
            this._splitterTemplate.dispose();
            this._splitterTemplate = null;
            this._options.dispose();
            this._options = null;
            this._splitters = null;
            this._selected = null;
            this._listener = null;
            this._roomEvents = null;
            this._disposed = true;
        }
    }
}
