package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboCommunicationDemoBootstrap;

    public class HabboCommunicationDemoCom extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboCommunicationDemoCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="binaryData/HabboCommunicationDemoCom_login_window.bin", mimeType="application/octet-stream")]
        public static var login_window:Class;
        [Embed(source="binaryData/HabboCommunicationDemoCom_login_environment_list_item.bin", mimeType="application/octet-stream")]
        public static var login_environment_list_item:Class;
        public static var requiredClasses:Array = new Array(HabboCommunicationDemoBootstrap);
    }
}
