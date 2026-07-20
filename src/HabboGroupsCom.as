package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboGroupsManagerBootstrap;
    import com.sulake.iid.IIDHabboGroupsManager;

    public class HabboGroupsCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboGroupsCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        [Embed(source="binaryData/HabboGroupsCom_group.bin", mimeType="application/octet-stream")]
    public static var group:Class;
        [Embed(source="binaryData/HabboGroupsCom_guild_members_window.bin", mimeType="application/octet-stream")]
    public static var guild_members_window:Class;
        [Embed(source="binaryData/HabboGroupsCom_group_entry.bin", mimeType="application/octet-stream")]
    public static var group_entry:Class;
        [Embed(source="binaryData/HabboGroupsCom_member_entry.bin", mimeType="application/octet-stream")]
    public static var member_entry:Class;
        [Embed(source="binaryData/HabboGroupsCom_group_info_window.bin", mimeType="application/octet-stream")]
    public static var group_info_window:Class;
        [Embed(source="binaryData/HabboGroupsCom_group_management_window.bin", mimeType="application/octet-stream")]
    public static var group_management_window:Class;
        [Embed(source="binaryData/HabboGroupsCom_new_extended_profile.bin", mimeType="application/octet-stream")]
    public static var new_extended_profile:Class;
        [Embed(source="binaryData/HabboGroupsCom_club_required.bin", mimeType="application/octet-stream")]
    public static var club_required:Class;
        [Embed(source="binaryData/HabboGroupsCom_group_created_window.bin", mimeType="application/octet-stream")]
    public static var group_created_window:Class;
        [Embed(source="binaryData/HabboGroupsCom_group_room_info.bin", mimeType="application/octet-stream")]
    public static var group_room_info:Class;
        [Embed(source="binaryData/HabboGroupsCom_no_groups.bin", mimeType="application/octet-stream")]
    public static var no_groups:Class;
        [Embed(source="binaryData/HabboGroupsCom_badge_color_item.bin", mimeType="application/octet-stream")]
    public static var badge_color_item:Class;
        [Embed(source="binaryData/HabboGroupsCom_badge_editor.bin", mimeType="application/octet-stream")]
    public static var badge_editor:Class;
        [Embed(source="binaryData/HabboGroupsCom_badge_layer.bin", mimeType="application/octet-stream")]
    public static var badge_layer:Class;
        [Embed(source="binaryData/HabboGroupsCom_badge_part_item.bin", mimeType="application/octet-stream")]
    public static var badge_part_item:Class;
        [Embed(source="images/HabboGroupsCom_color_chooser_bg.png")]
    public static var color_chooser_bg:Class;
        [Embed(source="images/HabboGroupsCom_color_chooser_fg.png")]
    public static var color_chooser_fg:Class;
        [Embed(source="images/HabboGroupsCom_color_chooser_selected.png")]
    public static var color_chooser_selected:Class;
        [Embed(source="images/HabboGroupsCom_part_preview_bg.png")]
    public static var part_preview_bg:Class;
        [Embed(source="images/HabboGroupsCom_position_grid.png")]
    public static var position_grid:Class;
        [Embed(source="images/HabboGroupsCom_position_picker.png")]
    public static var position_picker:Class;
        [Embed(source="images/HabboGroupsCom_badge_part_add.png")]
    public static var badge_part_add:Class;
        [Embed(source="images/HabboGroupsCom_badge_part_empty.png")]
    public static var badge_part_empty:Class;
        [Embed(source="images/HabboGroupsCom_badge_part_picker.png")]
    public static var badge_part_picker:Class;
        public static var requiredClasses:Array = new Array(HabboGroupsManagerBootstrap, IIDHabboGroupsManager);
    }
}
