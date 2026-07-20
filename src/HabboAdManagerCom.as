package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.AdManagerBootstrap;
    import com.sulake.iid.IIDHabboAdManager;

    public class HabboAdManagerCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboAdManagerCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        public static var requiredClasses:Array = new Array(AdManagerBootstrap, IIDHabboAdManager);
    }
}
