package com.sulake.habbo.ui.widget.furniture.gamehall.leaderboard
{
    import binaryData.HabboRoomUICom_gamehall_leaderboard_xml;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.avatar.enum.AvatarScaleType;
    import com.sulake.habbo.communication.messages.parser.games.OpenGamehallLeaderboardMessageParser;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.utils.HabboFaceFocuser;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.BitmapData;
    import flash.utils.ByteArray;

    public class GamehallLeaderboardView implements IAvatarImageListener
    {
        private static const ICON:String = "badge_rarity_badges_emblem_unique_extended";
        private static const MAX_ROWS:int = 10;
        private static const GAME_TYPES:Array = ["ALL", "BATTLESHIPS", "TICTACTOE", "CHESS", "POKER"];

        private var _disposed:Boolean = false;
        private var _windowManager:IHabboWindowManager;
        private var _localizations:IHabboLocalizationManager;
        private var _requestCallback:Function;
        private var _profileCallback:Function;
        private var _avatarRenderManager:IAvatarRenderManager;
        private var _window:IWindowContainer;
        private var _rowViews:Array;
        private var _entries:Array;
        private var _ownView:GamehallLeaderboardEntryView;
        private var _ownEntry:GamehallLeaderboardEntry;
        private var _template:IWindowContainer;
        private var _currentGameType:String = "ALL";
        private var _currentPeriod:String = "WEEKLY";
        private var _currentOffset:int = 0;
        private var _currentLimit:int = 10;

        public function GamehallLeaderboardView(windowManager:IHabboWindowManager, localizations:IHabboLocalizationManager, requestCallback:Function, profileCallback:Function, avatarRenderManager:IAvatarRenderManager)
        {
            this._windowManager = windowManager;
            this._localizations = localizations;
            this._requestCallback = requestCallback;
            this._profileCallback = profileCallback;
            this._avatarRenderManager = avatarRenderManager;
            this._rowViews = [];
            this._entries = [];
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function get window():IWindowContainer
        {
            return this._window;
        }

        public function show(data:OpenGamehallLeaderboardMessageParser):void
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            if (this._window == null)
            {
                return;
            }
            this.updateCurrentState(data);
            this.applyTexts(data);
            this.populateRows(data);
            this._window.visible = true;
            this._window.center();
            this._window.activate();
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
            if (this._disposed)
            {
                return;
            }
            for each (var view:GamehallLeaderboardEntryView in this._rowViews)
            {
                view.dispose();
            }
            this._rowViews = [];
            this._entries = [];
            if (this._ownView != null)
            {
                this._ownView.dispose();
                this._ownView = null;
            }
            this._ownEntry = null;
            this._template = null;
            this._requestCallback = null;
            this._profileCallback = null;
            this._avatarRenderManager = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._windowManager = null;
            this._localizations = null;
            this._disposed = true;
        }

        public function avatarImageReady(figure:String):void
        {
            if (this._disposed || figure == null)
            {
                return;
            }
            this.renderEntryFacesForFigure(figure);
        }

        private function createWindow():void
        {
            var bytes:ByteArray = new HabboRoomUICom_gamehall_leaderboard_xml() as ByteArray;
            bytes.position = 0;
            this._window = this._windowManager.buildFromXML(new XML(bytes.readUTFBytes(bytes.length)), 1) as IWindowContainer;
            if (this._window == null)
            {
                return;
            }
            this._window.name = "gamehall_leaderboard";
            var close:IWindow = this._window.findChildByTag("close");
            if (close != null)
            {
                close.procedure = this.onClose;
            }
            var dropdownRegion:IWindow = this._window.findChildByName("dropdown_region");
            if (dropdownRegion != null)
            {
                dropdownRegion.procedure = this.onDropdownOpen;
            }
            var dropdownOpener:IWindow = this._window.findChildByName("dropdown_opener");
            if (dropdownOpener != null)
            {
                dropdownOpener.procedure = this.onDropdownOpen;
            }
            var dropdown:IDropMenuWindow = this._window.findChildByName("hidden_dropdown") as IDropMenuWindow;
            if (dropdown != null)
            {
                dropdown.procedure = this.onDropdownSelection;
            }
            var previous:IWindow = this._window.findChildByName("previous_btn");
            if (previous != null)
            {
                previous.procedure = this.onPrevious;
            }
            var next:IWindow = this._window.findChildByName("next_btn");
            if (next != null)
            {
                next.procedure = this.onNext;
            }
            this.prepareRows();
        }

        private function prepareRows():void
        {
            var list:IItemListWindow = this._window.findChildByName("ranking_list") as IItemListWindow;
            if (list != null)
            {
                this._template = list.getListItemByName("entry_template") as IWindowContainer;
                if (this._template != null)
                {
                    list.removeListItem(this._template);
                    this._template.visible = false;
                    for (var index:int = 0; index < MAX_ROWS; index++)
                    {
                        var row:IWindowContainer = this._template.clone() as IWindowContainer;
                        row.name = "gamehall_leaderboard_row_" + index;
                        list.addListItem(row);
                        var view:GamehallLeaderboardEntryView = new GamehallLeaderboardEntryView(row, this._windowManager.assets);
                        if (view.profileRegion != null)
                        {
                            view.profileRegion.id = index;
                            view.profileRegion.procedure = this.onProfileClicked;
                        }
                        this._rowViews.push(view);
                    }
                }
            }
            var own:IWindowContainer = this._window.findChildByName("own_container") as IWindowContainer;
            if (own != null)
            {
                this._ownView = new GamehallLeaderboardEntryView(own, this._windowManager.assets);
                if (this._ownView.profileRegion != null)
                {
                    this._ownView.profileRegion.id = -1;
                    this._ownView.profileRegion.procedure = this.onProfileClicked;
                }
            }
        }

        private function applyTexts(data:OpenGamehallLeaderboardMessageParser):void
        {
            var title:String = this.titleForGame(this._currentGameType);
            this.setText("hacky_title", title);
            this.setText("title_txt", title);
            this.setText("title_txt_shadow_0", title);
            this.setText("title_txt_shadow_1", title);
            this.setText("title_txt_shadow_2", title);
            this.setText("title_txt_shadow_3", title);
            var hasRows:Boolean = data != null && data.rows != null && data.rows.length > 0;
            this.setText("rank_type_info", hasRows
                ? this.infoForGame(this._currentGameType)
                : this.text("gamehall.leaderboard.empty", "No games have been completed yet. Win a game to appear here!"));
            this.setDropdownOptions();
            this.setButton("previous_btn", this.text("gamehall.leaderboard.previous", "Previous"), this.canGoPrevious());
            this.setButton("next_btn", this.text("gamehall.leaderboard.next", "Next"), this.canGoNext(data));

            var icon:IStaticBitmapWrapperWindow = this._window.findChildByName("rank_type_extended_img") as IStaticBitmapWrapperWindow;
            if (icon != null)
            {
                icon.assetUri = ICON;
            }
        }

        private function populateRows(data:OpenGamehallLeaderboardMessageParser):void
        {
            var rows:Array = data == null || data.rows == null ? [] : data.rows;
            this._entries = [];
            for (var index:int = 0; index < this._rowViews.length; index++)
            {
                if (index < rows.length)
                {
                    var entry:GamehallLeaderboardEntry = new GamehallLeaderboardEntry(rows[index]);
                    this._entries[index] = entry;
                    this._rowViews[index].setData(entry, (index % 2) == 0);
                    this.renderEntryFace(this._rowViews[index], entry);
                }
                else
                {
                    this._entries[index] = null;
                    this._rowViews[index].clearFaceBitmap();
                    this._rowViews[index].hide();
                }
            }
            if (this._ownView != null)
            {
                if (data != null && data.ownRow != null)
                {
                    this._ownEntry = new GamehallLeaderboardEntry(data.ownRow);
                    this._ownView.setData(this._ownEntry, true);
                    this.renderEntryFace(this._ownView, this._ownEntry);
                }
                else
                {
                    this._ownEntry = null;
                    this._ownView.clearFaceBitmap();
                    this._ownView.hide();
                }
            }
        }

        private function renderEntryFacesForFigure(figure:String):void
        {
            var entry:GamehallLeaderboardEntry;
            for (var index:int = 0; index < this._rowViews.length; index++)
            {
                entry = index < this._entries.length ? this._entries[index] as GamehallLeaderboardEntry : null;
                if (entry != null && entry.figure == figure)
                {
                    this.renderEntryFace(this._rowViews[index], entry);
                }
            }
            if (this._ownEntry != null && this._ownEntry.figure == figure)
            {
                this.renderEntryFace(this._ownView, this._ownEntry);
            }
        }

        private function renderEntryFace(view:GamehallLeaderboardEntryView, entry:GamehallLeaderboardEntry):void
        {
            var avatar:IAvatarImage;
            var bitmap:BitmapData;
            if (view == null)
            {
                return;
            }
            view.clearFaceBitmap();
            if (entry == null || this._avatarRenderManager == null || entry.figure == null || entry.figure.length == 0)
            {
                return;
            }
            avatar = this._avatarRenderManager.createAvatarImage(entry.figure, AvatarScaleType.LARGE, null, this);
            if (avatar == null)
            {
                return;
            }
            bitmap = HabboFaceFocuser.focusUserFace(avatar, "head", 2, 1);
            avatar.dispose();
            if (bitmap != null)
            {
                view.setFaceBitmap(bitmap);
            }
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

        private function setButton(name:String, caption:String, enabled:Boolean):void
        {
            var button:IButtonWindow = this._window.findChildByName(name) as IButtonWindow;
            if (button != null)
            {
                button.caption = caption;
                if (enabled)
                {
                    button.enable();
                }
                else
                {
                    button.disable();
                }
            }
        }

        private function text(key:String, fallback:String):String
        {
            if (this._localizations == null)
            {
                return fallback;
            }
            var value:String = this._localizations.getLocalization(key, fallback);
            return (value == null || value == "" || value == key) ? fallback : value;
        }

        private function updateCurrentState(data:OpenGamehallLeaderboardMessageParser):void
        {
            if (data == null)
            {
                this._currentGameType = "ALL";
                this._currentPeriod = "WEEKLY";
                this._currentOffset = 0;
                this._currentLimit = MAX_ROWS;
                return;
            }
            this._currentGameType = this.normalizeGameType(data.gameType);
            this._currentPeriod = data.period == null || data.period == "" ? "WEEKLY" : data.period;
            this._currentOffset = Math.max(0, data.offset);
            this._currentLimit = data.limit <= 0 ? MAX_ROWS : data.limit;
        }

        private function setDropdownOptions():void
        {
            var dropdown:IDropMenuWindow = this._window.findChildByName("hidden_dropdown") as IDropMenuWindow;
            if (dropdown == null)
            {
                return;
            }

            dropdown.procedure = null;
            dropdown.populate(this.dropdownOptions());
            dropdown.selection = this.indexForGame(this._currentGameType);
            dropdown.procedure = this.onDropdownSelection;
        }

        private function dropdownOptions():Array
        {
            return [
                this.text("gamehall.leaderboard.dropdown.all", "Show total Games Hall"),
                this.text("gamehall.leaderboard.dropdown.battleships", "Show Top Battleships"),
                this.text("gamehall.leaderboard.dropdown.tictactoe", "Show Top Tic-Tac-Toe"),
                this.text("gamehall.leaderboard.dropdown.chess", "Show Top Chess"),
                this.text("gamehall.leaderboard.dropdown.poker", "Show Top Poker")
            ];
        }

        private function titleForGame(gameType:String):String
        {
            switch (gameType)
            {
                case "BATTLESHIPS":
                    return this.text("gamehall.leaderboard.option.battleships", "Battleships");
                case "TICTACTOE":
                    return this.text("gamehall.leaderboard.option.tictactoe", "Tic-Tac-Toe");
                case "CHESS":
                    return this.text("gamehall.leaderboard.option.chess", "Chess");
                case "POKER":
                    return this.text("gamehall.leaderboard.option.poker", "Poker");
                case "ALL":
                default:
                    return this.text("gamehall.leaderboard.option", "Games Hall");
            }
        }

        private function infoForGame(gameType:String):String
        {
            switch (gameType)
            {
                case "BATTLESHIPS":
                    return this.text("gamehall.leaderboard.info.battleships", "Overview of the best Battleships players.");
                case "TICTACTOE":
                    return this.text("gamehall.leaderboard.info.tictactoe", "Overview of the best Tic-Tac-Toe players.");
                case "CHESS":
                    return this.text("gamehall.leaderboard.info.chess", "Overview of the best Chess players.");
                case "POKER":
                    return this.text("gamehall.leaderboard.info.poker", "Overview of the best Poker players.");
                case "ALL":
                default:
                    return this.text("gamehall.leaderboard.info", "Overview of the best Games Hall players.");
            }
        }

        private function normalizeGameType(gameType:String):String
        {
            if (gameType == null)
            {
                return "ALL";
            }
            gameType = gameType.toUpperCase();
            return GAME_TYPES.indexOf(gameType) >= 0 ? gameType : "ALL";
        }

        private function indexForGame(gameType:String):int
        {
            var index:int = GAME_TYPES.indexOf(this.normalizeGameType(gameType));
            return index < 0 ? 0 : index;
        }

        private function gameForIndex(index:int):String
        {
            return index >= 0 && index < GAME_TYPES.length ? GAME_TYPES[index] : "ALL";
        }

        private function canGoPrevious():Boolean
        {
            return this._currentOffset > 0;
        }

        private function canGoNext(data:OpenGamehallLeaderboardMessageParser):Boolean
        {
            return data != null && this._currentOffset + this._currentLimit < data.totalRows;
        }

        private function onClose(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.hide();
            }
        }

        private function onDropdownOpen(event:WindowEvent, window:IWindow):void
        {
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }

            var dropdown:IDropMenuWindow = this._window.findChildByName("hidden_dropdown") as IDropMenuWindow;
            if (dropdown != null)
            {
                dropdown.openMenu();
                dropdown.activate();
            }
        }

        private function onDropdownSelection(event:WindowEvent, window:IWindow):void
        {
            if (event.type != WindowEvent.WINDOW_EVENT_SELECTED)
            {
                return;
            }

            var dropdown:IDropMenuWindow = this._window.findChildByName("hidden_dropdown") as IDropMenuWindow;
            if (dropdown == null)
            {
                return;
            }

            var gameType:String = this.gameForIndex(dropdown.selection);
            if (gameType == this._currentGameType)
            {
                return;
            }
            this.request(gameType, this._currentPeriod, 0, this._currentLimit);
        }

        private function onPrevious(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK && this.canGoPrevious())
            {
                this.request(this._currentGameType, this._currentPeriod, Math.max(0, this._currentOffset - this._currentLimit), this._currentLimit);
            }
        }

        private function onNext(event:WindowEvent, window:IWindow):void
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.request(this._currentGameType, this._currentPeriod, this._currentOffset + this._currentLimit, this._currentLimit);
            }
        }

        private function onProfileClicked(event:WindowEvent, window:IWindow):void
        {
            var entry:GamehallLeaderboardEntry;
            if (event.type != WindowMouseEvent.CLICK || window == null || this._profileCallback == null)
            {
                return;
            }
            if (window.id == -1)
            {
                entry = this._ownEntry;
            }
            else if (window.id >= 0 && window.id < this._entries.length)
            {
                entry = this._entries[window.id] as GamehallLeaderboardEntry;
            }
            if (entry != null && entry.userId > 0)
            {
                this._profileCallback(entry.userId);
            }
        }

        private function request(gameType:String, period:String, offset:int, limit:int):void
        {
            if (this._requestCallback != null)
            {
                this._requestCallback(this.normalizeGameType(gameType), period == null || period == "" ? "WEEKLY" : period, Math.max(0, offset), limit <= 0 ? MAX_ROWS : limit);
            }
        }
    }
}
