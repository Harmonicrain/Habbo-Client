package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import binaryData.HabboRoomUICom_gamehall_board_xml;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IDisplayObjectWrapper;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.enum.WindowParam;
    import com.sulake.core.window.enum.WindowStyle;
    import com.sulake.core.window.enum.WindowType;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.utils.ByteArray;
    import flash.display.Sprite;
    import flash.geom.Rectangle;

    public class GamehallBoardWindow
    {
        private static const WINDOW_WIDTH:int = 292;
        private static const WINDOW_HEIGHT:int = 304;
        private static const CANVAS_X:int = 5;
        private static const CANVAS_Y:int = 5;
        private static const SCREEN_WIDTH:int = 270;
        private static const SCREEN_HEIGHT:int = 264;

        private static const BOARD_XML_ASSET:String = "gamehall_board_xml";
        private var _windowManager:IHabboWindowManager;
        private var _assets:IAssetLibrary;
        private var _root:IWindowContainer;
        private var _frame:IWindowContainer;
        private var _canvas:IDisplayObjectWrapper;
        private var _panel:Sprite;

        public function GamehallBoardWindow(windowManager:IHabboWindowManager, assets:IAssetLibrary)
        {
            this._windowManager = windowManager;
            this._assets = assets;
            this._root = IWindowContainer(windowManager.createWindow("gamehall_desktop_root", "", WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, 10, 10)));
            this.resizeRoot();
            this._root.addEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this.onRootResized);
        }

        public function get root():IWindowContainer
        {
            return this._root;
        }

        public function get frame():IWindowContainer
        {
            return this._frame;
        }

        public function get panel():Sprite
        {
            return this._panel;
        }

        public function create(title:String, procedure:Function):Sprite
        {
            GamehallFonts.registerVolter();
            if (this._frame != null)
            {
                this._frame.visible = true;
                this._frame.caption = title;
                this._frame.procedure = procedure;
                this.center();
                this.activate();
                return this._panel;
            }
            var built:IWindow = null;
            try
            {
                built = this.buildFromXmlAsset();
            }
            catch(error:Error)
            {
                built = null;
            }
            this._frame = built as IWindowContainer;
            if (this._frame == null)
            {
                this._frame = IWindowContainer(this._windowManager.createWindow("gamehall_frame", title, WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, new Rectangle(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)));
            }
            this._frame.caption = title;
            this._frame.color = 4296112;
            this._frame.procedure = procedure;
            this._root.addChild(this._frame);
            this._canvas = this._frame.findChildByName("gamehall_canvas") as IDisplayObjectWrapper;
            if (this._canvas == null)
            {
                this._canvas = IDisplayObjectWrapper(this._windowManager.createWindow("gamehall_canvas", "", WindowType.WINDOW_TYPE_DISPLAY_OBJECT_WRAPPER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, new Rectangle(CANVAS_X, CANVAS_Y, SCREEN_WIDTH, SCREEN_HEIGHT)));
                this._frame.addChild(this._canvas);
            }
            this._panel = new Sprite();
            this._canvas.setDisplayObject(this._panel);
            this.center();
            this.activate();
            return this._panel;
        }

        public function destroyFrame():void
        {
            if (this._frame == null)
            {
                return;
            }
            this._frame.procedure = null;
            this._root.removeChild(this._frame);
            this._frame.dispose();
            this._frame = null;
            this._canvas = null;
            this._panel = null;
        }

        public function setTextVisible(name:String, visible:Boolean):void
        {
            if (this._frame == null)
            {
                return;
            }
            var window:IWindow = this._frame.findChildByName(name);
            if (window != null)
            {
                window.visible = visible;
            }
        }

        public function setCaption(name:String, caption:String):void
        {
            if (this._frame == null)
            {
                return;
            }
            var window:IWindow = this._frame.findChildByName(name);
            if (window != null)
            {
                window.caption = caption == null ? "" : caption;
            }
        }

        public function setFrameCaption(caption:String):void
        {
            if (this._frame != null)
            {
                this._frame.caption = caption;
            }
        }

        public function activate():void
        {
            if (this._root != null)
            {
                this._root.activate();
            }
            if (this._frame != null)
            {
                this._frame.activate();
            }
        }

        public function dispose():void
        {
            this.destroyFrame();
            if (this._root != null)
            {
                this._root.removeEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this.onRootResized);
                this._root.dispose();
                this._root = null;
            }
            this._windowManager = null;
            this._assets = null;
        }

        private function buildFromXmlAsset():IWindow
        {
            var xml:XML = null;
            if (this._assets != null)
            {
                var asset:IAsset = this._assets.getAssetByName(BOARD_XML_ASSET);
                if (asset != null && asset.content != null)
                {
                    xml = XML(asset.content);
                }
            }
            if (xml == null)
            {
                var bytes:ByteArray = new HabboRoomUICom_gamehall_board_xml() as ByteArray;
                xml = new XML(bytes.readUTFBytes(bytes.length));
            }
            if (xml == null)
            {
                return null;
            }
            return this._windowManager.buildFromXML(xml);
        }

        private function onRootResized(event:WindowEvent):void
        {
            if (this._frame != null)
            {
                this.center();
            }
        }

        private function resizeRoot():void
        {
            if (this._root != null && this._root.desktop != null)
            {
                this._root.width = this._root.desktop.width;
                this._root.height = this._root.desktop.height;
            }
        }

        private function center():void
        {
            this.resizeRoot();
            if (this._root.width < WINDOW_WIDTH)
            {
                this._root.width = WINDOW_WIDTH;
            }
            if (this._root.height < WINDOW_HEIGHT)
            {
                this._root.height = WINDOW_HEIGHT;
            }
            this._frame.x = int((this._root.width - WINDOW_WIDTH) / 2);
            this._frame.y = int((this._root.height - WINDOW_HEIGHT) / 2);
        }
    }
}
