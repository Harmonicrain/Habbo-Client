package com.sulake.habbo.roomevents.wired_setup.uibuilder.params.applications
{
    public class SubVariableParam
    {
        private var _id:int;
        private var _name:String;
        private var _hasExtraText:Boolean;

        public function SubVariableParam(id:int, name:String, hasExtraText:Boolean = false)
        {
            this._id = id;
            this._name = name;
            this._hasExtraText = hasExtraText;
        }

        public function get id():int { return this._id; }
        public function get name():String { return this._name; }
        public function get hasExtraText():Boolean { return this._hasExtraText; }
    }
}
