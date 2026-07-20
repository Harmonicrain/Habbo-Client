package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.ModerationManagerBootstrap;
    import com.sulake.iid.IIDHabboModeration;

    public class HabboModerationCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboModerationCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        public static var requiredClasses:Array = new Array(ModerationManagerBootstrap, IIDHabboModeration);
        [Embed(source="binaryData/HabboModerationCom_evidence_frame_xml.bin", mimeType="application/octet-stream")]
    public static var evidence_frame_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_issue_browser_xml.bin", mimeType="application/octet-stream")]
    public static var issue_browser_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_modact_summary_xml.bin", mimeType="application/octet-stream")]
    public static var modact_summary_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_send_msgs_xml.bin", mimeType="application/octet-stream")]
    public static var send_msgs_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_start_panel_xml.bin", mimeType="application/octet-stream")]
    public static var start_panel_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_user_info_xml.bin", mimeType="application/octet-stream")]
    public static var user_info_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_user_info_frame_xml.bin", mimeType="application/octet-stream")]
    public static var user_info_frame_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_issue_handler_xml.bin", mimeType="application/octet-stream")]
    public static var issue_handler_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_roomtool_frame_xml.bin", mimeType="application/octet-stream")]
    public static var roomtool_frame_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_roomvisits_frame_xml.bin", mimeType="application/octet-stream")]
    public static var roomvisits_frame_xml:Class;
        [Embed(source="binaryData/HabboModerationCom_userclassification_frame_xml.bin", mimeType="application/octet-stream")]
    public static var userclassification_frame_xml:Class;
        [Embed(source="images/HabboModerationCom_room_icon_png.png")]
    public static var room_icon_png:Class;
        [Embed(source="images/HabboModerationCom_user_icon_png.png")]
    public static var user_icon_png:Class;
		[Embed(source="binaryData/moderation_icon.bin", mimeType="application/octet-stream")]
    public static var moderation_icon_xml:Class;
		[Embed(source="images/ModerationMIconPng.png")]
    public static var moderation_m_icon_png:Class;
    }
}
