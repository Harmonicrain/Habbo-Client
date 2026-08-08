package com.sulake.habbo.quest.rewardtrack.view
{
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.utils.WindowUtils;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackPrize;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackRewardDisplayWrapper;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackTask;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackTaskLevel;
    import com.sulake.habbo.quest.rewardtrack.IRewardTrackController;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets.IProductIconWidget;
    import flash.utils.Dictionary;

    public class RewardTrackView
    {
        private static const TASK_ROW_HEIGHT:int = 61;
        private static const TASK_PROGRESS_WIDTH:int = 200;
        private static const LEVEL_PROGRESS_WIDTH:int = 260;
        private static const PROGRESS_INCOMPLETE_COLOR:uint = 0xEBA60C;
        private static const PROGRESS_COMPLETE_COLOR:uint = 0x71AF24;
        private static const MIN_PRIZE_SPACING:int = 15;
        private static const FILTER_ALL:int = 0;
        private static const FILTER_IN_PROGRESS:int = 1;
        private static const FILTER_COMPLETED:int = 2;
        private static const TAB_SELECTED_TEXT:uint = 0xFFFFFF;
        private static const TAB_NOT_SELECTED_TEXT:uint = 0x444444;
        private static const TASK_DEFAULT_COLOR:uint = 0xF0F0F0;
        private static const TASK_COMPLETE_COLOR:uint = 0xE6F4DF;
        private static const TASK_SELECTED_COLOR:uint = 0xB7D8F4;

        private var _windowManager:IHabboWindowManager;
        private var _localizations:IHabboLocalizationManager;
        private var _assets:IAssetLibrary;
        private var _controller:IRewardTrackController;
        private var _window:IFrameWindow;
        private var _taskTemplate:IWindow;
        private var _levelTemplate:IWindow;
        private var _prizeTemplate:IWindow;
        private var _premiumPrizeTemplate:IWindow;
        private var _pointIndicatorTemplate:IWindow;
        private var _ownFigure:String;
        private var _ownUserId:int;
        private var _claimTargets:Dictionary;
        private var _premiumTargets:Dictionary;
        private var _taskTargets:Dictionary;
        private var _tabTargets:Dictionary;
        private var _currentTrack:RewardTrack;
        private var _prizeLayout:RewardTrackPrizeLayout = new RewardTrackPrizeLayout();
        private var _prizePage:int = 0;
        private var _selectedTask:RewardTrackTask;
        private var _hintInternalLink:String;
        private var _taskFilter:int = 0;
        private var _disposed:Boolean = false;

        public function RewardTrackView(windowManager:IHabboWindowManager, localizations:IHabboLocalizationManager, assets:IAssetLibrary, controller:IRewardTrackController, ownFigure:String = null, ownUserId:int = 0)
        {
            this._windowManager = windowManager;
            this._localizations = localizations;
            this._assets = assets;
            this._controller = controller;
            this._ownFigure = ownFigure;
            this._ownUserId = ownUserId;
            this._claimTargets = new Dictionary(true);
            this._premiumTargets = new Dictionary(true);
        }

        public function get disposed():Boolean
        {
            return this._disposed;
        }

        public function show(track:RewardTrack):void
        {
            var windowCreated:Boolean = false;
            if (track == null || this._disposed)
            {
                return;
            }
            if (this._window == null)
            {
                this.createWindow();
                windowCreated = true;
            }
            if (this._window == null)
            {
                return;
            }
            this.populate(track);
            this._window.visible = true;
            if (windowCreated)
            {
                this._window.center();
            }
            this._window.activate();
        }

        public function taskProgressUpdated(task:RewardTrackTask, hadProgress:Boolean, wasComplete:Boolean):void
        {
            if (this._currentTrack == null || this._window == null || this._disposed)
            {
                return;
            }
            this.refreshTrackSummary(this._currentTrack);
            this.populateMainProgress(this._currentTrack, false);
            this.populatePrizes(this._currentTrack);
            this.refreshTaskProgress(task, hadProgress, wasComplete);
        }

        public function prizeClaimed(prize:RewardTrackPrize):void
        {
            if (this._currentTrack == null || this._window == null || this._disposed)
            {
                return;
            }
            this.refreshTrackSummary(this._currentTrack);
            this.populatePrizes(this._currentTrack);
        }

        public function premiumPurchased():void
        {
            if (this._currentTrack == null || this._window == null || this._disposed)
            {
                return;
            }
            this.refreshTrackSummary(this._currentTrack);
            this.populateMainProgress(this._currentTrack, false);
            this.populatePrizes(this._currentTrack);
            this.refreshPremiumInfo(this._currentTrack);
            this.populateTaskList(this._currentTrack);
            if (this._selectedTask != null)
            {
                this.populateTaskDetails(this._currentTrack, this._selectedTask);
            }
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._taskTemplate != null)
            {
                this._taskTemplate.dispose();
                this._taskTemplate = null;
            }
            if (this._levelTemplate != null)
            {
                this._levelTemplate.dispose();
                this._levelTemplate = null;
            }
            if (this._prizeTemplate != null)
            {
                this._prizeTemplate.dispose();
                this._prizeTemplate = null;
            }
            if (this._premiumPrizeTemplate != null)
            {
                this._premiumPrizeTemplate.dispose();
                this._premiumPrizeTemplate = null;
            }
            if (this._pointIndicatorTemplate != null)
            {
                this._pointIndicatorTemplate.dispose();
                this._pointIndicatorTemplate = null;
            }
            this._windowManager = null;
            this._localizations = null;
            this._assets = null;
            this._controller = null;
            this._claimTargets = null;
            this._premiumTargets = null;
            this._taskTargets = null;
            this._tabTargets = null;
            this._currentTrack = null;
            this._selectedTask = null;
            this._ownFigure = null;
            this._disposed = true;
        }

        private function createWindow():void
        {
            var asset:IAsset = this._assets != null ? this._assets.getAssetByName("reward_track_main_xml") : null;
            if (asset == null)
            {
                return;
            }
            this._window = this._windowManager.buildFromXML(asset.content as XML, 1) as IFrameWindow;
            if (this._window == null)
            {
                return;
            }
            this._window.procedure = this.onWindowEvent;
            this.captureTemplates();
            this.initializeTabs();
            this.refreshOwnAvatar();
        }

        public function setOwnUser(figure:String, userId:int):void
        {
            this._ownFigure = figure;
            this._ownUserId = userId;
            this.refreshOwnAvatar();
        }

        private function refreshOwnAvatar():void
        {
            var widgetWindow:IWidgetWindow = this._window != null ? this._window.findChildByName("own_avatar") as IWidgetWindow : null;
            var avatarWidget:IAvatarImageWidget = widgetWindow != null ? widgetWindow.widget as IAvatarImageWidget : null;
            if (avatarWidget == null)
            {
                return;
            }
            if (this._ownFigure != null && this._ownFigure != "")
            {
                avatarWidget.figure = this._ownFigure;
            }
            if (this._ownUserId > 0)
            {
                avatarWidget.userId = this._ownUserId;
            }
        }

        private function captureTemplates():void
        {
            var tasks:IItemListWindow = this._window.findChildByName("tasks") as IItemListWindow;
            var levels:IItemListWindow = this._window.findChildByName("levels") as IItemListWindow;
            var prizeContent:IWindowContainer = this._window.findChildByName("prize_content") as IWindowContainer;
            var template:IWindow;

            if (tasks != null)
            {
                template = tasks.getListItemByName("task_template");
                if (template != null)
                {
                    this._taskTemplate = template.clone();
                }
                tasks.destroyListItems();
            }
            if (levels != null)
            {
                template = levels.getListItemByName("level_template");
                if (template != null)
                {
                    this._levelTemplate = template.clone();
                }
                levels.destroyListItems();
            }
            if (prizeContent != null)
            {
                template = prizeContent.findChildByName("prize_template");
                if (template != null)
                {
                    this._prizeTemplate = template.clone();
                    prizeContent.removeChild(template);
                    template.dispose();
                }
                template = prizeContent.findChildByName("prize_template_premium");
                if (template != null)
                {
                    this._premiumPrizeTemplate = template.clone();
                    prizeContent.removeChild(template);
                    template.dispose();
                }
            }
            var pointsIndicator:IWindowContainer = this._window.findChildByName("points_indicator") as IWindowContainer;
            if (pointsIndicator != null)
            {
                template = pointsIndicator.findChildByName("point_indicator_template");
                if (template != null)
                {
                    this._pointIndicatorTemplate = template.clone();
                    pointsIndicator.removeChild(template);
                    template.dispose();
                }
            }
        }

        private function populate(track:RewardTrack):void
        {
            var firstTask:RewardTrackTask;
            this._currentTrack = track;
            this._window.caption = this.text("reward_track.window.title", "Reward Track");
            this.setText(this._window, "track_title_txt", this.text("reward_track." + track.id + ".name", track.id));
            this.setText(this._window, "track_desc_txt", this.text("reward_track." + track.id + ".desc", ""));
            this.setText(this._window, "track_instructions_txt", this.text("reward_track." + track.id + ".info", ""));
            this.setText(this._window, "points_total_collected_txt", String(track.points));
            this.setText(this._window, "rewards_collected_txt", this.rewardsCollectedText(track));
            this.setText(this._window, "tasks_completion_txt", this.tasksCompletionText(track));

            this.populateMainProgress(track, true);
            this.populateTaskList(track);
            this.populatePrizes(track);
            this.refreshPremiumInfo(track);
            if (this._selectedTask == null || track.getTask(this._selectedTask.id) == null || !this.matchesTaskFilter(this._selectedTask))
            {
                this._selectedTask = this.firstVisibleTask(track);
            }
            firstTask = this._selectedTask;
            if (firstTask != null)
            {
                this.populateTaskDetails(track, firstTask);
            }
            else
            {
                this.clearTaskDetails();
            }
            this.refreshTabs();
        }

        private function refreshTrackSummary(track:RewardTrack):void
        {
            this.setText(this._window, "points_total_collected_txt", String(track.points));
            this.setText(this._window, "rewards_collected_txt", this.rewardsCollectedText(track));
            this.setText(this._window, "tasks_completion_txt", this.tasksCompletionText(track));
        }

        private function refreshTaskProgress(task:RewardTrackTask, hadProgress:Boolean, wasComplete:Boolean):void
        {
            var list:IItemListWindow;
            var row:IWindowContainer;
            var taskChangedFilterState:Boolean;
            if (task == null || this._currentTrack == null)
            {
                return;
            }
            taskChangedFilterState = hadProgress != (task.progressCount > 0) || wasComplete != this.isTaskComplete(task);
            if (this._taskFilter != FILTER_ALL && taskChangedFilterState)
            {
                this.populateTaskList(this._currentTrack);
            }
            else
            {
                list = this._window.findChildByName("tasks") as IItemListWindow;
                row = list != null ? list.getListItemByName("task_" + task.id) as IWindowContainer : null;
                if (row != null)
                {
                    this.populateTaskRow(row, this._currentTrack, task);
                }
            }
            if (this._selectedTask == task || (this._selectedTask != null && this._selectedTask.id == task.id))
            {
                if (this.matchesTaskFilter(task))
                {
                    this._selectedTask = task;
                    this.populateTaskDetails(this._currentTrack, task);
                }
                else
                {
                    this._selectedTask = this.firstVisibleTask(this._currentTrack);
                    if (this._selectedTask != null)
                    {
                        this.populateTaskDetails(this._currentTrack, this._selectedTask);
                    }
                    else
                    {
                        this.clearTaskDetails();
                    }
                }
            }
            this.refreshTabs();
        }

        private function populateTaskList(track:RewardTrack):void
        {
            var list:IItemListWindow = this._window.findChildByName("tasks") as IItemListWindow;
            var task:RewardTrackTask;
            var row:IWindowContainer;
            var i:int;
            if (list == null || this._taskTemplate == null)
            {
                return;
            }
            list.destroyListItems();
            this._taskTargets = new Dictionary(true);
            for each (task in track.tasks)
            {
                if (!this.matchesTaskFilter(task))
                {
                    continue;
                }
                row = this._taskTemplate.clone() as IWindowContainer;
                if (row == null)
                {
                    continue;
                }
                row.name = "task_" + task.id;
                row.height = TASK_ROW_HEIGHT;
                row.procedure = this.onWindowEvent;
                this._taskTargets[row] = task;
                this.populateTaskRow(row, track, task);
                list.addListItem(row);
                i++;
            }
            list.arrangeListItems();
        }

        private function populateTaskRow(row:IWindowContainer, track:RewardTrack, task:RewardTrackTask):void
        {
            var activeLevel:RewardTrackTaskLevel = this.activeLevel(task);
            var required:int = activeLevel != null ? activeLevel.requiredCount : 0;
            var reward:int = activeLevel != null ? activeLevel.pointsReward : 0;
            this.setText(row, "task_name", this.taskName(track, task));
            this.setText(row, "task_description", this.taskDescription(track, task));
            this.setText(row, "task_progress_txt", task.progressCount + " / " + required);
            this.setText(row, "track_reward_txt", String(reward));
            this.setImage(row, "task_image", this.taskIcon(task));
            this.setProgress(row, task.progressCount, required, TASK_PROGRESS_WIDTH);
            this.setTaskRowStyle(row, task == this._selectedTask, this.isTaskComplete(task));
        }

        private function populateTaskDetails(track:RewardTrack, task:RewardTrackTask):void
        {
            var levels:IItemListWindow = this._window.findChildByName("levels") as IItemListWindow;
            var level:RewardTrackTaskLevel;
            var row:IWindowContainer;
            var i:int;
            var hintKey:String = "reward_track." + track.id + ".task." + task.id + ".hint";
            this.setText(this._window, "task_info_name", this.taskName(track, task));
            this.setText(this._window, "task_info_description", this.taskDescription(track, task));
            this.setText(this._window, "task_hint_text", this.text(hintKey + ".desc", ""));
            this.setHintButton(hintKey);
            this.setImage(this._window, "task_info_img", this.taskIcon(task));
            if (levels == null || this._levelTemplate == null)
            {
                return;
            }
            levels.destroyListItems();
            for (i = 0; i < task.levels.length; i++)
            {
                level = task.levels[i] as RewardTrackTaskLevel;
                row = this._levelTemplate.clone() as IWindowContainer;
                if (row == null)
                {
                    continue;
                }
                this.setText(row, "level_name", this.levelText(i + 1));
                this.setText(row, "level_progress_txt", Math.min(task.progressCount, level.requiredCount) + " / " + level.requiredCount);
                this.setText(row, "level_reward_txt", String(level.pointsReward));
                this.setProgress(row, task.progressCount, level.requiredCount, LEVEL_PROGRESS_WIDTH);
                this.setVisible(row, "completed_icon", task.progressCount >= level.requiredCount);
                this.setVisible(row, "locked_icon", level.premium && !track.premium);
                levels.addListItem(row);
            }
            levels.arrangeListItems();
        }

        private function clearTaskDetails():void
        {
            var levels:IItemListWindow = this._window.findChildByName("levels") as IItemListWindow;
            this.setText(this._window, "task_info_name", "");
            this.setText(this._window, "task_info_description", "");
            this.setText(this._window, "task_hint_text", "");
            this._hintInternalLink = "";
            this.setVisible(this._window, "hint_redirect_btn", false);
            this.setImage(this._window, "task_info_img", "");
            if (levels != null)
            {
                levels.destroyListItems();
            }
        }

        private function populatePrizes(track:RewardTrack):void
        {
            var prizeContent:IWindowContainer = this._window.findChildByName("prize_content") as IWindowContainer;
            var prize:RewardTrackPrize;
            var prizeWindow:IWindowContainer;
            var template:IWindow;
            var product:IWidgetWindow;
            var pointValues:Array = [];
            var pointCenters:Array = [];
            var center:int;
            var layout:Object;
            var i:int;
            if (prizeContent == null || this._prizeTemplate == null)
            {
                return;
            }
            this._claimTargets = new Dictionary(true);
            this._premiumTargets = new Dictionary(true);
            while (prizeContent.numChildren > 0)
            {
                prizeContent.removeChildAt(0).dispose();
            }
            this.clearPointIndicators();
            for each (prize in track.prizes)
            {
                if (this._prizeLayout.pageForPoints(prize.requiredPoints) != this._prizePage)
                {
                    continue;
                }
                template = prize.premium ? this._premiumPrizeTemplate : this._prizeTemplate;
                if (template == null)
                {
                    continue;
                }
                prizeWindow = template.clone() as IWindowContainer;
                if (prizeWindow == null)
                {
                    continue;
                }
                prizeWindow.name = "prize_" + prize.id;
                center = Math.round(this._prizeLayout.xForPoints(prize.requiredPoints, this._prizePage));
                prizeWindow.x = Math.round(center - (prizeWindow.width / 2));
                prizeWindow.y = template.y;
                if (pointValues.indexOf(prize.requiredPoints) < 0)
                {
                    pointValues.push(prize.requiredPoints);
                    pointCenters.push(center);
                }
                product = prizeWindow.findChildByName("product_icon") as IWidgetWindow;
                if (product != null && product.widget is IProductIconWidget)
                {
                    IProductIconWidget(product.widget).productInfo = new RewardTrackRewardDisplayWrapper(prize);
                }
                this.configurePrizeWindow(prizeWindow, prize);
                this.setVisible(prizeWindow, "locked_icon", prize.isPremiumLocked(track));
                this.setVisible(prizeWindow, "claimed_icon", prize.claimed);
                if (prize.isClaimable(track))
                {
                    this.registerClaimTarget(prizeWindow, track.id, prize.id);
                }
                else if (prize.isPremiumLocked(track))
                {
                    this.registerPremiumTarget(prizeWindow, track);
                }
                prizeContent.addChild(prizeWindow);
                this.setPrizeDimmed(prizeWindow, !prize.hasEnoughPoints(track));
                i++;
            }
            this.populatePointIndicators(track, pointValues, pointCenters);
            this.refreshPrizeNavigation();
        }

        private function refreshPremiumInfo(track:RewardTrack):void
        {
            var button:IWindow = this._window != null ? this._window.findChildByName("get_premium_btn") : null;
            var info:IWindow = this._window != null ? this._window.findChildByName("reward_info_not_premium") : null;
            this.setVisible(this._window, "reward_info", ((!(track.hasPremiumConfig)) || (track.premium)));
            this.setVisible(this._window, "reward_info_not_premium", ((track.hasPremiumConfig) && (!(track.premium))));
            if (button != null)
            {
                button.procedure = this.onWindowEvent;
            }
            if (info != null)
            {
                info.procedure = this.onWindowEvent;
            }
        }

        private function refreshPrizeNavigation():void
        {
            var previousButton:IWindow = this._window.findChildByName("previous_btn");
            var nextButton:IWindow = this._window.findChildByName("next_btn");
            var multiPage:Boolean = (this._prizeLayout.pageCount > 1);
            if (previousButton != null)
            {
                previousButton.visible = multiPage;
                if (multiPage)
                {
                    WindowUtils.disableSection(previousButton, (this._prizePage <= 0));
                }
            }
            if (nextButton != null)
            {
                nextButton.visible = multiPage;
                if (multiPage)
                {
                    WindowUtils.disableSection(nextButton, (this._prizePage >= (this._prizeLayout.pageCount - 1)));
                }
            }
        }

        private function handlePrizeNavClick(window:IWindow):Boolean
        {
            var page:int;
            if (((window == null) || (this._currentTrack == null)))
            {
                return false;
            }
            if (window.name == "previous_btn")
            {
                page = Math.max(0, (this._prizePage - 1));
            }
            else
            {
                if (window.name == "next_btn")
                {
                    page = Math.min((this._prizeLayout.pageCount - 1), (this._prizePage + 1));
                }
                else
                {
                    return false;
                }
            }
            if (page != this._prizePage)
            {
                this._prizePage = page;
                this.populateMainProgress(this._currentTrack, false);
                this.populatePrizes(this._currentTrack);
            }
            return true;
        }

        private function populateMainProgress(track:RewardTrack, resetPage:Boolean):void
        {
            var rewards:IWindowContainer = this._window.findChildByName("rewards") as IWindowContainer;
            var trackContainer:IWindowContainer = rewards != null ? rewards.findChildByName("track") as IWindowContainer : null;
            var loadingBar:IWindowContainer = trackContainer != null ? trackContainer.findChildByName("loading_bar") as IWindowContainer : null;
            var progress:IWindowContainer = loadingBar != null ? loadingBar.findChildByName("progress") as IWindowContainer : null;
            var prizeContent:IWindowContainer = this._window.findChildByName("prize_content") as IWindowContainer;
            var maxWidth:int = loadingBar != null ? loadingBar.width : 602;
            var contentWidth:int = prizeContent != null ? prizeContent.width : maxWidth;
            this._prizeLayout.rebuild(track, contentWidth, this._prizeTemplate != null ? this._prizeTemplate.width : 80, MIN_PRIZE_SPACING);
            if (resetPage)
            {
                this._prizePage = this._prizeLayout.pageForPoints(track.points);
            }
            this._prizePage = Math.max(0, Math.min((this._prizeLayout.pageCount - 1), this._prizePage));
            var fillWidth:int = Math.round(this._prizeLayout.xForPoints(track.points, this._prizePage));
            if (progress == null)
            {
                return;
            }
            fillWidth = Math.min(maxWidth, Math.max(0, fillWidth));
            progress.width = fillWidth;
            this.resizeMainProgressChildren(progress, fillWidth, maxWidth);
        }

        private function configurePrizeWindow(prizeWindow:IWindowContainer, prize:RewardTrackPrize):void
        {
            var product:IWidgetWindow = prizeWindow.findChildByName("product_icon") as IWidgetWindow;
            var quantity:IWindow = prizeWindow.findChildByName("quantity_container");
            var quantityText:ITextWindow = prizeWindow.findChildByName("quantity_text") as ITextWindow;

            if (product != null)
            {
                product.y = prize.rewardAmount > 1 ? 5 : 8;
            }
            if (quantity != null)
            {
                quantity.visible = prize.rewardAmount > 1;
                if (prize.rewardAmount > 1 && quantityText != null)
                {
                    quantityText.caption = String(prize.rewardAmount);
                    quantityText.width = (Math.ceil(quantityText.textWidth) + 2);
                    quantityText.x = int((quantity.width - quantityText.width) / 2);
                }
            }
        }

        private function setPrizeDimmed(prizeWindow:IWindowContainer, dimmed:Boolean):void
        {
            WindowUtils.disableSection(prizeWindow, dimmed, 0.75);
        }

        private function populatePointIndicators(track:RewardTrack, pointValues:Array, pointCenters:Array):void
        {
            var pointsIndicator:IWindowContainer = this._window.findChildByName("points_indicator") as IWindowContainer;
            var marker:IWindowContainer;
            var prize:RewardTrackPrize;
            var i:int;
            var value:int;
            if (pointsIndicator == null || this._pointIndicatorTemplate == null)
            {
                return;
            }
            for (i = 0; i < pointValues.length; i++)
            {
                value = int(pointValues[i]);
                marker = this._pointIndicatorTemplate.clone() as IWindowContainer;
                if (marker == null)
                {
                    continue;
                }
                marker.name = "point_indicator_" + value;
                marker.x = int(pointCenters[i]) - int(marker.width / 2);
                marker.visible = true;
                this.setText(marker, "points_txt", String(value));
                this.setImage(marker, "available_icon", track.points >= value ? "reward_track_available_icon" : "reward_track_not_available_icon");
                prize = this.findClaimablePrizeAtPoints(track, value);
                if (prize != null)
                {
                    this.registerClaimTarget(marker, track.id, prize.id);
                }
                else if (this.findPremiumLockedPrizeAtPoints(track, value) != null)
                {
                    this.registerPremiumTarget(marker, track);
                }
                pointsIndicator.addChild(marker);
            }
        }

        private function clearPointIndicators():void
        {
            var pointsIndicator:IWindowContainer = this._window.findChildByName("points_indicator") as IWindowContainer;
            if (pointsIndicator == null)
            {
                return;
            }
            while (pointsIndicator.numChildren > 0)
            {
                pointsIndicator.removeChildAt(0).dispose();
            }
        }

        private function registerClaimTarget(window:IWindow, trackId:String, rewardId:String):void
        {
            var target:Object = {"trackId":trackId, "rewardId":rewardId};
            this.registerClaimTargetRecursive(window, target);
        }

        private function registerClaimTargetRecursive(window:IWindow, target:Object):void
        {
            var container:IWindowContainer;
            var i:int;
            if (window == null || target == null || this._claimTargets == null)
            {
                return;
            }
            this._claimTargets[window] = target;
            window.procedure = this.onWindowEvent;
            container = window as IWindowContainer;
            if (container != null)
            {
                for (i = 0; i < container.numChildren; i++)
                {
                    this.registerClaimTargetRecursive(container.getChildAt(i), target);
                }
            }
        }

        private function registerPremiumTarget(window:IWindow, track:RewardTrack):void
        {
            this.registerPremiumTargetRecursive(window, track);
        }

        private function registerPremiumTargetRecursive(window:IWindow, track:RewardTrack):void
        {
            var container:IWindowContainer;
            var i:int;
            if (window == null || track == null || this._premiumTargets == null)
            {
                return;
            }
            this._premiumTargets[window] = track;
            window.procedure = this.onWindowEvent;
            container = window as IWindowContainer;
            if (container != null)
            {
                for (i = 0; i < container.numChildren; i++)
                {
                    this.registerPremiumTargetRecursive(container.getChildAt(i), track);
                }
            }
        }

        private function setProgress(container:IWindowContainer, value:int, required:int, maxWidth:int):void
        {
            var progress:IWindowContainer = container.findChildByName("progress") as IWindowContainer;
            var ratio:Number = required <= 0 ? 0 : Math.min(1, Math.max(0, value / required));
            var fillWidth:int = required <= 0 ? 0 : int(Math.min(maxWidth, Math.max(value > 0 ? 1 : 0, (Math.min(value, required) / required) * maxWidth)));
            if (progress != null)
            {
                progress.width = fillWidth;
                this.resizeProgressChildren(progress, fillWidth);
                this.setProgressColor(progress, ratio >= 1);
            }
        }

        private function resizeProgressChildren(progress:IWindowContainer, fillWidth:int):void
        {
            var child:IWindow;
            var i:int;
            if (progress == null)
            {
                return;
            }
            for (i = 0; i < progress.numChildren; i++)
            {
                child = progress.getChildAt(i);
                if (child != null)
                {
                    child.width = Math.max(0, fillWidth - child.x);
                }
            }
        }

        private function setProgressColor(progress:IWindowContainer, complete:Boolean):void
        {
            var loadingBar:IWindow = progress.findChildByName("loading_bar");
            if (loadingBar != null)
            {
                loadingBar.color = complete ? PROGRESS_COMPLETE_COLOR : PROGRESS_INCOMPLETE_COLOR;
            }
        }

        private function resizeMainProgressChildren(progress:IWindowContainer, fillWidth:int, maxWidth:int):void
        {
            var shape:IWindow = progress.findChildByName("shape");
            var shapeWidth:int = fillWidth >= maxWidth - 4 ? maxWidth : fillWidth + 4;
            if (shape != null)
            {
                shape.width = Math.max(0, Math.min(maxWidth, shapeWidth));
            }
        }

        private function setText(container:IWindowContainer, name:String, value:String):void
        {
            var text:ITextWindow = container.findChildByName(name) as ITextWindow;
            if (text != null)
            {
                text.caption = value != null ? value : "";
            }
        }

        private function setImage(container:IWindowContainer, name:String, assetUri:String):void
        {
            var bitmap:IStaticBitmapWrapperWindow = container.findChildByName(name) as IStaticBitmapWrapperWindow;
            if (bitmap != null)
            {
                bitmap.assetUri = assetUri;
            }
        }

        private function setVisible(container:IWindowContainer, name:String, visible:Boolean):void
        {
            var window:IWindow = container.findChildByName(name);
            if (window != null)
            {
                window.visible = visible;
            }
        }

        private function setHintButton(hintKey:String):void
        {
            var button:IButtonWindow = this._window.findChildByName("hint_redirect_btn") as IButtonWindow;
            var buttonText:String = this.text(hintKey + ".button_text", "");
            this._hintInternalLink = this.text(hintKey + ".internal_link", "");
            if (button == null)
            {
                return;
            }
            button.visible = this._hintInternalLink != "" && buttonText != "";
            button.caption = buttonText;
            button.procedure = this.onWindowEvent;
        }

        private function setTaskRowStyle(row:IWindowContainer, selected:Boolean, completed:Boolean):void
        {
            var border:IWindow = row.findChildByName("task_border");
            if (border != null)
            {
                border.color = selected ? TASK_SELECTED_COLOR : (completed ? TASK_COMPLETE_COLOR : TASK_DEFAULT_COLOR);
            }
        }

        private function findClaimablePrizeAtPoints(track:RewardTrack, points:int):RewardTrackPrize
        {
            var prize:RewardTrackPrize;
            if (track == null)
            {
                return null;
            }
            for each (prize in track.prizes)
            {
                if (!prize.premium && prize.requiredPoints == points && prize.isClaimable(track))
                {
                    return prize;
                }
            }
            return null;
        }

        private function findPremiumLockedPrizeAtPoints(track:RewardTrack, points:int):RewardTrackPrize
        {
            var prize:RewardTrackPrize;
            if (track == null)
            {
                return null;
            }
            for each (prize in track.prizes)
            {
                if (prize.requiredPoints == points && prize.isPremiumLocked(track))
                {
                    return prize;
                }
            }
            return null;
        }

        private function finalLevel(task:RewardTrackTask):RewardTrackTaskLevel
        {
            return task.levels.length > 0 ? task.levels[task.levels.length - 1] as RewardTrackTaskLevel : null;
        }

        private function activeLevel(task:RewardTrackTask):RewardTrackTaskLevel
        {
            var level:RewardTrackTaskLevel;
            if (task == null)
            {
                return null;
            }
            for each (level in task.levels)
            {
                if (level != null && task.progressCount < level.requiredCount)
                {
                    return level;
                }
            }
            return this.finalLevel(task);
        }

        private function taskName(track:RewardTrack, task:RewardTrackTask):String
        {
            return this.text("reward_track." + track.id + ".task." + task.id + ".name", task.id);
        }

        private function taskDescription(track:RewardTrack, task:RewardTrackTask):String
        {
            return this.text("reward_track." + track.id + ".task." + task.id + ".desc", task.actionType);
        }

        private function taskIcon(task:RewardTrackTask):String
        {
            if (task == null || task.actionType == null || task.actionType == "")
            {
                return "reward_track_task_list";
            }
            return "reward_track_tasks_" + task.actionType.toLowerCase();
        }

        private function tasksCompletionText(track:RewardTrack):String
        {
            var task:RewardTrackTask;
            var completed:int = 0;
            for each (task in track.tasks)
            {
                if (this.isTaskComplete(task))
                {
                    completed++;
                }
            }
            return this.replaceTokens(this.text("reward_track.tasks.progress", "%completed% / %total% completed"), completed, track.tasks.length);
        }

        private function rewardsCollectedText(track:RewardTrack):String
        {
            var prize:RewardTrackPrize;
            var completed:int = 0;
            for each (prize in track.prizes)
            {
                if (prize.claimed)
                {
                    completed++;
                }
            }
            return this.replaceTokens(this.text("reward_track.profile.rewards_collected", "%completed% / %total% rewards collected"), completed, track.prizes.length);
        }

        private function levelText(level:int):String
        {
            var value:String = this.text("reward_track.levels.level", "Level %level%");
            if (value.indexOf("%level%") >= 0)
            {
                return value.split("%level%").join(String(level));
            }
            return value + " " + level;
        }

        private function replaceTokens(value:String, completed:int, total:int):String
        {
            value = value.split("%completed%").join(String(completed));
            value = value.split("%total%").join(String(total));
            return value;
        }

        private function isTaskComplete(task:RewardTrackTask):Boolean
        {
            var final:RewardTrackTaskLevel = this.finalLevel(task);
            return final != null && task.progressCount >= final.requiredCount;
        }

        private function matchesTaskFilter(task:RewardTrackTask):Boolean
        {
            if (task == null)
            {
                return false;
            }
            if (this._taskFilter == FILTER_IN_PROGRESS)
            {
                return task.progressCount > 0 && !this.isTaskComplete(task);
            }
            if (this._taskFilter == FILTER_COMPLETED)
            {
                return this.isTaskComplete(task);
            }
            return true;
        }

        private function firstVisibleTask(track:RewardTrack):RewardTrackTask
        {
            var task:RewardTrackTask;
            if (track == null)
            {
                return null;
            }
            for each (task in track.tasks)
            {
                if (this.matchesTaskFilter(task))
                {
                    return task;
                }
            }
            return null;
        }

        private function text(key:String, fallback:String):String
        {
            var value:String = this._localizations != null ? this._localizations.getLocalization(key, fallback) : fallback;
            return value != null && value != "" ? value : fallback;
        }

        private function onWindowEvent(event:WindowEvent, window:IWindow):void
        {
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (this.handleClaimClick(window))
            {
                return;
            }
            if (this.handlePremiumClick(window))
            {
                return;
            }
            if (this.handleTaskClick(window))
            {
                return;
            }
            if (this.handleTaskHintClick(window))
            {
                return;
            }
            if (this.handleTabClick(window))
            {
                return;
            }
            if (this.handlePrizeNavClick(window))
            {
                return;
            }
            if (window != null && window.tags.indexOf("close") >= 0)
            {
                this._window.visible = false;
            }
        }

        private function handleClaimClick(window:IWindow):Boolean
        {
            var target:Object;
            while (window != null)
            {
                target = this._claimTargets != null ? this._claimTargets[window] : null;
                if (target != null)
                {
                    if (this._controller != null)
                    {
                        this._controller.claimReward(target.trackId, target.rewardId);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        private function handlePremiumClick(window:IWindow):Boolean
        {
            var track:RewardTrack;
            while (window != null)
            {
                if (window.name == "get_premium_btn" || window.name == "reward_info_not_premium")
                {
                    track = this._currentTrack;
                }
                else
                {
                    track = this._premiumTargets != null ? this._premiumTargets[window] as RewardTrack : null;
                }
                if (track != null)
                {
                    if (this._controller != null)
                    {
                        this._controller.openPremiumPurchaseConfirmation(track);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        private function handleTaskClick(window:IWindow):Boolean
        {
            var task:RewardTrackTask;
            while (window != null)
            {
                task = this._taskTargets != null ? this._taskTargets[window] as RewardTrackTask : null;
                if (task != null)
                {
                    this._selectedTask = task;
                    if (this._currentTrack != null)
                    {
                        this.populateTaskList(this._currentTrack);
                        this.populateTaskDetails(this._currentTrack, task);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        private function handleTaskHintClick(window:IWindow):Boolean
        {
            while (window != null)
            {
                if (window.name == "hint_redirect_btn")
                {
                    if (this._hintInternalLink != null && this._hintInternalLink != "" && this._controller != null)
                    {
                        this._controller.openTaskHintLink(this._hintInternalLink);
                    }
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        private function initializeTabs():void
        {
            var tabs:IItemListWindow = this._window.findChildByName("tab_selection") as IItemListWindow;
            var filter:int;
            var tab:IWindow;
            this._tabTargets = new Dictionary(true);
            if (tabs == null)
            {
                return;
            }
            for (filter = 0; filter < tabs.numListItems && filter < 3; filter++)
            {
                tab = tabs.getListItemAt(filter);
                if (tab != null)
                {
                    tab.name = this.tabName(filter);
                    tab.procedure = this.onWindowEvent;
                    this._tabTargets[tab] = filter;
                }
            }
            this.refreshTabs();
        }

        private function handleTabClick(window:IWindow):Boolean
        {
            var filter:Object;
            while (window != null)
            {
                filter = this._tabTargets != null ? this._tabTargets[window] : null;
                if (filter != null)
                {
                    this.setTaskFilter(int(filter));
                    return true;
                }
                window = window.parent;
            }
            return false;
        }

        private function setTaskFilter(filter:int):void
        {
            if (filter == this._taskFilter)
            {
                return;
            }
            this._taskFilter = filter;
            if (this._currentTrack != null)
            {
                this.populateTaskList(this._currentTrack);
                if (this._selectedTask == null || !this.matchesTaskFilter(this._selectedTask))
                {
                    this._selectedTask = this.firstVisibleTask(this._currentTrack);
                }
                if (this._selectedTask != null)
                {
                    this.populateTaskDetails(this._currentTrack, this._selectedTask);
                }
                else
                {
                    this.clearTaskDetails();
                }
            }
            this.refreshTabs();
        }

        private function refreshTabs():void
        {
            var tabs:IItemListWindow = this._window != null ? this._window.findChildByName("tab_selection") as IItemListWindow : null;
            var filter:int;
            var tab:IWindowContainer;
            var active:Boolean;
            var text:ITextWindow;
            if (tabs == null)
            {
                return;
            }
            for (filter = 0; filter < tabs.numListItems && filter < 3; filter++)
            {
                tab = tabs.getListItemAt(filter) as IWindowContainer;
                if (tab == null)
                {
                    continue;
                }
                active = filter == this._taskFilter;
                this.setVisible(tab, "selected_view", active);
                this.setVisible(tab, "notselected_shape", !active);
                text = tab.findChildByName("button_text") as ITextWindow;
                if (text != null)
                {
                    text.textColor = active ? TAB_SELECTED_TEXT : TAB_NOT_SELECTED_TEXT;
                }
            }
        }

        private function tabName(filter:int):String
        {
            if (filter == FILTER_IN_PROGRESS)
            {
                return "tab_in_progress";
            }
            if (filter == FILTER_COMPLETED)
            {
                return "tab_completed";
            }
            return "tab_all";
        }
    }
}
