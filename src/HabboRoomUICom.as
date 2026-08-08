package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomUIBootstrap;
    import com.sulake.habbo.ui.widget.RoomWidgetFactory;
    import com.sulake.iid.IIDHabboRoomUI;
	import com.sulake.habbo.ui.widget.infobuspolls.binaryData.VoteQuestionXML;
	import com.sulake.habbo.ui.widget.infobuspolls.binaryData.VoteChoiceXML;

    public class HabboRoomUICom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboRoomUICom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_desktop_layout_xml.bin", mimeType="application/octet-stream")]
        public static var room_desktop_layout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_view_container_xml.bin", mimeType="application/octet-stream")]
        public static var room_view_container_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_spectator_mode_xml.bin", mimeType="application/octet-stream")]
        public static var spectator_mode_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_habbiconselector_menu_xml.bin", mimeType="application/octet-stream")]
        public static var habbiconselector_menu_xml:Class;
        [Embed(source="images/HabboRoomUICom_spec_top_left_png.png")]
        public static var spec_top_left_png:Class;
        [Embed(source="images/HabboRoomUICom_spec_top_middle_png.png")]
        public static var spec_top_middle_png:Class;
        [Embed(source="images/HabboRoomUICom_spec_top_right_png.png")]
        public static var spec_top_right_png:Class;
        [Embed(source="images/HabboRoomUICom_spec_middle_left_png.png")]
        public static var spec_middle_left_png:Class;
        [Embed(source="images/HabboRoomUICom_spec_middle_right_png.png")]
        public static var spec_middle_right_png:Class;
        [Embed(source="images/HabboRoomUICom_spec_bottom_left_png.png")]
        public static var spec_bottom_left_png:Class;
        [Embed(source="images/HabboRoomUICom_spec_bottom_middle_png.png")]
        public static var spec_bottom_middle_png:Class;
        [Embed(source="images/HabboRoomUICom_spec_bottom_right_png.png")]
        public static var spec_bottom_right_png:Class;
        public static var requiredClasses:Array = new Array(RoomUIBootstrap, RoomWidgetFactory, IIDHabboRoomUI);
        [Embed(source="images/HabboRoomUICom_chatinput_bubble_left.png")]
        public static var chatinput_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_chatinput_bubble_middle.png")]
        public static var chatinput_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_chatinput_bubble_right.png")]
        public static var chatinput_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_packagecard_icon_hc.png")]
        public static var packagecard_icon_hc:Class;
        [Embed(source="images/HabboRoomUICom_packagecard_icon_floor.png")]
        public static var packagecard_icon_floor:Class;
        [Embed(source="images/HabboRoomUICom_packagecard_icon_landscape.png")]
        public static var packagecard_icon_landscape:Class;
        [Embed(source="images/HabboRoomUICom_packagecard_icon_wallpaper.png")]
        public static var packagecard_icon_wallpaper:Class;
        [Embed(source="images/HabboRoomUICom_stickie_blanco.png")]
        public static var stickie_blanco:Class;
        [Embed(source="images/HabboRoomUICom_stickie_close.png")]
        public static var stickie_close:Class;
        [Embed(source="images/HabboRoomUICom_stickie_remove.png")]
        public static var stickie_remove:Class;
        [Embed(source="images/HabboRoomUICom_stickie_vd.png")]
        public static var stickie_vd:Class;
        [Embed(source="images/HabboRoomUICom_stickie_xmas.png")]
        public static var stickie_xmas:Class;
        [Embed(source="images/HabboRoomUICom_stickie_dreams.png")]
        public static var stickie_dreams:Class;
        [Embed(source="images/HabboRoomUICom_stickie_juninas.png")]
        public static var stickie_juninas:Class;
        [Embed(source="images/HabboRoomUICom_stickie_shakesp.png")]
        public static var stickie_shakesp:Class;
        [Embed(source="images/HabboRoomUICom_trophy_bg_bronze.png")]
        public static var trophy_bg_bronze:Class;
        [Embed(source="images/HabboRoomUICom_trophy_bg_gold.png")]
        public static var trophy_bg_gold:Class;
        [Embed(source="images/HabboRoomUICom_trophy_bg_silver.png")]
        public static var trophy_bg_silver:Class;
        [Embed(source="images/HabboRoomUICom_dimmer_color_button.png")]
        public static var dimmer_color_button:Class;
        [Embed(source="images/HabboRoomUICom_dimmer_color_frame.png")]
        public static var dimmer_color_frame:Class;
        [Embed(source="images/HabboRoomUICom_dimmer_color_selected.png")]
        public static var dimmer_color_selected:Class;
        [Embed(source="images/HabboRoomUICom_dimmer_slider_base.png")]
        public static var dimmer_slider_base:Class;
        [Embed(source="images/HabboRoomUICom_dimmer_slider_button.png")]
        public static var dimmer_slider_button:Class;
        [Embed(source="images/HabboRoomUICom_dimmer_info.png")]
        public static var dimmer_info:Class;
        [Embed(source="images/HabboRoomUICom_icon_home.png")]
        public static var icon_home:Class;
        [Embed(source="images/HabboRoomUICom_badges_color.png")]
        public static var badges_color:Class;
        [Embed(source="images/HabboRoomUICom_badges_white.png")]
        public static var badges_white:Class;
        [Embed(source="images/HabboRoomUICom_clothes_color.png")]
        public static var clothes_color:Class;
        [Embed(source="images/HabboRoomUICom_clothes_highlighter.png")]
        public static var clothes_highlighter:Class;
        [Embed(source="images/HabboRoomUICom_clothes_white.png")]
        public static var clothes_white:Class;
        [Embed(source="images/HabboRoomUICom_clothes_highlighter_blue.png")]
        public static var clothes_highlighter_blue:Class;
        [Embed(source="images/HabboRoomUICom_dance_color.png")]
        public static var dance_color:Class;
        [Embed(source="images/HabboRoomUICom_dance_white.png")]
        public static var dance_white:Class;
        [Embed(source="images/HabboRoomUICom_effects_color.png")]
        public static var effects_color:Class;
        [Embed(source="images/HabboRoomUICom_effects_white.png")]
        public static var effects_white:Class;
        [Embed(source="images/HabboRoomUICom_gohome_color.png")]
        public static var gohome_color:Class;
        [Embed(source="images/HabboRoomUICom_gohome_white.png")]
        public static var gohome_white:Class;
        [Embed(source="images/HabboRoomUICom_compass_color.png")]
        public static var compass_color:Class;
        [Embed(source="images/HabboRoomUICom_compass_white.png")]
        public static var compass_white:Class;
        [Embed(source="images/HabboRoomUICom_memenu_fx_pause.png")]
        public static var memenu_fx_pause:Class;
        [Embed(source="images/HabboRoomUICom_memenu_fx_play.png")]
        public static var memenu_fx_play:Class;
        [Embed(source="images/HabboRoomUICom_wave_color.png")]
        public static var wave_color:Class;
        [Embed(source="images/HabboRoomUICom_wave_white.png")]
        public static var wave_white:Class;
        [Embed(source="images/HabboRoomUICom_settings_color.png")]
        public static var settings_color:Class;
        [Embed(source="images/HabboRoomUICom_settings_white.png")]
        public static var settings_white:Class;
        [Embed(source="images/HabboRoomUICom_sounds_off_color.png")]
        public static var sounds_off_color:Class;
        [Embed(source="images/HabboRoomUICom_sounds_off_white.png")]
        public static var sounds_off_white:Class;
        [Embed(source="images/HabboRoomUICom_sounds_on_color.png")]
        public static var sounds_on_color:Class;
        [Embed(source="images/HabboRoomUICom_sounds_on_white.png")]
        public static var sounds_on_white:Class;
        [Embed(source="images/HabboRoomUICom_achievements_color.png")]
        public static var achievements_color:Class;
        [Embed(source="images/HabboRoomUICom_achievements_white.png")]
        public static var achievements_white:Class;
        [Embed(source="images/HabboRoomUICom_lighthouse_color.png")]
        public static var lighthouse_color:Class;
        [Embed(source="images/HabboRoomUICom_lighthouse_white.png")]
        public static var lighthouse_white:Class;
        [Embed(source="images/HabboRoomUICom_memenu_settings_slider_base.png")]
        public static var memenu_settings_slider_base:Class;
        [Embed(source="images/HabboRoomUICom_memenu_settings_slider_button.png")]
        public static var memenu_settings_slider_button:Class;
        [Embed(source="images/HabboRoomUICom_chat_grapbar_bg.png")]
        public static var chat_grapbar_bg:Class;
        [Embed(source="images/HabboRoomUICom_chat_grapbar_grip.png")]
        public static var chat_grapbar_grip:Class;
        [Embed(source="images/HabboRoomUICom_chat_grapbar_handle.png")]
        public static var chat_grapbar_handle:Class;
        [Embed(source="images/HabboRoomUICom_chat_grapbar_x.png")]
        public static var chat_grapbar_x:Class;
        [Embed(source="images/HabboRoomUICom_chat_grapbar_x_hi.png")]
        public static var chat_grapbar_x_hi:Class;
        [Embed(source="images/HabboRoomUICom_chat_grapbar_x_pr.png")]
        public static var chat_grapbar_x_pr:Class;
        [Embed(source="images/HabboRoomUICom_chat_history_bg.png")]
        public static var chat_history_bg:Class;
        [Embed(source="images/HabboRoomUICom_icon_petrespect.png")]
        public static var icon_petrespect:Class;
        [Embed(source="images/HabboRoomUICom_icon_pet_skill.png")]
        public static var icon_pet_skill:Class;
        [Embed(source="images/HabboRoomUICom_icon_pet_wellbeing.png")]
        public static var icon_pet_wellbeing:Class;
        [Embed(source="images/HabboRoomUICom_jb_icon_composer.png")]
        public static var jb_icon_composer:Class;
        [Embed(source="images/HabboRoomUICom_jb_icon_disc.png")]
        public static var jb_icon_disc:Class;
        [Embed(source="images/HabboRoomUICom_small_pen.png")]
        public static var small_pen:Class;
        [Embed(source="images/HabboRoomUICom_credits_color.png")]
        public static var credits_color:Class;
        [Embed(source="images/HabboRoomUICom_credits_white.png")]
        public static var credits_white:Class;
        [Embed(source="images/HabboRoomUICom_minimail_color.png")]
        public static var minimail_color:Class;
        [Embed(source="images/HabboRoomUICom_minimail_white.png")]
        public static var minimail_white:Class;
        [Embed(source="images/HabboRoomUICom_club_color.png")]
        public static var club_color:Class;
        [Embed(source="images/HabboRoomUICom_club_white.png")]
        public static var club_white:Class;
        [Embed(source="images/HabboRoomUICom_vip_color.png")]
        public static var vip_color:Class;
        [Embed(source="images/HabboRoomUICom_vip_white.png")]
        public static var vip_white:Class;
        [Embed(source="images/HabboRoomUICom_icon_pet_energy.png")]
        public static var icon_pet_energy:Class;
        [Embed(source="images/HabboRoomUICom_icon_pet_experience.png")]
        public static var icon_pet_experience:Class;
        [Embed(source="images/HabboRoomUICom_icon_pet_happiness.png")]
        public static var icon_pet_happiness:Class;
        [Embed(source="images/HabboRoomUICom_edit_pen_icon.png")]
        public static var edit_pen_icon:Class;
        [Embed(source="images/HabboRoomUICom_email_icon.png")]
        public static var email_icon:Class;
        [Embed(source="images/HabboRoomUICom_ok_icon.png")]
        public static var ok_icon:Class;
        [Embed(source="images/HabboRoomUICom_gift_background.png")]
        public static var gift_background:Class;
        [Embed(source="images/HabboRoomUICom_giftbox_full.png")]
        public static var giftbox_full:Class;
        [Embed(source="images/HabboRoomUICom_progressbar_100.png")]
        public static var progressbar_100:Class;
        [Embed(source="images/HabboRoomUICom_progressbar_50.png")]
        public static var progressbar_50:Class;
        [Embed(source="images/HabboRoomUICom_yellow_highlight.png")]
        public static var yellow_highlight:Class;
        [Embed(source="images/HabboRoomUICom_icon_arrow.png")]
        public static var icon_arrow:Class;
        [Embed(source="images/HabboRoomUICom_icon_arrow_left.png")]
        public static var icon_arrow_left:Class;
        [Embed(source="images/HabboRoomUICom_icon_cd_big.png")]
        public static var icon_cd_big:Class;
        [Embed(source="images/HabboRoomUICom_icon_cd_small.png")]
        public static var icon_cd_small:Class;
        [Embed(source="images/HabboRoomUICom_icon_notes_small.png")]
        public static var icon_notes_small:Class;
        [Embed(source="images/HabboRoomUICom_icon_pause.png")]
        public static var icon_pause:Class;
        [Embed(source="images/HabboRoomUICom_icon_play.png")]
        public static var icon_play:Class;
        [Embed(source="images/HabboRoomUICom_icon_pause_large.png")]
        public static var icon_pause_large:Class;
        [Embed(source="images/HabboRoomUICom_icon_download.png")]
        public static var icon_download:Class;
        [Embed(source="images/HabboRoomUICom_title_fader.png")]
        public static var title_fader:Class;
        [Embed(source="images/HabboRoomUICom_profile_color.png")]
        public static var profile_color:Class;
        [Embed(source="images/HabboRoomUICom_profile_white.png")]
        public static var profile_white:Class;
        [Embed(source="binaryData/HabboRoomUICom_chatinput_window.bin", mimeType="application/octet-stream")]
        public static var chatinput_window:Class;
        [Embed(source="binaryData/HabboRoomUICom_chatinput_window_new.bin", mimeType="application/octet-stream")]
        public static var chatinput_window_new:Class;
        [Embed(source="binaryData/HabboRoomUICom_chooser_item.bin", mimeType="application/octet-stream")]
        public static var chooser_item:Class;
        [Embed(source="binaryData/HabboRoomUICom_chooser_view.bin", mimeType="application/octet-stream")]
        public static var chooser_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_table_view_xml.bin", mimeType="application/octet-stream")]
        public static var table_view_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_new_furni_chooser_view.bin", mimeType="application/octet-stream")]
        public static var new_furni_chooser_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_new_furni_chooser_item.bin", mimeType="application/octet-stream")]
        public static var new_furni_chooser_item:Class;
        [Embed(source="binaryData/HabboRoomUICom_new_user_chooser_view.bin", mimeType="application/octet-stream")]
        public static var new_user_chooser_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_doorbell.bin", mimeType="application/octet-stream")]
        public static var doorbell:Class;
        [Embed(source="binaryData/HabboRoomUICom_doorbell_list_entry.bin", mimeType="application/octet-stream")]
        public static var doorbell_list_entry:Class;
        [Embed(source="binaryData/HabboRoomUICom_credit_redeem.bin", mimeType="application/octet-stream")]
        public static var credit_redeem:Class;
        [Embed(source="binaryData/HabboRoomUICom_ecotronbox_card.bin", mimeType="application/octet-stream")]
        public static var ecotronbox_card:Class;
        [Embed(source="binaryData/HabboRoomUICom_ecotronbox_card_furnimatic.bin", mimeType="application/octet-stream")]
        public static var ecotronbox_card_furnimatic:Class;
        [Embed(source="binaryData/HabboRoomUICom_mystery_box_open_dialog.bin", mimeType="application/octet-stream")]
        public static var mystery_box_open_dialog:Class;
        [Embed(source="binaryData/HabboRoomUICom_mystery_box_reward.bin", mimeType="application/octet-stream")]
        public static var mystery_box_reward:Class;
        [Embed(source="binaryData/HabboRoomUICom_mystery_box_toolbar_extension.bin", mimeType="application/octet-stream")]
        public static var mystery_box_toolbar_extension:Class;
        [Embed(source="binaryData/HabboRoomUICom_petpackage.bin", mimeType="application/octet-stream")]
        public static var petpackage:Class;
        [Embed(source="binaryData/HabboRoomUICom_petpackage_new.bin", mimeType="application/octet-stream")]
        public static var petpackage_new:Class;
        [Embed(source="binaryData/HabboRoomUICom_placeholder.bin", mimeType="application/octet-stream")]
        public static var placeholder:Class;
        [Embed(source="binaryData/HabboRoomUICom_packagecard.bin", mimeType="application/octet-stream")]
        public static var packagecard:Class;
        [Embed(source="binaryData/HabboRoomUICom_packagecard_new.bin", mimeType="application/octet-stream")]
        public static var packagecard_new:Class;
        [Embed(source="binaryData/HabboRoomUICom_packagecard_new_opened.bin", mimeType="application/octet-stream")]
        public static var packagecard_new_opened:Class;
        [Embed(source="images/HabboRoomUICom_gift_icon_background.png")]
        public static const gift_icon_background:Class;
        [Embed(source="images/HabboRoomUICom_giftcard_blank.png")]
        public static const giftcard_blank:Class;
        [Embed(source="images/HabboRoomUICom_gift_incognito.png")]
        public static const gift_incognito:Class;
        [Embed(source="binaryData/HabboRoomUICom_stickie.bin", mimeType="application/octet-stream")]
        public static var stickie:Class;
        [Embed(source="binaryData/HabboRoomUICom_notification_teaser.bin", mimeType="application/octet-stream")]
        public static var notification_teaser:Class;
        [Embed(source="binaryData/HabboRoomUICom_notification_gift_locked.bin", mimeType="application/octet-stream")]
        public static var notification_gift_locked:Class;
        [Embed(source="binaryData/HabboRoomUICom_notification_gift_unlocked.bin", mimeType="application/octet-stream")]
        public static var notification_gift_unlocked:Class;
        [Embed(source="binaryData/HabboRoomUICom_notification_gift_unlocked_notify.bin", mimeType="application/octet-stream")]
        public static var notification_gift_unlocked_notify:Class;
        [Embed(source="binaryData/HabboRoomUICom_notification_gift_received.bin", mimeType="application/octet-stream")]
        public static var notification_gift_received:Class;
        [Embed(source="binaryData/HabboRoomUICom_notification_gift_alert.bin", mimeType="application/octet-stream")]
        public static var notification_gift_alert:Class;
        [Embed(source="binaryData/HabboRoomUICom_trophy.bin", mimeType="application/octet-stream")]
        public static var trophy:Class;
        [Embed(source="binaryData/HabboRoomUICom_niko_trophy.bin", mimeType="application/octet-stream")]
        public static var niko_trophy:Class;
        [Embed(source="binaryData/HabboRoomUICom_dimmer_ui.bin", mimeType="application/octet-stream")]
        public static var dimmer_ui:Class;
        [Embed(source="binaryData/HabboRoomUICom_dimmer_color_chooser_cell.bin", mimeType="application/octet-stream")]
        public static var dimmer_color_chooser_cell:Class;
        [Embed(source="binaryData/HabboRoomUICom_badge_details.bin", mimeType="application/octet-stream")]
        public static var badge_details:Class;
        [Embed(source="binaryData/HabboRoomUICom_furni_view.bin", mimeType="application/octet-stream")]
        public static var furni_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_furni_view_branding_element.bin", mimeType="application/octet-stream")]
        public static var furni_view_branding_element:Class;
        [Embed(source="binaryData/HabboRoomUICom_furni_view_branding_element_numeric.bin", mimeType="application/octet-stream")]
        public static var furni_view_branding_element_numeric:Class;
        [Embed(source="binaryData/HabboRoomUICom_user_tag.bin", mimeType="application/octet-stream")]
        public static var user_tag:Class;
        [Embed(source="binaryData/HabboRoomUICom_user_tag_highlighted.bin", mimeType="application/octet-stream")]
        public static var user_tag_highlighted:Class;
        [Embed(source="binaryData/HabboRoomUICom_user_view.bin", mimeType="application/octet-stream")]
        public static var user_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_bot_view.bin", mimeType="application/octet-stream")]
        public static var bot_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_rentable_bot_view.bin", mimeType="application/octet-stream")]
        public static var rentable_bot_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_badge_entity.bin", mimeType="application/octet-stream")]
        public static var badge_entity:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_loading_bar.bin", mimeType="application/octet-stream")]
        public static var room_loading_bar:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu.bin", mimeType="application/octet-stream")]
        public static var memenu:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_dance.bin", mimeType="application/octet-stream")]
        public static var memenu_dance:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_dance_button.bin", mimeType="application/octet-stream")]
        public static var memenu_dance_button:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_effect_inactive.bin", mimeType="application/octet-stream")]
        public static var memenu_effect_inactive:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_effect_selected.bin", mimeType="application/octet-stream")]
        public static var memenu_effect_selected:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_effect_unselected.bin", mimeType="application/octet-stream")]
        public static var memenu_effect_unselected:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_effects.bin", mimeType="application/octet-stream")]
        public static var memenu_effects:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_main.bin", mimeType="application/octet-stream")]
        public static var memenu_main:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_main_simple.bin", mimeType="application/octet-stream")]
        public static var memenu_main_simple:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_settings.bin", mimeType="application/octet-stream")]
        public static var memenu_settings:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_chat_settings.bin", mimeType="application/octet-stream")]
        public static var memenu_chat_settings:Class;
        [Embed(source="binaryData/HabboRoomUICom_memenu_settings_menu.bin", mimeType="application/octet-stream")]
        public static var memenu_settings_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_notification.bin", mimeType="application/octet-stream")]
        public static var notification:Class;
        [Embed(source="binaryData/HabboRoomUICom_chat_history_pulldown.bin", mimeType="application/octet-stream")]
        public static var chat_history_pulldown:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_queue.bin", mimeType="application/octet-stream")]
        public static var room_queue:Class;
        [Embed(source="binaryData/HabboRoomUICom_poll_offer.bin", mimeType="application/octet-stream")]
        public static var poll_offer:Class;
        [Embed(source="binaryData/HabboRoomUICom_poll_question.bin", mimeType="application/octet-stream")]
        public static var poll_question:Class;
        [Embed(source="binaryData/HabboRoomUICom_poll_answer_text_input.bin", mimeType="application/octet-stream")]
        public static var poll_answer_text_input:Class;
        [Embed(source="binaryData/HabboRoomUICom_poll_answer_checkbox_input.bin", mimeType="application/octet-stream")]
        public static var poll_answer_checkbox_input:Class;
        [Embed(source="binaryData/HabboRoomUICom_poll_answer_radiobutton_input.bin", mimeType="application/octet-stream")]
        public static var poll_answer_radiobutton_input:Class;
        [Embed(source="binaryData/HabboRoomUICom_poll_cancel_confirm.bin", mimeType="application/octet-stream")]
        public static var poll_cancel_confirm:Class;
        [Embed(source="binaryData/HabboRoomUICom_pet_commands.bin", mimeType="application/octet-stream")]
        public static var pet_commands:Class;
        [Embed(source="binaryData/HabboRoomUICom_pet_view.bin", mimeType="application/octet-stream")]
        public static var pet_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_instant_friend_request.bin", mimeType="application/octet-stream")]
        public static var instant_friend_request:Class;
        [Embed(source="binaryData/HabboRoomUICom_boygirl.bin", mimeType="application/octet-stream")]
        public static var boygirl:Class;
        [Embed(source="binaryData/HabboRoomUICom_avatar_info_widget.bin", mimeType="application/octet-stream")]
        public static var avatar_info_widget:Class;
        [Embed(source="binaryData/HabboRoomUICom_avatar_menu_widget.bin", mimeType="application/octet-stream")]
        public static var avatar_menu_widget:Class;
        [Embed(source="binaryData/HabboRoomUICom_own_avatar_menu.bin", mimeType="application/octet-stream")]
        public static var own_avatar_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_own_avatar_decorating.bin", mimeType="application/octet-stream")]
        public static var own_avatar_decorating:Class;
        [Embed(source="binaryData/HabboRoomUICom_new_user_help.bin", mimeType="application/octet-stream")]
        public static var new_user_help:Class;
        [Embed(source="binaryData/HabboRoomUICom_own_pet_menu.bin", mimeType="application/octet-stream")]
        public static var own_pet_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_pet_menu.bin", mimeType="application/octet-stream")]
        public static var pet_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_menu.bin", mimeType="application/octet-stream")]
        public static var use_product_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_breed_pet_menu.bin", mimeType="application/octet-stream")]
        public static var breed_pet_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_breed_pets_confirmation_xml.bin", mimeType="application/octet-stream")]
        public static var breed_pets_confirmation_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_confirm_pet_breeding_xml.bin", mimeType="application/octet-stream")]
        public static var confirm_pet_breeding_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_pet_breeding_pet_preview_xml.bin", mimeType="application/octet-stream")]
        public static var pet_breeding_pet_preview_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_nestBreedingSuccess_xml.bin", mimeType="application/octet-stream")]
        public static var nestBreedingSuccess_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_breed_pets_result_xml.bin", mimeType="application/octet-stream")]
        public static var breed_pets_result_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_widget_frame_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_widget_frame_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_custom_part_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_custom_part_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_shampoo_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_shampoo_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_custom_part_shampoo_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_custom_part_shampoo_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_saddle_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_saddle_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_widget_frame_monsterplant_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_widget_frame_monsterplant_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_widget_frame_monsterplant_rebreed_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_widget_frame_monsterplant_rebreed_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_widget_frame_monsterplant_fertilize_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_widget_frame_monsterplant_fertilize_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_revive_monsterplant_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_revive_monsterplant_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_rebreed_monsterplant_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_rebreed_monsterplant_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_fertilize_monsterplant_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_fertilize_monsterplant_xml:Class;
        [Embed(source="images/HabboRoomUICom_use_product_preview_bg_png.png")]
        public static var use_product_preview_bg_png:Class;
        [Embed(source="images/HabboRoomUICom_breed_pets_preview_bg_png.png")]
        public static var breed_pets_preview_bg_png:Class;
        [Embed(source="images/HabboRoomUICom_plant_seed_preview_bg_png.png")]
        public static var plant_seed_preview_bg_png:Class;
        [Embed(source="images/HabboRoomUICom_plant_seed_preview_png.png")]
        public static var plant_seed_preview_png:Class;
        [Embed(source="binaryData/HabboRoomUICom_minimized_menu.bin", mimeType="application/octet-stream")]
        public static var minimized_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_welcome_gift_widget.bin", mimeType="application/octet-stream")]
        public static var welcome_gift_widget:Class;
        [Embed(source="binaryData/HabboRoomUICom_welcome_gift_email_unverified.bin", mimeType="application/octet-stream")]
        public static var welcome_gift_email_unverified:Class;
        [Embed(source="binaryData/HabboRoomUICom_welcome_gift_email_verified.bin", mimeType="application/octet-stream")]
        public static var welcome_gift_email_verified:Class;
        [Embed(source="binaryData/HabboRoomUICom_welcome_gift_email_change.bin", mimeType="application/octet-stream")]
        public static var welcome_gift_email_change:Class;
        [Embed(source="binaryData/HabboRoomUICom_jukebox_view.bin", mimeType="application/octet-stream")]
        public static var jukebox_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_crackable_furni_view.bin", mimeType="application/octet-stream")]
        public static var crackable_furni_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_songdisk_view.bin", mimeType="application/octet-stream")]
        public static var songdisk_view:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_inventory_subwindow_get_more_music.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_inventory_subwindow_get_more_music:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_inventory_subwindow_play_preview.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_inventory_subwindow_play_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_main_window.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_main_window:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_music_inventory_item.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_music_inventory_item:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_playlist_item.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_playlist_item:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_playlist_subwindow_add_songs.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_playlist_subwindow_add_songs:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_playlist_subwindow_nowplaying.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_playlist_subwindow_nowplaying:Class;
        [Embed(source="binaryData/HabboRoomUICom_playlisteditor_playlist_subwindow_play_now.bin", mimeType="application/octet-stream")]
        public static var playlisteditor_playlist_subwindow_play_now:Class;
        [Embed(source="binaryData/HabboRoomUICom_effects_widget.bin", mimeType="application/octet-stream")]
        public static var effects_widget:Class;
        [Embed(source="binaryData/HabboRoomUICom_effect_selector.bin", mimeType="application/octet-stream")]
        public static var effect_selector:Class;
        [Embed(source="binaryData/HabboRoomUICom_mannequin_widget_frame_xml.bin", mimeType="application/octet-stream")]
        public static var mannequin_widget_frame_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_mannequin_controller_main_xml.bin", mimeType="application/octet-stream")]
        public static var mannequin_controller_main_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_mannequin_controller_save_xml.bin", mimeType="application/octet-stream")]
        public static var mannequin_controller_save_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_mannequin_peer_main_xml.bin", mimeType="application/octet-stream")]
        public static var mannequin_peer_main_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_mannequin_no_club_xml.bin", mimeType="application/octet-stream")]
        public static var mannequin_no_club_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_mannequin_wrong_gender_xml.bin", mimeType="application/octet-stream")]
        public static var mannequin_wrong_gender_xml:Class;
        [Embed(source="images/HabboRoomUICom_mannequin_preview_bg_png.png")]
        public static var mannequin_preview_bg_png:Class;
        [Embed(source="binaryData/HabboRoomUICom_guild_furni_menu.bin", mimeType="application/octet-stream")]
        public static var guild_furni_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_random_teleport_menu.bin", mimeType="application/octet-stream")]
        public static var random_teleport_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_monsterplant_seed_menu.bin", mimeType="application/octet-stream")]
        public static var monsterplant_seed_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_mysterybox_menu.bin", mimeType="application/octet-stream")]
        public static var mysterybox_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_widget_frame_plant_seed_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_widget_frame_plant_seed_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_generic_usable_menu.bin", mimeType="application/octet-stream")]
        public static var generic_usable_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_effectbox_xml.bin", mimeType="application/octet-stream")]
        public static var effectbox_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_mysterytrophy_xml.bin", mimeType="application/octet-stream")]
        public static var mysterytrophy_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_plant_seed_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_plant_seed_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_use_product_controller_purchasable_clothing_xml.bin", mimeType="application/octet-stream")]
        public static var use_product_controller_purchasable_clothing_xml:Class;
        [Embed(source="images/HabboRoomUICom_sign_icon_heart.png")]
        public static var sign_icon_heart:Class;
        [Embed(source="images/HabboRoomUICom_sign_icon_skull.png")]
        public static var sign_icon_skull:Class;
        [Embed(source="images/HabboRoomUICom_sign_icon_13.png")]
        public static var sign_icon_13:Class;
        [Embed(source="images/HabboRoomUICom_sign_icon_14.png")]
        public static var sign_icon_14:Class;
        [Embed(source="images/HabboRoomUICom_sign_icon_15.png")]
        public static var sign_icon_15:Class;
        [Embed(source="images/HabboRoomUICom_sign_icon_16.png")]
        public static var sign_icon_16:Class;
        [Embed(source="images/HabboRoomUICom_sign_icon_17.png")]
        public static var sign_icon_17:Class;
        [Embed(source="images/HabboRoomUICom_pet_skill_level_0.png")]
        public static const pet_skill_level_0:Class;
        [Embed(source="images/HabboRoomUICom_pet_skill_level_1.png")]
        public static const pet_skill_level_1:Class;
        [Embed(source="images/HabboRoomUICom_pet_skill_level_2.png")]
        public static const pet_skill_level_2:Class;
        [Embed(source="images/HabboRoomUICom_pet_skill_level_3.png")]
        public static const pet_skill_level_3:Class;
        [Embed(source="images/HabboRoomUICom_pet_skill_level_4.png")]
        public static const pet_skill_level_4:Class;
        [Embed(source="binaryData/HabboRoomUICom_camera_interface_xml.bin", mimeType="application/octet-stream")]
        public static var camera_interface_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_photo_purchase_confirmation_xml.bin", mimeType="application/octet-stream")]
        public static var photo_purchase_confirmation_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_camera_editor_xml.bin", mimeType="application/octet-stream")]
        public static var camera_editor_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_camera_filterbutton_xml.bin", mimeType="application/octet-stream")]
        public static var camera_filterbutton_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_camera_typebutton_xml.bin", mimeType="application/octet-stream")]
        public static var camera_typebutton_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_background_color_ui_xml.bin", mimeType="application/octet-stream")]
        public static var background_color_ui_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_area_hide_ui_xml.bin", mimeType="application/octet-stream")]
        public static var area_hide_ui_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_gamehall_board_xml.bin", mimeType="application/octet-stream")]
        public static var gamehall_board_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_gamehall_leaderboard_xml.bin", mimeType="application/octet-stream")]
        public static var gamehall_leaderboard_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_viprequired_xml.bin", mimeType="application/octet-stream")]
        public static var viprequired_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_costumehopper_costumerequired_xml.bin", mimeType="application/octet-stream")]
        public static var costumehopper_costumerequired_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_respect_giving_failed_notification_xml.bin", mimeType="application/octet-stream")]
        public static var respect_giving_failed_notification_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_chatinput_chatstyle_template_xml.bin", mimeType="application/octet-stream")]
        public static var chatinput_chatstyle_template_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_chatinput_chatfontsize_template_xml.bin", mimeType="application/octet-stream")]
        public static var chatinput_chatfontsize_template_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_chatstyles_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_chatstyles_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_chat_bubble_left.png")]
        public static const roomchat_styles_normal_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_chat_bubble_left_color.png")]
        public static const roomchat_styles_normal_chat_bubble_left_color:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_chat_bubble_right.png")]
        public static const roomchat_styles_normal_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_selector_preview.png")]
        public static const roomchat_styles_normal_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_generic_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_generic_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_generic_bubble_generic_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_generic_bubble_generic_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_generic_chat_bubble_left.png")]
        public static const roomchat_styles_generic_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_generic_chat_bubble_middle.png")]
        public static const roomchat_styles_generic_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_generic_chat_bubble_right.png")]
        public static const roomchat_styles_generic_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_generic_chat_bubble_pointer.png")]
        public static const roomchat_styles_generic_chat_bubble_pointer:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_bot_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_bot_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_bot_bubble_bot_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_bot_bubble_bot_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_bot_bubble_bot_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_bot_bubble_bot_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_bot_bubble_bot_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_bot_bubble_bot_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_bot_bot_chat_bubble_left.png")]
        public static const roomchat_styles_bot_bot_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_bot_bot_chat_bubble_middle.png")]
        public static const roomchat_styles_bot_bot_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_bot_bot_chat_bubble_right.png")]
        public static const roomchat_styles_bot_bot_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_bot_bot_chat_bubble_pointer.png")]
        public static const roomchat_styles_bot_bot_chat_bubble_pointer:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_firingmylazer_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_firingmylazer_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_firingmylazer_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_firingmylazer_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_firingmylazer_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_firingmylazer_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_firingmylazer_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_firingmylazer_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_firingmylazer_chat_bubble_left.png")]
        public static const roomchat_styles_firingmylazer_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_firingmylazer_chat_bubble_middle.png")]
        public static const roomchat_styles_firingmylazer_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_firingmylazer_chat_bubble_right.png")]
        public static const roomchat_styles_firingmylazer_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_firingmylazer_chat_bubble_pointer.png")]
        public static const roomchat_styles_firingmylazer_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_firingmylazer_selector_preview.png")]
        public static const roomchat_styles_firingmylazer_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_gothicrose_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_gothicrose_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_gothicrose_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_gothicrose_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_gothicrose_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_gothicrose_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_gothicrose_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_gothicrose_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_gothicrose_chat_bubble_left.png")]
        public static const roomchat_styles_gothicrose_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_gothicrose_chat_bubble_middle.png")]
        public static const roomchat_styles_gothicrose_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_gothicrose_chat_bubble_right.png")]
        public static const roomchat_styles_gothicrose_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_gothicrose_chat_bubble_pointer.png")]
        public static const roomchat_styles_gothicrose_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_gothicrose_selector_preview.png")]
        public static const roomchat_styles_gothicrose_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_piglet_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_piglet_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_piglet_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_piglet_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_piglet_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_piglet_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_piglet_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_piglet_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_piglet_chat_bubble_left.png")]
        public static const roomchat_styles_piglet_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_piglet_chat_bubble_middle.png")]
        public static const roomchat_styles_piglet_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_piglet_chat_bubble_right.png")]
        public static const roomchat_styles_piglet_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_piglet_chat_bubble_pointer.png")]
        public static const roomchat_styles_piglet_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_piglet_selector_preview.png")]
        public static const roomchat_styles_piglet_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sausagedog_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sausagedog_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sausagedog_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sausagedog_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sausagedog_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sausagedog_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sausagedog_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sausagedog_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sausagedog_chat_bubble_left.png")]
        public static const roomchat_styles_sausagedog_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sausagedog_chat_bubble_middle.png")]
        public static const roomchat_styles_sausagedog_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sausagedog_chat_bubble_right.png")]
        public static const roomchat_styles_sausagedog_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sausagedog_chat_bubble_pointer.png")]
        public static const roomchat_styles_sausagedog_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sausagedog_selector_preview.png")]
        public static const roomchat_styles_sausagedog_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_dragon_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_dragon_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_dragon_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_dragon_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_dragon_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_dragon_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_dragon_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_dragon_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_dragon_chat_bubble_left.png")]
        public static const roomchat_styles_dragon_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_dragon_chat_bubble_middle.png")]
        public static const roomchat_styles_dragon_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_dragon_chat_bubble_right.png")]
        public static const roomchat_styles_dragon_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_dragon_chat_bubble_pointer.png")]
        public static const roomchat_styles_dragon_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_dragon_selector_preview.png")]
        public static const roomchat_styles_dragon_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_hearts_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_hearts_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_hearts_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_hearts_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_hearts_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_hearts_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_hearts_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_hearts_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_hearts_chat_bubble_left.png")]
        public static const roomchat_styles_hearts_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_hearts_chat_bubble_middle.png")]
        public static const roomchat_styles_hearts_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_hearts_chat_bubble_right.png")]
        public static const roomchat_styles_hearts_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_hearts_chat_bubble_pointer.png")]
        public static const roomchat_styles_hearts_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_hearts_selector_preview.png")]
        public static const roomchat_styles_hearts_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_turquoise_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_turquoise_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_turquoise_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_turquoise_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_chat_bubble_left.png")]
        public static const roomchat_styles_normal_dark_turquoise_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_dark_turquoise_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_chat_bubble_right.png")]
        public static const roomchat_styles_normal_dark_turquoise_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_dark_turquoise_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_turquoise_selector_preview.png")]
        public static const roomchat_styles_normal_dark_turquoise_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_yellow_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_yellow_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_yellow_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_yellow_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_yellow_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_yellow_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_dark_yellow_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_dark_yellow_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_yellow_chat_bubble_left.png")]
        public static const roomchat_styles_normal_dark_yellow_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_yellow_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_dark_yellow_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_yellow_chat_bubble_right.png")]
        public static const roomchat_styles_normal_dark_yellow_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_yellow_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_dark_yellow_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_dark_yellow_selector_preview.png")]
        public static const roomchat_styles_normal_dark_yellow_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_green_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_green_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_green_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_green_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_green_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_green_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_green_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_green_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_green_chat_bubble_left.png")]
        public static const roomchat_styles_normal_green_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_green_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_green_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_green_chat_bubble_right.png")]
        public static const roomchat_styles_normal_green_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_green_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_green_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_green_selector_preview.png")]
        public static const roomchat_styles_normal_green_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_pink_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_pink_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_pink_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_pink_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_pink_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_pink_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_pink_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_pink_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_pink_chat_bubble_left.png")]
        public static const roomchat_styles_normal_pink_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_pink_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_pink_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_pink_chat_bubble_right.png")]
        public static const roomchat_styles_normal_pink_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_pink_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_pink_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_pink_selector_preview.png")]
        public static const roomchat_styles_normal_pink_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_purple_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_purple_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_purple_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_purple_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_purple_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_purple_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_purple_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_purple_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_purple_chat_bubble_left.png")]
        public static const roomchat_styles_normal_purple_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_purple_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_purple_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_purple_chat_bubble_right.png")]
        public static const roomchat_styles_normal_purple_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_purple_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_purple_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_purple_selector_preview.png")]
        public static const roomchat_styles_normal_purple_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_sky_blue_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_sky_blue_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_sky_blue_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_sky_blue_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_sky_blue_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_sky_blue_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_sky_blue_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_sky_blue_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_sky_blue_chat_bubble_left.png")]
        public static const roomchat_styles_normal_sky_blue_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_sky_blue_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_sky_blue_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_sky_blue_chat_bubble_right.png")]
        public static const roomchat_styles_normal_sky_blue_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_sky_blue_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_sky_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_sky_blue_selector_preview.png")]
        public static const roomchat_styles_normal_sky_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_yellow_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_yellow_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_yellow_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_yellow_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_yellow_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_yellow_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_yellow_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_yellow_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_yellow_chat_bubble_left.png")]
        public static const roomchat_styles_normal_yellow_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_yellow_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_yellow_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_yellow_chat_bubble_right.png")]
        public static const roomchat_styles_normal_yellow_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_yellow_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_yellow_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_yellow_selector_preview.png")]
        public static const roomchat_styles_normal_yellow_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sticking_plaster_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sticking_plaster_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sticking_plaster_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sticking_plaster_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sticking_plaster_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sticking_plaster_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_sticking_plaster_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_sticking_plaster_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sticking_plaster_chat_bubble_left.png")]
        public static const roomchat_styles_sticking_plaster_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sticking_plaster_chat_bubble_middle.png")]
        public static const roomchat_styles_sticking_plaster_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sticking_plaster_chat_bubble_right.png")]
        public static const roomchat_styles_sticking_plaster_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sticking_plaster_chat_bubble_pointer.png")]
        public static const roomchat_styles_sticking_plaster_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_sticking_plaster_selector_preview.png")]
        public static const roomchat_styles_sticking_plaster_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_red_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_red_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_red_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_red_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_red_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_red_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_red_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_red_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_red_chat_bubble_left.png")]
        public static const roomchat_styles_normal_red_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_red_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_red_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_red_chat_bubble_right.png")]
        public static const roomchat_styles_normal_red_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_red_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_red_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_red_selector_preview.png")]
        public static const roomchat_styles_normal_red_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_blue_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_blue_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_blue_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_blue_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_blue_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_blue_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_blue_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_blue_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_blue_chat_bubble_left.png")]
        public static const roomchat_styles_normal_blue_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_blue_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_blue_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_blue_chat_bubble_right.png")]
        public static const roomchat_styles_normal_blue_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_blue_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_blue_selector_preview.png")]
        public static const roomchat_styles_normal_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_grey_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_grey_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_grey_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_grey_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_grey_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_grey_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_normal_grey_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_normal_grey_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_grey_chat_bubble_left.png")]
        public static const roomchat_styles_normal_grey_chat_bubble_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_grey_chat_bubble_middle.png")]
        public static const roomchat_styles_normal_grey_chat_bubble_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_grey_chat_bubble_right.png")]
        public static const roomchat_styles_normal_grey_chat_bubble_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_grey_chat_bubble_pointer.png")]
        public static const roomchat_styles_normal_grey_chat_bubble_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_normal_grey_selector_preview.png")]
        public static const roomchat_styles_normal_grey_selector_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_fortune_teller_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_fortune_teller_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_fortune_teller_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_fortune_teller_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_fortune_teller_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_fortune_teller_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_fortune_teller_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_fortune_teller_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_fortune_teller_left.png")]
        public static const roomchat_styles_fortune_teller_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_fortune_teller_mid.png")]
        public static const roomchat_styles_fortune_teller_mid:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_fortune_teller_right.png")]
        public static const roomchat_styles_fortune_teller_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_fortune_teller_pointer.png")]
        public static const roomchat_styles_fortune_teller_pointer:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_zombie_hand_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_zombie_hand_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_zombie_hand_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_zombie_hand_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_zombie_hand_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_zombie_hand_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_zombie_hand_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_zombie_hand_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_zombie_hand_left.png")]
        public static const roomchat_styles_zombie_hand_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_zombie_hand_middle.png")]
        public static const roomchat_styles_zombie_hand_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_zombie_hand_right.png")]
        public static const roomchat_styles_zombie_hand_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_zombie_hand_pointer.png")]
        public static const roomchat_styles_zombie_hand_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_zombie_hand_preview.png")]
        public static const roomchat_styles_zombie_hand_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_skeleton_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_skeleton_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_skeleton_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_skeleton_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_skeleton_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_skeleton_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_skeleton_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_skeleton_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_skeleton_left.png")]
        public static const roomchat_styles_skeleton_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_skeleton_middle.png")]
        public static const roomchat_styles_skeleton_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_skeleton_right.png")]
        public static const roomchat_styles_skeleton_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_skeleton_preview.png")]
        public static const roomchat_styles_skeleton_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_staff_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_staff_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_staff_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_staff_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_staff_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_staff_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_staff_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_staff_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_staff_left.png")]
        public static const roomchat_styles_staff_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_staff_middle.png")]
        public static const roomchat_styles_staff_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_staff_right.png")]
        public static const roomchat_styles_staff_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_staff_pointer.png")]
        public static const roomchat_styles_staff_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_staff_preview.png")]
        public static const roomchat_styles_staff_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_pirate_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_pirate_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_pirate_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_pirate_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_pirate_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_pirate_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_pirate_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_pirate_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_pirate_left.png")]
        public static const roomchat_styles_pirate_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_pirate_middle.png")]
        public static const roomchat_styles_pirate_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_pirate_right.png")]
        public static const roomchat_styles_pirate_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_pirate_pointer.png")]
        public static const roomchat_styles_pirate_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_pirate_preview.png")]
        public static const roomchat_styles_pirate_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_parrot_style_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_parrot_style_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_parrot_bubble_shout_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_parrot_bubble_shout_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_parrot_bubble_speak_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_parrot_bubble_speak_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_roomchat_styles_parrot_bubble_whisper_xml.bin", mimeType="application/octet-stream")]
        public static var roomchat_styles_parrot_bubble_whisper_xml:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_parrot_left.png")]
        public static const roomchat_styles_parrot_left:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_parrot_middle.png")]
        public static const roomchat_styles_parrot_middle:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_parrot_right.png")]
        public static const roomchat_styles_parrot_right:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_parrot_pointer.png")]
        public static const roomchat_styles_parrot_pointer:Class;
        [Embed(source="images/HabboRoomUICom_roomchat_styles_parrot_preview.png")]
        public static const roomchat_styles_parrot_preview:Class;
        [Embed(source="binaryData/HabboRoomUICom_styleselector_menu_xml.bin", mimeType="application/octet-stream")]
        public static var styleselector_menu_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_styleselector_menu_new_xml.bin", mimeType="application/octet-stream")]
        public static var styleselector_menu_new_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_chatter_configuration_xml.bin", mimeType="application/octet-stream")]
        public static var chatter_configuration_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_name_configuration_xml.bin", mimeType="application/octet-stream")]
        public static var name_configuration_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_motto_configuration.bin", mimeType="application/octet-stream")]
        public static var motto_configuration_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_lock_confirm_xml.bin", mimeType="application/octet-stream")]
        public static var lock_confirm_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_lovelock_engraving_xml.bin", mimeType="application/octet-stream")]
        public static var lovelock_engraving_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_habboween_engraving_xml.bin", mimeType="application/octet-stream")]
        public static var habboween_engraving_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_wildwest_engraving_xml.bin", mimeType="application/octet-stream")]
        public static var wildwest_engraving_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_friendfurni_menu.bin", mimeType="application/octet-stream")]
        public static var friendfurni_menu:Class;
        [Embed(source="binaryData/HabboRoomUICom_high_score_display_xml.bin", mimeType="application/octet-stream")]
        public static var high_score_display_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_custom_stack_height_xml.bin", mimeType="application/octet-stream")]
        public static var custom_stack_height_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_video_viewer_xml.bin", mimeType="application/octet-stream")]
        public static var video_viewer_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_rentablespace_xml.bin", mimeType="application/octet-stream")]
        public static var rentablespace_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_vimeo_viewer_xml.bin", mimeType="application/octet-stream")]
        public static var vimeo_viewer_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_tools_toolbar_xml.bin", mimeType="application/octet-stream")]
        public static var room_tools_toolbar_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_tools_info_xml.bin", mimeType="application/octet-stream")]
        public static var room_tools_info_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_stories_image_widget_xml.bin", mimeType="application/octet-stream")]
        public static var stories_image_widget_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_tools_history_xml.bin", mimeType="application/octet-stream")]
        public static var room_tools_history_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_room_tools_history_item_xml.bin", mimeType="application/octet-stream")]
        public static var room_tools_history_item_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_share_room_xml.bin", mimeType="application/octet-stream")]
        public static var share_room_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_report_photo_xml.bin", mimeType="application/octet-stream")]
        public static var report_photo_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_report_photo_poster_xml.bin", mimeType="application/octet-stream")]
        public static var report_photo_poster_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_wordquiz_question_xml.bin", mimeType="application/octet-stream")]
        public static var wordquiz_question_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_wordquiz_result_xml.bin", mimeType="application/octet-stream")]
        public static var wordquiz_result_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_wordquiz_like_xml.bin", mimeType="application/octet-stream")]
        public static var wordquiz_like_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_wordquiz_unlike_xml.bin", mimeType="application/octet-stream")]
        public static var wordquiz_unlike_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_ui_help_bubble.bin", mimeType="application/octet-stream")]
        public static var ui_help_bubble:Class;
        [Embed(source="binaryData/HabboRoomUICom_ui_help_modal.bin", mimeType="application/octet-stream")]
        public static var ui_help_modal:Class;
        [Embed(source="binaryData/HabboRoomUICom_iro_room_thumbnail_camera_xml.bin", mimeType="application/octet-stream")]
        public static var iro_room_thumbnail_camera_xml:Class;
        [Embed(source="binaryData/HabboRoomUICom_craftingwidget_xml.bin", mimeType="application/octet-stream")]
        public static var craftingwidget_xml:Class;
		public static var vote_question:Class = VoteQuestionXML;
        public static var vote_choice:Class = VoteChoiceXML;
    }
}
