package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboTrackingBootstrap;
    import com.sulake.iid.IIDHabboTracking;

    public class HabboTrackingLib extends SimpleApplication 
    {
        [Embed(source="binaryData/HabboTrackingLib_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        public static var requiredClasses:Array = new Array(HabboTrackingBootstrap, IIDHabboTracking);
    }
}
