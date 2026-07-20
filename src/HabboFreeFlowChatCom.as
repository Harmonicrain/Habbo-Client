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
        public static var requiredClasses:Array = new Array(HabboFreeFlowChatBootstrap, IIDHabboFreeFlowChat);
    }
}
