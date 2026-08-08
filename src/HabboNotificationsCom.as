package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboNotificationsBootstrap;
    import com.sulake.iid.IIDHabboNotifications;

    public class HabboNotificationsCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboNotificationsCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="binaryData/HabboNotificationsCom_habbo_notifications_config_xml.bin", mimeType="application/octet-stream")]
        public static var habbo_notifications_config_xml:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_temp_png.png")]
        public static var if_icon_temp_png:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_hc_png.png")]
        public static var if_icon_hc_png:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_vip_png.png")]
        public static var if_icon_vip_png:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_recycler_png.png")]
        public static var if_icon_recycler_png:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_friend_bg_blue_png.png")]
        public static var if_icon_friend_bg_blue_png:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_duckets_png.png")]
        public static var if_icon_duckets_png:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_loyalty_png.png")]
        public static var if_icon_loyalty_png:Class;
        [Embed(source="images/HabboNotificationsCom_if_icon_diamond_png.png")]
        public static var if_icon_diamond_png:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_chest_capacity_exceeds.png")]
        public static var chests_icon_chest_capacity_exceeds:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_chest_donation.png")]
        public static var chests_icon_chest_donation:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_chest_empty.png")]
        public static var chests_icon_chest_empty:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_chest_full.png")]
        public static var chests_icon_chest_full:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_chest_wired_transaction.png")]
        public static var chests_icon_chest_wired_transaction:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_chest_withdraw.png")]
        public static var chests_icon_chest_withdraw:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_rejected.png")]
        public static var chests_icon_rejected:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_successful.png")]
        public static var chests_icon_successful:Class;
        [Embed(source="images/HabboNotificationsCom_chests_icon_trading_error.png")]
        public static var chests_icon_trading_error:Class;
        [Embed(source="binaryData/HabboNotificationsCom_motd_notification_xml.bin", mimeType="application/octet-stream")]
        public static var motd_notification_xml:Class;
        [Embed(source="binaryData/HabboNotificationsCom_motd_notification_item_xml.bin", mimeType="application/octet-stream")]
        public static var motd_notification_item_xml:Class;
        [Embed(source="binaryData/HabboNotificationsCom_layout_notification_xml.bin", mimeType="application/octet-stream")]
        public static var layout_notification_xml:Class;
        [Embed(source="binaryData/HabboNotificationsCom_layout_notification_wired_xml.bin", mimeType="application/octet-stream")]
        public static var layout_notification_wired_xml:Class;
        [Embed(source="binaryData/HabboNotificationsCom_layout_notifications_browser_xml.bin", mimeType="application/octet-stream")]
        public static var layout_notifications_browser_xml:Class;
        [Embed(source="binaryData/HabboNotificationsCom_club_gift_notification_xml.bin", mimeType="application/octet-stream")]
        public static var club_gift_notification_xml:Class;
        [Embed(source="binaryData/HabboNotificationsCom_safety_locked_notification_xml.bin", mimeType="application/octet-stream")]
        public static var safety_locked_notification_xml:Class;
        [Embed(source="binaryData/HabboNotificationsCom_layout_notification_popup_xml.bin", mimeType="application/octet-stream")]
        public static var layout_notification_popup_xml:Class;
        [Embed(source="binaryData/../images/HabboNotificationsCom_discord_box_png.png")]
        public static var discord_box_png:Class;
        [Embed(source="binaryData/../images/HabboNotificationsCom_icon_curator_stamp_large_png.png")]
        public static var icon_curator_stamp_large_png:Class;
        [Embed(source="binaryData/HabboNotificationsCom_discord_activity_dialog_xml.bin", mimeType="application/octet-stream")]
        public static var discord_activity_dialog_xml:Class;
        public static var requiredClasses:Array = new Array(HabboNotificationsBootstrap, IIDHabboNotifications);
    }
}
