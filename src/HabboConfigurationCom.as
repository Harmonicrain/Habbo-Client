package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboConfigurationManagerBootstrap;
    import com.sulake.iid.IIDHabboConfigurationManager;
    import com.sulake.habbo.configuration.HabboConfigurationManager;

    public class HabboConfigurationCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboConfigurationManagerBootstrap, IIDHabboConfigurationManager, HabboConfigurationManager);
        [Embed(source="binaryData/HabboConfigurationCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="binaryData/HabboConfigurationCom_localization_configuration.bin", mimeType="application/octet-stream")]
        public static var localization_configuration:Class;
    }
}
