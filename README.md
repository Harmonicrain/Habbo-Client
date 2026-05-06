# habbo-client-cc

A cleaned and maintained version of the classic Habbo Flash client (PRODUCTION-201611291003-338511768), written in ActionScript 3. This client is designed to work with compatible Habbo server emulators.

> **Note:** This is legacy software originally developed by Sulake. It uses Flash Player technology and contains proprietary assets. This project is intended for educational purposes and retro server operators.

---

## Table of Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Features](#features)
- [Architecture](#architecture)
- [Protocol](#protocol)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

The Habbo client is a large-scale multiplayer game client built on a component-based architecture using the Sulake core framework. It handles:

- Real-time multiplayer room interactions
- Avatar rendering and customization
- Furniture placement and interactions
- Inventory management
- Catalog/shop system
- Navigator (room browser)
- Messenger (chat and friends)
- Groups and guilds
- Achievements and quests

This repository contains a cleaned version of the original Habbo Flash client, with documentation for understanding its architecture and protocol.

---

## Technology Stack

| Component | Technology |
|-----------|------------|
| **Language** | ActionScript 3 |
| **Runtime** | Flash Player 25 (legacy) |
| **Framework** | Sulake Core (component-based) |
| **Protocol** | Binary TCP with EvaWireFormat framing |
| **Encryption** | RC4 stream cipher with Diffie-Hellman key exchange |
| **Rendering** | Custom isometric sprite renderer |

```
┌─────────────────────────────────────────────────────────────┐
│                      BROWSER / FLASH PLAYER                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  habbo-client-cc (ActionScript 3)                     │  │
│  │  ├─ HabboMain.as          Entry point & bootstrap     │  │
│  │  ├─ Habbo.as              Main application controller │  │
│  │  ├─ com/sulake/core/       Core framework             │  │
│  │  │   └─ communication/     Socket, encryption, codecs  │  │
│  │  └─ com/sulake/habbo/      Game modules               │  │
│  │      ├─ communication/   Protocol messages           │  │
│  │      ├─ room/             Room engine & rendering     │  │
│  │      ├─ avatar/           Figure rendering            │  │
│  │      ├─ catalog/          Shop UI                     │  │
│  │      ├─ inventory/        Furniture inventory         │  │
│  │      ├─ navigator/         Room browser                │  │
│  │      ├─ messenger/        Chat & friends              │  │
│  │      └─ [20+ subsystems]                              │  │
│  └───────────────────────────────────────────────────────┘  │
│                           │ TCP Socket                       │
└───────────────────────────┼─────────────────────────────────┘
```

---

## Features

### Core Systems

- **Room Engine** — Isometric 2.5D room rendering with furniture and avatar display
- **Avatar System** — Figure parsing, avatar rendering, animations, and actions
- **Furniture System** — Floor and wall items with interaction types (rollers, teleporters, dice, etc.)
- **Networking** — TCP socket connection with binary protocol

### User Interface

- **Window Manager** — Component-based UI system with XML layouts
- **Inventory** — Furniture items, trading, badges
- **Catalog** — Product display, purchasing, currency handling
- **Navigator** — Room search, categories, favorites
- **Messenger** — Chat, friend list, private messaging
- **Quest Engine** — Achievements and daily quests

### Protocol & Security

- **EvaWireFormat** — Binary message framing (4-byte length, 2-byte header)
- **RC4 Encryption** — Stream cipher for encrypted communication
- **Diffie-Hellman** — Key exchange for session encryption
- **RSA** — Authentication of DH parameters
- **500+ Packet Types** — Full client-server message system

---

## Architecture

The client uses a dependency injection pattern through the Sulake core framework:

```actionscript
// Example: Component declaration
override protected function get dependencies():Vector.<ComponentDependency>
{
    return (super.dependencies.concat(new <ComponentDependency>[
        new ComponentDependency(new IIDHabboConfigurationManager(), null, false, [
            { "type": Event.COMPLETE, "callback": this.onConfigurationComplete }
        ])
    ]));
}
```

### Key Subsystems

| Subsystem | Entry Point | Purpose |
|-----------|-------------|---------|
| **Communication** | `HabboCommunicationManager` | TCP connection, encryption, message routing |
| **Room Engine** | `RoomEngine` | Room rendering, object management, interactions |
| **Avatar System** | `AvatarRenderManager` | Figure parsing, avatar rendering, animations |
| **Window Manager** | `HabboWindowManagerComponent` | UI window creation, widget management |
| **Inventory** | `HabboInventory` | Furniture items, trading, badges |
| **Catalog** | `HabboCatalog` | Product display, purchasing |
| **Navigator** | `HabboNavigator` | Room search, categories |
| **Messenger** | `HabboMessenger` | Chat, friend messages |

### Rendering Layers

The room rendering system uses a layered approach:

```
┌─────────────────────────────────────────┐
│         RoomSpriteCanvas (UI)           │  ← Top layer (chat, cursors)
├─────────────────────────────────────────┤
│         RoomObjectLayer (Objects)       │  ← Avatars, furniture
├─────────────────────────────────────────┤
│         RoomVisualization (Room)        │  ← Floor, walls, masks
└─────────────────────────────────────────┘
```

---

## Protocol

### Connection Lifecycle

1. **TCP Connection** — Client connects to server via socket
2. **Flash Policy** — Legacy policy file exchange (if required)
3. **Handshake** — Diffie-Hellman key exchange with RC4 encryption
4. **Authentication** — SSO token verification
5. **Session** — Full client-server interaction

### Message Format

Every message on the wire uses EvaWireFormat:

```
┌──────────────┬──────────────┬──────────────────────────┐
│ Length (4B)  │ Header (2B)  │ Body (variable)           │
│ big-endian   │ big-endian   │                          │
│ int32        │ uint16       │ type-specific fields     │
└──────────────┴──────────────┴──────────────────────────┘
```

| Type    | Wire Size | Encoding |
|---------|-----------|----------|
| int     | 4 bytes   | Big-endian signed 32-bit |
| short   | 2 bytes   | Big-endian signed 16-bit |
| boolean | 1 byte    | `0x00` = false, `0x01` = true |
| string  | 2 + N     | 2-byte UTF-8 length prefix, then N bytes |
| byte[]  | 4 + N     | 4-byte length prefix, then N raw bytes |

### Encryption Flow

```
Client                                        Server
  │                                              │
  │  ── ClientHello (unencrypted) ──────────────▶│
  │                                              │
  │  ◀── InitDiffieHandshake ────────────────────│  RSA-signed DH params
  │                                              │
  │  RSA.verify(prime), RSA.verify(generator)    │
  │  DH.init(privateKey), pubKey = g^priv mod n  │
  │                                              │
  │  ── CompleteDiffieHandshake ────────────────▶│
  │                                              │
  │  ◀── CompleteDiffieHandshake ────────────────│
  │                                              │
  │  RC4(out).init(sharedKey)                    │
  │  RC4(in).init(sharedKey)                     │
  │                                              │
  │  ═══ ALL FRAMES NOW ENCRYPTED ═══            │
```

---

## Getting Started

### Prerequisites

- **Flash Player 25** or compatible runtime
- **Habbo Server Emulator** (compatible with this client revision)
- **ActionScript 3 IDE** (FlashDevelop, IntelliJ IDEA, etc.) for development

### Building

This is an ActionScript 3 project. The repository tooling is now managed through a TypeScript CLI:

```bash
npm install
npm run build:swf
```

The build command uses `asconfig.json`, `FLEX_HOME`, `JAVA_HOME`, and the Flex SDK `mxmlc.jar`. It writes the latest build to `bin/Habbo.swf` and keeps timestamped `PRODUCTION-*.swf` archives in `bin/`.

Tooling helpers are available through:

```bash
npm run tool -- --help
```

### Configuration

The client receives connection parameters via FlashVars or the SWF loader configuration:

```
connection.info.host = "127.0.0.1"
connection.info.port = "30000,3000,30001"  // fallback ports
```

---

## Project Structure

```
habbo-client-cc/
├── src/
│   ├── com/sulake/
│   │   ├── core/              # Sulake framework
│   │   │   ├── communication/  # Socket, encryption, messages
│   │   │   ├── window/          # Window system
│   │   │   ├── assets/          # Asset library
│   │   │   └── utils/           # Utilities
│   │   └── habbo/             # Habbo-specific modules
│   │       ├── communication/  # Protocol, messages
│   │       ├── room/           # Room engine
│   │       ├── avatar/          # Avatar rendering
│   │       ├── inventory/       # Inventory
│   │       ├── catalog/         # Catalog
│   │       ├── navigator/       # Navigator
│   │       ├── messenger/       # Messenger
│   │       ├── window/          # UI system
│   │       └── [20+ more]
│   ├── HabboMain.as           # Bootstrap
│   └── Habbo.as               # Main controller
├── docs/                      # Detailed documentation
│   ├── Architecture/         # System architecture
│   ├── Core-Systems/         # Core system docs
│   ├── UI-Framework/         # UI framework
│   ├── Features/             # Feature documentation
│   ├── Protocol/             # Protocol docs
│   └── Data-Flows/           # Data flow diagrams
├── LICENSE.md                # License file
└── README.md                 # This file
```

### Key Entry Points

| Class | File | Purpose |
|-------|------|---------|
| `HabboMain` | `src/HabboMain.as` | Bootstrap and component initialization |
| `Habbo` | `src/Habbo.as` | Main application controller |
| `HabboCommunicationManager` | `src/com/sulake/habbo/communication/HabboCommunicationManager.as` | Connection management |
| `RoomEngine` | `src/com/sulake/habbo/room/RoomEngine.as` | Room rendering engine |
| `AvatarRenderManager` | `src/com/sulake/habbo/avatar/AvatarRenderManager.as` | Avatar rendering |
| `HabboWindowManagerComponent` | `src/com/sulake/habbo/window/HabboWindowManagerComponent.as` | UI window management |

---

## Documentation

This repository contains extensive documentation in the `docs/` folder:

### Architecture
- [Architecture Overview](docs/Architecture/Overview.md) — High-level system summary
- [Application Lifecycle](docs/Architecture/Application-Lifecycle.md) — Boot sequence and initialization
- [Component Model](docs/Architecture/Component-Model.md) — Sulake core framework
- [Directory Structure](docs/Architecture/Directory-Structure.md) — Package organization

### Core Systems
- [Room Engine Architecture](docs/Core-Systems/Room-Engine/Architecture.md) — Overview and components
- [Avatar Rendering](docs/Core-Systems/Avatar-System/Rendering.md) — AvatarImage, rendering pipeline
- [Furniture System](docs/Core-Systems/Furniture-System/Architecture.md) — Furniture logic and visualization
- [Networking](docs/Core-Systems/Networking.md) — Connection management, socket handling

### Protocol
- [Wire Format](docs/Protocol/Wire-Format.md) — EvaWireFormat binary framing
- [Message Pattern](docs/Protocol/Message-Pattern.md) — Message structure and headers
- [Encryption](docs/Protocol/Encryption.md) — RC4 and Diffie-Hellman
- [Packet Reference](docs/Protocol/Packet-Reference.md) — Packet IDs and mappings

### Features
- [Inventory](docs/Features/Inventory.md) — Furniture inventory management
- [Catalog](docs/Features/Catalog.md) — Shop system
- [Navigator](docs/Features/Navigator.md) — Room browser
- [Messenger](docs/Features/Messenger.md) — Chat and messaging

### UI Framework
- [Window Manager](docs/UI-Framework/Window-Manager.md) — Window hierarchy and management
- [Widget System](docs/UI-Framework/Widget-System.md) — Room widgets and UI widgets
- [Theming](docs/UI-Framework/Skinning-Theming.md) — Themes and XML layouts

---

## Compatibility

This client is designed to work with:

- [habbo-server-cc](https://github.com/habbo-cc/habbo-server-cc) — Compatible server emulator
- Other compatible Habbo server emulators using the same protocol version

### Requirements

- Protocol version: `PRODUCTION-201611291003-338511768`
- Wire format: EvaWireFormat
- Encryption: RC4 + Diffie-Hellman (configurable)
- Packet IDs: ~500 message types

---

## Contributing

When contributing to this project:

1. Follow the coding conventions in `docs/Development/Coding-Conventions.md`
2. Use ASCII diagrams for visual explanations
3. Include code examples from the actual codebase
4. Cross-reference related documentation pages
5. Test changes with a compatible server emulator

---

## License

See [LICENSE.md](LICENSE.md) for details.

---

## Resources

- [Sulake Documentation Wiki](docs/Home.md)
- [Client-Server Architecture Guide](CLIENT-SERVER-ARCHITECTURE.md)
- [Packet Reference](docs/Protocol/Packet-Reference.md)
- [Encryption Details](docs/Protocol/Encryption.md)

---

*This is a legacy project maintained for educational purposes and retro Habbo server operators.*