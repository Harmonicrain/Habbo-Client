package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboMessengerBootstrap;
    import com.sulake.iid.IIDHabboMessenger;

    public class HabboMessengerCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboMessengerCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="images/HabboMessengerCom_close_png.png")]
        public static var close_png:Class;
        [Embed(source="images/HabboMessengerCom_convo_bg_png.png")]
        public static var convo_bg_png:Class;
        [Embed(source="images/HabboMessengerCom_follow_friend_png.png")]
        public static var follow_friend_png:Class;
        [Embed(source="images/HabboMessengerCom_minimail_png.png")]
        public static var minimail_png:Class;
        [Embed(source="images/HabboMessengerCom_next_png.png")]
        public static var next_png:Class;
        [Embed(source="images/HabboMessengerCom_prev_png.png")]
        public static var prev_png:Class;
        [Embed(source="images/HabboMessengerCom_resize_png.png")]
        public static var resize_png:Class;
        [Embed(source="images/HabboMessengerCom_tab_bg_hilite_png.png")]
        public static var tab_bg_hilite_png:Class;
        [Embed(source="images/HabboMessengerCom_tab_bg_next_png.png")]
        public static var tab_bg_next_png:Class;
        [Embed(source="images/HabboMessengerCom_tab_bg_sel_png.png")]
        public static var tab_bg_sel_png:Class;
        [Embed(source="images/HabboMessengerCom_tab_bg_unsel_png.png")]
        public static var tab_bg_unsel_png:Class;
        [Embed(source="binaryData/HabboMessengerCom_main_window_xml.bin", mimeType="application/octet-stream")]
        public static var main_window_xml:Class;
        [Embed(source="binaryData/HabboMessengerCom_msg_entry_xml.bin", mimeType="application/octet-stream")]
        public static var msg_entry_xml:Class;
        [Embed(source="binaryData/HabboMessengerCom_tab_entry_xml.bin", mimeType="application/octet-stream")]
        public static var tab_entry_xml:Class;
        [Embed(source="binaryData/HabboMessengerCom_messenger_xml.bin", mimeType="application/octet-stream")]
        public static var messenger_xml:Class;
        [Embed(source="binaryData/HabboMessengerCom_messenger_habbicon_picker_xml.bin", mimeType="application/octet-stream")]
        public static var messenger_habbicon_picker_xml:Class;
        public static var requiredClasses:Array = new Array(HabboMessengerBootstrap, IIDHabboMessenger);
    }
}
