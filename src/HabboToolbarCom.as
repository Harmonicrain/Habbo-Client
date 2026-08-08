package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboToolbarBootstrap;
    import com.sulake.iid.IIDHabboToolbar;

    public class HabboToolbarCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboToolbarBootstrap, IIDHabboToolbar);
        [Embed(source="binaryData/HabboToolbarCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="binaryData/HabboToolbarCom_toolbar_view_xml.bin", mimeType="application/octet-stream")]
        public static var toolbar_view_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_bottom_bar_left_xml.bin", mimeType="application/octet-stream")]
        public static var bottom_bar_left_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_bottom_background_border_xml.bin", mimeType="application/octet-stream")]
        public static var bottom_background_border_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_me_menu_view_xml.bin", mimeType="application/octet-stream")]
        public static var me_menu_view_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_me_menu_new_view_xml.bin", mimeType="application/octet-stream")]
        public static var me_menu_new_view_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_me_menu_settings_menu_xml.bin", mimeType="application/octet-stream")]
        public static var me_menu_settings_menu_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_me_menu_sound_settings_xml.bin", mimeType="application/octet-stream")]
        public static var me_menu_sound_settings_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_me_menu_other_settings_xml.bin", mimeType="application/octet-stream")]
        public static var me_menu_other_settings_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_new_items_label_xml.bin", mimeType="application/octet-stream")]
        public static var new_items_label_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_campaign_calendar_xml.bin", mimeType="application/octet-stream")]
        public static var campaign_calendar_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_logout_xml.bin", mimeType="application/octet-stream")]
        public static var logout_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_logout_confirmation_xml.bin", mimeType="application/octet-stream")]
        public static var logout_confirmation_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_roomtools_xml.bin", mimeType="application/octet-stream")]
        public static var roomtools_xml:Class;
        [Embed(source="images/HabboToolbarCom_roominfo_icon.png")]
        public static var roominfo_icon:Class;
        [Embed(source="binaryData/HabboToolbarCom_promo_duckets_xml.bin", mimeType="application/octet-stream")]
        public static var promo_duckets_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_gamehall_leaderboard_prompt_xml.bin", mimeType="application/octet-stream")]
        public static var gamehall_leaderboard_prompt_xml:Class;
        [Embed(source="images/HabboToolbarCom_wired_menu_png.png")]
        public static var wired_menu_png:Class;
        [Embed(source="images/HabboToolbarCom_prog_introduction_png.png")]
        public static var prog_introduction_png:Class;
        [Embed(source="binaryData/HabboToolbarCom_purse_xml.bin", mimeType="application/octet-stream")]
        public static var purse_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_settings_xml.bin", mimeType="application/octet-stream")]
        public static var settings_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_setting_category_xml.bin", mimeType="application/octet-stream")]
        public static var setting_category_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_purse_indicator_credits_xml.bin", mimeType="application/octet-stream")]
        public static var purse_indicator_credits_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_purse_indicator_pixels_xml.bin", mimeType="application/octet-stream")]
        public static var purse_indicator_pixels_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_purse_indicator_seasonal_xml.bin", mimeType="application/octet-stream")]
        public static var purse_indicator_seasonal_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_club_discount_promotion_xml.bin", mimeType="application/octet-stream")]
        public static var club_discount_promotion_xml:Class;
        [Embed(source="images/HabboToolbarCom_extend_hilite_png.png")]
        public static var extend_hilite_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_credit_0_png.png")]
        public static var icon_credit_0_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_credit_1_png.png")]
        public static var icon_credit_1_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_credit_2_png.png")]
        public static var icon_credit_2_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_credit_3_png.png")]
        public static var icon_credit_3_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_credit_4_png.png")]
        public static var icon_credit_4_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_credit_5_png.png")]
        public static var icon_credit_5_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_credit_6_png.png")]
        public static var icon_credit_6_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_pixel_0_png.png")]
        public static var icon_pixel_0_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_pixel_1_png.png")]
        public static var icon_pixel_1_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_pixel_2_png.png")]
        public static var icon_pixel_2_png:Class;
        [Embed(source="images/HabboToolbarCom_icon_pixel_3_png.png")]
        public static var icon_pixel_3_png:Class;
        [Embed(source="binaryData/HabboToolbarCom_extension_grid_xml.bin", mimeType="application/octet-stream")]
        public static var extension_grid_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_purse_indicator_club_xml.bin", mimeType="application/octet-stream")]
        public static var purse_indicator_club_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_video_offer_promotion_xml.bin", mimeType="application/octet-stream")]
        public static var video_offer_promotion_xml:Class;
        [Embed(source="images/HabboToolbarCom_offer_icon_png.png")]
        public static var offer_icon_png:Class;
        [Embed(source="binaryData/HabboToolbarCom_vip_discount_promotion_v2_xml.bin", mimeType="application/octet-stream")]
        public static var vip_discount_promotion_v2_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_vip_quests_promo_xml.bin", mimeType="application/octet-stream")]
        public static var vip_quests_promo_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_offer_extension_xml.bin", mimeType="application/octet-stream")]
        public static var offer_extension_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_phonenumber_collect_xml.bin", mimeType="application/octet-stream")]
        public static var phonenumber_collect_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_phonenumber_verify_xml.bin", mimeType="application/octet-stream")]
        public static var phonenumber_verify_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_phonenumber_collect_minimized_xml.bin", mimeType="application/octet-stream")]
        public static var phonenumber_collect_minimized_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_phonenumber_verify_minimized_xml.bin", mimeType="application/octet-stream")]
        public static var phonenumber_verify_minimized_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_phonenumber_country_menu_item_xml.bin", mimeType="application/octet-stream")]
        public static var phonenumber_country_menu_item_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_returnusergifting_miniview_xml.bin", mimeType="application/octet-stream")]
        public static var returnusergifting_miniview_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_nux_offer_old_user_xml.bin", mimeType="application/octet-stream")]
        public static var nux_offer_old_user_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_nux_gift_selection_xml.bin", mimeType="application/octet-stream")]
        public static var nux_gift_selection_xml:Class;
        [Embed(source="binaryData/HabboToolbarCom_nux_noob_room_offer_xml.bin", mimeType="application/octet-stream")]
        public static var nux_noob_room_offer_xml:Class;
    }
}
