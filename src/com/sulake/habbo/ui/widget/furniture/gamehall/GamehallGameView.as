package com.sulake.habbo.ui.widget.furniture.gamehall
{
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import flash.display.Sprite;

    public interface GamehallGameView
    {
        function reset(localSeat:int, seatCount:int):void;
        function applyUpdate(verb:String="", args:Array=null, reason:String=""):void;
        function render(panel:Sprite, assets:GamehallAssetLibrary):void;
        function handleWindowEvent(event:WindowEvent, window:IWindow):void;
        function dispose():void;
    }
}
