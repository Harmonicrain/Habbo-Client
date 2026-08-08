package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomObjectFactoryBootstrap;
    import com.sulake.iid.IIDRoomObjectFactory;

    public class HabboRoomObjectLogicLib extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboRoomObjectLogicLib_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        public static var requiredClasses:Array = new Array(RoomObjectFactoryBootstrap, IIDRoomObjectFactory);
    }
}
