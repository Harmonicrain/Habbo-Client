# Directory Structure

The Habbo client codebase follows a well-organized package structure based on the Sulake core framework. This document details the directory organization and the patterns used.

## Top-Level Directory Layout

```
habbo-client-clean/
├── src/           - Main source code (9,800+ ActionScript files)
├── bin/           - Compiled SWF and runtime files
├── docs/          - Documentation (this wiki)
├── tools/         - TypeScript build and maintenance CLI
├── .vscode/       - IDE settings
├── .git/          - Git repository
├── asconfig.json  - Flash compiler configuration
├── package.json   - TypeScript toolchain scripts
├── README.md      - Project readme
└── CLIENT-SERVER-ARCHITECTURE.md - Protocol documentation
```

## Source Code Organization

```
src/
├── Root Level Files
│   ├── Habbo.as                 - Main application class
│   ├── HabboMain.as            - Bootstrap & component init
│   ├── HabboLoadingScreen.as   - Loading UI
│   ├── ClientEnum.as           - Tracking constants
│   ├── Logger.as               - Logging utility
│   └── HabboWindowManagerCom.as
│
├── com/sulake/                 - Core + Habbo packages
│   ├── core/                   - Sulake framework
│   ├── habbo/                  - Habbo-specific code
│   ├── bootstrap/              - Component factories
│   ├── room/                   - Room rendering
│   ├── iid/                    - Interface IDs
│   └── habboclient/            - External variables
│
├── onBoardingHc/               - New user onboarding
├── snowwar/                    - SnowStorm game
├── fonts/                      - Font assets
├── deng/                       - ZIP library (FZip)
├── org/                        - Third-party (VPAID video)
└── [other directories]
```

## Package Hierarchy

### com.sulake.core (347 files)

The core framework providing infrastructure:

| Package | Files | Purpose |
|---------|-------|---------|
| `core/runtime/` | 32 | Component system, ICore |
| `core/window/` | 241 | Windowing framework |
| `core/communication/` | 47 | Socket, messages |
| `core/assets/` | 15 | Asset library |
| `core/utils/` | 12 | Utilities |

### com.sulake.habbo (3,556 files)

Main Habbo-specific implementation:

| Package | Files | Purpose |
|---------|-------|---------|
| `habbo/communication/` | 1,585 | Networking, protocol |
| `habbo/ui/` | 388 | Room UI widgets |
| `habbo/room/` | 306 | Room engine |
| `habbo/avatar/` | 131 | Avatar rendering |
| `habbo/catalog/` | 195 | Shop system |
| `habbo/navigator/` | 83 | Room browser |
| `habbo/inventory/` | 50 | Inventory |
| `habbo/messenger/` | 42 | Chat/messaging |
| `habbo/friendlist/` | 31 | Friends UI |
| `habbo/toolbar/` | 37 | Main toolbar |
| `habbo/window/` | 144 | UI framework |
| `habbo/notifications/` | 32 | Notifications |
| `habbo/groups/` | 21 | Guilds |
| `habbo/quest/` | 35 | Achievements |
| `habbo/session/` | 28 | User session |
| `habbo/configuration/` | 8 | Client config |
| `habbo/tracking/` | 15 | Analytics |
| `habbo/sound/` | 16 | Audio |
| `habbo/moderation/` | 38 | Moderation |
| `habbo/admanager/` | 12 | Advertising |
| `habbo/help/` | 18 | Help system |
| `habbo/freeflowchat/` | 32 | Chat improvements |
| `habbo/games/` | 14 | Games |
| `habbo/phonenumber/` | 12 | Phone verification |
| `habbo/nux/` | 8 | New user flow |

### com.sulake.bootstrap (35 files)

Component factory classes for lazy initialization:

```
HabboCommunicationManagerBootstrap
HabboConfigurationManagerBootstrap
RoomEngineBootstrap
HabboWindowManagerComponentBootstrap
HabboInventoryManagerBootstrap
HabboCatalogManagerBootstrap
...
```

Each bootstrap extends the actual implementation class and is registered in `HabboMain.prepareCore()`.

### com.sulake.iid (46 files)

Interface Identifier classes for dependency injection:

```
IIDCoreCommunicationManager
IIDHabboConfigurationManager
IIDHabboWindowManager
IIDHabboInventoryManager
IIDRoomEngine
...
```

## Bootstrap System Pattern

### Component Registration Flow

```
1. HabboMain.prepareCore() calls:
   _core.prepareComponent(HabboCommunicationCom)

2. HabboCommunicationCom (src/HabboCommunicationCom.as):
   public static var requiredClasses:Array = new Array(
       HabboCommunicationManagerBootstrap,
       IIDHabboCommunicationManager
   );

3. Core instantiates HabboCommunicationManagerBootstrap
   (which extends HabboCommunicationManager)

4. Component registers its IID interface for other components to request
```

### Bootstrap Class Example

```actionscript
// src/com/sulake/bootstrap/HabboCommunicationManagerBootstrap.as
package com.sulake.bootstrap {
    import com.sulake.habbo.communication.HabboCommunicationManager;

    public class HabboCommunicationManagerBootstrap 
        extends HabboCommunicationManager { }
}
```

## File Naming Conventions

### Prefix Patterns

| Prefix | Meaning | Example |
|--------|---------|---------|
| `Habbo*` | Main entry point for a feature | `HabboCatalog.as` |
| `I*` | Interface | `IHabboWindowManager.as` |
| `IID*` | Interface ID for DI | `IIDHabboConfigurationManager.as` |
| `_Str_*` | Obfuscated (should be renamed) | `_Str_18533` |
| `_SafeStr_*` | Safe string identifier | Used in message IDs |

### Message Patterns

| Pattern | Type | Location |
|---------|------|----------|
| `*MessageComposer` | Outgoing packet | `communication/messages/outgoing/` |
| `*MessageEvent` | Incoming packet | `communication/messages/incoming/` |
| `*MessageParser` | Data parser | `communication/messages/parser/` |

### Widget Patterns

| Pattern | Type |
|---------|------|
| `*Widget` | Room/in-room UI element |
| `*WidgetHandler` | Widget event handler |
| `*Controller` | UI controller |
| `*View` | UI view |

## Communication Package Structure

```
com/sulake/habbo/communication/
├── HabboCommunicationManager.as    - Main manager
├── HabboMessages.as               - Message ID mappings
├── encryption/
│   ├── ArcFour.as                 - RC4 cipher
│   └── DiffieHellman.as           - Key exchange
├── messages/
│   ├── outgoing/                  - 500+ composers
│   │   ├── handshake/
│   │   ├── room/
│   │   ├── catalog/
│   │   ├── friendlist/
│   │   └── ...
│   ├── incoming/                  - 470+ events
│   │   ├── handshake/
│   │   ├── room/
│   │   └── ...
│   └── parser/                    - Parsers
└── enums/
    └── HabboConnectionType.as
```

## Room Package Structure

```
com/sulake/habbo/room/
├── RoomEngine.as                  - Main entry point
├── RoomContentLoader.as           - Asset loading
├── RoomObjectLogicComponent.as    - Object logic factory
├── RoomObjectEventHandler.as      - Mouse events
├── object/
│   ├── logic/                     - 80+ furniture logic types
│   │   ├── FurnitureLogic.as
│   │   ├── FurnitureDiceLogic.as
│   │   └── ...
│   └── visualization/
│       ├── FurnitureVisualization.as
│       ├── AvatarVisualization.as
│       └── room/
│           └── RoomVisualization.as
├── utils/
│   ├── RoomCamera.as
│   ├── FurniStackingHeightMap.as
│   └── TileObjectMap.as
└── message/
    └── RoomMessageHandler.as
```

## UI Package Structure

```
com/sulake/habbo/window/
├── HabboWindowManagerComponent.as - Window system entry
├── IHabboWindowManager.as        - Interface
├── widgets/                      - Reusable widgets
│   ├── AvatarImageWidget.as
│   ├── BadgeImageWidget.as
│   └── ...
├── theme/                       - Theming
└── utils/                       - Dialogs

com/sulake/habbo/ui/
├── widget/
│   ├── RoomWidgetBase.as
│   ├── RoomChatWidget.as
│   ├── InfoStandWidget.as
│   └── furniture/
│       ├── FurnitureContextMenuWidget.as
│       └── ...
└── handler/
    ├── RoomWidgetBaseHandler.as
    ├── RoomChatHandler.as
    └── ...
```

## Key Files Reference

| File | Purpose |
|------|---------|
| `src/HabboMain.as` | Component registration |
| `src/Habbo.as` | Main application |
| `src/com/sulake/core/runtime/Component.as` | Base component |
| `src/com/sulake/habbo/communication/HabboCommunicationManager.as` | Network |
| `src/com/sulake/habbo/room/RoomEngine.as` | Room engine |
| `src/com/sulake/habbo/avatar/AvatarRenderManager.as` | Avatar rendering |
| `src/com/sulake/habbo/window/HabboWindowManagerComponent.as` | UI windows |

## Next Steps

- [Application Lifecycle](Architecture/Application-Lifecycle) - Boot sequence
- [Component Model](Architecture/Component-Model) - Framework details
- [Networking](Core-Systems/Networking) - Protocol and encryption
