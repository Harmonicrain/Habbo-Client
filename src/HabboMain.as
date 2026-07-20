package
{
    import flash.display.Sprite;
    import com.sulake.core.runtime.ICore;
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;
    import com.sulake.core.Core;
    import flash.events.ProgressEvent;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.room.IRoomEngine;
    import flash.system.Capabilities;
    import com.sulake.core.runtime.ICoreErrorLogger;
    import flash.external.ExternalInterface;
    import com.sulake.core.runtime.IID;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.habbo.room.events.RoomEngineEvent;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;

    public class HabboMain extends Sprite
    {
        public static const CORE_RATIO:Number = Habbo.CORE_RATIO; // 0.6
        private static const INIT_STEPS:int = 3;

        private var _core:ICore;
        private var _loadingScreen:IHabboLoadingScreen;
        private var _totalSteps:int = 3;
        private var _loadedFiles:int = 0;
        private var _completedInitSteps:int = 0;
        private var roomEngineReady:Boolean = false;
        private var coreRunning:Boolean = false;
        private var _prepareCoreOnNextFrame:Boolean = true;
        private var _corePrepared:Boolean = false;
        private var _startupErrorShown:Boolean = false;
        private var _disposed:Boolean = false;

        public function HabboMain(k:IHabboLoadingScreen)
        {
            this._loadingScreen = k;
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.EXIT_FRAME, this.onExitFrame);
            Logger.log(((getQualifiedClassName(Core) + " version: ") + Core.version));
        }

        private function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            removeEventListener(ProgressEvent.PROGRESS, this.onProgressEvent);
            removeEventListener(Event.COMPLETE, this.onCompleteEvent);
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            removeEventListener(Event.EXIT_FRAME, this.onExitFrame);
            if (this._loadingScreen)
            {
                this._loadingScreen.dispose();
                this._loadingScreen = null;
            }
            if (this._core != null && !this._core.disposed && this._core.events != null)
            {
                this._core.events.removeEventListener(Component.COMPONENT_EVENT_RUNNING, this.onCoreRunning);
            }
            this._core = null;
            if (parent)
            {
                try
                {
                    parent.removeChild(this);
                }
                catch (e:Error)
                {
                }
            }
        }

        public function disposeForReload():void
        {
            this.dispose();
        }

        public function unloading():void
        {
            try
            {
                if (((this._core) && (!(this._core.disposed))))
                {
                    ErrorReportStorage.addDebugData("Unload", "Client unloading started");
                    this._core.events.dispatchEvent(new Event(Event.UNLOAD));
                }
            }
            catch (error:Error)
            {
            }
        }

        protected function onAddedToStage(event:Event = null):void
        {
            this._prepareCoreOnNextFrame = true;
        }

        protected function onExitFrame(k:Event = null):void
        {
            if (this._prepareCoreOnNextFrame)
            {
                this._prepareCoreOnNextFrame = false;
                try
                {
                    this.prepareCore();
                }
                catch (error:Error)
                {
                    Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CORE_FAIL);
                    Habbo.trackLoginStep(error.message);
                    Habbo.reportCrash(("Failed to prepare the core: " + error.message), Core.ERROR_CATEGORY_INITIALIZE_CORE, true, error);
                    Core.dispose();
                }
                return;
            }
            if (((this.coreRunning) && (this.roomEngineReady)))
            {
                this.dispose();
            }
        }

        private function prepareCore():void
        {
            if (this._corePrepared)
            {
                return;
            }
            this._corePrepared = true;
            try
            {
                var k:ICoreErrorLogger = HabboWebTools.isAirDesktop ? new HabboAirCoreErrorReporter() : ((Capabilities.playerType != "StandAlone") ? new HabboCoreErrorReporter() : null);
                this._core = Core.instantiate(stage, Core.CORE_SETUP_FRAME_UPDATE_COMPLEX, k);
                this._core.prepareComponent(HabboTrackingLib);
                addEventListener(ProgressEvent.PROGRESS, this.onProgressEvent);
                addEventListener(Event.COMPLETE, this.onCompleteEvent);
                var assetBase:String = "";
                assetBase = HabboWebTools.getParameter("flash.client.url");
                if (assetBase == null)
                    assetBase = "";
                var _local_2:XML = <config>
				<asset-libraries>
					<library url={assetBase + "hh_human_body.swf"}/>
					<library url={assetBase + "hh_human_item.swf"}/>
				</asset-libraries>
				<service-libraries/>
				<component-libraries/>
			</config>
            ;
                this._core.readConfigDocument(_local_2, this);
                this._totalSteps = ((this._core.getNumberOfFilesPending() + this._core.getNumberOfFilesLoaded()) + INIT_STEPS);
                this._core.prepareComponent(CoreCommunicationFrameworkLib);
                this._core.prepareComponent(HabboRoomObjectLogicLib);
                this._core.prepareComponent(HabboRoomObjectVisualizationLib);
                this._core.prepareComponent(RoomManagerLib);
                this._core.prepareComponent(RoomSpriteRendererLib);
                this._core.prepareComponent(HabboRoomSessionManagerLib);
                this._core.prepareComponent(HabboAvatarRenderLib);
                this._core.prepareComponent(HabboSessionDataManagerLib);
                this._core.prepareComponent(HabboConfigurationCom);
                this._core.prepareComponent(HabboLocalizationCom);
                this._core.prepareComponent(HabboWindowManagerCom);
                this._core.prepareComponent(HabboCommunicationCom);
                this._core.prepareComponent(HabboCommunicationDemoCom);
                this._core.prepareComponent(HabboNavigatorCom);
                this._core.prepareComponent(HabboFriendListCom);
                this._core.prepareComponent(HabboMessengerCom);
                this._core.prepareComponent(HabboInventoryCom);
                this._core.prepareComponent(HabboToolbarCom);
                this._core.prepareComponent(HabboCatalogCom);
                this._core.prepareComponent(HabboRoomEngineCom);
                this._core.prepareComponent(HabboRoomUICom);
                this._core.prepareComponent(HabboAvatarEditorCom);
                this._core.prepareComponent(HabboNotificationsCom);
                this._core.prepareComponent(HabboHelpCom);
                this._core.prepareComponent(HabboAdManagerCom);
                this._core.prepareComponent(HabboModerationCom);
                this._core.prepareComponent(HabboUserDefinedRoomEventsCom);
                this._core.prepareComponent(HabboSoundManagerFlash10Com);
                this._core.prepareComponent(HabboQuestEngineCom);
                this._core.prepareComponent(HabboFriendBarCom);
                this._core.prepareComponent(HabboGroupsCom);
                this._core.prepareComponent(HabboGamesCom);
                this._core.prepareComponent(HabboFreeFlowChatCom);
                this._core.prepareComponent(HabboNewNavigatorCom);
                this.addInitializationProgressListeners();
                Habbo.trackLoginStep("addInitializationProgressListeners");
            }
            catch (error:Error)
            {
                Habbo.trackLoginStep("Error in HabboMain (" + error.message + "): " + error.getStackTrace());
                if (HabboWebTools.isAirDesktop)
                {
                    HabboWebTools.showAirError("Client startup error", "The client could not finish preparing required files.", error.message + " | " + error.getStackTrace());
                }
            }
        }

        private function updateProgressBar():void
        {
            var k:Number;
            if (this._loadingScreen != null)
            {
                k = (CORE_RATIO + (((this._completedInitSteps + this._loadedFiles) / this._totalSteps) * (1 - CORE_RATIO)));
                if (k > 1)
                    k = 1;
                this._loadingScreen._Str_774(k);
            }
        }

        private function onProgressEvent(k:ProgressEvent):void
        {
            this._loadedFiles = this._core.getNumberOfFilesLoaded();
            this.updateProgressBar();
        }

        private function onCompleteEvent(k:Event):void
        {
            removeEventListener(ProgressEvent.PROGRESS, this.onProgressEvent);
            removeEventListener(Event.COMPLETE, this.onCompleteEvent);
            this.initializeCore();
        }

        private function initializeCore():void
        {
            Habbo.trackLoginStep("Initializing Core!");
            try
            {
                this._core.initialize();
                if (ExternalInterface.available)
                {
                    ExternalInterface.addCallback("unloading", this.unloading);
                }
            }
            catch (error:Error)
            {
                Habbo.trackLoginStep(error.getStackTrace());
                Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CORE_FAIL);
                Core.crash(("Failed to initialize the core: " + error.message), Core.ERROR_CATEGORY_INITIALIZE_CORE, error);
            }
        }

        private function simpleQueueInterface(k:IID, _arg_2:Function):void
        {
            var _local_3:Object = this._core.queueInterface(k, _arg_2);
            if (_local_3 != null)
            {
                (_arg_2(k, _local_3));
            }
        }

        private function addInitializationProgressListeners():void
        {
            this.simpleQueueInterface(new IIDHabboLocalizationManager(), function(k:IID, _arg_2:Component):void
                {
                    _arg_2.events.addEventListener(Event.COMPLETE, onLocalizationComplete);
                });
            this.simpleQueueInterface(new IIDHabboConfigurationManager(), this.onConfigurationComplete);
            this.simpleQueueInterface(new IIDRoomEngine(), function(k:IID, _arg_2:Component):void
                {
                    var roomEngine:IRoomEngine = _arg_2 as IRoomEngine;
                    _arg_2.events.addEventListener(RoomEngineEvent.ENGINE_INITIALIZED, onRoomEngineReady);
                    if (((roomEngine != null) && (roomEngine.isInitialized)))
                    {
                        onRoomEngineReady(null);
                    }
                });
            this._core.events.addEventListener(Component.COMPONENT_EVENT_RUNNING, this.onCoreRunning);
        }

        private function onLocalizationComplete(k:Event):void
        {
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_LOCALIZATION_LOADED);
            this._completedInitSteps++;
            this.updateProgressBar();
        }

        private function onConfigurationComplete(k:IID, _arg_2:Component):void
        {
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CONFIG_LOADED);
            this._completedInitSteps++;
            this.updateProgressBar();
        }

        private function onRoomEngineReady(k:Event):void
        {
            if (this.roomEngineReady)
            {
                return;
            }
            this.roomEngineReady = true;
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_ROOM_READY);
            if (this._core.getInteger("spaweb", 0) == 1)
            {
                this.startSendingHeartBeat();
            }
        }

        private function startSendingHeartBeat():void
        {
            this.sendHeartBeat();
            setInterval(this.sendHeartBeat, 10000);
        }

        private function startAirStartupWatchdog():void
        {
            if (!HabboWebTools.isAirDesktop)
            {
                return;
            }
            setTimeout(this.checkAirStartupProgress, 12000);
        }

        private function checkAirStartupProgress():void
        {
            var details:String;
            if (!HabboWebTools.isAirDesktop || HabboWebTools.airLoginScreenVisible || this._startupErrorShown || this._disposed)
            {
                return;
            }
            if (this.coreRunning || this._completedInitSteps >= INIT_STEPS)
            {
                return;
            }
            this._startupErrorShown = true;
            details = "Client files URL: " + HabboWebTools.getParameter("flash.client.url");
            details += "\nVariables URL: " + HabboWebTools.getParameter("external.variables.txt");
            details += "\nTexts URL: " + HabboWebTools.getParameter("external.texts.txt");
            details += "\nProgress: loaded files " + this._loadedFiles + "/" + this._totalSteps + ", startup steps " + this._completedInitSteps + "/" + INIT_STEPS;
            HabboWebTools.showAirError("Startup files are not loading", "NGHWin is waiting for files from your configured base.url, but startup has not finished. Make sure config.ini points to the correct web folder and that the Gordon files are reachable in a browser.", details);
        }

        private function sendHeartBeat():void
        {
            HabboWebTools.sendHeartBeat();
        }

        private function onCoreRunning(k:Event):void
        {
            this.coreRunning = true;
            Habbo.trackLoginStep(ClientEnum.CLIENT_INIT_CORE_RUNNING);
            this._completedInitSteps++;
            this.updateProgressBar();
        }
    }
}
import com.sulake.core.runtime.ICoreErrorLogger;
import com.sulake.habbo.utils.HabboWebTools;

class HabboCoreErrorReporter implements ICoreErrorLogger
{

    public function logError(k:String, _arg_2:Boolean, _arg_3:int = -1, _arg_4:Error = null):void
    {
        Habbo.reportCrash(k, _arg_3, _arg_2, _arg_4);
    }

}

class HabboAirCoreErrorReporter implements ICoreErrorLogger
{
    public function logError(k:String, _arg_2:Boolean, _arg_3:int = -1, _arg_4:Error = null):void
    {
        var url:String = this.extractQuotedUrl(k);
        var details:String = (url != null) ? ("Missing or unreachable file: " + url) : ("Technical error: " + k);
        if (HabboWebTools.airLoginAttemptActive)
        {
            HabboWebTools.airDebug("CORE ERROR DURING LOGIN: " + k);
            HabboWebTools.showAirLoginError("Could not connect to the hotel server. Make sure the server is running and that connection.info.host / connection.info.port are correct.");
            return;
        }
        details += " | Category: " + _arg_3;
        if (_arg_4 != null)
        {
            details += " | " + _arg_4.getStackTrace();
        }
        HabboWebTools.showAirError("Required files could not load", "NGHWin could not download files it needs to start. Check config.ini, especially base.url and gordon.path, then confirm the shown file opens in your browser.", details);
    }

    private function extractQuotedUrl(value:String):String
    {
        var start:int;
        var end:int;
        if (value == null)
        {
            return null;
        }
        start = value.indexOf("\"http");
        if (start < 0)
        {
            return null;
        }
        start++;
        end = value.indexOf("\"", start);
        if (end < 0)
        {
            return null;
        }
        return value.substring(start, end);
    }
}
