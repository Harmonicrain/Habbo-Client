package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomObjectVisualizationFactoryBootstrap;
    import com.sulake.iid.IIDRoomObjectVisualizationFactory;

    public class HabboRoomObjectVisualizationLib extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboRoomObjectVisualizationLib_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        [Embed(source="images/HabboRoomObjectVisualizationLib_pet_experience_bubble_png.png")]
    public static var pet_experience_bubble_png:Class;
        [Embed(source="images/HabboRoomObjectVisualizationLib_snowball_small_png.png")]
    public static var snowball_small_png:Class;
        [Embed(source="images/HabboRoomObjectVisualizationLib_snowball_small_shadow_png.png")]
    public static var snowball_small_shadow_png:Class;
        [Embed(source="images/HabboRoomObjectVisualizationLib_snowball_big_png.png")]
    public static var snowball_big_png:Class;
        [Embed(source="images/HabboRoomObjectVisualizationLib_snowball_splash_1.png")]
    public static var snowball_splash_1:Class;
        [Embed(source="images/HabboRoomObjectVisualizationLib_snowball_splash_2.png")]
    public static var snowball_splash_2:Class;
        [Embed(source="images/HabboRoomObjectVisualizationLib_snowball_splash_3.png")]
    public static var snowball_splash_3:Class;
        public static var requiredClasses:Array = new Array(RoomObjectVisualizationFactoryBootstrap, IIDRoomObjectVisualizationFactory);
    }
}
