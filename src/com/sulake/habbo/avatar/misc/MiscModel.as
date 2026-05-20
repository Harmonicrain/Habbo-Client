package com.sulake.habbo.avatar.misc
{
    import com.sulake.habbo.avatar.HabboAvatarEditor;
    import com.sulake.habbo.avatar.common.CategoryBaseModel;
    import com.sulake.habbo.avatar.common.CategoryData;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.figuredata.FigureData;

    public class MiscModel extends CategoryBaseModel implements IAvatarEditorCategoryModel 
    {
        public function MiscModel(k:HabboAvatarEditor)
        {
            super(k);
        }

        override protected function init():void
        {
            super.init();
            _Str_3130(FigureData.PET);
            _Str_3130(FigureData.MISC);
            this.ensureEmptyCategory(FigureData.PET);
            this.ensureEmptyCategory(FigureData.MISC);
            _isInitialized = true;
            if (!_view)
            {
                _view = new MiscView(this);
                if (_view)
                {
                    _view.init();
                }
            }
        }

        private function ensureEmptyCategory(k:String):void
        {
            if ((!_categories) || (_categories[k] != null))
            {
                return;
            }
            _categories[k] = new CategoryData([], []);
        }
    }
}
