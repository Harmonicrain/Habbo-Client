package com.sulake.habbo.avatar.misc
{
    import com.sulake.habbo.avatar.common.CategoryBaseView;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryModel;
    import com.sulake.habbo.avatar.common.IAvatarEditorCategoryView;
    import com.sulake.habbo.avatar.enum.AvatarEditorFigureCategory;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;

    public class MiscView extends CategoryBaseView implements IAvatarEditorCategoryView 
    {
        private const defaultCategory:String = FigureData.PET;

        public function MiscView(k:IAvatarEditorCategoryModel)
        {
            super(k);
        }

        override public function init():void
        {
            if (!window)
            {
                window = (_model.controller.view.getCategoryContainer(AvatarEditorFigureCategory.MISC) as IWindowContainer);
                if (window == null)
                {
                    return;
                }
                window.visible = false;
                window.procedure = this.windowEventProc;
            }
            _isInitialized = true;
            if (((_model) && (_Str_2889 == "")))
            {
                _model.switchCategory(this.defaultCategory);
            }
        }

        public function switchCategory(k:String):void
        {
            if (window == null)
            {
                return;
            }
            if (window.disposed)
            {
                return;
            }
            _Str_3905(_Str_2851);
            k = ((k == "") ? _Str_2889 : k);
            switch (k)
            {
                case FigureData.PET:
                    _Str_2851 = "tab_pets";
                    break;
                case FigureData.MISC:
                    _Str_2851 = "tab_misc";
                    break;
                default:
                    throw (new Error((('[MiscView] Unknown item category: "' + k) + '"')));
            }
            _Str_2889 = k;
            _Str_3621(_Str_2851);
            if (!_isInitialized)
            {
                this.init();
            }
            updateGridView(k);
        }

        private function windowEventProc(k:WindowEvent, _arg_2:IWindow):void
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "tab_pets":
                        this.switchCategory(FigureData.PET);
                        break;
                    case "tab_misc":
                        this.switchCategory(FigureData.MISC);
                        break;
                }
            }
            else
            {
                if (k.type == WindowMouseEvent.OVER)
                {
                    switch (_arg_2.name)
                    {
                        case "tab_pets":
                        case "tab_misc":
                            _Str_3621(_arg_2.name);
                            break;
                    }
                }
                else
                {
                    if (k.type == WindowMouseEvent.OUT)
                    {
                        switch (_arg_2.name)
                        {
                            case "tab_pets":
                            case "tab_misc":
                                if (_Str_2851 != _arg_2.name)
                                {
                                    _Str_3905(_arg_2.name);
                                }
                                return;
                        }
                    }
                }
            }
        }
    }
}
