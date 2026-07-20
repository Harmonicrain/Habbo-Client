package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboFriendBarBootstrap;
    import com.sulake.iid.IIDHabboFriendBar;
	import snowwar.assets.binaryData.PlaySnowstormTabXML;
	import snowwar.assets.images.PlaySnowstormIcon;

    public class HabboFriendBarCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboFriendBarCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        [Embed(source="binaryData/HabboFriendBarCom_bar_xml.bin", mimeType="application/octet-stream")]
    public static var bar_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_new_bar_xml.bin", mimeType="application/octet-stream")]
    public static var new_bar_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_entity_xml.bin", mimeType="application/octet-stream")]
    public static var entity_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_new_friend_entity_xml.bin", mimeType="application/octet-stream")]
    public static var new_friend_entity_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_add_friends_tab_xml.bin", mimeType="application/octet-stream")]
    public static var add_friends_tab_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_friend_requests_tab_xml.bin", mimeType="application/octet-stream")]
    public static var friend_requests_tab_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_friend_request_tab_xml.bin", mimeType="application/octet-stream")]
    public static var friend_request_tab_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_toggle_xml.bin", mimeType="application/octet-stream")]
    public static var toggle_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_facebook_piece_xml.bin", mimeType="application/octet-stream")]
    public static var facebook_piece_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_controls_piece_xml.bin", mimeType="application/octet-stream")]
    public static var controls_piece_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_new_controls_piece_xml.bin", mimeType="application/octet-stream")]
    public static var new_controls_piece_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_message_piece_xml.bin", mimeType="application/octet-stream")]
    public static var message_piece_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_search_friends_tab_xml.bin", mimeType="application/octet-stream")]
    public static var search_friends_tab_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_new_search_friends_tab_xml.bin", mimeType="application/octet-stream")]
    public static var new_search_friends_tab_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_all_friends_tab_xml.bin", mimeType="application/octet-stream")]
    public static var all_friends_tab_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_new_all_friends_tab_xml.bin", mimeType="application/octet-stream")]
    public static var new_all_friends_tab_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_new_open_messenger_tab_xml.bin", mimeType="application/octet-stream")]
    public static var new_open_messenger_tab_xml:Class;
        [Embed(source="images/HabboFriendBarCom_ach_notification_icon_png.png")]
    public static var ach_notification_icon_png:Class;
        [Embed(source="images/HabboFriendBarCom_plus_friend_icon_png.png")]
    public static var plus_friend_icon_png:Class;
        [Embed(source="images/HabboFriendBarCom_add_friends_icon_png.png")]
    public static var add_friends_icon_png:Class;
        [Embed(source="images/HabboFriendBarCom_find_friends_icon_png.png")]
    public static var find_friends_icon_png:Class;
        [Embed(source="images/HabboFriendBarCom_fb_icon_small_png.png")]
    public static var fb_icon_small_png:Class;
        [Embed(source="images/HabboFriendBarCom_friends_icon_png.png")]
    public static var friends_icon_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_friendlist_png.png")]
    public static var icon_friendlist_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_friendlist_notify_0_png.png")]
    public static var icon_friendlist_notify_0_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_friendlist_notify_1_png.png")]
    public static var icon_friendlist_notify_1_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_friendlist_hover_0_png.png")]
    public static var icon_friendlist_hover_0_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_friendlist_hover_1_png.png")]
    public static var icon_friendlist_hover_1_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_friendlist_hover_2_png.png")]
    public static var icon_friendlist_hover_2_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_friendlist_hover_3_png.png")]
    public static var icon_friendlist_hover_3_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_messenger_png.png")]
    public static var icon_messenger_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_messenger_notify_0_png.png")]
    public static var icon_messenger_notify_0_png:Class;
        [Embed(source="images/HabboFriendBarCom_icon_messenger_notify_1_png.png")]
    public static var icon_messenger_notify_1_png:Class;
        [Embed(source="images/HabboFriendBarCom_search_friends_icon_png.png")]
    public static var search_friends_icon_png:Class;
        [Embed(source="images/HabboFriendBarCom_all_friends_icon_png.png")]
    public static var all_friends_icon_png:Class;
        [Embed(source="binaryData/HabboFriendBarCom_user_list_xml.bin", mimeType="application/octet-stream")]
    public static var user_list_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_user_entry_xml.bin", mimeType="application/octet-stream")]
    public static var user_entry_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_competition_user_popup_xml.bin", mimeType="application/octet-stream")]
    public static var competition_user_popup_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_on_duty_guide_user_popup_xml.bin", mimeType="application/octet-stream")]
    public static var on_duty_guide_user_popup_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_achievement_competition_prizes_xml.bin", mimeType="application/octet-stream")]
    public static var achievement_competition_prizes_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_avatar_image_xml.bin", mimeType="application/octet-stream")]
    public static var avatar_image_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_community_goal_xml.bin", mimeType="application/octet-stream")]
    public static var community_goal_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_community_goal_voting_xml.bin", mimeType="application/octet-stream")]
    public static var community_goal_voting_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_daily_quest_xml.bin", mimeType="application/octet-stream")]
    public static var daily_quest_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_dailyquest_xml.bin", mimeType="application/octet-stream")]
    public static var element_dailyquest_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_expiring_catalog_page_xml.bin", mimeType="application/octet-stream")]
    public static var expiring_catalog_page_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_expiring_catalog_page_small_xml.bin", mimeType="application/octet-stream")]
    public static var expiring_catalog_page_small_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_landing_view_generic_reception_xml.bin", mimeType="application/octet-stream")]
    public static var landing_view_generic_reception_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_catalog_promo_xml.bin", mimeType="application/octet-stream")]
    public static var catalog_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_catalog_promo_small_xml.bin", mimeType="application/octet-stream")]
    public static var catalog_promo_small_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_campaign_promo_xml.bin", mimeType="application/octet-stream")]
    public static var campaign_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_moving_object_xml.bin", mimeType="application/octet-stream")]
    public static var moving_object_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_moving_object_floating_xml.bin", mimeType="application/octet-stream")]
    public static var moving_object_floating_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_next_ltd_available_xml.bin", mimeType="application/octet-stream")]
    public static var next_ltd_available_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_safety_quiz_promo_xml.bin", mimeType="application/octet-stream")]
    public static var safety_quiz_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_citizenship_welcome_xml.bin", mimeType="application/octet-stream")]
    public static var citizenship_welcome_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_level_up_xml.bin", mimeType="application/octet-stream")]
    public static var level_up_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_talent_track_xml.bin", mimeType="application/octet-stream")]
    public static var talent_track_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_track_promo_xml.bin", mimeType="application/octet-stream")]
    public static var track_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_task_progress_dialog_xml.bin", mimeType="application/octet-stream")]
    public static var task_progress_dialog_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_tour_task_progress_dialog_xml.bin", mimeType="application/octet-stream")]
    public static var tour_task_progress_dialog_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_landing_view_default_dynamic_layout_xml.bin", mimeType="application/octet-stream")]
    public static var landing_view_default_dynamic_layout_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_habbo_moderation_promo_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_moderation_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_habbo_talents_promo_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_talents_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_habbo_way_promo_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_way_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_dynamic_widget_grid_xml.bin", mimeType="application/octet-stream")]
    public static var dynamic_widget_grid_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_pixel_removal_credit_promo_xml.bin", mimeType="application/octet-stream")]
    public static var pixel_removal_credit_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_pixel_removal_promo_xml.bin", mimeType="application/octet-stream")]
    public static var pixel_removal_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_fast_food_game_promo_xml.bin", mimeType="application/octet-stream")]
    public static var fast_food_game_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_room_hopper_network_xml.bin", mimeType="application/octet-stream")]
    public static var room_hopper_network_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_landing_view_jetset_xml.bin", mimeType="application/octet-stream")]
    public static var landing_view_jetset_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_generic_widget_xml.bin", mimeType="application/octet-stream")]
    public static var generic_widget_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_widget_container_widget_xml.bin", mimeType="application/octet-stream")]
    public static var widget_container_widget_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_bodytext_xml.bin", mimeType="application/octet-stream")]
    public static var element_bodytext_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_button_xml.bin", mimeType="application/octet-stream")]
    public static var element_button_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_caption_xml.bin", mimeType="application/octet-stream")]
    public static var element_caption_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_image_xml.bin", mimeType="application/octet-stream")]
    public static var element_image_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_link_xml.bin", mimeType="application/octet-stream")]
    public static var element_link_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_spacing_xml.bin", mimeType="application/octet-stream")]
    public static var element_spacing_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_subcaption_xml.bin", mimeType="application/octet-stream")]
    public static var element_subcaption_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_timer_xml.bin", mimeType="application/octet-stream")]
    public static var element_timer_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_title_xml.bin", mimeType="application/octet-stream")]
    public static var element_title_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_rewardbadge_xml.bin", mimeType="application/octet-stream")]
    public static var element_rewardbadge_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_concurrentusersmeter_xml.bin", mimeType="application/octet-stream")]
    public static var element_concurrentusersmeter_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_concurrentusersinfo_xml.bin", mimeType="application/octet-stream")]
    public static var element_concurrentusersinfo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_dynamic_widget_grid_separator_xml.bin", mimeType="application/octet-stream")]
    public static var dynamic_widget_grid_separator_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_epic_popup_frame_xml.bin", mimeType="application/octet-stream")]
    public static var epic_popup_frame_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_landing_view_furnimatic_xml.bin", mimeType="application/octet-stream")]
    public static var landing_view_furnimatic_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_initialization_error_xml.bin", mimeType="application/octet-stream")]
    public static var initialization_error_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_element_community_goal_score_xml.bin", mimeType="application/octet-stream")]
    public static var element_community_goal_score_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_promo_article_xml.bin", mimeType="application/octet-stream")]
    public static var promo_article_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_bonus_rare_promo_xml.bin", mimeType="application/octet-stream")]
    public static var bonus_rare_promo_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_groupforum_thread_list_item_xml.bin", mimeType="application/octet-stream")]
    public static var groupforum_thread_list_item_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_groupforum_forum_list_item_xml.bin", mimeType="application/octet-stream")]
    public static var groupforum_forum_list_item_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_groupforum_main_view_xml.bin", mimeType="application/octet-stream")]
    public static var groupforum_main_view_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_groupforum_message_list_item_xml.bin", mimeType="application/octet-stream")]
    public static var groupforum_message_list_item_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_groupforum_compose_message_xml.bin", mimeType="application/octet-stream")]
    public static var groupforum_compose_message_xml:Class;
        [Embed(source="binaryData/HabboFriendBarCom_groupforum_forum_settings_xml.bin", mimeType="application/octet-stream")]
    public static var groupforum_forum_settings_xml:Class;
        public static var play_snowstorm_tab_xml:Class = PlaySnowstormTabXML;
        public static var play_snowstorm_icon_png:Class = PlaySnowstormIcon;
        public static var requiredClasses:Array = new Array(HabboFriendBarBootstrap, IIDHabboFriendBar);
    }
}
