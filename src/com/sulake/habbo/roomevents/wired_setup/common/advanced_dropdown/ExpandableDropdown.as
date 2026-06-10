package com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.DropBaseController;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.events.WindowEvent;

    /**
     * Dropdown wrapper supporting "advanced" options hidden behind a show-more entry
     * (May ExpandableDropdown). Clean DropMenu has no WE_COLLAPSE event; the collapse
     * hook maps to WINDOW_EVENT_CLOSED, and openMenu maps to DropBaseController.open().
     */
    public class ExpandableDropdown implements IDisposable
    {
        private var _disposed:Boolean;
        private var _dropdown:IDropMenuWindow;
        private var _onChangeCallback:Function;
        private var _showingAdvanced:Boolean = false;
        private var _ignoreNextCollapse:Boolean = false;
        private var _lastSelectedId:Number = 0;
        private var _allOptions:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();
        private var _showMoreLocalization:String;
        private var _visibleOptions:Vector.<ExpandableDropdownOption> = new Vector.<ExpandableDropdownOption>();

        public function ExpandableDropdown(_arg_1:IDropMenuWindow, _arg_2:String, _arg_3:Function = null)
        {
            super();
            this._dropdown = _arg_1;
            this._showMoreLocalization = _arg_2;
            this._onChangeCallback = _arg_3;
            this._dropdown.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this.onSelectAction);
            this._dropdown.addEventListener(WindowEvent.WINDOW_EVENT_CLOSED, this.onDropdownCollapse);
        }

        public function init(_arg_1:Vector.<ExpandableDropdownOption>, _arg_2:int):void
        {
            this._allOptions = _arg_1;
            this._ignoreNextCollapse = false;
            this._showingAdvanced = false;
            this._lastSelectedId = 0;
            this.populate(_arg_2);
        }

        public function get dropdownOptions():Vector.<ExpandableDropdownOption>
        {
            return this._visibleOptions;
        }

        private function populate(_arg_1:int, _arg_2:Boolean = false):void
        {
            var _local_3:int = -1;
            this._visibleOptions.splice(0, this._visibleOptions.length);
            var _local_4:Vector.<String> = new Vector.<String>();
            for each (var _local_5:ExpandableDropdownOption in this._allOptions)
            {
                if (_arg_1 == _local_5.id)
                {
                    _local_3 = int(this._visibleOptions.length);
                    if (_local_5.isAdvanced && (!_arg_2))
                    {
                        this._showingAdvanced = true;
                        this.populate(_arg_1, true);
                        return;
                    }
                }
                if ((!_local_5.isAdvanced) || _arg_2)
                {
                    this._visibleOptions.push(_local_5);
                    _local_4.push(_local_5.displayString);
                }
            }
            if (this.advancedOptionsAvailable && (!_arg_2))
            {
                _local_4.push(this._showMoreLocalization);
            }
            this._ignoreNextCollapse = true;
            this._dropdown._Str_24893(_local_4);
            if (_local_3 != -1)
            {
                this._dropdown.selection = _local_3;
                this._lastSelectedId = _arg_1;
            }
            else
            {
                this._lastSelectedId = -1;
            }
        }

        private function get advancedOptionsAvailable():Boolean
        {
            for each (var _local_1:ExpandableDropdownOption in this._allOptions)
            {
                if (_local_1.isAdvanced)
                {
                    return true;
                }
            }
            return false;
        }

        private function onSelectAction(_arg_1:WindowEvent):void
        {
            var _local_2:DropBaseController;
            if (this._dropdown.selection >= this._visibleOptions.length)
            {
                this._showingAdvanced = true;
                this.populate(this._lastSelectedId, true);
                _local_2 = (this._dropdown as DropBaseController);
                if (_local_2 != null)
                {
                    _local_2.open();
                }
                return;
            }
            this._lastSelectedId = this.selectedOptionId;
            if (this._onChangeCallback != null)
            {
                this._onChangeCallback(this.selectedOption);
            }
        }

        private function onDropdownCollapse(_arg_1:WindowEvent):void
        {
            if (this._ignoreNextCollapse)
            {
                this._ignoreNextCollapse = false;
                return;
            }
            if (this._showingAdvanced && ((this.selectedOption == null) || (!this.selectedOption.isAdvanced)))
            {
                this._showingAdvanced = false;
                this.populate(this.selectedOptionId, false);
            }
        }

        public function get selectedOption():ExpandableDropdownOption
        {
            var _local_1:Number = this._dropdown.selection;
            if ((_local_1 < 0) || (_local_1 >= this._visibleOptions.length))
            {
                return null;
            }
            return this._visibleOptions[_local_1];
        }

        public function get selectedOptionId():Number
        {
            return (this.selectedOption == null) ? NaN : this.selectedOption.id;
        }

        public function set selectedOptionId(_arg_1:Number):void
        {
            this.init(this._allOptions, _arg_1);
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._dropdown.dispose();
            this._dropdown = null;
            this._onChangeCallback = null;
            this._allOptions = null;
            this._showMoreLocalization = null;
            this._visibleOptions = null;
            this._disposed = true;
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }
    }
}
