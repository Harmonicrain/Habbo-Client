package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboSoundManagerFlash10Bootstrap;
    import com.sulake.iid.IIDHabboSoundManager;

    public class HabboSoundManagerFlash10Com extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboSoundManagerFlash10Bootstrap, IIDHabboSoundManager);
        [Embed(source="binaryData/HabboSoundManagerFlash10Com_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_call_for_help.mp3")]
        public static var sound_call_for_help:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_catalogue_cash.mp3")]
        public static var sound_catalogue_cash:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_catalogue_duckets.mp3")]
        public static var sound_catalogue_duckets:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_console_message_sent.mp3")]
        public static var sound_console_message_sent:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_console_new_message.mp3")]
        public static var sound_console_new_message:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_guide_received_invitation.mp3")]
        public static var sound_guide_received_invitation:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_guide_help_requested.mp3")]
        public static var sound_guide_help_requested:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_respect_received.mp3")]
        public static var sound_respect_received:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_ig_countdown.mp3")]
        public static var HBSTG_ig_countdown:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_ig_losing.mp3")]
        public static var HBSTG_ig_losing:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_ig_winning.mp3")]
        public static var HBSTG_ig_winning:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_FURNITURE_cuckoo_clock.mp3")]
        public static var FURNITURE_cuckoo_clock:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_sound_camera_shutter.mp3")]
        public static var sound_camera_shutter:Class;
		
		[Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_get_snowball.mp3")]
		public static var HBSTG_snowwar_get_snowball:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_hit1.mp3")]
        public static var HBSTG_snowwar_hit1:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_hit2.mp3")]
        public static var HBSTG_snowwar_hit2:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_hit3.mp3")]
        public static var HBSTG_snowwar_hit3:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_make_snowball.mp3")]
        public static var HBSTG_snowwar_make_snowball:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_miss.mp3")]
        public static var HBSTG_snowwar_miss:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_throw.mp3")]
        public static var HBSTG_snowwar_throw:Class;
        [Embed(source="sounds/HabboSoundManagerFlash10Com_HBSTG_snowwar_walk.mp3")]
        public static var HBSTG_snowwar_walk:Class;
    }
}
