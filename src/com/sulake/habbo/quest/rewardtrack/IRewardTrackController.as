package com.sulake.habbo.quest.rewardtrack
{
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.quest.rewardtrack.data.RewardTrack;

    public interface IRewardTrackController extends IDisposable
    {
        function get enabled():Boolean;
        function open(trackId:String):void;
        function claimReward(trackId:String, rewardId:String):void;
        function purchasePremium(trackId:String):void;
        function openPremiumPurchaseConfirmation(track:RewardTrack):void;
        function openTaskHintLink(link:String):void;
    }
}
