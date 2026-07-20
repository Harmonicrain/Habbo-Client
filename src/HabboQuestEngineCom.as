package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboQuestEngineBootstrap;
    import com.sulake.iid.IIDHabboQuestEngine;

    public class HabboQuestEngineCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboQuestEngineCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        public static var requiredClasses:Array = new Array(HabboQuestEngineBootstrap, IIDHabboQuestEngine);
        [Embed(source="images/HabboQuestEngineCom_icon_quest_hidden.png")]
    public static const icon_quest_hidden:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_Campaign.bin", mimeType="application/octet-stream")]
    public static const Campaign:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_CampaignCompleted.bin", mimeType="application/octet-stream")]
    public static const CampaignCompleted:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_EntryArrows.bin", mimeType="application/octet-stream")]
    public static const EntryArrows:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_QuestEntry.bin", mimeType="application/octet-stream")]
    public static const QuestEntry:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_Quest.bin", mimeType="application/octet-stream")]
    public static const Quest:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_QuestDetails.bin", mimeType="application/octet-stream")]
    public static const QuestDetails:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_Quests.bin", mimeType="application/octet-stream")]
    public static const Quests:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_QuestTracker.bin", mimeType="application/octet-stream")]
    public static const QuestTracker:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_QuestCompletedDialog.bin", mimeType="application/octet-stream")]
    public static const QuestCompletedDialog:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_QuestHelp.bin", mimeType="application/octet-stream")]
    public static const QuestHelp:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_AchievementCategory.bin", mimeType="application/octet-stream")]
    public static const AchievementCategory:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_Achievements.bin", mimeType="application/octet-stream")]
    public static const Achievements:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_AchievementsResolutions.bin", mimeType="application/octet-stream")]
    public static const AchievementsResolutions:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_AchievementResolutionProgress.bin", mimeType="application/octet-stream")]
    public static const AchievementResolutionProgress:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_AchievementResolutionCompleted.bin", mimeType="application/octet-stream")]
    public static const AchievementResolutionCompleted:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_Achievement.bin", mimeType="application/octet-stream")]
    public static const Achievement:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_AchievementSimple.bin", mimeType="application/octet-stream")]
    public static const AchievementSimple:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_ProgressBar.bin", mimeType="application/octet-stream")]
    public static const ProgressBar:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_NextQuestTimer.bin", mimeType="application/octet-stream")]
    public static const NextQuestTimer:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_SeasonalCalendar.bin", mimeType="application/octet-stream")]
    public static const SeasonalCalendar:Class;
        [Embed(source="binaryData/HabboQuestEngineCom_RoomCompetition.bin", mimeType="application/octet-stream")]
    public static const RoomCompetition:Class;
        [Embed(source="images/HabboQuestEngineCom_calendar_quest_complete.png")]
    public static const calendar_quest_complete:Class;
        [Embed(source="images/HabboQuestEngineCom_arrow_back_active.png")]
    public static const arrow_back_active:Class;
        [Embed(source="images/HabboQuestEngineCom_arrow_back_inactive.png")]
    public static const arrow_back_inactive:Class;
        [Embed(source="images/HabboQuestEngineCom_arrow_back_hilite.png")]
    public static const arrow_back_hilite:Class;
        [Embed(source="images/HabboQuestEngineCom_arrow_next_active.png")]
    public static const arrow_next_active:Class;
        [Embed(source="images/HabboQuestEngineCom_arrow_next_inactive.png")]
    public static const arrow_next_inactive:Class;
        [Embed(source="images/HabboQuestEngineCom_arrow_next_hilite.png")]
    public static const arrow_next_hilite:Class;
        [Embed(source="images/HabboQuestEngineCom_stripe_mask_L.png")]
    public static const stripe_mask_L:Class;
        [Embed(source="images/HabboQuestEngineCom_stripe_mask_R.png")]
    public static const stripe_mask_R:Class;
    }
}
