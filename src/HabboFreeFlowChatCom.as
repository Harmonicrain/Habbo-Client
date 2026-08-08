package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboFreeFlowChatBootstrap;
    import com.sulake.iid.IIDHabboFreeFlowChat;

    public class HabboFreeFlowChatCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboFreeFlowChatCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="images/HabboFreeFlowChatCom_tray_bar.png")]
        public static var tray_bar:Class;
        [Embed(source="images/HabboFreeFlowChatCom_tray_handle_close.png")]
        public static var tray_handle_close:Class;
        [Embed(source="images/HabboFreeFlowChatCom_tray_handle_open.png")]
        public static var tray_handle_open:Class;
        [Embed(source="images/HabboFreeFlowChatCom_close_x.png")]
        public static var close_x:Class;
        [Embed(source="images/HabboFreeFlowChatCom_room_change.png")]
        public static var room_change:Class;
        [Embed(source="images/HabboFreeFlowChatCom_scrollbar_back.png")]
        public static var scrollbar_back:Class;
        [Embed(source="images/HabboFreeFlowChatCom_scrollbar_thumb.png")]
        public static var scrollbar_thumb:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_chatstyles_xml.bin", mimeType="application/octet-stream")]
        public static var chatstyles_xml:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_bats_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_bats_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bats_chat_bubble_base.png")]
        public static var style_bats_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bats_chat_bubble_pointer.png")]
        public static var style_bats_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bats_selector_preview.png")]
        public static var style_bats_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_bot_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_bot_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_chat_bubble_base.png")]
        public static var style_bot_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_chat_bubble_pointer.png")]
        public static var style_bot_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_selector_preview.png")]
        public static var style_bot_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_console_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_console_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_console_chat_bubble_base.png")]
        public static var style_console_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_console_chat_bubble_pointer.png")]
        public static var style_console_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_console_selector_preview.png")]
        public static var style_console_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_firingmylazer_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_firingmylazer_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_firingmylazer_chat_bubble_base.png")]
        public static var style_firingmylazer_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_firingmylazer_chat_bubble_pointer.png")]
        public static var style_firingmylazer_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_firingmylazer_selector_preview.png")]
        public static var style_firingmylazer_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_fortune_teller_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_fortune_teller_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_fortune_teller_chat_bubble_base.png")]
        public static var style_fortune_teller_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_fortune_teller_chat_bubble_pointer.png")]
        public static var style_fortune_teller_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_fortune_teller_selector_preview.png")]
        public static var style_fortune_teller_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_generic_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_generic_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_generic_chat_bubble_base.png")]
        public static var style_generic_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_generic_chat_bubble_pointer.png")]
        public static var style_generic_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_generic_selector_preview.png")]
        public static var style_generic_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_gothicrose_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_gothicrose_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_gothicrose_chat_bubble_base.png")]
        public static var style_gothicrose_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_gothicrose_chat_bubble_pointer.png")]
        public static var style_gothicrose_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_gothicrose_selector_preview.png")]
        public static var style_gothicrose_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_chat_bubble_base.png")]
        public static var style_normal_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_chat_bubble_color.png")]
        public static var style_normal_chat_bubble_color:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_chat_bubble_pointer.png")]
        public static var style_normal_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_selector_preview.png")]
        public static var style_normal_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_blue_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_blue_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_blue_chat_bubble_base.png")]
        public static var style_normal_blue_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_blue_chat_bubble_pointer.png")]
        public static var style_normal_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_blue_selector_preview.png")]
        public static var style_normal_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_dark_turquoise_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_dark_turquoise_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_dark_turquoise_chat_bubble_base.png")]
        public static var style_normal_dark_turquoise_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_dark_turquoise_chat_bubble_pointer.png")]
        public static var style_normal_dark_turquoise_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_dark_turquoise_selector_preview.png")]
        public static var style_normal_dark_turquoise_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_dark_yellow_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_dark_yellow_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_dark_yellow_chat_bubble_base.png")]
        public static var style_normal_dark_yellow_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_dark_yellow_chat_bubble_pointer.png")]
        public static var style_normal_dark_yellow_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_dark_yellow_selector_preview.png")]
        public static var style_normal_dark_yellow_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_green_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_green_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_green_chat_bubble_base.png")]
        public static var style_normal_green_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_green_chat_bubble_pointer.png")]
        public static var style_normal_green_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_green_selector_preview.png")]
        public static var style_normal_green_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_grey_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_grey_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_grey_chat_bubble_base.png")]
        public static var style_normal_grey_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_grey_chat_bubble_pointer.png")]
        public static var style_normal_grey_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_grey_selector_preview.png")]
        public static var style_normal_grey_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_pink_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_pink_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_pink_chat_bubble_base.png")]
        public static var style_normal_pink_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_pink_chat_bubble_pointer.png")]
        public static var style_normal_pink_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_pink_selector_preview.png")]
        public static var style_normal_pink_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_purple_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_purple_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_purple_chat_bubble_base.png")]
        public static var style_normal_purple_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_purple_chat_bubble_pointer.png")]
        public static var style_normal_purple_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_purple_selector_preview.png")]
        public static var style_normal_purple_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_red_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_red_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_red_chat_bubble_base.png")]
        public static var style_normal_red_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_red_chat_bubble_pointer.png")]
        public static var style_normal_red_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_red_selector_preview.png")]
        public static var style_normal_red_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_sky_blue_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_sky_blue_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_sky_blue_chat_bubble_base.png")]
        public static var style_normal_sky_blue_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_sky_blue_chat_bubble_pointer.png")]
        public static var style_normal_sky_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_sky_blue_selector_preview.png")]
        public static var style_normal_sky_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_normal_yellow_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_normal_yellow_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_yellow_chat_bubble_base.png")]
        public static var style_normal_yellow_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_yellow_chat_bubble_pointer.png")]
        public static var style_normal_yellow_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_normal_yellow_selector_preview.png")]
        public static var style_normal_yellow_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_skeleton_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_skeleton_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_skeleton_chat_bubble_base.png")]
        public static var style_skeleton_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_skeleton_chat_bubble_pointer.png")]
        public static var style_skeleton_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_skeleton_selector_preview.png")]
        public static var style_skeleton_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_staff_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_staff_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_staff_chat_bubble_base.png")]
        public static var style_staff_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_staff_chat_bubble_pointer.png")]
        public static var style_staff_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_staff_selector_preview.png")]
        public static var style_staff_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_steampunk_pipe_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_steampunk_pipe_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_steampunk_pipe_chat_bubble_base.png")]
        public static var style_steampunk_pipe_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_steampunk_pipe_chat_bubble_pointer.png")]
        public static var style_steampunk_pipe_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_steampunk_pipe_selector_preview.png")]
        public static var style_steampunk_pipe_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_storm_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_storm_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_storm_chat_bubble_base.png")]
        public static var style_storm_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_storm_chat_bubble_pointer.png")]
        public static var style_storm_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_storm_selector_preview.png")]
        public static var style_storm_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_zombie_hand_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_zombie_hand_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_zombie_hand_chat_bubble_base.png")]
        public static var style_zombie_hand_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_zombie_hand_chat_bubble_pointer.png")]
        public static var style_zombie_hand_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_zombie_hand_selector_preview.png")]
        public static var style_zombie_hand_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_dragon_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_dragon_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_dragon_chat_bubble_base.png")]
        public static var style_dragon_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_dragon_chat_bubble_pointer.png")]
        public static var style_dragon_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_dragon_selector_preview.png")]
        public static var style_dragon_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_hearts_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_hearts_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_hearts_chat_bubble_base.png")]
        public static var style_hearts_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_hearts_chat_bubble_pointer.png")]
        public static var style_hearts_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_hearts_selector_preview.png")]
        public static var style_hearts_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_sausagedog_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_sausagedog_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_sausagedog_chat_bubble_base.png")]
        public static var style_sausagedog_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_sausagedog_chat_bubble_pointer.png")]
        public static var style_sausagedog_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_sausagedog_selector_preview.png")]
        public static var style_sausagedog_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_piglet_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_piglet_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_piglet_chat_bubble_base.png")]
        public static var style_piglet_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_piglet_chat_bubble_pointer.png")]
        public static var style_piglet_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_piglet_selector_preview.png")]
        public static var style_piglet_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_parrot_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_parrot_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_parrot_chat_bubble_base.png")]
        public static var style_parrot_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_parrot_chat_bubble_pointer.png")]
        public static var style_parrot_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_parrot_selector_preview.png")]
        public static var style_parrot_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_pirate_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_pirate_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_pirate_chat_bubble_base.png")]
        public static var style_pirate_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_pirate_chat_bubble_pointer.png")]
        public static var style_pirate_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_pirate_selector_preview.png")]
        public static var style_pirate_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_bot_guide_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_bot_guide_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_guide_chat_bubble_base.png")]
        public static var style_bot_guide_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_guide_chat_bubble_pointer.png")]
        public static var style_bot_guide_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_guide_selector_preview.png")]
        public static var style_bot_guide_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_bot_rentable_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_bot_rentable_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_rentable_chat_bubble_base.png")]
        public static var style_bot_rentable_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_rentable_chat_bubble_pointer.png")]
        public static var style_bot_rentable_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_rentable_selector_preview.png")]
        public static var style_bot_rentable_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_skelestock_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_skelestock_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_skelestock_chat_bubble_base.png")]
        public static var style_skelestock_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_skelestock_chat_bubble_pointer.png")]
        public static var style_skelestock_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_skelestock_selector_preview.png")]
        public static var style_skelestock_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_bot_frank_large_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_bot_frank_large_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_frank_large_chat_bubble_base.png")]
        public static var style_bot_frank_large_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_frank_large_chat_bubble_pointer.png")]
        public static var style_bot_frank_large_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_frank_large_selector_preview.png")]
        public static var style_bot_frank_large_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_frank_large_icon.png")]
        public static var style_bot_frank_large_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_chat_bubble_base.png")]
        public static var style_notification_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_chat_bubble_pointer.png")]
        public static var style_notification_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_selector_preview.png")]
        public static var style_notification_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_icon.png")]
        public static var style_notification_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_goat_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_goat_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_goat_chat_bubble_base.png")]
        public static var style_goat_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_goat_chat_bubble_pointer.png")]
        public static var style_goat_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_goat_selector_preview.png")]
        public static var style_goat_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_santa_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_santa_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_santa_chat_bubble_base.png")]
        public static var style_santa_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_santa_chat_bubble_pointer.png")]
        public static var style_santa_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_santa_selector_preview.png")]
        public static var style_santa_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_santa_icon.png")]
        public static var style_santa_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_ambassador_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_ambassador_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_ambassador_chat_bubble_base.png")]
        public static var style_ambassador_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_ambassador_chat_bubble_pointer.png")]
        public static var style_ambassador_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_ambassador_selector_preview.png")]
        public static var style_ambassador_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_radio_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_radio_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_radio_chat_bubble_base.png")]
        public static var style_radio_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_radio_chat_bubble_pointer.png")]
        public static var style_radio_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_radio_selector_preview.png")]
        public static var style_radio_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_radio_icon.png")]
        public static var style_radio_icon:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_staff_chat_bubble_emblem.png")]
        public static var style_staff_chat_bubble_emblem:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_staff_chat_bubble_emblem_multiline.png")]
        public static var style_staff_chat_bubble_emblem_multiline:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_wired_team_blue_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_wired_team_blue_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_blue_chat_bubble_base.png")]
        public static var style_wired_team_blue_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_blue_chat_bubble_pointer.png")]
        public static var style_wired_team_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_blue_selector_preview.png")]
        public static var style_wired_team_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_wired_team_green_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_wired_team_green_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_green_chat_bubble_base.png")]
        public static var style_wired_team_green_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_green_chat_bubble_pointer.png")]
        public static var style_wired_team_green_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_green_selector_preview.png")]
        public static var style_wired_team_green_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_wired_team_red_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_wired_team_red_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_red_chat_bubble_base.png")]
        public static var style_wired_team_red_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_red_chat_bubble_pointer.png")]
        public static var style_wired_team_red_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_red_selector_preview.png")]
        public static var style_wired_team_red_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_wired_team_yellow_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_wired_team_yellow_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_yellow_chat_bubble_base.png")]
        public static var style_wired_team_yellow_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_yellow_chat_bubble_pointer.png")]
        public static var style_wired_team_yellow_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_wired_team_yellow_selector_preview.png")]
        public static var style_wired_team_yellow_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_bot_rentable_icon.png")]
        public static var style_bot_rentable_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_red_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_red_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_red_chat_bubble_base.png")]
        public static var style_notification_red_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_red_chat_bubble_pointer.png")]
        public static var style_notification_red_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_red_selector_preview.png")]
        public static var style_notification_red_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_red_icon.png")]
        public static var style_notification_red_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_green_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_green_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_green_chat_bubble_base.png")]
        public static var style_notification_green_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_green_chat_bubble_pointer.png")]
        public static var style_notification_green_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_green_selector_preview.png")]
        public static var style_notification_green_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_green_icon.png")]
        public static var style_notification_green_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_blue_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_blue_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_blue_chat_bubble_base.png")]
        public static var style_notification_blue_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_blue_chat_bubble_pointer.png")]
        public static var style_notification_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_blue_selector_preview.png")]
        public static var style_notification_blue_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_blue_icon.png")]
        public static var style_notification_blue_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_alert_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_alert_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_alert_chat_bubble_base.png")]
        public static var style_notification_alert_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_alert_chat_bubble_pointer.png")]
        public static var style_notification_alert_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_alert_selector_preview.png")]
        public static var style_notification_alert_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_alert_icon.png")]
        public static var style_notification_alert_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_info_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_info_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_info_chat_bubble_base.png")]
        public static var style_notification_info_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_info_chat_bubble_pointer.png")]
        public static var style_notification_info_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_info_selector_preview.png")]
        public static var style_notification_info_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_info_icon.png")]
        public static var style_notification_info_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_warning_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_warning_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_warning_chat_bubble_base.png")]
        public static var style_notification_warning_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_warning_chat_bubble_pointer.png")]
        public static var style_notification_warning_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_warning_selector_preview.png")]
        public static var style_notification_warning_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_warning_icon.png")]
        public static var style_notification_warning_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_wrong_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_wrong_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_chat_bubble_base.png")]
        public static var style_notification_wrong_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_chat_bubble_pointer.png")]
        public static var style_notification_wrong_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_selector_preview.png")]
        public static var style_notification_wrong_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_icon.png")]
        public static var style_notification_wrong_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_wrong_circle_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_wrong_circle_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_circle_chat_bubble_base.png")]
        public static var style_notification_wrong_circle_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_circle_chat_bubble_pointer.png")]
        public static var style_notification_wrong_circle_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_circle_selector_preview.png")]
        public static var style_notification_wrong_circle_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_wrong_circle_icon.png")]
        public static var style_notification_wrong_circle_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_correct_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_correct_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_chat_bubble_base.png")]
        public static var style_notification_correct_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_chat_bubble_pointer.png")]
        public static var style_notification_correct_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_selector_preview.png")]
        public static var style_notification_correct_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_icon.png")]
        public static var style_notification_correct_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_correct_circle_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_correct_circle_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_circle_chat_bubble_base.png")]
        public static var style_notification_correct_circle_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_circle_chat_bubble_pointer.png")]
        public static var style_notification_correct_circle_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_circle_selector_preview.png")]
        public static var style_notification_correct_circle_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_correct_circle_icon.png")]
        public static var style_notification_correct_circle_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_question_mark_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_question_mark_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_chat_bubble_base.png")]
        public static var style_notification_question_mark_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_chat_bubble_pointer.png")]
        public static var style_notification_question_mark_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_selector_preview.png")]
        public static var style_notification_question_mark_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_icon.png")]
        public static var style_notification_question_mark_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_question_mark_circle_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_question_mark_circle_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_circle_chat_bubble_base.png")]
        public static var style_notification_question_mark_circle_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_circle_chat_bubble_pointer.png")]
        public static var style_notification_question_mark_circle_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_circle_selector_preview.png")]
        public static var style_notification_question_mark_circle_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_question_mark_circle_icon.png")]
        public static var style_notification_question_mark_circle_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_arrow_up_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_arrow_up_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_chat_bubble_base.png")]
        public static var style_notification_arrow_up_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_chat_bubble_pointer.png")]
        public static var style_notification_arrow_up_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_selector_preview.png")]
        public static var style_notification_arrow_up_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_icon.png")]
        public static var style_notification_arrow_up_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_arrow_up_circle_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_arrow_up_circle_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_circle_chat_bubble_base.png")]
        public static var style_notification_arrow_up_circle_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_circle_chat_bubble_pointer.png")]
        public static var style_notification_arrow_up_circle_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_circle_selector_preview.png")]
        public static var style_notification_arrow_up_circle_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_up_circle_icon.png")]
        public static var style_notification_arrow_up_circle_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_arrow_down_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_arrow_down_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_chat_bubble_base.png")]
        public static var style_notification_arrow_down_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_chat_bubble_pointer.png")]
        public static var style_notification_arrow_down_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_selector_preview.png")]
        public static var style_notification_arrow_down_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_icon.png")]
        public static var style_notification_arrow_down_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_arrow_down_circle_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_arrow_down_circle_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_circle_chat_bubble_base.png")]
        public static var style_notification_arrow_down_circle_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_circle_chat_bubble_pointer.png")]
        public static var style_notification_arrow_down_circle_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_circle_selector_preview.png")]
        public static var style_notification_arrow_down_circle_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_arrow_down_circle_icon.png")]
        public static var style_notification_arrow_down_circle_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_skull_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_skull_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_chat_bubble_base.png")]
        public static var style_notification_skull_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_chat_bubble_pointer.png")]
        public static var style_notification_skull_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_selector_preview.png")]
        public static var style_notification_skull_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_icon.png")]
        public static var style_notification_skull_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_skull_2_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_skull_2_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_2_chat_bubble_base.png")]
        public static var style_notification_skull_2_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_2_chat_bubble_pointer.png")]
        public static var style_notification_skull_2_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_2_selector_preview.png")]
        public static var style_notification_skull_2_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_skull_2_icon.png")]
        public static var style_notification_skull_2_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_notification_magnifier_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_notification_magnifier_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_magnifier_chat_bubble_base.png")]
        public static var style_notification_magnifier_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_magnifier_chat_bubble_pointer.png")]
        public static var style_notification_magnifier_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_magnifier_selector_preview.png")]
        public static var style_notification_magnifier_selector_preview:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_notification_magnifier_icon.png")]
        public static var style_notification_magnifier_icon:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_snowstorm_red_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_snowstorm_red_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_snowstorm_red_chat_bubble_base.png")]
        public static var style_snowstorm_red_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_snowstorm_red_chat_bubble_pointer.png")]
        public static var style_snowstorm_red_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_snowstorm_red_selector_preview.png")]
        public static var style_snowstorm_red_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_snowstorm_blue_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_snowstorm_blue_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_snowstorm_blue_chat_bubble_base.png")]
        public static var style_snowstorm_blue_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_snowstorm_blue_chat_bubble_pointer.png")]
        public static var style_snowstorm_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_snowstorm_blue_selector_preview.png")]
        public static var style_snowstorm_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_habbo_avatar_bronze_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_habbo_avatar_bronze_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_bronze_chat_bubble_base.png")]
        public static var style_nft_habbo_avatar_bronze_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_bronze_chat_bubble_pointer.png")]
        public static var style_nft_habbo_avatar_bronze_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_bronze_selector_preview.png")]
        public static var style_nft_habbo_avatar_bronze_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_habbo_avatar_gold_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_habbo_avatar_gold_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_gold_chat_bubble_base.png")]
        public static var style_nft_habbo_avatar_gold_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_gold_chat_bubble_pointer.png")]
        public static var style_nft_habbo_avatar_gold_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_gold_selector_preview.png")]
        public static var style_nft_habbo_avatar_gold_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_habbo_avatar_diamond_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_habbo_avatar_diamond_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_diamond_chat_bubble_base.png")]
        public static var style_nft_habbo_avatar_diamond_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_diamond_chat_bubble_pointer.png")]
        public static var style_nft_habbo_avatar_diamond_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_diamond_selector_preview.png")]
        public static var style_nft_habbo_avatar_diamond_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_habbo_avatar_rainbow_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_habbo_avatar_rainbow_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_rainbow_chat_bubble_base.png")]
        public static var style_nft_habbo_avatar_rainbow_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_rainbow_chat_bubble_pointer.png")]
        public static var style_nft_habbo_avatar_rainbow_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_rainbow_selector_preview.png")]
        public static var style_nft_habbo_avatar_rainbow_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_habbo_avatar_trippy_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_habbo_avatar_trippy_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_trippy_chat_bubble_base.png")]
        public static var style_nft_habbo_avatar_trippy_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_trippy_chat_bubble_pointer.png")]
        public static var style_nft_habbo_avatar_trippy_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_trippy_selector_preview.png")]
        public static var style_nft_habbo_avatar_trippy_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_habbo_avatar_ultra_trippy_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_habbo_avatar_ultra_trippy_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_ultra_trippy_chat_bubble_base.png")]
        public static var style_nft_habbo_avatar_ultra_trippy_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_ultra_trippy_chat_bubble_pointer.png")]
        public static var style_nft_habbo_avatar_ultra_trippy_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_habbo_avatar_ultra_trippy_selector_preview.png")]
        public static var style_nft_habbo_avatar_ultra_trippy_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_mvhq_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_mvhq_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_mvhq_chat_bubble_base.png")]
        public static var style_nft_mvhq_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_mvhq_chat_bubble_pointer.png")]
        public static var style_nft_mvhq_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_mvhq_selector_preview.png")]
        public static var style_nft_mvhq_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_metakey_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_metakey_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_metakey_chat_bubble_base.png")]
        public static var style_nft_metakey_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_metakey_chat_bubble_pointer.png")]
        public static var style_nft_metakey_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_metakey_selector_preview.png")]
        public static var style_nft_metakey_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_crafted_habbo_avatar_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_crafted_habbo_avatar_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_crafted_habbo_avatar_chat_bubble_base.png")]
        public static var style_nft_crafted_habbo_avatar_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_crafted_habbo_avatar_chat_bubble_pointer.png")]
        public static var style_nft_crafted_habbo_avatar_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_crafted_habbo_avatar_selector_preview.png")]
        public static var style_nft_crafted_habbo_avatar_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_balloon_orange_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_balloon_orange_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_balloon_orange_chat_bubble_base.png")]
        public static var style_nft_balloon_orange_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_balloon_orange_chat_bubble_pointer.png")]
        public static var style_nft_balloon_orange_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_balloon_orange_selector_preview.png")]
        public static var style_nft_balloon_orange_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_balloon_blue_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_balloon_blue_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_balloon_blue_chat_bubble_base.png")]
        public static var style_nft_balloon_blue_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_balloon_blue_chat_bubble_pointer.png")]
        public static var style_nft_balloon_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_balloon_blue_selector_preview.png")]
        public static var style_nft_balloon_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_origami_orange_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_origami_orange_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_origami_orange_chat_bubble_base.png")]
        public static var style_nft_origami_orange_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_origami_orange_chat_bubble_pointer.png")]
        public static var style_nft_origami_orange_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_origami_orange_selector_preview.png")]
        public static var style_nft_origami_orange_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_origami_blue_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_origami_blue_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_origami_blue_chat_bubble_base.png")]
        public static var style_nft_origami_blue_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_origami_blue_chat_bubble_pointer.png")]
        public static var style_nft_origami_blue_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_origami_blue_selector_preview.png")]
        public static var style_nft_origami_blue_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_chocolate_dark_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_chocolate_dark_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_chocolate_dark_chat_bubble_base.png")]
        public static var style_nft_chocolate_dark_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_chocolate_dark_chat_bubble_pointer.png")]
        public static var style_nft_chocolate_dark_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_chocolate_dark_selector_preview.png")]
        public static var style_nft_chocolate_dark_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_chocolate_white_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_chocolate_white_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_chocolate_white_chat_bubble_base.png")]
        public static var style_nft_chocolate_white_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_chocolate_white_chat_bubble_pointer.png")]
        public static var style_nft_chocolate_white_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_chocolate_white_selector_preview.png")]
        public static var style_nft_chocolate_white_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_clay_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_clay_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_clay_chat_bubble_base.png")]
        public static var style_nft_clay_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_clay_chat_bubble_pointer.png")]
        public static var style_nft_clay_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_clay_selector_preview.png")]
        public static var style_nft_clay_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_scroll_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_scroll_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_scroll_chat_bubble_base.png")]
        public static var style_nft_scroll_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_scroll_chat_bubble_pointer.png")]
        public static var style_nft_scroll_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_scroll_selector_preview.png")]
        public static var style_nft_scroll_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_pillow_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_pillow_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_pillow_chat_bubble_base.png")]
        public static var style_nft_pillow_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_pillow_chat_bubble_pointer.png")]
        public static var style_nft_pillow_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_pillow_selector_preview.png")]
        public static var style_nft_pillow_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_bobba_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_bobba_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_bobba_chat_bubble_base.png")]
        public static var style_nft_bobba_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_bobba_chat_bubble_pointer.png")]
        public static var style_nft_bobba_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_bobba_selector_preview.png")]
        public static var style_nft_bobba_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_pinktube_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_pinktube_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_pinktube_chat_bubble_base.png")]
        public static var style_nft_pinktube_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_pinktube_chat_bubble_pointer.png")]
        public static var style_nft_pinktube_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_pinktube_selector_preview.png")]
        public static var style_nft_pinktube_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_keycaps_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_keycaps_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_keycaps_chat_bubble_base.png")]
        public static var style_nft_keycaps_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_keycaps_chat_bubble_pointer.png")]
        public static var style_nft_keycaps_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_keycaps_selector_preview.png")]
        public static var style_nft_keycaps_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_xmas22_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_xmas22_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_xmas22_chat_bubble_base.png")]
        public static var style_nft_xmas22_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_xmas22_chat_bubble_pointer.png")]
        public static var style_nft_xmas22_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_xmas22_selector_preview.png")]
        public static var style_nft_xmas22_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_recycled_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_recycled_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_recycled_chat_bubble_base.png")]
        public static var style_recycled_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_recycled_chat_bubble_pointer.png")]
        public static var style_recycled_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_recycled_selector_preview.png")]
        public static var style_recycled_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_rocky_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_rocky_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_rocky_chat_bubble_base.png")]
        public static var style_nft_rocky_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_rocky_chat_bubble_pointer.png")]
        public static var style_nft_rocky_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_rocky_selector_preview.png")]
        public static var style_nft_rocky_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_ice_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_ice_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_ice_chat_bubble_base.png")]
        public static var style_nft_ice_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_ice_chat_bubble_pointer.png")]
        public static var style_nft_ice_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_ice_selector_preview.png")]
        public static var style_nft_ice_selector_preview:Class;
        [Embed(source="binaryData/HabboFreeFlowChatCom_style_nft_aurora_regpoints.bin", mimeType="application/octet-stream")]
        public static var style_nft_aurora_regpoints:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_aurora_chat_bubble_base.png")]
        public static var style_nft_aurora_chat_bubble_base:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_aurora_chat_bubble_pointer.png")]
        public static var style_nft_aurora_chat_bubble_pointer:Class;
        [Embed(source="images/HabboFreeFlowChatCom_style_nft_aurora_selector_preview.png")]
        public static var style_nft_aurora_selector_preview:Class;
        public static var requiredClasses:Array = new Array(HabboFreeFlowChatBootstrap, IIDHabboFreeFlowChat);
    }
}
