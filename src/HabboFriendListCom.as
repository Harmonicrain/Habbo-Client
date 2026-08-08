package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboFriendListBootstrap;
    import com.sulake.iid.IIDHabboFriendList;

    public class HabboFriendListCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboFriendListCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="images/HabboFriendListCom_arrow_down_black_png.png")]
        public static var arrow_down_black_png:Class;
        [Embed(source="images/HabboFriendListCom_arrow_down_white_png.png")]
        public static var arrow_down_white_png:Class;
        [Embed(source="images/HabboFriendListCom_arrow_right_black_png.png")]
        public static var arrow_right_black_png:Class;
        [Embed(source="images/HabboFriendListCom_arrow_right_white_png.png")]
        public static var arrow_right_white_png:Class;
        [Embed(source="images/HabboFriendListCom_ask_for_friend_png.png")]
        public static var ask_for_friend_png:Class;
        [Embed(source="images/HabboFriendListCom_follow_friend_png.png")]
        public static var follow_friend_png:Class;
        [Embed(source="images/HabboFriendListCom_hdr_friend_requests_png.png")]
        public static var hdr_friend_requests_png:Class;
        [Embed(source="images/HabboFriendListCom_hdr_friends_png.png")]
        public static var hdr_friends_png:Class;
        [Embed(source="images/HabboFriendListCom_hdr_hilite_png.png")]
        public static var hdr_hilite_png:Class;
        [Embed(source="images/HabboFriendListCom_hdr_search_png.png")]
        public static var hdr_search_png:Class;
        [Embed(source="images/HabboFriendListCom_minimail_png.png")]
        public static var minimail_png:Class;
        [Embed(source="images/HabboFriendListCom_offline_png.png")]
        public static var offline_png:Class;
        [Embed(source="images/HabboFriendListCom_open_edit_ctgs_png.png")]
        public static var open_edit_ctgs_png:Class;
        [Embed(source="images/HabboFriendListCom_open_homepage_png.png")]
        public static var open_homepage_png:Class;
        [Embed(source="images/HabboFriendListCom_open_inbox_png.png")]
        public static var open_inbox_png:Class;
        [Embed(source="images/HabboFriendListCom_open_minimail_png.png")]
        public static var open_minimail_png:Class;
        [Embed(source="images/HabboFriendListCom_opened_to_web_png.png")]
        public static var opened_to_web_png:Class;
        [Embed(source="images/HabboFriendListCom_popup_arrow_left_png.png")]
        public static var popup_arrow_left_png:Class;
        [Embed(source="images/HabboFriendListCom_popup_arrow_right_png.png")]
        public static var popup_arrow_right_png:Class;
        [Embed(source="images/HabboFriendListCom_remove_friend_png.png")]
        public static var remove_friend_png:Class;
        [Embed(source="images/HabboFriendListCom_room_invite_png.png")]
        public static var room_invite_png:Class;
        [Embed(source="images/HabboFriendListCom_start_chat_png.png")]
        public static var start_chat_png:Class;
        [Embed(source="images/HabboFriendListCom_search_png.png")]
        public static var search_png:Class;
        [Embed(source="binaryData/HabboFriendListCom_avatar_popup_xml.bin", mimeType="application/octet-stream")]
        public static var avatar_popup_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_friend_entry_xml.bin", mimeType="application/octet-stream")]
        public static var friend_entry_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_friend_remove_confirm_xml.bin", mimeType="application/octet-stream")]
        public static var friend_remove_confirm_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_friend_request_entry_xml.bin", mimeType="application/octet-stream")]
        public static var friend_request_entry_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_friend_requests_footer_xml.bin", mimeType="application/octet-stream")]
        public static var friend_requests_footer_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_friends_footer_xml.bin", mimeType="application/octet-stream")]
        public static var friends_footer_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_opened_to_web_popup_xml.bin", mimeType="application/octet-stream")]
        public static var opened_to_web_popup_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_pagelink_xml.bin", mimeType="application/octet-stream")]
        public static var pagelink_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_main_window_xml.bin", mimeType="application/octet-stream")]
        public static var main_window_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_room_invite_confirm_xml.bin", mimeType="application/octet-stream")]
        public static var room_invite_confirm_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_search_entry_xml.bin", mimeType="application/octet-stream")]
        public static var search_entry_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_search_footer_xml.bin", mimeType="application/octet-stream")]
        public static var search_footer_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_simple_alert_xml.bin", mimeType="application/octet-stream")]
        public static var simple_alert_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_tab_content_xml.bin", mimeType="application/octet-stream")]
        public static var tab_content_xml:Class;
        [Embed(source="binaryData/HabboFriendListCom_relationship_chooser_xml.bin", mimeType="application/octet-stream")]
        public static var relationship_chooser_xml:Class;
        public static var requiredClasses:Array = new Array(HabboFriendListBootstrap, IIDHabboFriendList);
    }
}
