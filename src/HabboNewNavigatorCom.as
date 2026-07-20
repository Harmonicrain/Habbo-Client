package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboNewNavigatorBootstrap;
    import com.sulake.iid.IIDHabboNewNavigator;

    public class HabboNewNavigatorCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboNewNavigatorCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        [Embed(source="binaryData/HabboNewNavigatorCom_navigator_frame_2_xml.bin", mimeType="application/octet-stream")]
    public static var navigator_frame_2_xml:Class;
        [Embed(source="binaryData/HabboNewNavigatorCom_room_info_popup_bubble_xml.bin", mimeType="application/octet-stream")]
    public static var room_info_popup_bubble_xml:Class;
        [Embed(source="binaryData/HabboNewNavigatorCom_property_xml.bin", mimeType="application/octet-stream")]
    public static var property_xml:Class;
        [Embed(source="binaryData/HabboNewNavigatorCom_tag_xml.bin", mimeType="application/octet-stream")]
    public static var tag_xml:Class;
        public static var requiredClasses:Array = new Array(HabboNewNavigatorBootstrap, IIDHabboNewNavigator);
    }
}
