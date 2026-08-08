package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboUserDefinedRoomEventsBootstrap;
    import com.sulake.iid.IIDHabboUserDefinedRoomEvents;

    public class HabboUserDefinedRoomEventsCom extends SimpleApplication 
    {
        [Embed(source="images/HabboUserDefinedRoomEventsCom_icon_action_png.png")]
        public static var icon_action_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_icon_condition_png.png")]
        public static var icon_condition_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_icon_trigger_png.png")]
        public static var icon_trigger_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_move_0_png.png")]
        public static var move_0_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_move_2_png.png")]
        public static var move_2_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_move_4_png.png")]
        public static var move_4_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_move_6_png.png")]
        public static var move_6_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_move_diag_png.png")]
        public static var move_diag_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_move_rnd_png.png")]
        public static var move_rnd_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_move_vrt_png.png")]
        public static var move_vrt_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_rotate_ccw_png.png")]
        public static var rotate_ccw_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_rotate_cw_png.png")]
        public static var rotate_cw_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_slider_bg_png.png")]
        public static var slider_bg_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_slider_obj_png.png")]
        public static var slider_obj_png:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_slider_bg_png.png")]
        public static var wired_styles_volter_slider_bg:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_slider_obj_png.png")]
        public static var wired_styles_illumina_slider_obj:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_main_xml.bin", mimeType="application/octet-stream")]
        public static var ude_main_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_help_xml.bin", mimeType="application/octet-stream")]
        public static var ude_help_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_slider_xml.bin", mimeType="application/octet-stream")]
        public static var ude_slider_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_0_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_0_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_3_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_3_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_6_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_6_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_7_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_7_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_12_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_12_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_10_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_10_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_13_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_13_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_trigger_inputs_14_xml.bin", mimeType="application/octet-stream")]
        public static var ude_trigger_inputs_14_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_3_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_3_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_4_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_4_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_6_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_6_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_7_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_7_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_9_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_9_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_13_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_13_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_14_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_14_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_16_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_16_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_17_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_17_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_17_reward_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_17_reward_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_19_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_19_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_20_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_20_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_21_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_21_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_22_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_22_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_23_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_23_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_24_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_24_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_25_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_25_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_26_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_26_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_action_inputs_27_xml.bin", mimeType="application/octet-stream")]
        public static var ude_action_inputs_27_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_0_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_0_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_3_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_3_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_4_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_4_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_5_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_5_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_6_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_6_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_7_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_7_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_9_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_9_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_11_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_11_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_12_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_12_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_18_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_18_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_24_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_24_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_ude_condition_inputs_25_xml.bin", mimeType="application/octet-stream")]
        public static var ude_condition_inputs_25_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_container_view_xml.bin", mimeType="application/octet-stream")]
        public static var container_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_growing_container_view_xml.bin", mimeType="application/octet-stream")]
        public static var growing_container_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_horizontal_list_view_xml.bin", mimeType="application/octet-stream")]
        public static var horizontal_list_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_vertical_list_view_xml.bin", mimeType="application/octet-stream")]
        public static var vertical_list_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_radio_group_view_xml.bin", mimeType="application/octet-stream")]
        public static var radio_group_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_vertical_scroll_list_view_xml.bin", mimeType="application/octet-stream")]
        public static var vertical_scroll_list_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_static_bitmap_view_xml.bin", mimeType="application/octet-stream")]
        public static var static_bitmap_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_bitmap_wrapper_view_xml.bin", mimeType="application/octet-stream")]
        public static var bitmap_wrapper_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_border_view_xml.bin", mimeType="application/octet-stream")]
        public static var border_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_search_tree_dropdown_xml.bin", mimeType="application/octet-stream")]
        public static var search_tree_dropdown_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_wired_style_illumina_xml.bin", mimeType="application/octet-stream")]
        public static var wired_style_illumina_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_wired_style_ubuntu_xml.bin", mimeType="application/octet-stream")]
        public static var wired_style_ubuntu_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_wired_menu_view_xml.bin", mimeType="application/octet-stream")]
        public static var wired_menu_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_wired_menu_logs_overview_xml.bin", mimeType="application/octet-stream")]
        public static var wired_menu_logs_overview_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_wired_menu_variables_management_overview_xml.bin", mimeType="application/octet-stream")]
        public static var wired_menu_variables_management_overview_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_wired_menu_variables_management_detail_xml.bin", mimeType="application/octet-stream")]
        public static var wired_menu_variables_management_detail_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_wired_menu_error_info_view_xml.bin", mimeType="application/octet-stream")]
        public static var wired_menu_error_info_view_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_chest_generic_xml.bin", mimeType="application/octet-stream")]
        public static var chest_generic_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_coins_chest_contents_xml.bin", mimeType="application/octet-stream")]
        public static var coins_chest_contents_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_furni_chest_contents_xml.bin", mimeType="application/octet-stream")]
        public static var furni_chest_contents_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_chest_upgrade_xml.bin", mimeType="application/octet-stream")]
        public static var chest_upgrade_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_chest_wired_upgrade_xml.bin", mimeType="application/octet-stream")]
        public static var chest_wired_upgrade_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_transaction_overview_xml.bin", mimeType="application/octet-stream")]
        public static var transaction_overview_xml:Class;
        [Embed(source="binaryData/HabboUserDefinedRoomEventsCom_transaction_details_xml.bin", mimeType="application/octet-stream")]
        public static var transaction_details_xml:Class;
        // Reuse the clean client's established table renderer inside the July
        // Wired Menu rather than cloning unscrollable text controls.
        [Embed(source="binaryData/HabboRoomUICom_table_view_xml.bin", mimeType="application/octet-stream")]
        public static var table_view_xml:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_N.png")]
        public static var floor_editor_border_N:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_NE.png")]
        public static var floor_editor_border_NE:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_E.png")]
        public static var floor_editor_border_E:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_SE.png")]
        public static var floor_editor_border_SE:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_S.png")]
        public static var floor_editor_border_S:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_SW.png")]
        public static var floor_editor_border_SW:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_W.png")]
        public static var floor_editor_border_W:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_border_NW.png")]
        public static var floor_editor_border_NW:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_tile_base.png")]
        public static var floor_editor_tile_base:Class;
        [Embed(source="images/HabboUserDefinedRoomEventsCom_floor_editor_tile_entry.png")]
        public static var floor_editor_tile_entry:Class;
        public static var requiredClasses:Array = new Array(HabboUserDefinedRoomEventsBootstrap, IIDHabboUserDefinedRoomEvents);
    }
}
