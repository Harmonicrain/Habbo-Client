package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.SessionDataManagerBootstrap;
    import com.sulake.iid.IIDSessionDataManager;

    public class HabboSessionDataManagerLib extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(SessionDataManagerBootstrap, IIDSessionDataManager);
        [Embed(source="binaryData/HabboSessionDataManagerLib_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="images/HabboSessionDataManagerLib_loading_icon.png")]
        public static var loading_icon:Class;
    }
}
