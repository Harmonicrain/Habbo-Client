package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboCommunicationManagerBootstrap;
    import com.sulake.iid.IIDHabboCommunicationManager;

    public class HabboCommunicationCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboCommunicationManagerBootstrap, IIDHabboCommunicationManager);
        [Embed(source="binaryData/HabboCommunicationCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
    }
}
