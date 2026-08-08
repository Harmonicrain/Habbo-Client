package com.sulake.habbo.roomevents
{
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesDiffMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesHashMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.RequestAllVariablesHashMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.RequestVariablesDiffMessageComposer;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.AllVariablesDiffMessageParser;
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    /**
     * Room-scoped July variable hash/diff cache.
     *
     * The capability gate is deliberately checked at the send boundary: a clean
     * client connected to a legacy or partially upgraded server emits no variable
     * synchronization packets.
     */
    public class WiredVariablesSynchronizer implements IDisposable
    {
        public static const STATUS_IDLE:int = 0;
        public static const STATUS_AWAIT_HASH:int = 1;
        public static const STATUS_AWAIT_DIFFS:int = 2;

        private static const REQUEST_THROTTLE_MS:int = 800;
        private static const STALE_REQUEST_MS:int = 4000;
        private static const REQUEST_TIMEOUT_MS:int = 10000;
        private static const MAX_CACHED_VARIABLES:int = 4096;
        private static const FURNI_INTERNAL_ORDER:Array = [
            "@id", "@class_id", "@height", "@state",
            "@position.x", "@position.y", "@rotation", "@altitude",
            "@type", "@dimensions.x", "@dimensions.y", "@owner_id",
            "@is_invisible", "@is_stackable", "@can_stand_on",
            "@can_sit_on", "@can_lay_on",
            "@projectile.animation.tiles_travelled",
            "@projectile.animation.user_collisions",
            "@projectile.animation.furni_collisions",
            "@projectile.animation.position.x",
            "@projectile.animation.position.y",
            "@projectile.animation.position.altitude",
            "@projectile.animation.is_travelling"
        ];
        private static const USER_INTERNAL_ORDER:Array = [
            "@index", "@type", "@gender", "@achievement_score", "@is_hc",
            "@has_rights", "@is_group_admin", "@is_owner",
            "@position.x", "@position.y", "@direction", "@altitude",
            "@handitem", "@effect", "@dance", "@sign", "@is_muted",
            "@is_trading", "@is_idle", "@user_id", "@pet_id", "@bot_id",
            "@favourite_group_id", "@team.score", "@team.color"
        ];
        private static const GLOBAL_INTERNAL_ORDER:Array = [
            "@furni_count", "@user_count", "@wired_timer",
            "@teams.red.score", "@teams.red.size",
            "@teams.green.score", "@teams.green.size",
            "@teams.blue.score", "@teams.blue.size",
            "@teams.yellow.score", "@teams.yellow.size",
            "@room_id", "@group_id", "@current_time",
            "@current_time.milliseconds_of_seconds",
            "@current_time.seconds_of_minute",
            "@current_time.minute_of_hour", "@current_time.hour_of_day",
            "@current_time.day_of_week", "@current_time.day_of_month",
            "@current_time.day_of_year", "@current_time.week_of_year",
            "@current_time.month_of_year", "@current_time.year"
        ];
        private static const CONTEXT_INTERNAL_ORDER:Array = [
            "@selector_furni_count", "@selector_user_count",
            "@signal_furni_count", "@signal_user_count",
            "@event.signal.antenna_id",
            "@event.chat.type", "@event.chat.style",
            "@event.variable_update.box_id",
            "@event.variable_update.change_type",
            "@event.variable_update.old_value",
            "@event.variable_update.new_value",
            "@event.variable_update.difference",
            "@event.variable_update.change_origin",
            "@event.transaction_complete.multiplier",
            "@event.transaction_complete.deposit.furni_count",
            "@event.transaction_complete.deposit.coins_count",
            "@event.transaction_complete.withdrawal.furni_count",
            "@event.transaction_complete.withdrawal.coins_count",
            "@event.transaction_failed.reason",
            "@held_down", "@held_down.total_duration_ticks",
            "@held_down.origin_type", "@held_down.origin_id",
            "@held_down.origin_x", "@held_down.origin_y",
            "@held_down.origin_valid", "@held_down.release_type",
            "@held_down.release_id", "@held_down.release_x",
            "@held_down.release_y"
        ];

        private var _roomEvents:HabboUserDefinedRoomEvents;
        private var _messageEvents:Array;
        private var _timeout:Timer;
        private var _status:int = STATUS_IDLE;
        private var _lastActivityAt:Number = -1;
        private var _requestRoomId:int;
        private var _allVariablesHash:int;
        private var _pendingAllVariablesHash:int;
        private var _receivedDiffChunk:Boolean;
        private var _variablesById:Dictionary;
        private var _variableHashesById:Dictionary;
        private var _stagedVariablesById:Dictionary;
        private var _stagedHashesById:Dictionary;
        private var _listeners:Vector.<Function> = new Vector.<Function>();
        private var _disposed:Boolean;

        public function WiredVariablesSynchronizer(k:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = k;
            this._messageEvents = [];
            this._messageEvents.push(this._roomEvents.communication.addHabboConnectionMessageEvent(
                new AllVariablesHashMessageEvent(this.onAllVariablesHashEvent)));
            this._messageEvents.push(this._roomEvents.communication.addHabboConnectionMessageEvent(
                new AllVariablesDiffMessageEvent(this.onAllVariablesDiffEvent)));
            this._timeout = new Timer(REQUEST_TIMEOUT_MS, 1);
            this._timeout.addEventListener(TimerEvent.TIMER_COMPLETE, this.onRequestTimeout);
        }

        /**
         * Calls k with a sorted Vector.<WiredVariable>. Returns true when the
         * callback was completed synchronously from cache (or fail-closed).
         */
        public function getAllVariables(k:Function, forceRefresh:Boolean=true,
                                        knownAggregateHash:int=0):Boolean
        {
            if (this._disposed || k == null)
            {
                return true;
            }
            if (!this.canSynchronize())
            {
                k(new Vector.<WiredVariable>());
                return true;
            }

            var now:int = getTimer();
            if (this._status != STATUS_IDLE && this._lastActivityAt < now - STALE_REQUEST_MS)
            {
                this.abortPending(true);
            }
            if (this._status != STATUS_IDLE)
            {
                this.addListener(k);
                return false;
            }
            if (this._lastActivityAt > now - REQUEST_THROTTLE_MS)
            {
                k(this.sortedCachedVariables);
                return true;
            }
            if (!forceRefresh && this._variablesById != null)
            {
                k(this.sortedCachedVariables);
                return true;
            }

            this._requestRoomId = this._roomEvents.roomId;
            this._lastActivityAt = now;
            this._status = STATUS_AWAIT_HASH;
            this.addListener(k);
            this.startTimeout();
            if (knownAggregateHash != 0)
            {
                this.onAllVariablesHash(knownAggregateHash);
            }
            else
            {
                this._roomEvents.send(new RequestAllVariablesHashMessageComposer());
            }
            return false;
        }

        public function getCachedVariableById(k:String):WiredVariable
        {
            return this._variablesById == null ? null : this._variablesById[k] as WiredVariable;
        }

        private function onAllVariablesHashEvent(k:IMessageEvent):void
        {
            this.onAllVariablesHash((k as AllVariablesHashMessageEvent).getParser().allVariablesHash);
        }

        private function onAllVariablesHash(k:int):void
        {
            if (!this.isCurrentRequest(STATUS_AWAIT_HASH))
            {
                return;
            }
            this._lastActivityAt = getTimer();
            if (k == this._allVariablesHash && this._variablesById != null)
            {
                this.completePending();
                return;
            }

            this._pendingAllVariablesHash = k;
            this._receivedDiffChunk = false;
            this._stagedVariablesById = this.cloneDictionary(this._variablesById);
            this._stagedHashesById = this.cloneDictionary(this._variableHashesById);
            this._status = STATUS_AWAIT_DIFFS;
            this._roomEvents.send(new RequestVariablesDiffMessageComposer(this._variableHashesById));
        }

        private function onAllVariablesDiffEvent(k:IMessageEvent):void
        {
            if (!this.isCurrentRequest(STATUS_AWAIT_DIFFS))
            {
                return;
            }
            var parser:AllVariablesDiffMessageParser =
                (k as AllVariablesDiffMessageEvent).getParser();
            // The catalog may change between the hash request and the following
            // diff request; AIR's diff request carries no expected aggregate
            // hash. Accept the first chunk's current hash, then require every
            // remaining chunk in that response stream to use the same snapshot.
            if (this._receivedDiffChunk &&
                parser.allVariablesHash != this._pendingAllVariablesHash)
            {
                this.abortPending(true);
                return;
            }
            this._pendingAllVariablesHash = parser.allVariablesHash;
            this._receivedDiffChunk = true;

            this._lastActivityAt = getTimer();
            for each (var removedId:String in parser.removedVariables)
            {
                delete this._stagedVariablesById[removedId];
                delete this._stagedHashesById[removedId];
            }
            for (var variableObject:Object in parser.addedOrUpdated)
            {
                var variable:WiredVariable = variableObject as WiredVariable;
                this._stagedVariablesById[variable.variableId] = variable;
                this._stagedHashesById[variable.variableId] = int(parser.addedOrUpdated[variableObject]);
            }
            if (this.dictionarySize(this._stagedVariablesById) > MAX_CACHED_VARIABLES)
            {
                this.abortPending(true);
                return;
            }

            if (parser.isLastChunk)
            {
                this._variablesById = this._stagedVariablesById;
                this._variableHashesById = this._stagedHashesById;
                this._allVariablesHash = this._pendingAllVariablesHash;
                this.completePending();
            }
        }

        private function isCurrentRequest(k:int):Boolean
        {
            if (this._status != k || !this.canSynchronize() ||
                this._requestRoomId != this._roomEvents.roomId)
            {
                if (this._status != STATUS_IDLE)
                {
                    this.abortPending(false);
                }
                return false;
            }
            return true;
        }

        private function canSynchronize():Boolean
        {
            return this._roomEvents != null && this._roomEvents.roomId > 0 &&
                this._roomEvents.isWiredFeatureEnabled(
                    WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC);
        }

        private function addListener(k:Function):void
        {
            if (this._listeners.indexOf(k) == -1)
            {
                this._listeners.push(k);
            }
        }

        public function removeListener(k:Function):void
        {
            if (this._listeners == null)
            {
                return;
            }
            var index:int = this._listeners.indexOf(k);
            if (index != -1)
            {
                this._listeners.removeAt(index);
            }
        }

        private function completePending():void
        {
            this.stopTimeout();
            this._status = STATUS_IDLE;
            this._requestRoomId = 0;
            this._pendingAllVariablesHash = 0;
            this._receivedDiffChunk = false;
            this._stagedVariablesById = null;
            this._stagedHashesById = null;
            this.releaseListeners(this.sortedCachedVariables);
        }

        private function abortPending(useCache:Boolean):void
        {
            this.stopTimeout();
            this._status = STATUS_IDLE;
            this._requestRoomId = 0;
            this._pendingAllVariablesHash = 0;
            this._receivedDiffChunk = false;
            this._stagedVariablesById = null;
            this._stagedHashesById = null;
            this.releaseListeners(useCache ? this.sortedCachedVariables : new Vector.<WiredVariable>());
        }

        private function releaseListeners(k:Vector.<WiredVariable>):void
        {
            var listeners:Vector.<Function> = this._listeners;
            this._listeners = new Vector.<Function>();
            for each (var listener:Function in listeners)
            {
                try
                {
                    listener(k.concat());
                }
                catch (error:Error)
                {
                }
            }
        }

        private function startTimeout():void
        {
            this._timeout.reset();
            this._timeout.start();
        }

        private function stopTimeout():void
        {
            if (this._timeout != null)
            {
                this._timeout.reset();
            }
        }

        private function onRequestTimeout(k:TimerEvent):void
        {
            if (this._status != STATUS_IDLE)
            {
                this.abortPending(true);
            }
        }

        private function get sortedCachedVariables():Vector.<WiredVariable>
        {
            var result:Vector.<WiredVariable> = new Vector.<WiredVariable>();
            if (this._variablesById != null)
            {
                for each (var variable:WiredVariable in this._variablesById)
                {
                    result.push(variable);
                }
            }
            result.sort(this.compareVariables);
            return result;
        }

        private function compareVariables(a:WiredVariable, b:WiredVariable):int
        {
            var aInternal:Boolean = a.variableType == 1;
            var bInternal:Boolean = b.variableType == 1;
            if (aInternal != bInternal)
            {
                return aInternal ? 1 : -1;
            }
            if (aInternal)
            {
                var aId:Number = Number(a.variableId);
                var bId:Number = Number(b.variableId);
                if (!isNaN(aId) && !isNaN(bId))
                {
                    if (aId == bId)
                    {
                        return 0;
                    }
                    return aId > bId ? -1 : 1;
                }
                var aRank:int = this.internalVariableRank(a);
                var bRank:int = this.internalVariableRank(b);
                if (aRank != bRank)
                {
                    return aRank < bRank ? -1 : 1;
                }
                return a.variableName.localeCompare(b.variableName);
            }
            return a.variableName.localeCompare(b.variableName);
        }

        /**
         * July's official internal IDs are numeric and are ordered above.
         * Our capture-safe emulation keeps opaque string IDs, so use the same
         * semantic registry order instead of passing NaN to the comparator.
         */
        private function internalVariableRank(variable:WiredVariable):int
        {
            var order:Array;
            switch (variable.variableTarget)
            {
                case 0:
                    order = FURNI_INTERNAL_ORDER;
                    break;
                case 1:
                    order = USER_INTERNAL_ORDER;
                    break;
                case -10:
                    order = GLOBAL_INTERNAL_ORDER;
                    break;
                case -20:
                    order = CONTEXT_INTERNAL_ORDER;
                    break;
                default:
                    return int.MAX_VALUE;
            }
            var rank:int = order.indexOf(variable.variableName);
            return rank < 0 ? int.MAX_VALUE : rank;
        }

        private function cloneDictionary(k:Dictionary):Dictionary
        {
            var result:Dictionary = new Dictionary();
            if (k != null)
            {
                for (var key:Object in k)
                {
                    result[key] = k[key];
                }
            }
            return result;
        }

        private function dictionarySize(k:Dictionary):int
        {
            var count:int = 0;
            for (var key:Object in k)
            {
                count++;
                if (count > MAX_CACHED_VARIABLES)
                {
                    break;
                }
            }
            return count;
        }

        /** Stops room-scoped work, clears cache and releases every waiter. */
        public function clear():void
        {
            this.stopTimeout();
            this._status = STATUS_IDLE;
            this._requestRoomId = 0;
            this._allVariablesHash = 0;
            this._pendingAllVariablesHash = 0;
            this._receivedDiffChunk = false;
            this._lastActivityAt = -1;
            this._variablesById = null;
            this._variableHashesById = null;
            this._stagedVariablesById = null;
            this._stagedHashesById = null;
            this.releaseListeners(new Vector.<WiredVariable>());
        }

        public function dispose():void
        {
            if (this._disposed)
            {
                return;
            }
            this.clear();
            this._disposed = true;
            if (this._timeout != null)
            {
                this._timeout.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onRequestTimeout);
                this._timeout = null;
            }
            for each (var event:IMessageEvent in this._messageEvents)
            {
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
            }
            this._messageEvents = null;
            this._listeners = null;
            this._roomEvents = null;
        }

        public function get status():int { return this._status; }
        public function get disposed():Boolean { return this._disposed; }
    }
}
