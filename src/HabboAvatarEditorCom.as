package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboAvatarEditorManagerBootstrap;
    import com.sulake.iid.IIDHabboAvatarEditor;

    public class HabboAvatarEditorCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboAvatarEditorManagerBootstrap, IIDHabboAvatarEditor);
        [Embed(source="binaryData/HabboAvatarEditorCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_AvatarEditor.bin", mimeType="application/octet-stream")]
        public static var AvatarEditor:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_AvatarEditorFrame.bin", mimeType="application/octet-stream")]
        public static var AvatarEditorFrame:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_AvatarEditorContent.bin", mimeType="application/octet-stream")]
        public static var AvatarEditorContent:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_StripClubItemsInfo.bin", mimeType="application/octet-stream")]
        public static var StripClubItemsInfo:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_Outfit.bin", mimeType="application/octet-stream")]
        public static var Outfit:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_avatareditor_wardrobe_base.bin", mimeType="application/octet-stream")]
        public static var avatareditor_wardrobe_base:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_avatar_editor_effect_griditem_xml.bin", mimeType="application/octet-stream")]
        public static var avatar_editor_effect_griditem_xml:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_avatar_editor_name_change.bin", mimeType="application/octet-stream")]
        public static var avatar_editor_name_change:Class;
        [Embed(source="binaryData/HabboAvatarEditorCom_avatar_editor_name_change_item.bin", mimeType="application/octet-stream")]
        public static var avatar_editor_name_change_item:Class;
    }
}
