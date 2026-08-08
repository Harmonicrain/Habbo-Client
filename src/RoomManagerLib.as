package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomManagerBootstrap;
    import com.sulake.iid.IIDRoomManager;

    public class RoomManagerLib extends SimpleApplication 
    {
        [Embed(source="binaryData/RoomManagerLib_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        public static var requiredClasses:Array = new Array(RoomManagerBootstrap, IIDRoomManager);
    }
}
