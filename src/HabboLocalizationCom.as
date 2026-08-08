package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboLocalizationManagerBootstrap;
    import com.sulake.iid.IIDCoreLocalizationManager;
    import com.sulake.iid.IIDHabboLocalizationManager;
    import com.sulake.core.localization.ICoreLocalizationManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.localization.HabboLocalizationManager;

    public class HabboLocalizationCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboLocalizationManagerBootstrap, IIDCoreLocalizationManager, IIDHabboLocalizationManager, ICoreLocalizationManager, IHabboLocalizationManager, HabboLocalizationManager);
        [Embed(source="binaryData/HabboLocalizationCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
    }
}
