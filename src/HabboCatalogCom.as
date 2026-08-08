package 
{
    import mx.core.SimpleApplication;
    import com.sulake.bootstrap.HabboCatalogBootstrap;
    import com.sulake.iid.IIDHabboCatalog;

    public class HabboCatalogCom extends SimpleApplication 
    {
        public static var requiredClasses:Array = new Array(HabboCatalogBootstrap, IIDHabboCatalog);
        [Embed(source="binaryData/HabboCatalogCom_manifest.bin", mimeType="application/octet-stream")]
        public static var manifest:Class;
        [Embed(source="images/HabboCatalogCom_bot_thumb_bg.png")]
        public static const bot_thumb_bg:Class;
        [Embed(source="images/HabboCatalogCom_bot_thumb_bg_selected.png")]
        public static const bot_thumb_bg_selected:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_clr_27x22_1.png")]
        public static const ctlg_clr_27x22_1:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_clr_27x22_2.png")]
        public static const ctlg_clr_27x22_2:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_clr_27x22_3.png")]
        public static const ctlg_clr_27x22_3:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_clr_40x32_1.png")]
        public static const ctlg_clr_40x32_1:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_clr_40x32_2.png")]
        public static const ctlg_clr_40x32_2:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_clr_40x32_3.png")]
        public static const ctlg_clr_40x32_3:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_arrow_down.png")]
        public static const ctlg_arrow_down:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_arrow_next.png")]
        public static const ctlg_arrow_next:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_arrow_prev.png")]
        public static const ctlg_arrow_prev:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_arrow_right.png")]
        public static const ctlg_arrow_right:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_dyndeal_background.png")]
        public static const ctlg_dyndeal_background:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_icon_deal_hc.png")]
        public static const ctlg_icon_deal_hc:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_pic_deal_icon_narrow.png")]
        public static const ctlg_pic_deal_icon_narrow:Class;
        [Embed(source="images/HabboCatalogCom_events_confirm_purchase.png")]
        public static const events_confirm_purchase:Class;
        [Embed(source="images/HabboCatalogCom_ctlg_recycler_slot_bg.png")]
        public static const ctlg_recycler_slot_bg:Class;
        [Embed(source="images/HabboCatalogCom_purse_club_small.png")]
        public static const purse_club_small:Class;
        [Embed(source="images/HabboCatalogCom_purse_coins_small.png")]
        public static const purse_coins_small:Class;
        [Embed(source="images/HabboCatalogCom_purse_pixels_small.png")]
        public static const purse_pixels_small:Class;
        [Embed(source="images/HabboCatalogCom_testarrow_down.png")]
        public static const testarrow_down:Class;
        [Embed(source="images/HabboCatalogCom_testarrow_right.png")]
        public static const testarrow_right:Class;
        [Embed(source="images/HabboCatalogCom_vip_icon_medium.png")]
        public static const vip_icon_medium:Class;
        [Embed(source="images/HabboCatalogCom_icon_credit_0.png")]
        public static const icon_credit_0:Class;
        [Embed(source="images/HabboCatalogCom_icon_credit_1.png")]
        public static const icon_credit_1:Class;
        [Embed(source="images/HabboCatalogCom_icon_credit_2.png")]
        public static const icon_credit_2:Class;
        [Embed(source="images/HabboCatalogCom_icon_credit_3.png")]
        public static const icon_credit_3:Class;
        [Embed(source="images/HabboCatalogCom_icon_credit_4.png")]
        public static const icon_credit_4:Class;
        [Embed(source="images/HabboCatalogCom_icon_credit_5.png")]
        public static const icon_credit_5:Class;
        [Embed(source="images/HabboCatalogCom_icon_credit_6.png")]
        public static const icon_credit_6:Class;
        [Embed(source="images/HabboCatalogCom_icon_pixel_0.png")]
        public static const icon_pixel_0:Class;
        [Embed(source="images/HabboCatalogCom_icon_shell_0.png")]
        public static const icon_shell_0:Class;
        [Embed(source="images/HabboCatalogCom_icon_bg_img_2.png")]
        public static const icon_bg_img_2:Class;
        [Embed(source="images/HabboCatalogCom_icon_bg_img.png")]
        public static const icon_bg_img:Class;
        [Embed(source="images/HabboCatalogCom_icon_duck_vipwhite.png")]
        public static const icon_duck_vipwhite:Class;
        [Embed(source="images/HabboCatalogCom_icon_hc.png")]
        public static const icon_hc:Class;
        [Embed(source="images/HabboCatalogCom_thumb_bg.png")]
        public static const thumb_bg:Class;
        [Embed(source="images/HabboCatalogCom_thumb_bg_selected.png")]
        public static const thumb_bg_selected:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_center_xml.bin", mimeType="application/octet-stream")]
        public static var club_center_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_center_special_info_xml.bin", mimeType="application/octet-stream")]
        public static var club_center_special_info_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_extend_confirmation.bin", mimeType="application/octet-stream")]
        public static const club_extend_confirmation:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_buy_confirmation.bin", mimeType="application/octet-stream")]
        public static const club_buy_confirmation:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_buy_hc_item.bin", mimeType="application/octet-stream")]
        public static const club_buy_hc_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_buy_info_item.bin", mimeType="application/octet-stream")]
        public static const club_buy_info_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_buy_vip_item.bin", mimeType="application/octet-stream")]
        public static const club_buy_vip_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_buy_vip_upgrade_item.bin", mimeType="application/octet-stream")]
        public static const club_buy_vip_upgrade_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_gift_confirmation.bin", mimeType="application/octet-stream")]
        public static const club_gift_confirmation:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_gift_list_item.bin", mimeType="application/octet-stream")]
        public static const club_gift_list_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_gift_preview.bin", mimeType="application/octet-stream")]
        public static const club_gift_preview:Class;
        [Embed(source="binaryData/HabboCatalogCom_vip_buy_item.bin", mimeType="application/octet-stream")]
        public static const vip_buy_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_vip_benefits.bin", mimeType="application/octet-stream")]
        public static const vip_benefits:Class;
        [Embed(source="images/HabboCatalogCom_touchscreen_phone.png")]
        public static const touchscreen_phone:Class;
        [Embed(source="binaryData/HabboCatalogCom_color_chooser_cell.bin", mimeType="application/octet-stream")]
        public static const color_chooser_cell:Class;
        [Embed(source="binaryData/HabboCatalogCom_configuration_catalog_spaces.bin", mimeType="application/octet-stream")]
        public static const configuration_catalog_spaces:Class;
        [Embed(source="binaryData/HabboCatalogCom_gridItem.bin", mimeType="application/octet-stream")]
        public static const gridItem:Class;
        [Embed(source="binaryData/HabboCatalogCom_grid_item_with_price_multi.bin", mimeType="application/octet-stream")]
        public static const grid_item_with_price_multi:Class;
        [Embed(source="binaryData/HabboCatalogCom_grid_item_with_price_single.bin", mimeType="application/octet-stream")]
        public static const grid_item_with_price_single:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_club_buy.bin", mimeType="application/octet-stream")]
        public static const layout_club_buy:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_club_gifts.bin", mimeType="application/octet-stream")]
        public static const layout_club_gifts:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_default_3x3.bin", mimeType="application/octet-stream")]
        public static const layout_default_3x3:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_frontpage4.bin", mimeType="application/octet-stream")]
        public static const layout_frontpage4:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_frontpage_featured.bin", mimeType="application/octet-stream")]
        public static const layout_frontpage_featured:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_info_rentables.bin", mimeType="application/octet-stream")]
        public static const layout_info_rentables:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_info_duckets.bin", mimeType="application/octet-stream")]
        public static const layout_info_duckets:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_info_loyalty.bin", mimeType="application/octet-stream")]
        public static const layout_info_loyalty:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_loyalty_vip_buy.bin", mimeType="application/octet-stream")]
        public static const layout_loyalty_vip_buy:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_monkey.bin", mimeType="application/octet-stream")]
        public static const layout_monkey:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_marketplace_own_items.bin", mimeType="application/octet-stream")]
        public static const layout_marketplace_own_items:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_marketplace.bin", mimeType="application/octet-stream")]
        public static const layout_marketplace:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_petcustomization.bin", mimeType="application/octet-stream")]
        public static const layout_petcustomization:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_pets2.bin", mimeType="application/octet-stream")]
        public static const layout_pets2:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_pets3.bin", mimeType="application/octet-stream")]
        public static const layout_pets3:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_pets.bin", mimeType="application/octet-stream")]
        public static const layout_pets:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_roomads.bin", mimeType="application/octet-stream")]
        public static const layout_roomads:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_recycler_info.bin", mimeType="application/octet-stream")]
        public static const layout_recycler_info:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_recycler_prizes.bin", mimeType="application/octet-stream")]
        public static const layout_recycler_prizes:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_recycler.bin", mimeType="application/octet-stream")]
        public static const layout_recycler:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_soundmachine.bin", mimeType="application/octet-stream")]
        public static const layout_soundmachine:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_spaces_new.bin", mimeType="application/octet-stream")]
        public static const layout_spaces_new:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_trophies.bin", mimeType="application/octet-stream")]
        public static const layout_trophies:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_vip_buy.bin", mimeType="application/octet-stream")]
        public static const layout_vip_buy:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_guild_custom_furni.bin", mimeType="application/octet-stream")]
        public static const layout_guild_custom_furni:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_guild_frontpage.bin", mimeType="application/octet-stream")]
        public static const layout_guild_frontpage:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_guild_forum.bin", mimeType="application/octet-stream")]
        public static const layout_guild_forum:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_badge_display.bin", mimeType="application/octet-stream")]
        public static const layout_badge_display:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_single_bundle.bin", mimeType="application/octet-stream")]
        public static const layout_single_bundle:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_builders_club_addons.bin", mimeType="application/octet-stream")]
        public static const layout_builders_club_addons:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_builders_club_loyalty.bin", mimeType="application/octet-stream")]
        public static const layout_builders_club_loyalty:Class;
        [Embed(source="binaryData/HabboCatalogCom_layout_builders_club_frontpage.bin", mimeType="application/octet-stream")]
        public static const layout_builders_club_frontpage:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_club_buy.bin", mimeType="application/octet-stream")]
        public static const old_layout_club_buy:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_club_gifts.bin", mimeType="application/octet-stream")]
        public static const old_layout_club_gifts:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_default_3x3.bin", mimeType="application/octet-stream")]
        public static const old_layout_default_3x3:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_frontpage4.bin", mimeType="application/octet-stream")]
        public static const old_layout_frontpage4:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_info_rentables.bin", mimeType="application/octet-stream")]
        public static const old_layout_info_rentables:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_info_duckets.bin", mimeType="application/octet-stream")]
        public static const old_layout_info_duckets:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_info_loyalty.bin", mimeType="application/octet-stream")]
        public static const old_layout_info_loyalty:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_loyalty_vip_buy.bin", mimeType="application/octet-stream")]
        public static const old_layout_loyalty_vip_buy:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_monkey.bin", mimeType="application/octet-stream")]
        public static const old_layout_monkey:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_marketplace_own_items.bin", mimeType="application/octet-stream")]
        public static const old_layout_marketplace_own_items:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_marketplace.bin", mimeType="application/octet-stream")]
        public static const old_layout_marketplace:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_petcustomization.bin", mimeType="application/octet-stream")]
        public static const old_layout_petcustomization:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_pets2.bin", mimeType="application/octet-stream")]
        public static const old_layout_pets2:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_pets3.bin", mimeType="application/octet-stream")]
        public static const old_layout_pets3:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_pets.bin", mimeType="application/octet-stream")]
        public static const old_layout_pets:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_roomads.bin", mimeType="application/octet-stream")]
        public static const old_layout_roomads:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_recycler_info.bin", mimeType="application/octet-stream")]
        public static const old_layout_recycler_info:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_recycler_prizes.bin", mimeType="application/octet-stream")]
        public static const old_layout_recycler_prizes:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_recycler.bin", mimeType="application/octet-stream")]
        public static const old_layout_recycler:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_soundmachine.bin", mimeType="application/octet-stream")]
        public static const old_layout_soundmachine:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_spaces_new.bin", mimeType="application/octet-stream")]
        public static const old_layout_spaces_new:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_trophies.bin", mimeType="application/octet-stream")]
        public static const old_layout_trophies:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_vip_buy.bin", mimeType="application/octet-stream")]
        public static const old_layout_vip_buy:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_guild_custom_furni.bin", mimeType="application/octet-stream")]
        public static const old_layout_guild_custom_furni:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_guild_frontpage.bin", mimeType="application/octet-stream")]
        public static const old_layout_guild_frontpage:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_badge_display.bin", mimeType="application/octet-stream")]
        public static const old_layout_badge_display:Class;
        [Embed(source="binaryData/HabboCatalogCom_old_layout_single_bundle.bin", mimeType="application/octet-stream")]
        public static const old_layout_single_bundle:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbo_orderinfo_cantbuycredits.bin", mimeType="application/octet-stream")]
        public static const habbo_orderinfo_cantbuycredits:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbo_orderinfo_dialog.bin", mimeType="application/octet-stream")]
        public static const habbo_orderinfo_dialog:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbo_orderinfo_gift_checked.bin", mimeType="application/octet-stream")]
        public static const habbo_orderinfo_gift_checked:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbo_orderinfo_gift_unchecked.bin", mimeType="application/octet-stream")]
        public static const habbo_orderinfo_gift_unchecked:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbo_orderinfo_nocredits.bin", mimeType="application/octet-stream")]
        public static const habbo_orderinfo_nocredits:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbo_orderinfo_receiver_suggestion.bin", mimeType="application/octet-stream")]
        public static const habbo_orderinfo_receiver_suggestion:Class;
        [Embed(source="binaryData/HabboCatalogCom_clubBuyWidget.bin", mimeType="application/octet-stream")]
        public static const clubBuyWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_clubGiftWidget.bin", mimeType="application/octet-stream")]
        public static const clubGiftWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_colourGridWidget.bin", mimeType="application/octet-stream")]
        public static const colourGridWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_itemGridWidget.bin", mimeType="application/octet-stream")]
        public static const itemGridWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_marketPlaceOwnItemsWidget.bin", mimeType="application/octet-stream")]
        public static const marketPlaceOwnItemsWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_marketPlaceWidget.bin", mimeType="application/octet-stream")]
        public static const marketPlaceWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_petPreviewWidget.bin", mimeType="application/octet-stream")]
        public static const petPreviewWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_productViewWidget.bin", mimeType="application/octet-stream")]
        public static const productViewWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_purchaseWidget.bin", mimeType="application/octet-stream")]
        public static const purchaseWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_recyclerPrizesWidgetLevelItem.bin", mimeType="application/octet-stream")]
        public static const recyclerPrizesWidgetLevelItem:Class;
        [Embed(source="binaryData/HabboCatalogCom_recyclerWidget.bin", mimeType="application/octet-stream")]
        public static const recyclerWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_redeemItemCodeWidget.bin", mimeType="application/octet-stream")]
        public static const redeemItemCodeWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_singleViewWidget.bin", mimeType="application/octet-stream")]
        public static const singleViewWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_specialInfoWidget.bin", mimeType="application/octet-stream")]
        public static const specialInfoWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_textInputWidget.bin", mimeType="application/octet-stream")]
        public static const textInputWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_traxPreviewWidget.bin", mimeType="application/octet-stream")]
        public static const traxPreviewWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_trophyWidget.bin", mimeType="application/octet-stream")]
        public static const trophyWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_marketplace_offer_details.bin", mimeType="application/octet-stream")]
        public static const marketplace_offer_details:Class;
        [Embed(source="binaryData/HabboCatalogCom_marketplace_purchase_confirmation.bin", mimeType="application/octet-stream")]
        public static const marketplace_purchase_confirmation:Class;
        [Embed(source="binaryData/HabboCatalogCom_marketplace_search_advanced.bin", mimeType="application/octet-stream")]
        public static const marketplace_search_advanced:Class;
        [Embed(source="binaryData/HabboCatalogCom_marketplace_search_simple.bin", mimeType="application/octet-stream")]
        public static const marketplace_search_simple:Class;
        [Embed(source="binaryData/HabboCatalogCom_gift_palette_item.bin", mimeType="application/octet-stream")]
        public static const gift_palette_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_price_display.bin", mimeType="application/octet-stream")]
        public static const price_display:Class;
        [Embed(source="binaryData/HabboCatalogCom_priceDisplayWidget.bin", mimeType="application/octet-stream")]
        public static const priceDisplayWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_purchase_confirmation.bin", mimeType="application/octet-stream")]
        public static const purchase_confirmation:Class;
        [Embed(source="binaryData/HabboCatalogCom_gift_wrapping.bin", mimeType="application/octet-stream")]
        public static const gift_wrapping:Class;
        [Embed(source="images/HabboCatalogCom_gift_incognito.png")]
        public static const gift_incognito:Class;
        [Embed(source="binaryData/HabboCatalogCom_suggestion_list_item.bin", mimeType="application/octet-stream")]
        public static const suggestion_list_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_suggestion_list_item_new.bin", mimeType="application/octet-stream")]
        public static const suggestion_list_item_new:Class;
        [Embed(source="binaryData/HabboCatalogCom_spaces.bin", mimeType="application/octet-stream")]
        public static const spaces:Class;
        [Embed(source="binaryData/HabboCatalogCom_purchaseButtons.bin", mimeType="application/octet-stream")]
        public static const purchaseButtons:Class;
        [Embed(source="binaryData/HabboCatalogCom_purchaseWidgetBuyVipStub.bin", mimeType="application/octet-stream")]
        public static const purchaseWidgetBuyVipStub:Class;
        [Embed(source="binaryData/HabboCatalogCom_guildSelectorWidget.bin", mimeType="application/octet-stream")]
        public static const guildSelectorWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_guildBadgeViewWidget.bin", mimeType="application/octet-stream")]
        public static const guildBadgeViewWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_guild_selector_widget_item.bin", mimeType="application/octet-stream")]
        public static const guild_selector_widget_item:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_direct_buy_xml.bin", mimeType="application/octet-stream")]
        public static const club_direct_buy_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_club_direct_buy_success_xml.bin", mimeType="application/octet-stream")]
        public static const club_direct_buy_success_xml:Class;
        [Embed(source="images/HabboCatalogCom_catalog_icon_badge_included.png")]
        public static const catalog_icon_badge_included:Class;
        [Embed(source="images/HabboCatalogCom_catalog_icon_ninja_effect_included.png")]
        public static const catalog_icon_ninja_effect_included:Class;
        [Embed(source="binaryData/HabboCatalogCom_badgeDisplayWidget.bin", mimeType="application/octet-stream")]
        public static const badgeDisplayWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_spinnerWidget.bin", mimeType="application/octet-stream")]
        public static const spinnerWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_catalog_volter.bin", mimeType="application/octet-stream")]
        public static const catalog_volter:Class;
        [Embed(source="binaryData/HabboCatalogCom_catalog_ubuntu.bin", mimeType="application/octet-stream")]
        public static const catalog_ubuntu:Class;
        [Embed(source="binaryData/HabboCatalogCom_catalog_ubuntu_with_tabs.bin", mimeType="application/octet-stream")]
        public static const catalog_ubuntu_with_tabs:Class;
        [Embed(source="binaryData/HabboCatalogCom_discountPromoItem.bin", mimeType="application/octet-stream")]
        public static const discountPromoItem:Class;
        [Embed(source="binaryData/HabboCatalogCom_discountValueItem.bin", mimeType="application/octet-stream")]
        public static const discountValueItem:Class;
        [Embed(source="binaryData/HabboCatalogCom_totalPriceWidget.bin", mimeType="application/octet-stream")]
        public static const totalPriceWidget:Class;
        [Embed(source="images/HabboCatalogCom_bundle_discount_star_sheet.png")]
        public static const bundle_discount_star_sheet:Class;
        [Embed(source="images/HabboCatalogCom_thumb_up.png")]
        public static const thumb_up:Class;
        [Embed(source="binaryData/HabboCatalogCom_bundlesInfoItem.bin", mimeType="application/octet-stream")]
        public static const bundlesInfoItem:Class;
        [Embed(source="binaryData/HabboCatalogCom_soldLtdItemsWidget.bin", mimeType="application/octet-stream")]
        public static const soldLtdItemsWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbicon_view_xml.bin", mimeType="application/octet-stream")]
        public static var habbicon_view_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_habbicon_purchase_confirmation_xml.bin", mimeType="application/octet-stream")]
        public static var habbicon_purchase_confirmation_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_rent_confirmation.bin", mimeType="application/octet-stream")]
        public static var rent_confirmation:Class;
        [Embed(source="binaryData/HabboCatalogCom_badgeGridItem.bin", mimeType="application/octet-stream")]
        public static const badgeGridItem:Class;
        [Embed(source="binaryData/HabboCatalogCom_activityPointDisplayWidget.bin", mimeType="application/octet-stream")]
        public static const activityPointDisplayWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_addOnBadgeViewWidget.bin", mimeType="application/octet-stream")]
        public static const addOnBadgeViewWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_builderWidget.bin", mimeType="application/octet-stream")]
        public static const builderWidget:Class;
        [Embed(source="binaryData/HabboCatalogCom_targeted_offer_dialog_xml.bin", mimeType="application/octet-stream")]
        public static const targeted_offer_dialog_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_targeted_offer_dialog_variation_xml.bin", mimeType="application/octet-stream")]
        public static const targeted_offer_dialog_variation_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_targeted_offer_minimized_xml.bin", mimeType="application/octet-stream")]
        public static const targeted_offer_minimized_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_targeted_offer_purchase_confirmation_xml.bin", mimeType="application/octet-stream")]
        public static const targeted_offer_purchase_confirmation_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_targeted_offer_habbomall_xml.bin", mimeType="application/octet-stream")]
        public static const targeted_offer_habbomall_xml:Class;
        [Embed(source="binaryData/HabboCatalogCom_offer_center_xml.bin", mimeType="application/octet-stream")]
        public static var offer_center_xml:Class;
		[Embed(source="binaryData/HabboCatalogCom_charge_confirmation.bin", mimeType="application/octet-stream")]
		public static const charge_confirmation:Class;
    }
}
