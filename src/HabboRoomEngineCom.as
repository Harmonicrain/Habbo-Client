package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomEngineBootstrap;
    import com.sulake.iid.IIDRoomEngine;

    public class HabboRoomEngineCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboRoomEngineCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        public static var requiredClasses:Array = new Array(RoomEngineBootstrap, IIDRoomEngine);
    }
}
