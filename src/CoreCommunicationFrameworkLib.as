package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.CoreCommunicationManagerBootstrap;
    import com.sulake.iid.IIDCoreCommunicationManager;

    public class CoreCommunicationFrameworkLib extends SimpleApplication 
    {
        [Embed(source="binaryData/CoreCommunicationFrameworkLib_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        public static var requiredClasses:Array = new Array(CoreCommunicationManagerBootstrap, IIDCoreCommunicationManager);
    }
}
