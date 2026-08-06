package com.sulake.habbo.roomevents
{
    public class WiredCapabilityCodes
    {
        public static const PROTOCOL_REVISION:int = 1;

        public static const PROTOCOL:int = 1 << 0;
        public static const ADDONS:int = 1 << 1;
        public static const VARIABLES:int = 1 << 2;
        public static const VARIABLE_SYNC:int = 1 << 3;
        public static const SIGNALS:int = 1 << 4;
        public static const REMOTE_SELECTOR:int = 1 << 5;
        public static const WIRED_MENU:int = 1 << 6;
        public static const MENU_INSPECTION:int = 1 << 7;
        public static const MENU_LOGS:int = 1 << 8;
        public static const MENU_SETTINGS:int = 1 << 9;
        public static const MENU_VARIABLES:int = 1 << 10;
        public static const MENU_CHESTS:int = 1 << 11;
        public static const ENVIRONMENT_V2:int = 1 << 12;
        public static const CLICK_SETTINGS_V2:int = 1 << 13;
        public static const WIRED_MOVEMENTS:int = 1 << 14;
        public static const CREATOR_TOOLS:int = 1 << 15;
        public static const CHESTS:int = 1 << 16;
        public static const CHEST_WIRED:int = 1 << 17;
        /** Wired trading contracts require their own server context and item-type catalog. */
        public static const CONTRACTS:int = 1 << 18;

        public static const ALL:int = (1 << 19) - 1;

        /*
         * Bits the AIR client can actually render, configure and save today.
         *
         * This is deliberately not a localhost override: WiredCapabilities
         * still intersects this mask with the server response and the current
         * room mask before exposing an editor.  It is only the client's honest
         * side of capability negotiation, so a legacy/no-response server keeps
         * every Wired 2.0 editor unavailable without affecting legacy Wired.
         *
         * Creator tools remain out because July AIR does not expose that
         * subsystem. Chests, chest Wired, contracts and the chest menu are
         * compiled together so their dependency chain cannot be partially
         * advertised.
         */
        public static const COMPILED_MASK:int = PROTOCOL
            | ADDONS
            | VARIABLES
            | VARIABLE_SYNC
            | SIGNALS
            | REMOTE_SELECTOR
            | WIRED_MENU
            | MENU_INSPECTION
            | MENU_LOGS
            | MENU_SETTINGS
            | MENU_VARIABLES
            | MENU_CHESTS
            | ENVIRONMENT_V2
            | CLICK_SETTINGS_V2
            | WIRED_MOVEMENTS
            | CHESTS
            | CHEST_WIRED
            | CONTRACTS;

        public static const PROTOCOL_ENABLED:String = "wired2.protocol.enabled";
        public static const ADDONS_ENABLED:String = "wired2.addons.enabled";
        public static const VARIABLES_ENABLED:String = "wired2.variables.enabled";
        public static const VARIABLE_SYNC_ENABLED:String = "wired2.variable_sync.enabled";
        public static const SIGNALS_ENABLED:String = "wired2.signals.enabled";
        public static const REMOTE_SELECTOR_ENABLED:String = "wired2.remote_selector.enabled";
        public static const WIRED_MENU_ENABLED:String = "wired2.menu.enabled";
        public static const MENU_INSPECTION_ENABLED:String = "wired2.menu.inspection.enabled";
        public static const MENU_LOGS_ENABLED:String = "wired2.menu.logs.enabled";
        public static const MENU_SETTINGS_ENABLED:String = "wired2.menu.settings.enabled";
        public static const MENU_VARIABLES_ENABLED:String = "wired2.menu.variables.enabled";
        public static const MENU_CHESTS_ENABLED:String = "wired2.menu.chests.enabled";
        public static const ENVIRONMENT_V2_ENABLED:String = "wired2.environment.enabled";
        public static const CLICK_SETTINGS_V2_ENABLED:String = "wired2.click_settings.enabled";
        public static const WIRED_MOVEMENTS_ENABLED:String = "wired2.movements.enabled";
        public static const CREATOR_TOOLS_ENABLED:String = "wired2.creator_tools.enabled";
        public static const CHESTS_ENABLED:String = "wired2.chests.enabled";
        public static const CHEST_WIRED_ENABLED:String = "wired2.chest_wired.enabled";
        public static const CONTRACTS_ENABLED:String = "wired2.contracts.enabled";
    }
}
