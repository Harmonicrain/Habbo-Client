package com.sulake.habbo.roomevents.wired_setup
{
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;

    public class WrappedSourceTypeListener implements ISourceTypeListener
    {
        private var _element:DefaultElement;
        private var _id:int;

        public function WrappedSourceTypeListener(k:DefaultElement, _arg_2:int)
        {
            super();
            this._element = k;
            this._id = _arg_2;
        }

        public function set sourceType(k:int):void
        {
            this._element.roomEvents.wiredCtrl.setMergedSourceType(this._id, k);
        }
    }
}
