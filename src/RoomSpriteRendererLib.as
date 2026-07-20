package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.RoomRendererFactoryBootstrap;
    import com.sulake.iid.IIDRoomRendererFactory;

    public class RoomSpriteRendererLib extends SimpleApplication 
    {
        [Embed(source="binaryData/RoomSpriteRendererLib_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        public static var requiredClasses:Array = new Array(RoomRendererFactoryBootstrap, IIDRoomRendererFactory);
    }
}
