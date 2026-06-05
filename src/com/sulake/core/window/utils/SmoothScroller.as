package com.sulake.core.window.utils
{
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    public class SmoothScroller
    {
        public static const DEFAULT_SCROLL_STEP:Number = 25;

        private static const DEFAULT_MAX_DURATION_MS:Number = 200;
        private static const INVERSE_DELTA_RAMP_START_PX:Number = 120;
        private static const INVERSE_DELTA_RAMP_END_PX:Number = 480;
        private static const INVERSE_DELTA_MIN_DURATION_SCALE:Number = 0.5;
        private static const VELOCITY_BOUND_FUDGE:Number = 2.5;
        private static const CURVE_EPSILON:Number = 0.01;
        private static const CURVE_X1:Number = 0.42;
        private static const CURVE_X2:Number = 0.58;
        private static const CURVE_Y2:Number = 1;
        private static const MAX_SLOPE:Number = 1000;
        private static const NEWTON_ITERATIONS:int = 4;
        private static const BINARY_SEARCH_ITERATIONS:int = 8;

        private var _getPosition:Function;
        private var _setPosition:Function;
        private var _getMaxScroll:Function;
        private var _onComplete:Function;
        private var _scrollStep:Number = DEFAULT_SCROLL_STEP;
        private var _duration:Number = DEFAULT_MAX_DURATION_MS;
        private var _minDuration:Number = 100;
        private var _normalizeToMaxScroll:Boolean = true;
        private var _clampToBounds:Boolean = true;
        private var _timer:Timer;
        private var _timerInterval:Number = 1000 / 60;
        private var _startPosition:Number = 0;
        private var _targetPosition:Number = 0;
        private var _startTime:Number = 0;
        private var _endTime:Number = 0;
        private var _curveControlY1:Number = 0;

        public function SmoothScroller(getPosition:Function, setPosition:Function, getMaxScroll:Function, duration:Number=DEFAULT_MAX_DURATION_MS, frameRate:int=60, normalizeToMaxScroll:Boolean=true, onComplete:Function=null, scrollStep:Number=NaN, clampToBounds:Boolean=true)
        {
            super();
            if (!isNaN(scrollStep))
            {
                this._scrollStep = scrollStep;
            }
            this.duration = duration;
            this._normalizeToMaxScroll = normalizeToMaxScroll;
            this._clampToBounds = clampToBounds;
            this._onComplete = onComplete;
            this._getPosition = getPosition;
            this._setPosition = setPosition;
            this._getMaxScroll = getMaxScroll;
            this._timer = new Timer(this._timerInterval = int(1000 / frameRate));
            this._timer.addEventListener(TimerEvent.TIMER, this.updateScrolling);
        }

        private static function getBezierValue(k:Number, x1:Number, y1:Number, x2:Number, y2:Number):Number
        {
            k = clamp(k, 0, 1);
            var t:Number = solveCurveTForX(k, x1, x2);
            return sampleCurve(t, y1, y2);
        }

        private static function getBezierSlope(k:Number, x1:Number, y1:Number, x2:Number, y2:Number):Number
        {
            k = clamp(k, 0, 1);
            var t:Number = solveCurveTForX(k, x1, x2);
            var dx:Number = sampleCurveDerivative(t, x1, x2);
            if (Math.abs(dx) < CURVE_EPSILON)
            {
                return 0;
            }
            return sampleCurveDerivative(t, y1, y2) / dx;
        }

        private static function solveCurveTForX(k:Number, x1:Number, x2:Number):Number
        {
            var i:int;
            var x:Number;
            var slope:Number;
            var t:Number = k;
            for (i = 0; i < NEWTON_ITERATIONS; i++)
            {
                x = sampleCurve(t, x1, x2) - k;
                if (Math.abs(x) < CURVE_EPSILON)
                {
                    return t;
                }
                slope = sampleCurveDerivative(t, x1, x2);
                if (Math.abs(slope) < CURVE_EPSILON)
                {
                    break;
                }
                t = t - (x / slope);
            }
            var low:Number = 0;
            var high:Number = 1;
            t = k;
            for (i = 0; i < BINARY_SEARCH_ITERATIONS; i++)
            {
                x = sampleCurve(t, x1, x2);
                if (Math.abs(x - k) < CURVE_EPSILON)
                {
                    return t;
                }
                if (x > k)
                {
                    high = t;
                }
                else
                {
                    low = t;
                }
                t = (high + low) * 0.5;
            }
            return t;
        }

        private static function sampleCurve(k:Number, c1:Number, c2:Number):Number
        {
            return (((getCurveA(c1, c2) * k) + getCurveB(c1, c2)) * k + getCurveC(c1)) * k;
        }

        private static function sampleCurveDerivative(k:Number, c1:Number, c2:Number):Number
        {
            return ((3 * getCurveA(c1, c2) * k * k) + (2 * getCurveB(c1, c2) * k) + getCurveC(c1));
        }

        private static function getCurveA(c1:Number, c2:Number):Number
        {
            return (1 - (3 * c2) + (3 * c1));
        }

        private static function getCurveB(c1:Number, c2:Number):Number
        {
            return ((3 * c2) - (6 * c1));
        }

        private static function getCurveC(c1:Number):Number
        {
            return (3 * c1);
        }

        private static function clamp(k:Number, min:Number, max:Number):Number
        {
            if (k < min)
            {
                return min;
            }
            if (k > max)
            {
                return max;
            }
            return k;
        }

        public function dispose():void
        {
            this.stop();
            if (this._timer != null)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.updateScrolling);
                this._timer = null;
            }
            this._getPosition = null;
            this._setPosition = null;
            this._getMaxScroll = null;
            this._onComplete = null;
        }

        public function get duration():Number
        {
            return this._duration;
        }

        public function set duration(k:Number):void
        {
            if (!isFinite(k) || k <= 0)
            {
                k = DEFAULT_MAX_DURATION_MS;
            }
            this._duration = k;
            this._minDuration = k * INVERSE_DELTA_MIN_DURATION_SCALE;
        }

        public function get isScrolling():Boolean
        {
            return (this._timer != null) && this._timer.running;
        }

        public function adjustStartPosition(k:Number):void
        {
            if (!this.isScrolling || !isFinite(k) || k == 0)
            {
                return;
            }
            this._startPosition = this.clampPosition(this._startPosition + k);
            this._targetPosition = this.clampPosition(this._targetPosition + k);
        }

        public function scrollWithWheel(k:Number):Boolean
        {
            return this.scrollBySteps(k);
        }

        public function scrollBySteps(k:Number):Boolean
        {
            if (!isFinite(k) || k == 0)
            {
                return false;
            }
            var maxScroll:Number = this.getMaxScroll();
            if (this._normalizeToMaxScroll && (!isFinite(maxScroll) || maxScroll <= 0))
            {
                this.stop();
                return false;
            }
            var delta:Number = this.wheelDeltaToScrollDelta(k, maxScroll);
            if (!isFinite(delta) || delta == 0)
            {
                return false;
            }
            var now:Number = getTimer();
            var current:Number = this.getPosition();
            var target:Number = this.clampPosition((this.isScrolling ? this._targetPosition : current) + delta);
            if ((Math.abs(target - current) < CURVE_EPSILON) && (!this.isScrolling || Math.abs(target - this._targetPosition) < CURVE_EPSILON))
            {
                if (target != current)
                {
                    this.setPosition(target);
                    this.stop();
                    return true;
                }
                this.stop();
                return false;
            }
            if (this.isScrolling)
            {
                this.updateTarget(now, target);
            }
            else
            {
                this.startAnimation(now, current, target);
            }
            if (this._endTime <= this._startTime)
            {
                this.complete();
                return false;
            }
            this._timer.reset();
            this._timer.start();
            this.applyPositionAt(now + this._timerInterval);
            return true;
        }

        public function stop():void
        {
            this.stopInternal(false);
        }

        public function complete():void
        {
            if (this._endTime > this._startTime)
            {
                this.setPosition(this.clampPosition(this._targetPosition));
            }
            this.stopInternal(true);
        }

        private function stopInternal(complete:Boolean):void
        {
            if (this._timer == null)
            {
                return;
            }
            var wasRunning:Boolean = this._timer.running;
            this._timer.reset();
            this._startTime = 0;
            this._endTime = 0;
            this._startPosition = 0;
            this._targetPosition = 0;
            this._curveControlY1 = 0;
            if (complete && wasRunning && this._onComplete != null)
            {
                this._onComplete();
            }
        }

        private function startAnimation(now:Number, start:Number, target:Number):void
        {
            this._startPosition = this.clampPosition(start);
            this._targetPosition = this.clampPosition(target);
            this._curveControlY1 = 0;
            this._startTime = now;
            this._endTime = now + this.getInverseDeltaDurationMs(this._targetPosition - this._startPosition);
        }

        private function updateTarget(now:Number, target:Number):void
        {
            target = this.clampPosition(target);
            if (Math.abs(this._targetPosition - target) < CURVE_EPSILON)
            {
                this._targetPosition = target;
                return;
            }
            var current:Number = this.getValueAt(now);
            var delta:Number = target - current;
            if (Math.abs(delta) < CURVE_EPSILON)
            {
                this._startPosition = current;
                this._targetPosition = target;
                this._startTime = now;
                this._endTime = now;
                return;
            }
            if ((this._endTime - this._startTime) <= CURVE_EPSILON)
            {
                this.startAnimation(now, current, target);
                return;
            }
            var velocity:Number = this.calculateVelocity(now);
            var duration:Number = this.getBoundedDurationMs(delta, velocity);
            if (!isFinite(duration) || duration < CURVE_EPSILON)
            {
                this._startPosition = current;
                this._targetPosition = target;
                this._startTime = now;
                this._endTime = now;
                return;
            }
            var slope:Number = velocity * (duration / delta);
            slope = clamp(slope, -MAX_SLOPE, MAX_SLOPE);
            this._curveControlY1 = slope * CURVE_X1;
            this._startPosition = current;
            this._targetPosition = target;
            this._startTime = now;
            this._endTime = now + duration;
        }

        private function updateScrolling(k:TimerEvent):void
        {
            this.applyPositionAt(getTimer());
        }

        private function applyPositionAt(k:Number):void
        {
            this.setPosition(this.getValueAt(k));
            if (k >= this._endTime || ((this._endTime - this._startTime) <= CURVE_EPSILON))
            {
                this.complete();
            }
        }

        private function wheelDeltaToScrollDelta(delta:Number, maxScroll:Number):Number
        {
            if (this._normalizeToMaxScroll)
            {
                return ((-delta * this._scrollStep) / maxScroll);
            }
            return (-delta * this._scrollStep);
        }

        private function getInverseDeltaDurationMs(k:Number):Number
        {
            var distance:Number = Math.abs(k);
            var result:Number = this._duration;
            if (distance > INVERSE_DELTA_RAMP_START_PX)
            {
                result = result + ((distance - INVERSE_DELTA_RAMP_START_PX) * (this._minDuration - this._duration) / (INVERSE_DELTA_RAMP_END_PX - INVERSE_DELTA_RAMP_START_PX));
            }
            return clamp(result, this._minDuration, this._duration);
        }

        private function getBoundedDurationMs(delta:Number, velocity:Number):Number
        {
            return Math.min(this.getInverseDeltaDurationMs(delta), this.getVelocityBasedDurationBoundMs(delta, velocity));
        }

        private function getVelocityBasedDurationBoundMs(delta:Number, velocity:Number):Number
        {
            if (Math.abs(delta) < CURVE_EPSILON)
            {
                return 0;
            }
            if (Math.abs(velocity) < CURVE_EPSILON)
            {
                return Number.MAX_VALUE;
            }
            var result:Number = (delta / velocity) * VELOCITY_BOUND_FUDGE;
            return (result < 0) ? Number.MAX_VALUE : result;
        }

        private function getValueAt(k:Number):Number
        {
            var duration:Number = this._endTime - this._startTime;
            if (duration <= CURVE_EPSILON || k >= this._endTime)
            {
                return this._targetPosition;
            }
            if (k <= this._startTime)
            {
                return this._startPosition;
            }
            var progress:Number = (k - this._startTime) / duration;
            var eased:Number = getBezierValue(progress, CURVE_X1, this._curveControlY1, CURVE_X2, CURVE_Y2);
            return this._startPosition + ((this._targetPosition - this._startPosition) * eased);
        }

        private function calculateVelocity(k:Number):Number
        {
            var duration:Number = this._endTime - this._startTime;
            if (duration <= CURVE_EPSILON)
            {
                return 0;
            }
            var progress:Number = clamp((k - this._startTime) / duration, 0, 1);
            var slope:Number = getBezierSlope(progress, CURVE_X1, this._curveControlY1, CURVE_X2, CURVE_Y2);
            return slope * ((this._targetPosition - this._startPosition) / duration);
        }

        private function getPosition():Number
        {
            return this._getPosition();
        }

        private function setPosition(k:Number):void
        {
            this._setPosition(k);
        }

        private function getMaxScroll():Number
        {
            return this._getMaxScroll();
        }

        private function clampPosition(k:Number):Number
        {
            if (!this._clampToBounds || !isFinite(k))
            {
                return k;
            }
            var maxPosition:Number = this.getMaxPosition();
            if (!isFinite(maxPosition))
            {
                return k;
            }
            return clamp(k, 0, maxPosition);
        }

        private function getMaxPosition():Number
        {
            var maxScroll:Number;
            if (this._normalizeToMaxScroll)
            {
                return 1;
            }
            maxScroll = this.getMaxScroll();
            if (!isFinite(maxScroll) || maxScroll < 0)
            {
                return NaN;
            }
            return maxScroll;
        }
    }
}
