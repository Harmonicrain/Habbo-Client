package com.sulake.habbo.roomevents.wired_setup.variables
{
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;

    /** Shared July-compatible state for variable configuration editors. */
    public class VariableElement extends DefaultElement implements IWiredVariableElement
    {
        private var _initialVariableName:String = "";

        public function set initialVariableName(value:String):void
        {
            this._initialVariableName = value != null ? value : "";
            if (this.variableNameSection != null)
            {
                this.variableNameSection.variableName = this._initialVariableName;
            }
        }

        public function get initialVariableName():String
        {
            return this._initialVariableName;
        }

        public function variableType():int
        {
            return 0;
        }

        protected function get variableNameSection():VariableNameSection
        {
            return null;
        }
    }
}
