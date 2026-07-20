package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboHelpBootstrap;
    import com.sulake.iid.IIDHabboHelp;

    public class HabboHelpCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboHelpCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        [Embed(source="binaryData/HabboHelpCom_welcome_name_change_xml.bin", mimeType="application/octet-stream")]
    public static var welcome_name_change_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_welcome_name_selection_xml.bin", mimeType="application/octet-stream")]
    public static var welcome_name_selection_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_welcome_name_suggestion_item_xml.bin", mimeType="application/octet-stream")]
    public static var welcome_name_suggestion_item_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_welcome_name_confirmation_xml.bin", mimeType="application/octet-stream")]
    public static var welcome_name_confirmation_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_welcome_screen_xml.bin", mimeType="application/octet-stream")]
    public static var welcome_screen_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_welcome_tour_popup_xml.bin", mimeType="application/octet-stream")]
    public static var welcome_tour_popup_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_topics_flow_help_xml.bin", mimeType="application/octet-stream")]
    public static var topics_flow_help_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_main_help_xml.bin", mimeType="application/octet-stream")]
    public static var main_help_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_main_xml.bin", mimeType="application/octet-stream")]
    public static var main_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_user_create_xml.bin", mimeType="application/octet-stream")]
    public static var user_create_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_user_pending_xml.bin", mimeType="application/octet-stream")]
    public static var user_pending_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_user_ongoing_xml.bin", mimeType="application/octet-stream")]
    public static var user_ongoing_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_user_feedback_xml.bin", mimeType="application/octet-stream")]
    public static var user_feedback_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_user_thanks_xml.bin", mimeType="application/octet-stream")]
    public static var user_thanks_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_user_guide_disconnected_xml.bin", mimeType="application/octet-stream")]
    public static var user_guide_disconnected_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guide_tool_xml.bin", mimeType="application/octet-stream")]
    public static var guide_tool_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guide_accept_xml.bin", mimeType="application/octet-stream")]
    public static var guide_accept_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guide_ongoing_xml.bin", mimeType="application/octet-stream")]
    public static var guide_ongoing_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guide_closed_xml.bin", mimeType="application/octet-stream")]
    public static var guide_closed_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guardian_chat_review_accept_xml.bin", mimeType="application/octet-stream")]
    public static var guardian_chat_review_accept_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guardian_chat_review_results_xml.bin", mimeType="application/octet-stream")]
    public static var guardian_chat_review_results_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guardian_chat_review_vote_xml.bin", mimeType="application/octet-stream")]
    public static var guardian_chat_review_vote_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guardian_chat_review_wait_for_results_xml.bin", mimeType="application/octet-stream")]
    public static var guardian_chat_review_wait_for_results_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_guardian_chat_review_wait_for_voters_xml.bin", mimeType="application/octet-stream")]
    public static var guardian_chat_review_wait_for_voters_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_report_window_xml.bin", mimeType="application/octet-stream")]
    public static var report_window_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_error_window_xml.bin", mimeType="application/octet-stream")]
    public static var error_window_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_chat_msg_xml.bin", mimeType="application/octet-stream")]
    public static var chat_msg_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_chat_msg_notification_xml.bin", mimeType="application/octet-stream")]
    public static var chat_msg_notification_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_chat_msg_reminder_xml.bin", mimeType="application/octet-stream")]
    public static var chat_msg_reminder_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_rejected_window_xml.bin", mimeType="application/octet-stream")]
    public static var rejected_window_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_pending_bully_request_xml.bin", mimeType="application/octet-stream")]
    public static var pending_bully_request_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_pending_guide_session_xml.bin", mimeType="application/octet-stream")]
    public static var pending_guide_session_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_pending_instructions_request_xml.bin", mimeType="application/octet-stream")]
    public static var pending_instructions_request_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_pending_tour_request_xml.bin", mimeType="application/octet-stream")]
    public static var pending_tour_request_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_chat_review_reporter_feedback_xml.bin", mimeType="application/octet-stream")]
    public static var chat_review_reporter_feedback_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_abusive_notice_xml.bin", mimeType="application/octet-stream")]
    public static var abusive_notice_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_bully_report_xml.bin", mimeType="application/octet-stream")]
    public static var bully_report_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_chat_report_xml.bin", mimeType="application/octet-stream")]
    public static var chat_report_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_chat_report_item_xml.bin", mimeType="application/octet-stream")]
    public static var chat_report_item_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_emergency_help_request_xml.bin", mimeType="application/octet-stream")]
    public static var emergency_help_request_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_pending_request_xml.bin", mimeType="application/octet-stream")]
    public static var pending_request_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_habbo_way_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_way_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_habbo_way_quiz_xml.bin", mimeType="application/octet-stream")]
    public static var habbo_way_quiz_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_safety_booklet_xml.bin", mimeType="application/octet-stream")]
    public static var safety_booklet_xml:Class;
        [Embed(source="binaryData/HabboHelpCom_sanction_info_xml.bin", mimeType="application/octet-stream")]
    public static var sanction_info_xml:Class;
        public static var requiredClasses:Array = new Array(HabboHelpBootstrap, IIDHabboHelp);
    }
}
