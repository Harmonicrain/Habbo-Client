package com.sulake.habbo.ui.widget.furniture.gamehall.leaderboard
{
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import flash.display.BitmapData;

    public class GamehallLeaderboardEntryView
    {
        private static const SCORE_ICON:String = "badge_rarity_badges_emblem_unique";
        private static const RANK_COLORS:Array = [0x00D4AF37, 0x00C0C0C0, 0x00CD7F32, 0x006382AA];

        private var _window:IWindowContainer;
        private var _assets:IAssetLibrary;

        public function GamehallLeaderboardEntryView(window:IWindowContainer, assets:IAssetLibrary)
        {
            this._window = window;
            this._assets = assets;
        }

        public function get window():IWindowContainer
        {
            return this._window;
        }

        public function get profileRegion():IRegionWindow
        {
            return this._window == null ? null : this._window.findChildByName("region_profile") as IRegionWindow;
        }

        public function get profileCanvas():IBitmapWrapperWindow
        {
            return this._window == null ? null : this._window.findChildByName("canvas") as IBitmapWrapperWindow;
        }

        public function setData(entry:GamehallLeaderboardEntry, even:Boolean):void
        {
            if (this._window == null || entry == null)
            {
                return;
            }

            this._window.visible = true;
            this.setVisible("entry_bg_even", !entry.own && even);
            this.setVisible("entry_bg_uneven", !entry.own && !even);
            this.setVisible("own_bg", entry.own);
            this.setText("rank_number", entry.rankCaption);
            this.setText("rank_own", entry.rankCaption);
            this.setText("username_txt", entry.username);
            this.setText("score_txt", String(entry.score));
            this.setScoreIcon();
            this.clearFaceBitmap();
            this.applyRankColor(entry);
        }

        public function hide():void
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function dispose():void
        {
            this.clearFaceBitmap();
            this._window = null;
            this._assets = null;
        }

        public function setFaceBitmap(bitmap:BitmapData):void
        {
            var canvas:IBitmapWrapperWindow = this.profileCanvas;
            if (canvas == null || bitmap == null)
            {
                return;
            }
            this.clearFaceBitmap();
            canvas.bitmap = bitmap;
            canvas.width = bitmap.width;
            canvas.height = bitmap.height;
            canvas.invalidate();
        }

        public function clearFaceBitmap():void
        {
            var canvas:IBitmapWrapperWindow = this.profileCanvas;
            if (canvas == null)
            {
                return;
            }
            if (canvas.bitmap != null)
            {
                canvas.bitmap.dispose();
                canvas.bitmap = null;
            }
            canvas.invalidate();
        }

        private function setText(name:String, value:String):void
        {
            var text:ITextWindow = this._window.findChildByName(name) as ITextWindow;
            if (text != null)
            {
                text.text = value == null ? "" : value;
                text.caption = text.text;
            }
        }

        private function setVisible(name:String, visible:Boolean):void
        {
            var window:IWindow = this._window.findChildByName(name);
            if (window != null)
            {
                window.visible = visible;
            }
        }

        private function setScoreIcon():void
        {
            var icon:IStaticBitmapWrapperWindow = this._window.findChildByName("rank_type_img") as IStaticBitmapWrapperWindow;
            if (icon != null)
            {
                icon.assetUri = SCORE_ICON;
            }
        }

        private function applyRankColor(entry:GamehallLeaderboardEntry):void
        {
            var border:IWindow = this._window.findChildByName("rank_border");
            if (border == null || entry.own)
            {
                return;
            }
            var rank:int = entry.rank;
            if (rank >= 1 && rank <= 3)
            {
                border.color = RANK_COLORS[rank - 1];
            }
            else
            {
                border.color = RANK_COLORS[3];
            }
        }
    }
}
