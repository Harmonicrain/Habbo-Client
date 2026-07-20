package 
{
	import com.sulake.habbo.ui.widget.infobuspolls.binaryData.VoteChoiceXML;
	import com.sulake.habbo.ui.widget.infobuspolls.binaryData.VoteQuestionXML;
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboWindowManagerComponentBootstrap;
    import com.sulake.iid.IIDHabboWindowManager;
    import com.sulake.iid.IIDCoreWindowManager;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import fonts.*;

    public class HabboWindowManagerCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboWindowManagerComponentBootstrap, IIDHabboWindowManager, IIDCoreWindowManager, HabboWindowManagerComponent, ICoreLocalizationFrameworkLib, ICoreWindowFrameworkLib, CoreWindowFrameworkLib);
        [Embed(source="binaryData/HabboWindowManagerCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_element_description_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_element_description_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_alert_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_alert_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_bubble_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_bubble_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_bubble_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_bubble_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_thick_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_thick_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_thick_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_thick_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_shiny_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_shiny_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_shiny_thick_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_shiny_thick_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_shiny_large_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_shiny_large_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_shiny_large_5_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_shiny_large_5_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_shiny_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_shiny_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_button_shiny_thick_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_button_shiny_thick_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_dropmenu_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_dropmenu_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_dropmenu_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_dropmenu_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_dropmenu_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_dropmenu_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_dropmenu_item_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_dropmenu_item_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_dropmenu_item_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_dropmenu_item_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_dropmenu_item_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_dropmenu_item_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_droplist_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_droplist_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_frame_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_frame_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_frame_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_frame_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_frame_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_header_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_header_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_header_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_header_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_header_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_header_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_header_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_header_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scaler_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scaler_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scaler_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scaler_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scrollbar_horizontal_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scrollbar_horizontal_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scrollbar_vertical_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scrollbar_vertical_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scrollable_itemlist_vertical_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scrollable_itemlist_vertical_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scrollable_itemgrid_vertical_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scrollable_itemgrid_vertical_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scrollable_itemlist_vertical_ubuntu_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scrollable_itemlist_vertical_ubuntu_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_scrollable_itemgrid_vertical_ubuntu_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_scrollable_itemgrid_vertical_ubuntu_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_simple_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_simple_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_tab_button_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_tab_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_tab_button_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_tab_button_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_tab_button_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_tab_button_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_tab_context_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_tab_context_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_tab_context_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_tab_context_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_layout_tooltip_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_layout_tooltip_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_frame_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_frame_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_frame_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_frame_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_frame_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_up_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_up_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_right_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_right_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_down_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_down_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_frame_pointer_down_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_frame_pointer_down_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_left_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_left_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_up_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_up_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_right_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_right_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_down_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_down_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_bubble_pointer_left_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_bubble_pointer_left_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_default_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_default_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_default_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_default_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_default_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_default_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_shiny_default_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_shiny_default_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_shiny_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_shiny_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_shiny_thick_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_shiny_thick_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_shiny_large_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_shiny_large_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_shiny_thick_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_shiny_thick_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_thick_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_thick_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_thick_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_thick_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_thick_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_thick_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_left_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_left_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_left_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_left_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_left_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_left_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_center_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_center_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_center_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_center_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_center_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_center_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_right_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_right_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_right_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_right_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_group_right_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_group_right_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_checkbox_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_checkbox_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_checkbox_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_checkbox_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_checkbox_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_checkbox_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_close_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_close_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_close_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_close_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_close_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_close_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_close_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_close_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_help_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_help_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_radio_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_radio_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_radio_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_radio_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_radio_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_radio_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_tab_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_tab_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_tab_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_tab_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_tab_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_tab_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_button_tab_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_button_tab_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_tab_content_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_tab_content_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_scaler_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_scaler_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_scaler_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_scaler_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_scaler_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_scaler_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_scaler_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_scaler_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_scrollbar_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_scrollbar_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_scrollbar_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_scrollbar_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_scrollbar_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_scrollbar_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_header_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_header_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_header_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_header_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_header_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_header_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_icon_set_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_icon_set_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_dropmenu_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_dropmenu_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_dropmenu_3_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_dropmenu_3_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_dropmenu_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_dropmenu_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_droplist_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_droplist_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_droplist_thick_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_droplist_thick_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_tab_context_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_tab_context_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_black_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_black_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_colorless_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_colorless_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_colorless_dropshadow_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_colorless_dropshadow_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_white_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_white_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_slot_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_slot_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_4_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_4_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_5_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_5_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_6_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_6_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_7_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_7_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_8_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_8_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_border_9_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_border_9_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_text_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_text_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_skin_tooltip_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_skin_tooltip_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_text_styles_css.bin", mimeType="application/octet-stream")]
    public static var text_styles_css:Class;
        [Embed(source="images/HabboWindowManagerCom_habbo_blue_skin_png.png")]
    public static var habbo_blue_skin_png:Class;
        [Embed(source="images/HabboWindowManagerCom_habbo_skin_ubuntu_png.png")]
    public static var habbo_skin_ubuntu_png:Class;
        [Embed(source="images/HabboWindowManagerCom_skin_ubuntu_bg_9.png")]
    public static var skin_ubuntu_bg_9:Class;
        [Embed(source="images/HabboWindowManagerCom_habbo_cursor_link_png.png")]
    public static var habbo_cursor_link_png:Class;
        [Embed(source="images/HabboWindowManagerCom_habbo_cursor_drag_png.png")]
    public static var habbo_cursor_drag_png:Class;
        [Embed(source="images/HabboWindowManagerCom_habbo_icons_png.png")]
    public static var habbo_icons_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_png.png")]
    public static var placeholder_avatar_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_head_png.png")]
    public static var placeholder_avatar_head_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_cropped_png.png")]
    public static var placeholder_avatar_cropped_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_head_cropped_png.png")]
    public static var placeholder_avatar_head_cropped_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_small_png.png")]
    public static var placeholder_avatar_small_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_small_head_png.png")]
    public static var placeholder_avatar_small_head_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_small_cropped_png.png")]
    public static var placeholder_avatar_small_cropped_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_avatar_small_head_cropped_png.png")]
    public static var placeholder_avatar_small_head_cropped_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_pet_png.png")]
    public static var placeholder_pet_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_pet_small_png.png")]
    public static var placeholder_pet_small_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_furni_png.png")]
    public static var placeholder_furni_png:Class;
        [Embed(source="images/HabboWindowManagerCom_placeholder_furni_small_png.png")]
    public static var placeholder_furni_small_png:Class;
        [Embed(source="images/HabboWindowManagerCom_navigation_icon_weblink.png")]
    public static var navigation_icon_weblink:Class;
        public static var volter:Class = _Str_10363;
        public static var volterb:Class = _Str_10339;
        public static var ubuntu_regular:Class = _Str_10940;
        public static var ubuntu_bold:Class = _Str_11970;
        public static var ubuntu_condensed:Class = _Str_11108;
        public static var ubuntuThick_bold:Class = _Str_10537;
        public static var ubuntu_italic:Class = _Str_11991;
        public static var ubuntu_bold_italic:Class = _Str_10581;
        public static var ubuntuMedium:Class = _Str_10176;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_alert_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_alert_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_alert_link_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_alert_link_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_window_confirm_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_window_confirm_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_habbo_crasher_dialog_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_crasher_dialog_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_unseen_item_counter_xml.bin", mimeType="application/octet-stream")]
    public static var unseen_item_counter_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_simple_alert_xml.bin", mimeType="application/octet-stream")]
    public static var simple_alert_xml:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_alert_illustrations_frank_neutral_png.png")]
    public static var illumina_alert_illustrations_frank_neutral_png:Class;
        [Embed(source="images/HabboWindowManagerCom_habbo_skin_illumina_light_png.png")]
    public static var habbo_skin_illumina_light_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_balloon_png.png")]
    public static var illumina_light_balloon_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_border_etched_png.png")]
    public static var illumina_light_border_etched_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_border_frame_png.png")]
    public static var illumina_light_border_frame_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_border_infobox_png.png")]
    public static var illumina_light_border_infobox_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_border_light_png.png")]
    public static var illumina_light_border_light_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_border_raised_png.png")]
    public static var illumina_light_border_raised_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_border_sunk_png.png")]
    public static var illumina_light_border_sunk_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_bubble_chat_arrow_png.png")]
    public static var illumina_light_bubble_chat_arrow_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_bubble_chat_bg_png.png")]
    public static var illumina_light_bubble_chat_bg_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_button_default_png.png")]
    public static var illumina_light_button_default_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_button_frame_close_png.png")]
    public static var illumina_light_button_frame_close_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_button_unetched_png.png")]
    public static var illumina_light_button_unetched_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_checkbox_basic_png.png")]
    public static var illumina_light_checkbox_basic_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_clock_background_png.png")]
    public static var illumina_light_clock_background_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_clock_background_left_png.png")]
    public static var illumina_light_clock_background_left_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_clock_background_mid_png.png")]
    public static var illumina_light_clock_background_mid_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_clock_background_right_png.png")]
    public static var illumina_light_clock_background_right_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_icons_png.png")]
    public static var illumina_light_icons_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_input_chat_png.png")]
    public static var illumina_light_input_chat_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_progress_indicator_etched_png.png")]
    public static var illumina_light_progress_indicator_etched_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_progress_indicator_flat_png.png")]
    public static var illumina_light_progress_indicator_flat_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_radio_button_png.png")]
    public static var illumina_light_radio_button_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_scrollbar_horizontal_png.png")]
    public static var illumina_light_scrollbar_horizontal_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_scrollbar_vertical_png.png")]
    public static var illumina_light_scrollbar_vertical_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_separator_png.png")]
    public static var illumina_light_separator_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_light_switch_png.png")]
    public static var illumina_light_switch_png:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_sunk_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_sunk_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_light_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_light_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_raised_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_raised_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_input_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_input_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_chat_bubble_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_chat_bubble_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_balloon_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_balloon_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_border_infobox_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_border_infobox_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_frame_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_frame_modal_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_frame_modal_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_frame_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_button_plain_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_button_plain_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_button_plain_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_button_plain_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_button_unetched_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_button_unetched_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_checkbox_basic_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_checkbox_basic_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_checkbox_basic_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_checkbox_basic_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_switch_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_switch_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_switch_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_switch_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_radio_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_radio_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_radio_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_radio_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_scrollbar_horizontal_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_scrollbar_horizontal_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_scrollbar_vertical_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_scrollbar_vertical_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_skin_scrollbar_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_skin_scrollbar_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_scrollable_itemlist_vertical_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_scrollable_itemlist_vertical_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_dropmenu_item_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_dropmenu_item_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_light_dropmenu_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_light_dropmenu_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_purple_frame_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_purple_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_purple_skin_frame_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_purple_skin_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_purple_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_purple_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_purple_skin_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_purple_skin_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_purple_button_plain_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_purple_button_plain_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_purple_skin_button_plain_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_purple_skin_button_plain_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_purple_skin_button_frame_close_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_purple_skin_button_frame_close_xml:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_purple_border_frame_png.png")]
    public static var illumina_purple_border_frame_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_purple_button_default_png.png")]
    public static var illumina_purple_button_default_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_purple_button_frame_close_png.png")]
    public static var illumina_purple_button_frame_close_png:Class;
        [Embed(source="images/HabboWindowManagerCom_habbo_skin_illumina_dark_png.png")]
    public static var habbo_skin_illumina_dark_png:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_skin_border_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_skin_border_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_frame_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_skin_frame_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_skin_frame_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_header_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_header_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_skin_header_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_skin_header_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_skin_button_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_skin_button_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_scrollbar_horizontal_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_scrollbar_horizontal_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_scrollbar_vertical_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_scrollbar_vertical_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_dark_skin_scrollbar_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_dark_skin_scrollbar_xml:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_dark_scrollbar_horizontal_png.png")]
    public static var illumina_dark_scrollbar_horizontal_png:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_dark_scrollbar_vertical_png.png")]
    public static var illumina_dark_scrollbar_vertical_png:Class;
        [Embed(source="images/HabboWindowManagerCom_achievement_ach_progressbar1.png")]
    public static var achievement_ach_progressbar1:Class;
        [Embed(source="images/HabboWindowManagerCom_achievement_ach_progressbar2.png")]
    public static var achievement_ach_progressbar2:Class;
        [Embed(source="images/HabboWindowManagerCom_achievement_ach_progressbar3.png")]
    public static var achievement_ach_progressbar3:Class;
        [Embed(source="images/HabboWindowManagerCom_achievement_ach_progressbar4.png")]
    public static var achievement_ach_progressbar4:Class;
        [Embed(source="images/HabboWindowManagerCom_achievement_ach_progressbar5.png")]
    public static var achievement_ach_progressbar5:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_avatar_editor_download_icon.png")]
    public static var avatar_editor_avatar_editor_download_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_editor_clr_13x21_1.png")]
    public static var avatar_editor_editor_clr_13x21_1:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_editor_clr_13x21_2.png")]
    public static var avatar_editor_editor_clr_13x21_2:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_editor_clr_13x21_3.png")]
    public static var avatar_editor_editor_clr_13x21_3:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_editor_clr_40x32_1.png")]
    public static var avatar_editor_editor_clr_40x32_1:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_editor_clr_40x32_2.png")]
    public static var avatar_editor_editor_clr_40x32_2:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_editor_clr_40x32_3.png")]
    public static var avatar_editor_editor_clr_40x32_3:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_generic_platform.png")]
    public static var avatar_editor_generic_platform:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_generic_remove_selection.png")]
    public static var avatar_editor_generic_remove_selection:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_parts_hilite.png")]
    public static var avatar_editor_parts_hilite:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_parts_hilite_with_sd.png")]
    public static var avatar_editor_parts_hilite_with_sd:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_rotate_avatar_button.png")]
    public static var avatar_editor_rotate_avatar_button:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_effects.png")]
    public static var avatar_editor_tabs_ae_tabs_effects:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_generic.png")]
    public static var avatar_editor_tabs_ae_tabs_generic:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_head.png")]
    public static var avatar_editor_tabs_ae_tabs_head:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_hotlooks.png")]
    public static var avatar_editor_tabs_ae_tabs_hotlooks:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_legs.png")]
    public static var avatar_editor_tabs_ae_tabs_legs:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_misc.png")]
    public static var avatar_editor_tabs_ae_tabs_misc:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_torso.png")]
    public static var avatar_editor_tabs_ae_tabs_torso:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_ae_tabs_wardrobe.png")]
    public static var avatar_editor_tabs_ae_tabs_wardrobe:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_bottom_accessories.png")]
    public static var avatar_editor_tabs_bottom_accessories:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_bottom_accessories_on.png")]
    public static var avatar_editor_tabs_bottom_accessories_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_bottom_shoes.png")]
    public static var avatar_editor_tabs_bottom_shoes:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_bottom_shoes_on.png")]
    public static var avatar_editor_tabs_bottom_shoes_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_bottom_trousers.png")]
    public static var avatar_editor_tabs_bottom_trousers:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_bottom_trousers_on.png")]
    public static var avatar_editor_tabs_bottom_trousers_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_effects_fx.png")]
    public static var avatar_editor_tabs_effects_fx:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_gender_female.png")]
    public static var avatar_editor_tabs_gender_female:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_gender_female_on.png")]
    public static var avatar_editor_tabs_gender_female_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_gender_male.png")]
    public static var avatar_editor_tabs_gender_male:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_gender_male_on.png")]
    public static var avatar_editor_tabs_gender_male_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_accessories.png")]
    public static var avatar_editor_tabs_head_accessories:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_accessories_on.png")]
    public static var avatar_editor_tabs_head_accessories_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_eyewear.png")]
    public static var avatar_editor_tabs_head_eyewear:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_eyewear_on.png")]
    public static var avatar_editor_tabs_head_eyewear_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_face_accessories.png")]
    public static var avatar_editor_tabs_head_face_accessories:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_face_accessories_on.png")]
    public static var avatar_editor_tabs_head_face_accessories_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_hair.png")]
    public static var avatar_editor_tabs_head_hair:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_hair_on.png")]
    public static var avatar_editor_tabs_head_hair_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_hats.png")]
    public static var avatar_editor_tabs_head_hats:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_head_hats_on.png")]
    public static var avatar_editor_tabs_head_hats_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_icon_misc_misc_off.png")]
    public static var avatar_editor_tabs_icon_misc_misc_off:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_icon_misc_pets_off.png")]
    public static var avatar_editor_tabs_icon_misc_pets_off:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_accessories.png")]
    public static var avatar_editor_tabs_top_accessories:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_accessories_on.png")]
    public static var avatar_editor_tabs_top_accessories_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_jacket.png")]
    public static var avatar_editor_tabs_top_jacket:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_jacket_on.png")]
    public static var avatar_editor_tabs_top_jacket_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_prints.png")]
    public static var avatar_editor_tabs_top_prints:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_prints_on.png")]
    public static var avatar_editor_tabs_top_prints_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_shirt.png")]
    public static var avatar_editor_tabs_top_shirt:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_tabs_top_shirt_on.png")]
    public static var avatar_editor_tabs_top_shirt_on:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_wardrobe_select_outfit.png")]
    public static var avatar_editor_wardrobe_select_outfit:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_wardrobe_select_outfit_over.png")]
    public static var avatar_editor_wardrobe_select_outfit_over:Class;
        [Embed(source="images/HabboWindowManagerCom_avatar_editor_wardrobe_wardrobe_empty_slot.png")]
    public static var avatar_editor_wardrobe_wardrobe_empty_slot:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_buildersclub.png")]
    public static var bottom_bar_buildersclub:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_camera.png")]
    public static var bottom_bar_camera:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_collapse_left.png")]
    public static var bottom_bar_collapse_left:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_collapse_right.png")]
    public static var bottom_bar_collapse_right:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_divider_1px.png")]
    public static var bottom_bar_divider_1px:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_games.png")]
    public static var bottom_bar_games:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_home.png")]
    public static var bottom_bar_home:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_inventory.png")]
    public static var bottom_bar_inventory:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_logo.png")]
    public static var bottom_bar_logo:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_navigator.png")]
    public static var bottom_bar_navigator:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_memenu_bg.png")]
    public static var bottom_bar_memenu_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_memenu_circle.png")]
    public static var bottom_bar_memenu_circle:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_quests.png")]
    public static var bottom_bar_quests:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_shop.png")]
    public static var bottom_bar_shop:Class;
        [Embed(source="images/HabboWindowManagerCom_bottom_bar_stories.png")]
    public static var bottom_bar_stories:Class;
		[Embed(source="images/ModerationMIconPng.png")]
    public static var bottom_bar_modtool:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_arrow_gray.png")]
    public static var camera_arrow_gray:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_arrow_green.png")]
    public static var camera_arrow_green:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_browse_ffwd.png")]
    public static var camera_browse_ffwd:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_cam_bg.png")]
    public static var camera_cam_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_cam_btn_hi.png")]
    public static var camera_cam_btn_hi:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_cam_close_x.png")]
    public static var camera_cam_close_x:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_camera_btn.png")]
    public static var camera_camera_btn:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_camera_btn_down.png")]
    public static var camera_camera_btn_down:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_camera_edit.png")]
    public static var camera_camera_edit:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_camera_icon.png")]
    public static var camera_camera_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_fx_button_active.png")]
    public static var camera_fx_button_active:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_fx_button_outline.png")]
    public static var camera_fx_button_outline:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_fx_button_selected.png")]
    public static var camera_fx_button_selected:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_fx_frame_selected.png")]
    public static var camera_fx_frame_selected:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_fx_slider_bottom_active.png")]
    public static var camera_fx_slider_bottom_active:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_fx_slider_button.png")]
    public static var camera_fx_slider_button:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_habbo_camera.png")]
    public static var camera_habbo_camera:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_icon_colorfilter.png")]
    public static var camera_icon_colorfilter:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_icon_compositefilter.png")]
    public static var camera_icon_compositefilter:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_icon_frame.png")]
    public static var camera_icon_frame:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_locked.png")]
    public static var camera_locked:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_photo_border.png")]
    public static var camera_photo_border:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_remove_effect.png")]
    public static var camera_remove_effect:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_retake_button.png")]
    public static var camera_retake_button:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_shadow_outline.png")]
    public static var camera_shadow_outline:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_viewfinder.png")]
    public static var camera_viewfinder:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_zoom_in.png")]
    public static var camera_zoom_in:Class;
        [Embed(source="images/HabboWindowManagerCom_camera_zoom_out.png")]
    public static var camera_zoom_out:Class;
        [Embed(source="images/HabboWindowManagerCom_campaign_day_generic_activated.png")]
    public static var campaign_day_generic_activated:Class;
        [Embed(source="images/HabboWindowManagerCom_campaign_day_generic_bg.png")]
    public static var campaign_day_generic_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_campaign_day_generic_button.png")]
    public static var campaign_day_generic_button:Class;
        [Embed(source="images/HabboWindowManagerCom_campaign_generic_lock.png")]
    public static var campaign_generic_lock:Class;
        [Embed(source="images/HabboWindowManagerCom_campaign_calendar_icon.png")]
    public static var campaign_calendar_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_campaign_opened.png")]
    public static var campaign_opened:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_background.png")]
    public static var catalogue_background:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_badge_background.png")]
    public static var catalogue_badge_background:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_bundle_star.png")]
    public static var catalogue_bundle_star:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_clakboard.png")]
    public static var catalogue_clakboard:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_color_picker_27x22_border.png")]
    public static var catalogue_color_picker_27x22_border:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_color_picker_27x22_color.png")]
    public static var catalogue_color_picker_27x22_color:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_color_picker_27x22_selection.png")]
    public static var catalogue_color_picker_27x22_selection:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_effects_ninja.png")]
    public static var catalogue_effects_ninja:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_giftcard_blank.png")]
    public static var catalogue_giftcard_blank:Class;
        [Embed(source="images/HabboWindowManagerCom_catalogue_ufo_pricebg.png")]
    public static var catalogue_ufo_pricebg:Class;
        [Embed(source="images/HabboWindowManagerCom_common_beta_sign.png")]
    public static var common_beta_sign:Class;
        [Embed(source="images/HabboWindowManagerCom_common_blue_arrow_horizontal.png")]
    public static var common_blue_arrow_horizontal:Class;
        [Embed(source="images/HabboWindowManagerCom_common_blue_arrow_vertical.png")]
    public static var common_blue_arrow_vertical:Class;
        [Embed(source="images/HabboWindowManagerCom_common_chat_indicator.png")]
    public static var common_chat_indicator:Class;
        [Embed(source="images/HabboWindowManagerCom_common_chat_style_block.png")]
    public static var common_chat_style_block:Class;
        [Embed(source="images/HabboWindowManagerCom_common_chat_styles.png")]
    public static var common_chat_styles:Class;
        [Embed(source="images/HabboWindowManagerCom_common_chisel.png")]
    public static var common_chisel:Class;
        [Embed(source="images/HabboWindowManagerCom_common_close_x.png")]
    public static var common_close_x:Class;
        [Embed(source="images/HabboWindowManagerCom_common_green_arrow_horizontal.png")]
    public static var common_green_arrow_horizontal:Class;
        [Embed(source="images/HabboWindowManagerCom_common_green_arrow_vertical.png")]
    public static var common_green_arrow_vertical:Class;
        [Embed(source="images/HabboWindowManagerCom_common_hilight_big.png")]
    public static var common_hilight_big:Class;
        [Embed(source="images/HabboWindowManagerCom_common_info_icon_grey.png")]
    public static var common_info_icon_grey:Class;
        [Embed(source="images/HabboWindowManagerCom_common_item_selected.png")]
    public static var common_item_selected:Class;
        [Embed(source="images/HabboWindowManagerCom_common_item_unselected.png")]
    public static var common_item_unselected:Class;
        [Embed(source="images/HabboWindowManagerCom_common_loading_icon.png")]
    public static var common_loading_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_common_maximize.png")]
    public static var common_maximize:Class;
        [Embed(source="images/HabboWindowManagerCom_common_maximize_unetched.png")]
    public static var common_maximize_unetched:Class;
        [Embed(source="images/HabboWindowManagerCom_common_minimize_unetched.png")]
    public static var common_minimize_unetched:Class;
        [Embed(source="images/HabboWindowManagerCom_common_offers_icon.png")]
    public static var common_offers_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_common_promo_arrow_close.png")]
    public static var common_promo_arrow_close:Class;
        [Embed(source="images/HabboWindowManagerCom_common_promo_arrow_top_right.png")]
    public static var common_promo_arrow_top_right:Class;
        [Embed(source="images/HabboWindowManagerCom_common_small_coin.png")]
    public static var common_small_coin:Class;
        [Embed(source="images/HabboWindowManagerCom_common_small_pen.png")]
    public static var common_small_pen:Class;
        [Embed(source="images/HabboWindowManagerCom_common_star.png")]
    public static var common_star:Class;
        [Embed(source="images/HabboWindowManagerCom_common_trashcan_big.png")]
    public static var common_trashcan_big:Class;
        [Embed(source="images/HabboWindowManagerCom_common_trashcan_small.png")]
    public static var common_trashcan_small:Class;
        [Embed(source="images/HabboWindowManagerCom_common_welcome_screen_arrow.png")]
    public static var common_welcome_screen_arrow:Class;
        [Embed(source="images/HabboWindowManagerCom_craft_craft_bg.png")]
    public static var craft_craft_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_extended_profile_clear_favourite.png")]
    public static var extended_profile_clear_favourite:Class;
        [Embed(source="images/HabboWindowManagerCom_extended_profile_make_favourite.png")]
    public static var extended_profile_make_favourite:Class;
        [Embed(source="images/HabboWindowManagerCom_extended_profile_rooms.png")]
    public static var extended_profile_rooms:Class;
        [Embed(source="images/HabboWindowManagerCom_floor_plan_editor_add_tile.png")]
    public static var floor_plan_editor_add_tile:Class;
        [Embed(source="images/HabboWindowManagerCom_floor_plan_editor_enter_tile.png")]
    public static var floor_plan_editor_enter_tile:Class;
        [Embed(source="images/HabboWindowManagerCom_floor_plan_editor_logo.png")]
    public static var floor_plan_editor_logo:Class;
        [Embed(source="images/HabboWindowManagerCom_floor_plan_editor_raise_tile.png")]
    public static var floor_plan_editor_raise_tile:Class;
        [Embed(source="images/HabboWindowManagerCom_floor_plan_editor_remove_tile.png")]
    public static var floor_plan_editor_remove_tile:Class;
        [Embed(source="images/HabboWindowManagerCom_floor_plan_editor_sink_tile.png")]
    public static var floor_plan_editor_sink_tile:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_edit.png")]
    public static var forum_forum_edit:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_hide.png")]
    public static var forum_forum_hide:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_list0.png")]
    public static var forum_forum_list0:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_list1.png")]
    public static var forum_forum_list1:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_list2.png")]
    public static var forum_forum_list2:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_locked.png")]
    public static var forum_forum_locked:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_pinned.png")]
    public static var forum_forum_pinned:Class;
        [Embed(source="images/HabboWindowManagerCom_infostand_furni_place.png")]
    public static var infostand_furni_place:Class;
        [Embed(source="images/HabboWindowManagerCom_infostand_furni_shop.png")]
    public static var infostand_furni_shop:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_report.png")]
    public static var forum_forum_report:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_unhide.png")]
    public static var forum_forum_unhide:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_unlocked.png")]
    public static var forum_forum_unlocked:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_forum_unpinned.png")]
    public static var forum_forum_unpinned:Class;
        [Embed(source="images/HabboWindowManagerCom_forum_reply.png")]
    public static var forum_reply:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_all_friends.png")]
    public static var friend_bar_all_friends:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_event_notification_icon.png")]
    public static var friend_bar_event_notification_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_friendlist_chat.png")]
    public static var friend_bar_friendlist_chat:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_friendlist_eye.png")]
    public static var friend_bar_friendlist_eye:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_friendlist_go_room.png")]
    public static var friend_bar_friendlist_go_room:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_friendlist_messenger.png")]
    public static var friend_bar_friendlist_messenger:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_friendlist_messenger_notify_0.png")]
    public static var friend_bar_friendlist_messenger_notify_0:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_friendlist_messenger_notify_1.png")]
    public static var friend_bar_friendlist_messenger_notify_1:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_friends_browse_bg.png")]
    public static var friend_bar_friends_browse_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_friend_bar_search_habbos.png")]
    public static var friend_bar_search_habbos:Class;
        [Embed(source="images/HabboWindowManagerCom_game_center_achievement_locked_icon.png")]
    public static var game_center_achievement_locked_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_game_center_loading_icon.png")]
    public static var game_center_loading_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_group_guild_color_btm.png")]
    public static var group_guild_color_btm:Class;
        [Embed(source="images/HabboWindowManagerCom_group_guild_color_top.png")]
    public static var group_guild_color_top:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_hc_center_cover.png")]
    public static var hc_center_hc_center_cover:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_hc_center_icon_credits.png")]
    public static var hc_center_hc_center_icon_credits:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_hc_center_illustration.png")]
    public static var hc_center_hc_center_illustration:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_hc_center_timer.png")]
    public static var hc_center_hc_center_timer:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_hc_postit_bg.png")]
    public static var hc_center_hc_postit_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t0.png")]
    public static var hc_center_t0:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t1.png")]
    public static var hc_center_t1:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t2.png")]
    public static var hc_center_t2:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t3.png")]
    public static var hc_center_t3:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t4.png")]
    public static var hc_center_t4:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t5.png")]
    public static var hc_center_t5:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t6.png")]
    public static var hc_center_t6:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t7.png")]
    public static var hc_center_t7:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t8.png")]
    public static var hc_center_t8:Class;
        [Embed(source="images/HabboWindowManagerCom_hc_center_t9.png")]
    public static var hc_center_t9:Class;
        [Embed(source="images/HabboWindowManagerCom_help_accept_icon.png")]
    public static var help_accept_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_help_bandaid.png")]
    public static var help_bandaid:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_anonymous.png")]
    public static var help_chat_review_anonymous:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_avatar_anonymous.png")]
    public static var help_chat_review_avatar_anonymous:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_avatar_perpetrator.png")]
    public static var help_chat_review_avatar_perpetrator:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_bad.png")]
    public static var help_chat_review_decision_bad:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_ok.png")]
    public static var help_chat_review_decision_ok:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_refused.png")]
    public static var help_chat_review_decision_refused:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_searching_1.png")]
    public static var help_chat_review_decision_searching_1:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_searching_2.png")]
    public static var help_chat_review_decision_searching_2:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_undecided.png")]
    public static var help_chat_review_decision_undecided:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_very_bad.png")]
    public static var help_chat_review_decision_very_bad:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_waiting_1.png")]
    public static var help_chat_review_decision_waiting_1:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_decision_waiting_2.png")]
    public static var help_chat_review_decision_waiting_2:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_perpetrator.png")]
    public static var help_chat_review_perpetrator:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_progress_big_1.png")]
    public static var help_chat_review_progress_big_1:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_progress_big_2.png")]
    public static var help_chat_review_progress_big_2:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_progress_big_3.png")]
    public static var help_chat_review_progress_big_3:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_progress_big_4.png")]
    public static var help_chat_review_progress_big_4:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_bad.png")]
    public static var help_chat_review_vote_bad:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_bad_down.png")]
    public static var help_chat_review_vote_bad_down:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_bad_over.png")]
    public static var help_chat_review_vote_bad_over:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_ok.png")]
    public static var help_chat_review_vote_ok:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_ok_down.png")]
    public static var help_chat_review_vote_ok_down:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_ok_over.png")]
    public static var help_chat_review_vote_ok_over:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_very_bad.png")]
    public static var help_chat_review_vote_very_bad:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_very_bad_down.png")]
    public static var help_chat_review_vote_very_bad_down:Class;
        [Embed(source="images/HabboWindowManagerCom_help_chat_review_vote_very_bad_over.png")]
    public static var help_chat_review_vote_very_bad_over:Class;
        [Embed(source="images/HabboWindowManagerCom_help_citizenship_default.png")]
    public static var help_citizenship_default:Class;
        [Embed(source="images/HabboWindowManagerCom_help_decline_icon.png")]
    public static var help_decline_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_help_error_state.png")]
    public static var help_error_state:Class;
        [Embed(source="images/HabboWindowManagerCom_help_feeling_confused.png")]
    public static var help_feeling_confused:Class;
        [Embed(source="images/HabboWindowManagerCom_help_feeling_confused_coming_up.png")]
    public static var help_feeling_confused_coming_up:Class;
        [Embed(source="images/HabboWindowManagerCom_help_frank_greeting.png")]
    public static var help_frank_greeting:Class;
        [Embed(source="images/HabboWindowManagerCom_help_guide_accept.png")]
    public static var help_guide_accept:Class;
        [Embed(source="images/HabboWindowManagerCom_help_guide_icon.png")]
    public static var help_guide_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_help_habboway_correct.png")]
    public static var help_habboway_correct:Class;
        [Embed(source="images/HabboWindowManagerCom_help_habboway_dove_off.png")]
    public static var help_habboway_dove_off:Class;
        [Embed(source="images/HabboWindowManagerCom_help_habboway_dove_on.png")]
    public static var help_habboway_dove_on:Class;
        [Embed(source="images/HabboWindowManagerCom_help_habboway_dove_quizz.png")]
    public static var help_habboway_dove_quizz:Class;
        [Embed(source="images/HabboWindowManagerCom_help_habboway_next.png")]
    public static var help_habboway_next:Class;
        [Embed(source="images/HabboWindowManagerCom_help_habboway_prev.png")]
    public static var help_habboway_prev:Class;
        [Embed(source="images/HabboWindowManagerCom_help_habboway_wrong.png")]
    public static var help_habboway_wrong:Class;
        [Embed(source="images/HabboWindowManagerCom_help_help_duck.png")]
    public static var help_help_duck:Class;
        [Embed(source="images/HabboWindowManagerCom_help_illustrations_bully.png")]
    public static var help_illustrations_bully:Class;
        [Embed(source="images/HabboWindowManagerCom_help_illustrations_question.png")]
    public static var help_illustrations_question:Class;
        [Embed(source="images/HabboWindowManagerCom_help_illustrations_tour.png")]
    public static var help_illustrations_tour:Class;
        [Embed(source="images/HabboWindowManagerCom_help_need_help.png")]
    public static var help_need_help:Class;
        [Embed(source="images/HabboWindowManagerCom_help_notification.png")]
    public static var help_notification:Class;
        [Embed(source="images/HabboWindowManagerCom_help_poor_frank.png")]
    public static var help_poor_frank:Class;
        [Embed(source="images/HabboWindowManagerCom_help_requester_icon.png")]
    public static var help_requester_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_help_user_create.png")]
    public static var help_user_create:Class;
        [Embed(source="images/HabboWindowManagerCom_help_user_feedback.png")]
    public static var help_user_feedback:Class;
        [Embed(source="images/HabboWindowManagerCom_help_user_pending.png")]
    public static var help_user_pending:Class;
        [Embed(source="images/HabboWindowManagerCom_high_score_highscore_cup.png")]
    public static var high_score_highscore_cup:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_back.png")]
    public static var icons_back:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_back_small.png")]
    public static var icons_back_small:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_builder_error_full.png")]
    public static var icons_builder_error_full:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_builder_error_furnilimit.png")]
    public static var icons_builder_error_furnilimit:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_builder_error_grouproom.png")]
    public static var icons_builder_error_grouproom:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_builder_error_notroom.png")]
    public static var icons_builder_error_notroom:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_builder_error_room.png")]
    public static var icons_builder_error_room:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_builder_error_userinroom.png")]
    public static var icons_builder_error_userinroom:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_close.png")]
    public static var icons_close:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_facebook.png")]
    public static var icons_facebook:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_flag.png")]
    public static var icons_flag:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_forward.png")]
    public static var icons_forward:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_forward_small.png")]
    public static var icons_forward_small:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_go_to_room_icon.png")]
    public static var icons_go_to_room_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_hc_icon_small.png")]
    public static var icons_hc_icon_small:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_hilighter_yellow.png")]
    public static var icons_hilighter_yellow:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_link_icon.png")]
    public static var icons_link_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_next.png")]
    public static var icons_next:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_panic.png")]
    public static var icons_panic:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_share.png")]
    public static var icons_share:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_star.png")]
    public static var icons_star:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_tickmark.png")]
    public static var icons_tickmark:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_achievements_hover.png")]
    public static var icons_toolbar_achievements_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_achievements_normal.png")]
    public static var icons_toolbar_achievements_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_builder_hover.png")]
    public static var icons_toolbar_builder_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_builder_normal.png")]
    public static var icons_toolbar_builder_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_catalogue_hover.png")]
    public static var icons_toolbar_catalogue_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_catalogue_normal.png")]
    public static var icons_toolbar_catalogue_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_divider.png")]
    public static var icons_toolbar_divider:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_games_hover.png")]
    public static var icons_toolbar_games_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_games_normal.png")]
    public static var icons_toolbar_games_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_home_hover.png")]
    public static var icons_toolbar_home_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_home_normal.png")]
    public static var icons_toolbar_home_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_inventory_hover.png")]
    public static var icons_toolbar_inventory_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_inventory_normal.png")]
    public static var icons_toolbar_inventory_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_me_menu_placeholder.png")]
    public static var icons_toolbar_me_menu_placeholder:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_minimail_hover.png")]
    public static var icons_toolbar_minimail_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_minimail_normal.png")]
    public static var icons_toolbar_minimail_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_navigator_hover.png")]
    public static var icons_toolbar_navigator_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_navigator_normal.png")]
    public static var icons_toolbar_navigator_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_quests_hover.png")]
    public static var icons_toolbar_quests_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_quests_normal.png")]
    public static var icons_toolbar_quests_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_reception_hover.png")]
    public static var icons_toolbar_reception_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_reception_normal.png")]
    public static var icons_toolbar_reception_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_stories_hover.png")]
    public static var icons_toolbar_stories_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_stories_normal.png")]
    public static var icons_toolbar_stories_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_valentines_hover.png")]
    public static var icons_toolbar_valentines_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_valentines_normal.png")]
    public static var icons_toolbar_valentines_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_xmas_hover.png")]
    public static var icons_toolbar_xmas_hover:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_toolbar_xmas_normal.png")]
    public static var icons_toolbar_xmas_normal:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_twitter.png")]
    public static var icons_twitter:Class;
        [Embed(source="images/HabboWindowManagerCom_icons_wearable.png")]
    public static var icons_wearable:Class;
        [Embed(source="images/HabboWindowManagerCom_illumina_horizontal_separator.png")]
    public static var illumina_horizontal_separator:Class;
        [Embed(source="images/HabboWindowManagerCom_infostand_bot_info_bg.png")]
    public static var infostand_bot_info_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_download_icon.png")]
    public static var inventory_download_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_icon_credits.png")]
    public static var inventory_furni_icon_credits:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_icon_floor.png")]
    public static var inventory_furni_icon_floor:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_icon_landscape.png")]
    public static var inventory_furni_icon_landscape:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_icon_wallpaper.png")]
    public static var inventory_furni_icon_wallpaper:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_no_recycle_icon.png")]
    public static var inventory_furni_no_recycle_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_no_trade_icon.png")]
    public static var inventory_furni_no_trade_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_recycle_icon.png")]
    public static var inventory_furni_recycle_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_furni_trade_icon.png")]
    public static var inventory_furni_trade_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_inventory_empty.png")]
    public static var inventory_inventory_empty:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_inventory_icon.png")]
    public static var inventory_inventory_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_thumb_bg.png")]
    public static var inventory_thumb_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_thumb_bg_selected.png")]
    public static var inventory_thumb_bg_selected:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_thumb_icon_recycle.png")]
    public static var inventory_thumb_icon_recycle:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_thumb_rent_ending.png")]
    public static var inventory_thumb_rent_ending:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_thumb_rent_started.png")]
    public static var inventory_thumb_rent_started:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_thumb_selected_outline.png")]
    public static var inventory_thumb_selected_outline:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_trading_trading_locked_icon.png")]
    public static var inventory_trading_trading_locked_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_inventory_trading_trading_unlocked_icon.png")]
    public static var inventory_trading_trading_unlocked_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_avatar_info_background.png")]
    public static var landing_view_avatar_info_background:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle0.png")]
    public static var landing_view_needle_meter_needle0:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle1.png")]
    public static var landing_view_needle_meter_needle1:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle10.png")]
    public static var landing_view_needle_meter_needle10:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle11.png")]
    public static var landing_view_needle_meter_needle11:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle12.png")]
    public static var landing_view_needle_meter_needle12:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle13.png")]
    public static var landing_view_needle_meter_needle13:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle14.png")]
    public static var landing_view_needle_meter_needle14:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle15.png")]
    public static var landing_view_needle_meter_needle15:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle16.png")]
    public static var landing_view_needle_meter_needle16:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle17.png")]
    public static var landing_view_needle_meter_needle17:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle18.png")]
    public static var landing_view_needle_meter_needle18:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle19.png")]
    public static var landing_view_needle_meter_needle19:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle2.png")]
    public static var landing_view_needle_meter_needle2:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle20.png")]
    public static var landing_view_needle_meter_needle20:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle21.png")]
    public static var landing_view_needle_meter_needle21:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle22.png")]
    public static var landing_view_needle_meter_needle22:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle23.png")]
    public static var landing_view_needle_meter_needle23:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle3.png")]
    public static var landing_view_needle_meter_needle3:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle4.png")]
    public static var landing_view_needle_meter_needle4:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle5.png")]
    public static var landing_view_needle_meter_needle5:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle6.png")]
    public static var landing_view_needle_meter_needle6:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle7.png")]
    public static var landing_view_needle_meter_needle7:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle8.png")]
    public static var landing_view_needle_meter_needle8:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_needle_meter_needle9.png")]
    public static var landing_view_needle_meter_needle9:Class;
        [Embed(source="images/HabboWindowManagerCom_landing_view_reception_horizontal.png")]
    public static var landing_view_reception_horizontal:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_achv.png")]
    public static var me_menu_me_achv:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_clothing.png")]
    public static var me_menu_me_clothing:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_forums.png")]
    public static var me_menu_me_forums:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_guide.png")]
    public static var me_menu_me_guide:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_mail.png")]
    public static var me_menu_me_mail:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_profile.png")]
    public static var me_menu_me_profile:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_rooms.png")]
    public static var me_menu_me_rooms:Class;
        [Embed(source="images/HabboWindowManagerCom_me_menu_me_talents.png")]
    public static var me_menu_me_talents:Class;
        [Embed(source="images/HabboWindowManagerCom_messenger_caution.png")]
    public static var messenger_caution:Class;
        [Embed(source="images/HabboWindowManagerCom_messenger_minimize_button.png")]
    public static var messenger_minimize_button:Class;
        [Embed(source="images/HabboWindowManagerCom_messenger_notification_icon.png")]
    public static var messenger_notification_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_messenger_profile_icon.png")]
    public static var messenger_profile_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_messenger_visit_icon.png")]
    public static var messenger_visit_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_mysterybox_box_base.png")]
    public static var mysterybox_box_base:Class;
        [Embed(source="images/HabboWindowManagerCom_mysterybox_box_overlay.png")]
    public static var mysterybox_box_overlay:Class;
        [Embed(source="images/HabboWindowManagerCom_mysterybox_box_small.png")]
    public static var mysterybox_box_small:Class;
        [Embed(source="images/HabboWindowManagerCom_mysterybox_key_base.png")]
    public static var mysterybox_key_base:Class;
        [Embed(source="images/HabboWindowManagerCom_mysterybox_key_overlay.png")]
    public static var mysterybox_key_overlay:Class;
        [Embed(source="images/HabboWindowManagerCom_mysterybox_key_small.png")]
    public static var mysterybox_key_small:Class;
        [Embed(source="images/HabboWindowManagerCom_mysterybox_tracker_border.png")]
    public static var mysterybox_tracker_border:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_back.png")]
    public static var newnavigator_button_back:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_category_collapse.png")]
    public static var newnavigator_button_category_collapse:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_category_expand.png")]
    public static var newnavigator_button_category_expand:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_category_show_more.png")]
    public static var newnavigator_button_category_show_more:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_leftpane_hide.png")]
    public static var newnavigator_button_leftpane_hide:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_leftpane_show.png")]
    public static var newnavigator_button_leftpane_show:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_quicklink_add.png")]
    public static var newnavigator_button_quicklink_add:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_quicklink_remove.png")]
    public static var newnavigator_button_quicklink_remove:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_rows.png")]
    public static var newnavigator_button_rows:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_show_room_info.png")]
    public static var newnavigator_button_show_room_info:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_button_tiles.png")]
    public static var newnavigator_button_tiles:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_create_room.png")]
    public static var newnavigator_create_room:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_default_room.png")]
    public static var newnavigator_default_room:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_doormode_doorbell_small.png")]
    public static var newnavigator_doormode_doorbell_small:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_doormode_invisible_small.png")]
    public static var newnavigator_doormode_invisible_small:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_doormode_password_small.png")]
    public static var newnavigator_doormode_password_small:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_event_icon.png")]
    public static var newnavigator_event_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_group_base_icon.png")]
    public static var newnavigator_group_base_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_fav_no.png")]
    public static var newnavigator_icon_fav_no:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_fav_yes.png")]
    public static var newnavigator_icon_fav_yes:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_group.png")]
    public static var newnavigator_icon_group:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_group_admin.png")]
    public static var newnavigator_icon_group_admin:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_group_owner.png")]
    public static var newnavigator_icon_group_owner:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_home_no.png")]
    public static var newnavigator_icon_home_no:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_home_yes.png")]
    public static var newnavigator_icon_home_yes:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_ql_add.png")]
    public static var newnavigator_icon_ql_add:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_ql_remove.png")]
    public static var newnavigator_icon_ql_remove:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_quicklink_plain.png")]
    public static var newnavigator_icon_quicklink_plain:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_icon_usercount.png")]
    public static var newnavigator_icon_usercount:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_nav_view_mini.png")]
    public static var newnavigator_nav_view_mini:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_nav_view_row.png")]
    public static var newnavigator_nav_view_row:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_nav_view_thumbs.png")]
    public static var newnavigator_nav_view_thumbs:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_promote_room.png")]
    public static var newnavigator_promote_room:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_random_room.png")]
    public static var newnavigator_random_room:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_rating_star_off.png")]
    public static var newnavigator_rating_star_off:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_rating_star_on.png")]
    public static var newnavigator_rating_star_on:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_refresh_search_icon.png")]
    public static var newnavigator_refresh_search_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_report_room.png")]
    public static var newnavigator_report_room:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_room_settings_icon.png")]
    public static var newnavigator_room_settings_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_roominfo_temp.png")]
    public static var newnavigator_roominfo_temp:Class;
        [Embed(source="images/HabboWindowManagerCom_newnavigator_roomusercount_dimmer_black.png")]
    public static var newnavigator_roomusercount_dimmer_black:Class;
        [Embed(source="images/HabboWindowManagerCom_poll_poll_prompt_frank.png")]
    public static var poll_poll_prompt_frank:Class;
        [Embed(source="images/HabboWindowManagerCom_poll_poll_prompt_question.png")]
    public static var poll_poll_prompt_question:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_credits_icon.png")]
    public static var pursearea_credits_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_credits_icon2.png")]
    public static var pursearea_credits_icon2:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_diamond_icon.png")]
    public static var pursearea_diamond_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_duckets_icon.png")]
    public static var pursearea_duckets_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_hc_icon.png")]
    public static var pursearea_hc_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_logout_icon.png")]
    public static var pursearea_logout_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_loyalty_icon.png")]
    public static var pursearea_loyalty_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_pursearea_settings_icon.png")]
    public static var pursearea_settings_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_rarity_item_rarity_item_plaque.png")]
    public static var rarity_item_rarity_item_plaque:Class;
        [Embed(source="images/HabboWindowManagerCom_rarity_item_rarity_preview_bg.png")]
    public static var rarity_item_rarity_preview_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_relationship_status_bobba.png")]
    public static var relationship_status_bobba:Class;
        [Embed(source="images/HabboWindowManagerCom_relationship_status_heart.png")]
    public static var relationship_status_heart:Class;
        [Embed(source="images/HabboWindowManagerCom_relationship_status_none.png")]
    public static var relationship_status_none:Class;
        [Embed(source="images/HabboWindowManagerCom_relationship_status_smile.png")]
    public static var relationship_status_smile:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_camera.png")]
    public static var roomtools_camera:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_chat_history.png")]
    public static var roomtools_chat_history:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_gear.png")]
    public static var roomtools_gear:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_history_back_bg.png")]
    public static var roomtools_history_back_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_history_back_icon.png")]
    public static var roomtools_history_back_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_history_forward_bg.png")]
    public static var roomtools_history_forward_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_history_forward_icon.png")]
    public static var roomtools_history_forward_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_history_open_bg.png")]
    public static var roomtools_history_open_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_history_open_icon.png")]
    public static var roomtools_history_open_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_like.png")]
    public static var roomtools_like:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_magnifier.png")]
    public static var roomtools_magnifier:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_minimizebutton.png")]
    public static var roomtools_minimizebutton:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_photo_icon.png")]
    public static var roomtools_photo_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_unlike.png")]
    public static var roomtools_unlike:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_zoom_in.png")]
    public static var roomtools_zoom_in:Class;
        [Embed(source="images/HabboWindowManagerCom_roomtools_zoom_out.png")]
    public static var roomtools_zoom_out:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_achieved_div.png")]
    public static var talent_achieved_div:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_achieved_left.png")]
    public static var talent_achieved_left:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_achieved_mid.png")]
    public static var talent_achieved_mid:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_achieved_right.png")]
    public static var talent_achieved_right:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_action_overlay.png")]
    public static var talent_action_overlay:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_avatar_glow.png")]
    public static var talent_avatar_glow:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_check_mark_circle.png")]
    public static var talent_check_mark_circle:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_citizenship_accomplished.png")]
    public static var talent_citizenship_accomplished:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_helper_icon.png")]
    public static var talent_helper_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_locked_achievement.png")]
    public static var talent_locked_achievement:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_locked_stripe.png")]
    public static var talent_locked_stripe:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_mask_left.png")]
    public static var talent_mask_left:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_mask_right.png")]
    public static var talent_mask_right:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_progress_lower.png")]
    public static var talent_progress_lower:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_progress_upper.png")]
    public static var talent_progress_upper:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_register_cutout_character.png")]
    public static var talent_register_cutout_character:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_task_progress_bg.png")]
    public static var talent_task_progress_bg:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_task_progress_fg.png")]
    public static var talent_task_progress_fg:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_task_progress_left.png")]
    public static var talent_task_progress_left:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_task_progress_right.png")]
    public static var talent_task_progress_right:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_unachieved_div.png")]
    public static var talent_unachieved_div:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_unachieved_left.png")]
    public static var talent_unachieved_left:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_unachieved_mid.png")]
    public static var talent_unachieved_mid:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_unachieved_right.png")]
    public static var talent_unachieved_right:Class;
        [Embed(source="images/HabboWindowManagerCom_talent_vip_reward.png")]
    public static var talent_vip_reward:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_citizenship_icon.png")]
    public static var toolbar_citizenship_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_credit_icon_0.png")]
    public static var toolbar_credit_icon_0:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_credit_icon_1.png")]
    public static var toolbar_credit_icon_1:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_credit_icon_2.png")]
    public static var toolbar_credit_icon_2:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_duckat_icon_0.png")]
    public static var toolbar_duckat_icon_0:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_duckat_icon_1.png")]
    public static var toolbar_duckat_icon_1:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_duckat_icon_2.png")]
    public static var toolbar_duckat_icon_2:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_hc_icon_0.png")]
    public static var toolbar_hc_icon_0:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_hc_icon_1.png")]
    public static var toolbar_hc_icon_1:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_hc_icon_2.png")]
    public static var toolbar_hc_icon_2:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_achievements_color.png")]
    public static var toolbar_memenu_achievements_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_achievements_white.png")]
    public static var toolbar_memenu_achievements_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_clothes_color.png")]
    public static var toolbar_memenu_clothes_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_clothes_white.png")]
    public static var toolbar_memenu_clothes_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_guide_color.png")]
    public static var toolbar_memenu_guide_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_guide_white.png")]
    public static var toolbar_memenu_guide_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_minimail_color.png")]
    public static var toolbar_memenu_minimail_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_minimail_white.png")]
    public static var toolbar_memenu_minimail_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_profile_color.png")]
    public static var toolbar_memenu_profile_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_profile_white.png")]
    public static var toolbar_memenu_profile_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_rooms_color.png")]
    public static var toolbar_memenu_rooms_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_rooms_white.png")]
    public static var toolbar_memenu_rooms_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_color.png")]
    public static var toolbar_memenu_settings_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_slider_base.png")]
    public static var toolbar_memenu_settings_slider_base:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_slider_button.png")]
    public static var toolbar_memenu_settings_slider_button:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_sounds_off_color.png")]
    public static var toolbar_memenu_settings_sounds_off_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_sounds_off_white.png")]
    public static var toolbar_memenu_settings_sounds_off_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_sounds_on_color.png")]
    public static var toolbar_memenu_settings_sounds_on_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_sounds_on_white.png")]
    public static var toolbar_memenu_settings_sounds_on_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_settings_white.png")]
    public static var toolbar_memenu_settings_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_talents_color.png")]
    public static var toolbar_memenu_talents_color:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_memenu_talents_white.png")]
    public static var toolbar_memenu_talents_white:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_offer_icon_0.png")]
    public static var toolbar_offer_icon_0:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_offer_icon_1.png")]
    public static var toolbar_offer_icon_1:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_offer_icon_2.png")]
    public static var toolbar_offer_icon_2:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_room_icon_0.png")]
    public static var toolbar_room_icon_0:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_room_icon_1.png")]
    public static var toolbar_room_icon_1:Class;
        [Embed(source="images/HabboWindowManagerCom_toolbar_room_icon_2.png")]
    public static var toolbar_room_icon_2:Class;
        [Embed(source="images/HabboWindowManagerCom_tools_black_pixel.png")]
    public static var tools_black_pixel:Class;
        [Embed(source="images/HabboWindowManagerCom_tools_file_icon.png")]
    public static var tools_file_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_tools_folder_icon.png")]
    public static var tools_folder_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_tools_tools_download_icon.png")]
    public static var tools_tools_download_icon:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_label_1.png")]
    public static var unique_item_label_1:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_label_glass_shine.png")]
    public static var unique_item_label_glass_shine:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_label_number_glyphs.png")]
    public static var unique_item_label_number_glyphs:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_label_plaque_border.png")]
    public static var unique_item_label_plaque_border:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_label_plaque_metal.png")]
    public static var unique_item_label_plaque_metal:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_label_studs.png")]
    public static var unique_item_label_studs:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_background_wide.png")]
    public static var unique_item_large_background_wide:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_glass_bottom.png")]
    public static var unique_item_large_glass_bottom:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_glass_mid.png")]
    public static var unique_item_large_glass_mid:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_glass_shine.png")]
    public static var unique_item_large_glass_shine:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_glass_top.png")]
    public static var unique_item_large_glass_top:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_iron.png")]
    public static var unique_item_large_iron:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_na_button.png")]
    public static var unique_item_large_na_button:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_na_button_wide.png")]
    public static var unique_item_large_na_button_wide:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_large_tile_upright.png")]
    public static var unique_item_large_tile_upright:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_sold_out_label.png")]
    public static var unique_item_sold_out_label:Class;
        [Embed(source="images/HabboWindowManagerCom_unique_item_sold_out_tile.png")]
    public static var unique_item_sold_out_tile:Class;
        [Embed(source="images/HabboWindowManagerCom_word_quiz_thum_down.png")]
    public static var word_quiz_thum_down:Class;
        [Embed(source="images/HabboWindowManagerCom_word_quiz_thum_down_big.png")]
    public static var word_quiz_thum_down_big:Class;
        [Embed(source="images/HabboWindowManagerCom_word_quiz_thum_up.png")]
    public static var word_quiz_thum_up:Class;
        [Embed(source="images/HabboWindowManagerCom_word_quiz_thum_up_big.png")]
    public static var word_quiz_thum_up_big:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_avatar_image_xml.bin", mimeType="application/octet-stream")]
    public static var avatar_image_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_badge_image_xml.bin", mimeType="application/octet-stream")]
    public static var badge_image_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_balloon_xml.bin", mimeType="application/octet-stream")]
    public static var balloon_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_clock_base_xml.bin", mimeType="application/octet-stream")]
    public static var clock_base_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_hover_bitmap_xml.bin", mimeType="application/octet-stream")]
    public static var hover_bitmap_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_border_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_border_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_chat_bubble_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_chat_bubble_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_illumina_input_xml.bin", mimeType="application/octet-stream")]
    public static var illumina_input_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_updating_timestamp_xml.bin", mimeType="application/octet-stream")]
    public static var updating_timestamp_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_progress_indicator_xml.bin", mimeType="application/octet-stream")]
    public static var progress_indicator_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_separator_xml.bin", mimeType="application/octet-stream")]
    public static var separator_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_running_number_xml.bin", mimeType="application/octet-stream")]
    public static var running_number_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_pet_image_xml.bin", mimeType="application/octet-stream")]
    public static var pet_image_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_furniture_image_xml.bin", mimeType="application/octet-stream")]
    public static var furniture_image_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_room_previewer_xml.bin", mimeType="application/octet-stream")]
    public static var room_previewer_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_pixel_limit_xml.bin", mimeType="application/octet-stream")]
    public static var pixel_limit_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_room_usercount_xml.bin", mimeType="application/octet-stream")]
    public static var room_usercount_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_room_thumbnail_xml.bin", mimeType="application/octet-stream")]
    public static var room_thumbnail_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_unique_item_overlay_griditem_xml.bin", mimeType="application/octet-stream")]
    public static var unique_item_overlay_griditem_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_unique_item_overlay_supply_xml.bin", mimeType="application/octet-stream")]
    public static var unique_item_overlay_supply_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_unique_item_overlay_preview_xml.bin", mimeType="application/octet-stream")]
    public static var unique_item_overlay_preview_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_rarity_item_overlay_griditem_xml.bin", mimeType="application/octet-stream")]
    public static var rarity_item_overlay_griditem_xml:Class;
        [Embed(source="binaryData/HabboWindowManagerCom_rarity_item_overlay_preview_xml.bin", mimeType="application/octet-stream")]
    public static var rarity_item_overlay_preview_xml:Class;
		public static var vote_question_xml:Class = VoteQuestionXML;
		public static var vote_choice_xml:Class = VoteChoiceXML;
    }
}
