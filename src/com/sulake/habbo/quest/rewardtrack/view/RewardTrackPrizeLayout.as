package com.sulake.habbo.quest.rewardtrack.view
{
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrackPrize;

    public class RewardTrackPrizeLayout
    {
        private static const PAGE_BOUNDARY_EPSILON:Number = 0.0001;

        private var _visibleWidth:int;
        private var _prizeWidth:int;
        private var _spacing:int;
        private var _edgePadding:Number;
        private var _zeroOffset:Number;
        private var _pagePointSpan:int = 1;
        private var _distancePerPoint:Number = 1;
        private var _pageCount:int = 1;
        private var _minRequiredPoints:int;

        public function rebuild(track:RewardTrack, visibleWidth:int, prizeWidth:int, spacing:int):void
        {
            this._visibleWidth = visibleWidth;
            this._prizeWidth = prizeWidth;
            this._spacing = spacing;
            this._edgePadding = ((this._prizeWidth / 2) + this._spacing);
            this._minRequiredPoints = this.findMinRequiredPoints(track.prizes);
            var minimumGap:int = this.findMinimumGap(track.prizes);
            var maxPoints:int = this.findMaxRequiredPoints(track.prizes);
            if (minimumGap <= 0)
            {
                minimumGap = Math.max(1, maxPoints);
            }
            this._distancePerPoint = ((this._prizeWidth + this._spacing) / minimumGap);
            if (this._distancePerPoint <= 0)
            {
                this._distancePerPoint = 1;
            }
            this._pagePointSpan = this.calculatePagePointSpan(this._distancePerPoint, minimumGap);
            if (maxPoints > 0)
            {
                this._pagePointSpan = Math.min(this._pagePointSpan, Math.max(minimumGap, (int(Math.ceil(maxPoints / minimumGap)) * minimumGap)));
            }
            this._distancePerPoint = this.findMaxDistancePerPoint(this._distancePerPoint, this._pagePointSpan);
            this._zeroOffset = this.zeroOffsetFor(this._distancePerPoint);
            this._pageCount = this.calculatePageCount(track.prizes);
        }

        public function xForPoints(points:int, page:int):Number
        {
            var pageStart:int = Math.max(0, (page * this._pagePointSpan));
            return (this._zeroOffset + ((points - pageStart) * this._distancePerPoint));
        }

        public function pageForPoints(points:int):int
        {
            var page:int = this.pageForPointSpan(points, this._pagePointSpan);
            return Math.max(0, Math.min((this._pageCount - 1), page));
        }

        public function get pageCount():int
        {
            return this._pageCount;
        }

        public function get distancePerPoint():Number
        {
            return this._distancePerPoint;
        }

        private function calculatePageCount(prizes:Array):int
        {
            var prize:RewardTrackPrize;
            var maxPage:int;
            for each (prize in prizes)
            {
                maxPage = Math.max(maxPage, this.pageForPointSpan(prize.requiredPoints, this._pagePointSpan));
            }
            return Math.max(1, (maxPage + 1));
        }

        private function pageForPointSpan(points:int, span:int):int
        {
            if (points <= 0)
            {
                return 0;
            }
            return Math.max(0, (int(Math.ceil(((points - PAGE_BOUNDARY_EPSILON) / span))) - 1));
        }

        private function zeroOffsetFor(distancePerPoint:Number):Number
        {
            return Math.max(0, (this._edgePadding - (this._minRequiredPoints * distancePerPoint)));
        }

        private function usableWidthFor(distancePerPoint:Number):Number
        {
            return Math.max(1, ((this._visibleWidth - this._edgePadding) - this.zeroOffsetFor(distancePerPoint)));
        }

        private function calculatePagePointSpan(distancePerPoint:Number, minimumGap:int):int
        {
            var gapsPerPage:int = Math.max(1, int(Math.floor(((this.usableWidthFor(distancePerPoint) / distancePerPoint) / minimumGap))));
            return Math.max(1, (gapsPerPage * minimumGap));
        }

        private function findMaxDistancePerPoint(distancePerPoint:Number, pagePointSpan:int):Number
        {
            var i:int;
            var middle:Number;
            var fits:Number = distancePerPoint;
            var overflows:Number = distancePerPoint;
            i = 0;
            while (i < 32)
            {
                overflows = (overflows * 2);
                if (!this.pagePointSpanFits(overflows, pagePointSpan))
                {
                    break;
                }
                fits = overflows;
                i++;
            }
            i = 0;
            while (i < 24)
            {
                middle = ((fits + overflows) / 2);
                if (this.pagePointSpanFits(middle, pagePointSpan))
                {
                    fits = middle;
                }
                else
                {
                    overflows = middle;
                }
                i++;
            }
            return fits;
        }

        private function pagePointSpanFits(distancePerPoint:Number, pagePointSpan:int):Boolean
        {
            return ((pagePointSpan * distancePerPoint) <= (this.usableWidthFor(distancePerPoint) + PAGE_BOUNDARY_EPSILON));
        }

        private function findMinimumGap(prizes:Array):int
        {
            var freeGap:int = this.findMinimumGapForPremium(prizes, false);
            var premiumGap:int = this.findMinimumGapForPremium(prizes, true);
            if (freeGap <= 0)
            {
                return premiumGap;
            }
            if (premiumGap <= 0)
            {
                return freeGap;
            }
            return Math.min(freeGap, premiumGap);
        }

        private function findMinimumGapForPremium(prizes:Array, premium:Boolean):int
        {
            var prize:RewardTrackPrize;
            var points:Array = [];
            var gap:int;
            var minimumGap:int;
            var i:int;
            for each (prize in prizes)
            {
                if (prize.premium == premium)
                {
                    points.push(prize.requiredPoints);
                }
            }
            points.sort(Array.NUMERIC);
            for (i = 1; i < points.length; i++)
            {
                gap = (int(points[i]) - int(points[(i - 1)]));
                if (((gap > 0) && ((minimumGap == 0) || (gap < minimumGap))))
                {
                    minimumGap = gap;
                }
            }
            return minimumGap;
        }

        private function findMinRequiredPoints(prizes:Array):int
        {
            var prize:RewardTrackPrize;
            var minimum:int = -1;
            for each (prize in prizes)
            {
                if (((minimum == -1) || (prize.requiredPoints < minimum)))
                {
                    minimum = prize.requiredPoints;
                }
            }
            return Math.max(0, minimum);
        }

        private function findMaxRequiredPoints(prizes:Array):int
        {
            var prize:RewardTrackPrize;
            var maximum:int;
            for each (prize in prizes)
            {
                maximum = Math.max(maximum, prize.requiredPoints);
            }
            return maximum;
        }
    }
}
