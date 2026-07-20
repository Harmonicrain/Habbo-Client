package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomSessionManagerBootstrap;
    import com.sulake.iid.IIDHabboRoomSessionManager;

    public class HabboRoomSessionManagerLib extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboRoomSessionManagerLib_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        public static var requiredClasses:Array = new Array(RoomSessionManagerBootstrap, IIDHabboRoomSessionManager);
    }
}
