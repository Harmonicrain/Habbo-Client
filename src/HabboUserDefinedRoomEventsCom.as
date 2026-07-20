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
        public static var requiredClasses:Array = new Array(HabboUserDefinedRoomEventsBootstrap, IIDHabboUserDefinedRoomEvents);
    }
}
