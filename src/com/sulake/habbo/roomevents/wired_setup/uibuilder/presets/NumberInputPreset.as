package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
{
    import com.sulake.core.runtime.exceptions.Exception;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class NumberInputPreset extends WiredUIPreset
    {
        private var _inputView:IWindow;
        private var _field:ITextFieldWindow;
        private var _param:NumberInputParam;
        private var _initialValue:int;
        private var _currentValue:int;
        private var _latestValidValueStr:String;
        private var _min:int;
        private var _max:int;
        private var _precision:int;
        private var _endsWithFive:Boolean;
        private var _fieldWidthDelta:int;
        private var _onValueChange:Function;
        private var _ignoreListeners:Boolean = false;

        public function NumberInputPreset(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:NumberInputParam)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._inputView = _arg_3.createTextInputView();
            this._field = (this._inputView as IWindowContainer).findChildByName("field") as ITextFieldWindow;
            this._param = _arg_4;
            this._fieldWidthDelta = (this._inputView.width - this._field.width);
            if (_arg_4.width >= 0)
            {
                this._inputView.width = (_arg_4.width + this._fieldWidthDelta);
            }
            this._field.restrict = ("0123456789" + ((_arg_4.min < 0) ? "\\-" : "") + ((_arg_4.precision > 0) ? ",." : "") + ((_arg_4.nonDecimalNotations) ? "xba-fA-F" : ""));
            this._endsWithFive = _arg_4.endsWithFive;
            this._min = (this._endsWithFive) ? (_arg_4.min * 5) : _arg_4.min;
            this._max = (this._endsWithFive) ? (_arg_4.max * 5) : _arg_4.max;
            this._precision = _arg_4.precision;
            if (_arg_4.tooltip != null)
            {
                this._field.toolTipCaption = _arg_4.tooltip;
            }
            this.setValue(_arg_4.initialValue);
            this._field.addEventListener(WindowEvent.WINDOW_EVENT_CHANGE, this.onTextChange);
        }

        private static function swapChars(_arg_1:String, _arg_2:int, _arg_3:int):String
        {
            var _local_5:Array = _arg_1.split("");
            var _local_4:String = _local_5[_arg_2];
            _local_5[_arg_2] = _local_5[_arg_3];
            _local_5[_arg_3] = _local_4;
            return _local_5.join("");
        }

        private static function isValidInt(_arg_1:String):Boolean
        {
            var _local_2:RegExp = /^-?\d+$/;
            return _local_2.test(_arg_1);
        }

        public function set onValueChange(_arg_1:Function):void
        {
            this._onValueChange = _arg_1;
        }

        private function displayValue(_arg_1:int):String
        {
            var _local_3:int;
            var _local_2:String = _arg_1.toString();
            if (this._precision > 0)
            {
                while (_local_2.length < (this._precision + 1))
                {
                    _local_2 = ("0" + _local_2);
                }
                _local_2 = (_local_2.substring(0, (_local_2.length - this._precision)) + "." + _local_2.substring(_local_2.length - this._precision));
                while (_local_2.charAt(_local_2.length - 1) == "0")
                {
                    _local_2 = _local_2.substring(0, (_local_2.length - 1));
                }
                if (_local_2.charAt(_local_2.length - 1) == ".")
                {
                    _local_2 = _local_2.substring(0, (_local_2.length - 1));
                }
            }
            if (this._precision < 0)
            {
                _local_3 = 0;
                while (_local_3 > this._precision)
                {
                    _local_2 = (_local_2 + "0");
                    _local_3--;
                }
            }
            return _local_2;
        }

        private function setValue(_arg_1:int):void
        {
            this._ignoreListeners = true;
            this._initialValue = _arg_1;
            this._currentValue = _arg_1;
            this._latestValidValueStr = this.displayValue((this._endsWithFive) ? (_arg_1 * 5) : _arg_1);
            this._field.text = this._latestValidValueStr;
            this._ignoreListeners = false;
        }

        public function set value(_arg_1:int):void
        {
            this.setValue(_arg_1);
        }

        public function reset():void
        {
            this.setValue(this._param.initialValue);
        }

        private function onTextChange(_arg_1:WindowEvent):void
        {
            var _local_2:int;
            var _local_4:RegExp;
            var _local_5:int;
            var _local_6:int;
            if (this._ignoreListeners)
            {
                return;
            }
            var _local_8:String = this._field.text;
            if ((_local_8 == "") || ((_local_8 == "-") && (this._param.min < 0)))
            {
                return;
            }
            var _local_3:String = _local_8.charAt(_local_8.length - 1);
            if ((this._precision == 0) && this._endsWithFive && (_local_3 != "0") && (_local_3 != "5"))
            {
                return;
            }
            if ((this._precision < 0) && (_local_3 == "0"))
            {
                return;
            }
            if (this._param.nonDecimalNotations && ((_local_8.indexOf("0b") == 0) || (_local_8.indexOf("0x") == 0)))
            {
                _local_2 = (_local_8.indexOf("0b") == 0) ? parseInt(_local_8.substr(2), 2) : parseInt(_local_8.substr(2), 16);
                this.setValidValueAndNotify((_local_2 < this._min) ? this._min : ((_local_2 > this._max) ? this._max : _local_2));
                return;
            }
            var _local_9:String = _local_8.replace(",", ".");
            if (this._precision > 0)
            {
                if (_local_9.charAt(_local_9.length - 1) == ".")
                {
                    _local_9 = _local_9.substring(0, (_local_9.length - 1));
                }
                _local_4 = /^-?([0-9]*[.])?[0-9]+$/;
                if (!_local_4.test(_local_9))
                {
                    this._ignoreListeners = true;
                    this._field.text = this._latestValidValueStr;
                    this._ignoreListeners = false;
                    return;
                }
                _local_5 = 0;
                while (_local_5 < this._precision)
                {
                    _local_6 = int(_local_9.indexOf("."));
                    if (_local_6 == -1)
                    {
                        _local_9 = (_local_9 + "0");
                    }
                    else
                    {
                        _local_9 = swapChars(_local_9, _local_6, (_local_6 + 1));
                        if (_local_9.charAt(_local_9.length - 1) == ".")
                        {
                            _local_9 = _local_9.substring(0, (_local_9.length - 1));
                        }
                    }
                    _local_5++;
                }
            }
            else if (this._precision < 0)
            {
                _local_5 = 0;
                while (_local_5 > this._precision)
                {
                    if ((_local_9 == "0") || (_local_9 == "-0") || (_local_9 == ""))
                    {
                        break;
                    }
                    if (_local_9.charAt(_local_9.length - 1) == "0")
                    {
                        _local_9 = _local_9.substring(0, (_local_9.length - 1));
                    }
                    else
                    {
                        this._ignoreListeners = true;
                        this._field.text = this._latestValidValueStr;
                        this._ignoreListeners = false;
                    }
                    _local_5--;
                }
            }
            var _local_7:ITextFieldWindow = this._field;
            if (this._endsWithFive && (_local_9.charAt(_local_9.length - 1) != "0") && (_local_9.charAt(_local_9.length - 1) != "5"))
            {
                _local_7.text = this._latestValidValueStr;
                return;
            }
            _local_2 = int(_local_9);
            if ((!isNaN(_local_2)) && isValidInt(_local_9))
            {
                if ((String(_local_2).length <= String(this._param.min).length) && (_local_2 < this._param.min) && (String(this._param.max).length > String(this._param.min).length))
                {
                    return;
                }
                if ((_local_2 >= this._min) && (_local_2 <= this._max))
                {
                    this._latestValidValueStr = _local_7.text;
                }
                else if (_local_2 < this._min)
                {
                    _local_2 = this._min;
                    this._latestValidValueStr = this.displayValue(this._min);
                    _local_7.text = this._latestValidValueStr;
                }
                else
                {
                    _local_2 = this._max;
                    this._latestValidValueStr = this.displayValue(this._max);
                    _local_7.text = this._latestValidValueStr;
                }
                this.setValidValueAndNotify((this._endsWithFive) ? (_local_2 / 5) : _local_2);
            }
            else
            {
                _local_7.text = this._latestValidValueStr;
            }
        }

        private function setValidValueAndNotify(_arg_1:int):void
        {
            this._currentValue = _arg_1;
            if (this._onValueChange != null)
            {
                this._onValueChange(_arg_1);
            }
        }

        public function get value():int
        {
            return this._currentValue;
        }

        public function get number():Number
        {
            return Number(this._latestValidValueStr);
        }

        override public function hasStaticWidth():Boolean
        {
            return this._param.width >= 0;
        }

        override public function get staticWidth():int
        {
            if (this._param.width >= 0)
            {
                return (this._param.width + this._fieldWidthDelta);
            }
            throw new Exception("Number input with -1 width has no static width");
        }

        override public function resizeToWidth(_arg_1:int):void
        {
            super.resizeToWidth(_arg_1);
            var _local_2:int = int((this._param.width >= 0) ? (this._param.width + this._fieldWidthDelta) : _arg_1);
            this._inputView.width = _local_2;
        }

        override public function get window():IWindow
        {
            return this._inputView;
        }

        override public function dispose():void
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._inputView.dispose();
            this._inputView = null;
            this._param = null;
        }
    }
}
