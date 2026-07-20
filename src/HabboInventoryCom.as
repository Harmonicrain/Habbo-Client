package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboInventoryBootstrap;
    import com.sulake.iid.IIDHabboInventory;

    public class HabboInventoryCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboInventoryBootstrap, IIDHabboInventory);
        [Embed(source="binaryData/HabboInventoryCom_manifest.bin", mimeType="application/octet-stream")]
    public static var manifest:Class;
        [Embed(source="binaryData/HabboInventoryCom_inventory_xml.bin", mimeType="application/octet-stream")]
    public static var inventory_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_inventory_thumb_xml.bin", mimeType="application/octet-stream")]
    public static var inventory_thumb_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_inventory_thumb_credits_xml.bin", mimeType="application/octet-stream")]
    public static var inventory_thumb_credits_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_inventory_effects_xml.bin", mimeType="application/octet-stream")]
    public static var inventory_effects_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_inventory_trading_xml.bin", mimeType="application/octet-stream")]
    public static var inventory_trading_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_inventory_trading_minimized_xml.bin", mimeType="application/octet-stream")]
    public static var inventory_trading_minimized_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_buy_marketplace_tokens_xml.bin", mimeType="application/octet-stream")]
    public static var buy_marketplace_tokens_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_make_marketplace_offer_xml.bin", mimeType="application/octet-stream")]
    public static var make_marketplace_offer_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_marketplace_no_credits_xml.bin", mimeType="application/octet-stream")]
    public static var marketplace_no_credits_xml:Class;
        [Embed(source="binaryData/HabboInventoryCom_unseen_item_symbol_xml.bin", mimeType="application/octet-stream")]
    public static var unseen_item_symbol_xml:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_1_png.png")]
    public static var fx_icon_1_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_2_png.png")]
    public static var fx_icon_2_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_3_png.png")]
    public static var fx_icon_3_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_4_png.png")]
    public static var fx_icon_4_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_5_png.png")]
    public static var fx_icon_5_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_6_png.png")]
    public static var fx_icon_6_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_7_png.png")]
    public static var fx_icon_7_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_8_png.png")]
    public static var fx_icon_8_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_9_png.png")]
    public static var fx_icon_9_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_10_png.png")]
    public static var fx_icon_10_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_11_png.png")]
    public static var fx_icon_11_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_12_png.png")]
    public static var fx_icon_12_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_13_png.png")]
    public static var fx_icon_13_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_14_png.png")]
    public static var fx_icon_14_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_15_png.png")]
    public static var fx_icon_15_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_16_png.png")]
    public static var fx_icon_16_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_17_png.png")]
    public static var fx_icon_17_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_18_png.png")]
    public static var fx_icon_18_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_19_png.png")]
    public static var fx_icon_19_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_20_png.png")]
    public static var fx_icon_20_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_21_png.png")]
    public static var fx_icon_21_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_22_png.png")]
    public static var fx_icon_22_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_23_png.png")]
    public static var fx_icon_23_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_24_png.png")]
    public static var fx_icon_24_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_25_png.png")]
    public static var fx_icon_25_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_26_png.png")]
    public static var fx_icon_26_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_27_png.png")]
    public static var fx_icon_27_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_31_png.png")]
    public static var fx_icon_31_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_32_png.png")]
    public static var fx_icon_32_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_44_png.png")]
    public static var fx_icon_44_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_47_png.png")]
    public static var fx_icon_47_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_48_png.png")]
    public static var fx_icon_48_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_53_png.png")]
    public static var fx_icon_53_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_54_png.png")]
    public static var fx_icon_54_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_59_png.png")]
    public static var fx_icon_59_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_60_png.png")]
    public static var fx_icon_60_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_61_png.png")]
    public static var fx_icon_61_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_62_png.png")]
    public static var fx_icon_62_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_63_png.png")]
    public static var fx_icon_63_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_64_png.png")]
    public static var fx_icon_64_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_65_png.png")]
    public static var fx_icon_65_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_66_png.png")]
    public static var fx_icon_66_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_67_png.png")]
    public static var fx_icon_67_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_69_png.png")]
    public static var fx_icon_69_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_70_png.png")]
    public static var fx_icon_70_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_71_png.png")]
    public static var fx_icon_71_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_72_png.png")]
    public static var fx_icon_72_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_73_png.png")]
    public static var fx_icon_73_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_74_png.png")]
    public static var fx_icon_74_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_75_png.png")]
    public static var fx_icon_75_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_76_png.png")]
    public static var fx_icon_76_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_78_png.png")]
    public static var fx_icon_78_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_79_png.png")]
    public static var fx_icon_79_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_80_png.png")]
    public static var fx_icon_80_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_81_png.png")]
    public static var fx_icon_81_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_82_png.png")]
    public static var fx_icon_82_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_83_png.png")]
    public static var fx_icon_83_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_84_png.png")]
    public static var fx_icon_84_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_85_png.png")]
    public static var fx_icon_85_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_86_png.png")]
    public static var fx_icon_86_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_87_png.png")]
    public static var fx_icon_87_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_88_png.png")]
    public static var fx_icon_88_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_89_png.png")]
    public static var fx_icon_89_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_90_png.png")]
    public static var fx_icon_90_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_91_png.png")]
    public static var fx_icon_91_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_92_png.png")]
    public static var fx_icon_92_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_93_png.png")]
    public static var fx_icon_93_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_94_png.png")]
    public static var fx_icon_94_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_99_png.png")]
    public static var fx_icon_99_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_100_png.png")]
    public static var fx_icon_100_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_101_png.png")]
    public static var fx_icon_101_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_102_png.png")]
    public static var fx_icon_102_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_104_png.png")]
    public static var fx_icon_104_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_105_png.png")]
    public static var fx_icon_105_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_106_png.png")]
    public static var fx_icon_106_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_107_png.png")]
    public static var fx_icon_107_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_108_png.png")]
    public static var fx_icon_108_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_109_png.png")]
    public static var fx_icon_109_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_110_png.png")]
    public static var fx_icon_110_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_111_png.png")]
    public static var fx_icon_111_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_112_png.png")]
    public static var fx_icon_112_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_113_png.png")]
    public static var fx_icon_113_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_114_png.png")]
    public static var fx_icon_114_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_115_png.png")]
    public static var fx_icon_115_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_116_png.png")]
    public static var fx_icon_116_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_117_png.png")]
    public static var fx_icon_117_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_118_png.png")]
    public static var fx_icon_118_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_119_png.png")]
    public static var fx_icon_119_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_120_png.png")]
    public static var fx_icon_120_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_121_png.png")]
    public static var fx_icon_121_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_122_png.png")]
    public static var fx_icon_122_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_123_png.png")]
    public static var fx_icon_123_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_124_png.png")]
    public static var fx_icon_124_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_125_png.png")]
    public static var fx_icon_125_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_126_png.png")]
    public static var fx_icon_126_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_127_png.png")]
    public static var fx_icon_127_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_128_png.png")]
    public static var fx_icon_128_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_129_png.png")]
    public static var fx_icon_129_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_130_png.png")]
    public static var fx_icon_130_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_131_png.png")]
    public static var fx_icon_131_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_132_png.png")]
    public static var fx_icon_132_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_133_png.png")]
    public static var fx_icon_133_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_134_png.png")]
    public static var fx_icon_134_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_135_png.png")]
    public static var fx_icon_135_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_136_png.png")]
    public static var fx_icon_136_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_137_png.png")]
    public static var fx_icon_137_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_138_png.png")]
    public static var fx_icon_138_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_139_png.png")]
    public static var fx_icon_139_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_140_png.png")]
    public static var fx_icon_140_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_141_png.png")]
    public static var fx_icon_141_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_142_png.png")]
    public static var fx_icon_142_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_143_png.png")]
    public static var fx_icon_143_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_144_png.png")]
    public static var fx_icon_144_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_145_png.png")]
    public static var fx_icon_145_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_146_png.png")]
    public static var fx_icon_146_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_147_png.png")]
    public static var fx_icon_147_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_148_png.png")]
    public static var fx_icon_148_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_149_png.png")]
    public static var fx_icon_149_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_150_png.png")]
    public static var fx_icon_150_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_151_png.png")]
    public static var fx_icon_151_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_152_png.png")]
    public static var fx_icon_152_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_153_png.png")]
    public static var fx_icon_153_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_154_png.png")]
    public static var fx_icon_154_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_155_png.png")]
    public static var fx_icon_155_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_156_png.png")]
    public static var fx_icon_156_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_157_png.png")]
    public static var fx_icon_157_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_158_png.png")]
    public static var fx_icon_158_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_159_png.png")]
    public static var fx_icon_159_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_160_png.png")]
    public static var fx_icon_160_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_161_png.png")]
    public static var fx_icon_161_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_162_png.png")]
    public static var fx_icon_162_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_164_png.png")]
    public static var fx_icon_164_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_165_png.png")]
    public static var fx_icon_165_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_166_png.png")]
    public static var fx_icon_166_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_167_png.png")]
    public static var fx_icon_167_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_168_png.png")]
    public static var fx_icon_168_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_169_png.png")]
    public static var fx_icon_169_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_170_png.png")]
    public static var fx_icon_170_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_171_png.png")]
    public static var fx_icon_171_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_172_png.png")]
    public static var fx_icon_172_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_173_png.png")]
    public static var fx_icon_173_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_174_png.png")]
    public static var fx_icon_174_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_175_png.png")]
    public static var fx_icon_175_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_176_png.png")]
    public static var fx_icon_176_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_177_png.png")]
    public static var fx_icon_177_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_178_png.png")]
    public static var fx_icon_178_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_179_png.png")]
    public static var fx_icon_179_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_180_png.png")]
    public static var fx_icon_180_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_181_png.png")]
    public static var fx_icon_181_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_182_png.png")]
    public static var fx_icon_182_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_183_png.png")]
    public static var fx_icon_183_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_186_png.png")]
    public static var fx_icon_186_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_191_png.png")]
    public static var fx_icon_191_png:Class;
        [Embed(source="images/HabboInventoryCom_fx_icon_192_png.png")]
    public static var fx_icon_192_png:Class;
        [Embed(source="binaryData/HabboInventoryCom_item_popup_xml.bin", mimeType="application/octet-stream")]
    public static var item_popup_xml:Class;
        [Embed(source="images/HabboInventoryCom_popup_arrow_left_png.png")]
    public static var popup_arrow_left_png:Class;
        [Embed(source="images/HabboInventoryCom_popup_arrow_right_png.png")]
    public static var popup_arrow_right_png:Class;
    }
}
