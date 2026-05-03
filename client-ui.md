# Habbo Client — UI Architecture & Porting Reference

> **Audience.** A developer who wants to re-implement this client's UI on a different platform (HTML5/PixiJS, Unity, native, etc.). This document is descriptive: it explains *how the AS3 client puts its UI on screen*, where every piece lives, and the contracts a port must satisfy. The 3-D **room renderer** (isometric tiles, furniture, avatars) is **out of scope** — see `docs/Architecture/` and the `*RoomEngineCom` / `RoomSpriteRendererLib` / `RoomManagerLib` / `HabboAvatarRenderLib` libs for that.
>
> **Companion docs.** This file consolidates and extends `docs/UI-Framework/{Window-Manager,Widget-System,Event-Handling,Skinning-Theming}.md`. Where those existing docs go deeper on a specific topic they are linked.

---

## Table of contents

1. [Executive summary](#1-executive-summary)
2. [The `bin/` directory and build output](#2-the-bin-directory-and-build-output)
3. [Boot sequence](#3-boot-sequence)
4. [The component model (`SimpleApplication` / `Component` / Bootstrap)](#4-the-component-model)
5. [Window framework — `com.sulake.core.window`](#5-window-framework)
6. [Skinning & theming](#6-skinning--theming)
7. [Event handling](#7-event-handling)
8. [The `binaryData/` manifest system — *the key porting concept*](#8-the-binarydata-manifest-system)
9. [Image resolution (embedded vs. remote)](#9-image-resolution)
10. [The Habbo window manager (`HabboWindowManagerCom`)](#10-the-habbo-window-manager)
11. [Catalog of feature components — every UI surface in the client](#11-catalog-of-feature-components)
12. [Room widget vs. window — the second UI tree](#12-room-widget-vs-window)
13. [Localization](#13-localization)
14. [End-to-end traces](#14-end-to-end-traces)
15. [Porting checklist](#15-porting-checklist)

---

## 1. Executive summary

The Habbo client is a single Flash/AS3 SWF (`bin/Habbo.swf`) that hosts ~35 logically-isolated **components** (the `Habbo*Com` and `*Lib` classes in [src/](src/)). Components are wired together at startup by a tiny dependency-injection runtime (`com.sulake.core.runtime`). Two-thirds of those components own a slice of the UI; the rest are infrastructure (network, localization, configuration, sound, tracking, room engine, etc.).

The UI itself is **XML-driven, asset-table-resolved, and message-fed**:

| Concern | Mechanism | Where it lives |
|---|---|---|
| What windows look like | XML layouts | embedded in each component as ByteArrayAssets ([src/binaryData/](src/binaryData/)) |
| How XML becomes a tree of widgets | `WindowParser` → `WindowFactory` → `WindowController` instances | [com/sulake/core/window/](src/com/sulake/core/window/) |
| What graphics fill those widgets | `SkinContainer` + `ISkinRenderer` (bitmap, fill, shape, text) | [com/sulake/core/window/graphics/](src/com/sulake/core/window/graphics/) |
| Where bitmaps come from | `IAssetLibrary` per component, looked up by name | [com/sulake/core/assets/](src/com/sulake/core/assets/) |
| Where remote images come from | `ResourceManager.retrieveAsset()` interpolates `${config.key}` placeholders against `external_variables.txt` | [com/sulake/habbo/window/ResourceManager.as](src/com/sulake/habbo/window/ResourceManager.as), [com/sulake/habbo/configuration/HabboConfigurationManager.as](src/com/sulake/habbo/configuration/HabboConfigurationManager.as) |
| How user input reaches windows | `MouseEventProcessor` hit-tests the window tree, dispatches pooled `WindowMouseEvent`s | [com/sulake/core/window/events/](src/com/sulake/core/window/events/) |
| How the network drives the UI | Each component subscribes to typed message events (`*Event`/`*Composer`/`*Parser`) on `IHabboCommunicationManager` | per-component `events/incoming/` folders |

**The five concrete things a port must replicate:**

1. **Component registry & lifecycle.** A way to register N components, declare their dependencies, resolve them in order, and call `init()`.
2. **Window/widget tree from XML.** A factory that turns each component's embedded XML into a tree of typed view objects (button, frame, label, region, item-list, …) with state-aware skinning.
3. **Asset library + manifest binary format.** Each component embeds a `*_manifest.bin` listing its assets (XML + PNG); each asset is itself an embedded `[Embed]` ByteArrayAsset class. Lookup by *logical name*.
4. **External variables–driven URL resolution.** Window XMLs reference assets as `${image.library.url}foo.png`; the runtime interpolates those against a flat string-map populated from `external_variables.txt`/JSON downloaded at startup.
5. **Message-driven UI updates.** Every panel listens for typed events and mutates its window tree; there is **no central UI store**.

---

## 2. The `bin/` directory and build output

### Build configuration

[asconfig.json](asconfig.json) — a single-target Flex compile:

```json
"compilerOptions": {
  "source-path": ["src"],
  "output": "bin/CoompileHabbo.swf",
  "default-frame-rate": 30,
  "default-size": { "width": 800, "height": 600 },
  "target-player": "25.0",
  ...
},
"files": ["src/Habbo.as"]
```

- **Output file is `bin/CoompileHabbo.swf`** — the typo is intentional in the build script and is renamed/copied to `Habbo.swf` (and timestamped `PRODUCTION-YYYYMMDDHHMM-NNN.swf`) by the publish step.
- **Single-file compilation.** Only `src/Habbo.as` is the entry point; AS3's automatic class resolution drags in all `Habbo*Com`, `*Lib`, `binaryData/*`, etc. **Components are NOT separate SWFs** — every UI feature ships inside this one ~5-11 MB file (`APPROXIMATE_SWF_SIZE = 11000000` in [Habbo.as:32](src/Habbo.as)).
- **Target = Flash Player 25.** The modern client runs the SWF on Ruffle (see recent commits `9ffe7d3df fix(ruffle):` etc.). A port should not assume a Flash runtime.

### Files in `bin/`

| File | Purpose |
|---|---|
| `Habbo.swf` | Published copy of `CoompileHabbo.swf` — the client. |
| `PRODUCTION-202604231802-678.swf` | Timestamped versioned release. |
| `expressInstall.swf` | Legacy Adobe Flash auto-installer SWF; loaded only if Flash is missing. |
| `index.html` | Page that embeds `Habbo.swf` via `swfobject` and feeds it flashvars. |
| `js/swfobject.js` | The classic Adobe SWF embedder. |

### What goes in (and what does NOT)

**Everything under `src/` is in the SWF**, including:

- All 35 `Habbo*Com.as` / `*Lib.as` component classes ([src/](src/)).
- All window XMLs and PNGs ([src/binaryData/](src/binaryData/) — 1055 `.as` wrappers and 284 `.bin` payloads).
- Avatar metadata XMLs (geometry, partsets, animation, figure) embedded in `HabboAvatarRenderLib`.
- Splash, fonts, and onboarding assets ([src/splash/](src/splash/), [src/fonts/](src/fonts/), [src/onBoardingHc*/](src/)).
- Third-party libraries vendored under [src/com/](src/com/) — `adobe`, `deng` (zip), `hurlant` (crypto), `org/`, `vimeo`, `apdevblog`, `probertson`.

**At runtime the client downloads:**

- `external_variables.txt` (or `.json`) — bootstrap config.
- `localization_xx_YY.xml` — localized strings.
- `hh_human_body.swf`, `hh_human_item.swf` — avatar vector assets ([HabboMain.as:111-118](src/HabboMain.as)).
- `figurepartlist.txt`, `HabboAvatarActions.xml`, effect maps — figure part data.
- Any number of remote PNGs/GIFs: badges, room thumbnails, catalogue art, group badges, giftcards, etc.

### The HTML host

[bin/index.html](bin/index.html) embeds the SWF via `swfobject` with a flashvars object that the client reads from `stage.loaderInfo.parameters` in [Habbo.as:79-96](src/Habbo.as):

| FlashVar | Used as |
|---|---|
| `connection.info.host` | Game socket host |
| `connection.info.port` | Game socket port (CSV list) |
| `url.prefix` | Site root (e.g. `https://www.habbo.com`); prepended to `flash_client_error` for crash reporting |
| `client.fatal.error.url` | Override for crash POST URL |
| `spaweb` | `"1"` if running inside the SPA web shell |
| `external.variables.txt` | URL of the bootstrap config (typically supplied via `external_variables.txt` itself once it loads, but the *initial* URL must come from flashvars or the embedded localization config) |

A port has to provide an equivalent shell that supplies these (or hard-codes them).

---

## 3. Boot sequence

[src/Habbo.as](src/Habbo.as) is the `MovieClip` AS3 entry. It reads flashvars, instantiates `HabboLoadingScreen`, and proceeds to construct `HabboMain`, which orchestrates the whole startup. The key method is [HabboMain.prepareCore()](src/HabboMain.as) at lines 102-156:

```
HabboLoadingScreen   // splash + progress bar
       │
HabboMain.prepareCore()
       │
       ├── Core.instantiate(stage, CORE_SETUP_FRAME_UPDATE_COMPLEX, errorLogger)
       │   ↳ creates the IoC root (com.sulake.core.runtime.Core)
       │
       ├── _core.prepareComponent(HabboTrackingLib)
       │
       ├── _core.readConfigDocument(<config>
       │       <asset-libraries>
       │           <library url="hh_human_body.swf"/>
       │           <library url="hh_human_item.swf"/>
       │       </asset-libraries>
       │   </config>, this)
       │   ↳ schedules the avatar-asset SWFs as background downloads
       │
       └── _core.prepareComponent(...) for each component, in dependency order:
            CoreCommunicationFrameworkLib
            HabboRoomObjectLogicLib
            HabboRoomObjectVisualizationLib
            RoomManagerLib
            RoomSpriteRendererLib
            HabboRoomSessionManagerLib
            HabboAvatarRenderLib
            HabboSessionDataManagerLib
            HabboConfigurationCom            ← downloads external_variables.txt
            HabboLocalizationCom             ← downloads localization XML
            HabboWindowManagerCom            ← embeds default skins/layouts
            HabboCommunicationCom            ← opens the game socket
            HabboCommunicationDemoCom
            HabboNavigatorCom
            HabboFriendListCom
            HabboMessengerCom
            HabboInventoryCom
            HabboToolbarCom
            HabboCatalogCom
            HabboRoomEngineCom
            HabboRoomUICom
            HabboAvatarEditorCom
            HabboNotificationsCom
            HabboHelpCom
            HabboAdManagerCom
            HabboModerationCom
            HabboUserDefinedRoomEventsCom
            HabboSoundManagerFlash10Com
            HabboQuestEngineCom
            HabboFriendBarCom
            HabboGroupsCom
            HabboGamesCom
            HabboFreeFlowChatCom
            HabboNewNavigatorCom
```

`prepareComponent()` *registers* a class; the core resolves dependencies and calls each component's bootstrap → `init()` once everything it depends on is live. The progress bar is driven by:

```
totalSteps = core.getNumberOfFilesPending() + core.getNumberOfFilesLoaded() + INIT_STEPS;
ratio     = CORE_RATIO + (completedInitSteps + loadedFiles) / totalSteps * (1 - CORE_RATIO);
loadingScreen._Str_774(ratio);   // de-obfuscated name was setProgress
```

[HabboMain.as:165-178](src/HabboMain.as).

### Ordering matters

Three components are *load-order-critical* and a port must keep them in this order:

1. **HabboConfigurationCom** must run before anything that interpolates URLs (i.e. before any UI that loads remote images).
2. **HabboLocalizationCom** must run before any text is shown.
3. **HabboWindowManagerCom** must run before any `Habbo*Com` that creates a window — its embedded skins (`habbo_skin_button_*_xml`, `habbo_skin_frame_*_xml`, `habbo_window_layout_*_xml`) are the *defaults* every other component renders against.

The remaining order is mostly dependency-driven (RoomEngine before RoomUI, Catalog before InfoStand uses it, Messenger before FriendBar references it, etc.), and the IoC system enforces it via `@ComponentDependency` annotations, so the linear list above is just the *registration* order — the actual init is topologically sorted.

---

## 4. The component model

### The class triple

Every UI subsystem is exactly three classes:

| Role | Class | Lives in |
|---|---|---|
| **Outer SWF entry** | `HabboXxxCom extends SimpleApplication` | [src/](src/) (e.g. [HabboCatalogCom.as](src/HabboCatalogCom.as)) |
| **DI bootstrap** | `HabboXxxBootstrap` | [src/com/sulake/habbo/.../](src/com/sulake/habbo/) |
| **Runtime singleton** | `HabboXxx extends Component` (sometimes `XxxManager`) | same package as bootstrap |

#### 4.1 The outer `*Com` class

A `HabboXxxCom` is mostly a **constant table**. It declares:

```actionscript
public class HabboCatalogCom extends SimpleApplication {
    public static var manifest:Class      = HabboCatalogCom_manifest;     // the manifest .bin
    public static var requiredClasses:Array = [HabboCatalogBootstrap, IIDHabboCatalog];

    // 50+ embedded XML layouts (window descriptions)
    public static var club_center_xml      :Class = HabboCatalogCom_club_center_xml;
    public static var purchase_confirmation:Class = HabboCatalogCom_purchase_confirmation;
    public static var layout_marketplace   :Class = HabboCatalogCom_layout_marketplace;
    ...

    // Embedded PNG icons / decorations
    public static var bot_thumb_bg         :Class = HabboCatalogCom_bot_thumb_bg;
    public static var ctlg_arrow_down      :Class = HabboCatalogCom_ctlg_arrow_down;
    ...
}
```

The `manifest` is the catalogue of these assets (see §8). `requiredClasses` is what `prepareComponent()` reads to know which bootstrap to register and which IID interface to expose.

**No code lives here.** The class is a static asset map and an entry-point marker.

#### 4.2 `HabboXxxBootstrap`

The bootstrap declares dependencies via metadata attributes that the IoC reads. Every bootstrap `extends ComponentDependency` and lists imports + `@ComponentDependency` annotations that name the IID interfaces it needs (e.g. `IIDHabboWindowManager`, `IIDHabboCommunicationManager`, `IIDHabboLocalizationManager`, `IIDHabboCatalog`). The DI system sets a private field on the manager for each one and finally calls `init()`.

#### 4.3 `HabboXxx` (the manager)

Concrete logic lives here. A typical manager:

- Stores its injected references (windowManager, communicationManager, localization, assetLibrary, etc.).
- Registers message listeners on the comm manager (e.g. `CatalogPagesListEvent`, `PurchaseOKMessageEvent`).
- Owns the views/controllers (`CatalogViewer`, `Purse`, `MarketPlace`, `RoomPreviewer` for catalog).
- Lazily creates windows on demand: most components don't build their UI at init; they wait for the user to open the panel or a server message to arrive.

#### 4.4 IID interfaces

Each component publishes its API via a single interface — for example `IIDHabboCatalog` is the lookup token, and the actual interface is `IHabboCatalog` (or similar). Other components ask the IoC for `IIDHabboCatalog` and receive a cross-component reference. This is the only way two components are allowed to talk.

**Porting note.** The IoC machinery is straightforward — it's a dictionary `Class → Component` plus a topological sort of `[ComponentDependency]` annotations. Replicating it in any language is trivial; the value is purely organizational.

---

## 5. Window framework

The framework lives under [src/com/sulake/core/window/](src/com/sulake/core/window/) and is exported by [CoreWindowFrameworkLib.as](src/CoreWindowFrameworkLib.as). It's an MVC system:

- **Model**: [WindowModel.as](src/com/sulake/core/window/WindowModel.as) holds raw state — position, size, color, blend, alpha, state flags, style flags, tags, params, caption.
- **Controller**: [WindowController.as](src/com/sulake/core/window/WindowController.as) extends `WindowModel`, adds parent/child wiring, the graphics context, the event dispatcher, and the XML-construction entry point `buildFromXML()`.
- **View**: rendered by `ISkinRenderer` implementations into a `BitmapData` per state (see §6).

### 5.1 Interfaces

| Interface | Purpose |
|---|---|
| `IWindow` ([IWindow.as](src/com/sulake/core/window/IWindow.as)) | Root window contract: positioning, visibility, state/style flags, event subscription, `invalidate()`, `buildFromXML()`. |
| `IWindowContainer` ([IWindowContainer.as](src/com/sulake/core/window/IWindowContainer.as)) | Adds children: `addChild`, `removeChild`, `getChildByName`, `getChildAt`, iteration, `groupChildrenByTag`. |
| `IWindowContext` ([IWindowContext.as](src/com/sulake/core/window/IWindowContext.as)) | The "world" a window lives in — provides asset library, factory, parser, theme, resource manager. Each component runs in its own context. |
| `IWindowFactory` ([IWindowFactory.as](src/com/sulake/core/window/IWindowFactory.as)) | `create(typeID, styleID)` produces a new `IWindow`; also supplies layout XML and default attributes per (type, style). |
| `ICoreWindowManager` ([ICoreWindowManager.as](src/com/sulake/core/window/ICoreWindowManager.as)) | Top-level manager: `create(name, typeID, styleID, ...)`, layer management, focus, dialogs. |

### 5.2 Window types — the widget catalogue

[com/sulake/core/window/enum/WindowType.as](src/com/sulake/core/window/enum/WindowType.as) enumerates ~80 `WINDOW_TYPE_*` `uint` constants. Highlights:

| Constant | Code | Use |
|---|---:|---|
| `WINDOW_TYPE_CONTAINER` | 4 | Generic group |
| `WINDOW_TYPE_REGION` | 5 | Logical sub-region (often clipped) |
| `WINDOW_TYPE_HEADER` | 6 | Title bar |
| `WINDOW_TYPE_TEXT` | 10 | Plain text |
| `WINDOW_TYPE_HTML` | 11 | HTML-flavored text |
| `WINDOW_TYPE_LABEL` | 12 | Single-line label |
| `WINDOW_TYPE_FORMATTED_TEXT` | 15 | Rich text |
| `WINDOW_TYPE_WIDGET` | 16 | Widget host (room widgets attach here) |
| `WINDOW_TYPE_BITMAP_WRAPPER` | 21 | Wraps a `BitmapData` |
| `WINDOW_TYPE_STATIC_BITMAP_WRAPPER` | 23 | Static (cached) bitmap |
| `WINDOW_TYPE_BORDER` / `_THIN` / `_THICK` | 30/31/32 | Decorative borders |
| `WINDOW_TYPE_FRAME` / `_THIN` / `_THICK` / `_NOTIFY` | 35/36/37/38 | Top-level frames (window chrome) |
| `WINDOW_TYPE_BUBBLE` + 4 pointer dirs | 45-49 | Speech bubbles / tooltips |
| `WINDOW_TYPE_ITEMLIST` (vertical/horizontal) | 50/51 | List of children, single axis |
| `WINDOW_TYPE_ITEMGRID` (vertical/horizontal) | 52/53/54 | Grid of children |
| `WINDOW_TYPE_SCROLLABLE_ITEMLIST*` | 55-57 | Scroll-clipped variants |
| `WINDOW_TYPE_BUTTON` (+8 variants) | 60-69 | Buttons; arrow buttons, group ends |
| `WINDOW_TYPE_CHECKBOX` / `_RADIOBUTTON` | 70/71 | Selection controls |
| `WINDOW_TYPE_CLOSEBUTTON` / `_MINIMIZEBOX` / `_MAXIMIZEBOX` / `_RESTOREBOX` | 72-75 | Frame chrome |
| `WINDOW_TYPE_DRAGBAR` | 76 | Drag handle |
| `WINDOW_TYPE_TEXTFIELD` / `_PASSWORD` | 77/78 | Text inputs |
| `WINDOW_TYPE_TAB_CONTENT` / `_CONTEXT` / `_SELECTOR` / `_BUTTON` / `_CONTAINER_BUTTON` | 90-94 | Tab system |
| `WINDOW_TYPE_DROPMENU` / `_DROPMENU_ITEM` / `_SUBMENU` | 102-104 | Dropdown menus |
| `WINDOW_TYPE_DROPLIST` / `_DROPLIST_ITEM` | 105-106 | Combo boxes |
| `WINDOW_TYPE_SLIDER_*` | 110-112 | Sliders |
| `WINDOW_TYPE_SCALER_*` | 120-122 | Resize grips |
| `WINDOW_TYPE_SCROLLBAR_*` | 130-139 | Scrollbar parts (track, thumb, buttons, in both orientations) |
| `WINDOW_TYPE_SCROLLABLE_ITEMGRID_VERTICAL` | 140 | Scrollable grid |

Note `WINDOW_TYPE_ITEMLIST` and `WINDOW_TYPE_ITEMLIST_VERTICAL` share value 50 — `ITEMLIST` is the default vertical orientation.

### 5.3 Type → controller registry

[Classes.as:56-135](src/com/sulake/core/window/Classes.as) is a `Dictionary` mapping each `WindowType.WINDOW_TYPE_X` → its concrete `XxxController` class. Every controller lives in [com/sulake/core/window/components/](src/com/sulake/core/window/components/). The full list (alphabetical):

```
ActivatorController              IconController
BackgroundController             InteractiveController
BitmapDataController             ItemGridController
BitmapWrapperController          ItemListController
BorderController                 PasswordFieldController
BoxSizerController               RadioButtonController
BubbleController                 RegionController
ButtonController                 ScalerController
ButtonGroupController            ScrollBarController
CheckboxController               ScrollableItemGridWindow
CloseButtonController            ScrollableItemListWindow
ContainerButtonController        SelectableController
ContainerController              SelectorController
DesktopController                SelectorListController
DisplayObjectWrapperController   StaticBitmapController
DragBarController                SubstituteParentController
DropBaseController               TabButtonController
DropListController               TabContainerController
DropListItemController           TabContextController
DropMenuController               TextController
DropMenuItemController           TextFieldController
FormattedTextController          TextLabelController
FrameController                  TextLinkController
HTMLTextController               TooltipController
HeaderController                 WidgetWindowController
```

**Each one understands a small, well-defined subset of `WindowParam`/`WindowState`/`WindowStyle` flags** (see [enum/](src/com/sulake/core/window/enum/) for those). Implementing a port means implementing each of these as a view object on the target platform — but **a tiny handful (Frame, Container, Region, Button, TextLabel, ItemList, BitmapWrapper, ScrollBar, DragBar)** covers >90% of the actual UI. The rest (DropList, Bubble, Scaler, Tab*) cover the remainder.

### 5.4 Layout XML format

A window XML is simple and recursive. Two top-level shapes:

**Layout root** (file embedded in `binaryData`):
```xml
<layout>
  <variables>
    <variable name="margin" value="4"/>
  </variables>
  <filters>
    <drop_shadow distance="2" angle="90" color="0x000000" alpha="0.5" blurX="4" blurY="4"/>
  </filters>

  <window type="frame" name="catalog_main" width="640" height="480"
          background="true" color="0xFFFFFF" blend="1">
    <children>
      <window type="header" name="title" caption="${catalog.title}" height="20"/>
      <window type="region" name="content" y="20" width="640" height="460">
        <children>
          <window type="itemlist" name="pages" width="160" height="460"/>
          <window type="region"   name="page_view" x="160" width="480" height="460"/>
        </children>
      </window>
    </children>
  </window>
</layout>
```

**Recurring window attributes** (parsed by [WindowParser.as](src/com/sulake/core/window/WindowParser.as)):

| Attribute | Meaning |
|---|---|
| `type` | String form of `WindowType` (see § 5.5 for the table) |
| `style` | Numeric or named style index (selects skin variant) |
| `name`, `id` | Lookup keys |
| `x`, `y`, `width`, `height` | Position/size in pixels |
| `width_min`, `width_max`, `height_min`, `height_max` | Resize constraints |
| `caption` | Display text (often `${localization.key}`) |
| `visible` | Initial visibility |
| `background` | Whether to paint a background |
| `color` | RGB tint |
| `blend` | Alpha multiplier |
| `clipping` | Whether children are clipped |
| `params` | Bitmask of `WindowParam.PARAM_*` flags (selectable, draggable, resizable, focusable, …) |
| `tags` | Comma-separated tag list (used by `groupChildrenByTag()`) |
| `dynamic_style` | Whether style can change at runtime |
| `treshold` (sic) | Threshold for state transitions / drag deadzone |
| `assetUri` | Image URL (interpolated against config; see §9) |

Children nest under `<children>`. Variables `${name}` are substituted from the local `<variables>` block; localization keys `${key.id}` are resolved by `HabboLocalizationCom`; config keys are resolved by `HabboConfigurationManager.interpolate()` (see §9).

### 5.5 Tag-name → type-id mapping

`WindowParser` keeps a bidirectional `TypeCodeTable` mapping XML tag names ("button", "frame", "itemlist", …) ↔ `WindowType` `uint` constants. The set is closed: only the names in that table parse successfully.

### 5.6 Parsing pipeline

```
ICoreWindowManager.create(name, typeID, styleID, ...)
       │
       ├── factory._Str_19128(typeID, styleID)        // returns layout XML
       │
       ├── new WindowController(name, typeID, styleID, factory, parent)
       │       │
       │       ├── reads width/height from XML
       │       ├── pulls property defaults from ThemeManager for (typeID, styleID)
       │       └── WindowParser.parseAndConstruct(xml, this, null)
       │              ├── strips <layout> wrapper
       │              ├── reads <variables> and <filters>
       │              └── for each <window>:
       │                     ├── tag → typeID via TypeCodeTable
       │                     ├── factory.create() → child WindowController
       │                     ├── apply attributes (x,y,w,h,style,caption,...)
       │                     ├── parent.addChild(child)
       │                     └── recurse into <children>
       │
       └── return root window (already wired)
```

The whole pipeline is **purely synchronous** because all XML and skin assets are already in memory (they were `[Embed]`-ded). Only `<bitmap assetUri>` references can trigger network I/O — and that happens lazily during paint (see §9).

---

## 6. Skinning & theming

### 6.1 SkinContainer — the four-table data structure

[com/sulake/core/window/graphics/SkinContainer.as](src/com/sulake/core/window/graphics/SkinContainer.as) holds four lookup tables, all keyed by **(windowType, style)**:

| Table | Value | Purpose |
|---|---|---|
| `_skinRendererTable` | `ISkinRenderer` | Draws this widget |
| `_defaultAttrTable` | `DefaultAttStruct` | Default color, blend, threshold, min/max sizes |
| `_windowLayoutTable` | `XML` | Default layout for frames/dialogs of this type |
| `_intentTable` | `String` | Theme intent (e.g. "destructive", "primary") |

A theme is loaded by registering `(typeID, styleID, renderer, defaults, layout, intent)` tuples for every supported combination. The `HabboWindowManagerCom` manifest (see [HabboWindowManagerCom.as](src/HabboWindowManagerCom.as)) embeds all of these as `habbo_skin_*_xml` and `habbo_window_layout_*_xml` ByteArrayAssets and registers them at component init.

### 6.2 Skin renderers

| Renderer | Use |
|---|---|
| `BitmapSkinRenderer` | Composes a bitmap from named source slices, supports per-state variants (default, hovering, pressed, disabled, …) |
| `FillSkinRenderer` | Solid color fill |
| `TextSkinRenderer` | Renders text (used by labels/text fields) |
| `ShapeSkinRenderer` | Vector primitives (rounded rect, ellipse) |
| `NullSkinRenderer` | No-op (transparent) |

All implement `ISkinRenderer` ([com/sulake/core/window/graphics/ISkinRenderer.as](src/com/sulake/core/window/graphics/ISkinRenderer.as)). The contract:

```actionscript
function parse(xml:XML, ...) : void;            // Parse the skin XML
function draw(bd:BitmapData, state:uint, ...) : void;  // Render for a given state
function isStateDrawable(state:uint) : Boolean; // Does this state have artwork?
```

### 6.3 Window states

[com/sulake/core/window/enum/WindowState.as](src/com/sulake/core/window/enum/WindowState.as) defines the bitflag set: `LOCKED, DISABLED, PRESSED, SELECTED, HOVERING, FOCUSED, ACTIVE, DEFAULT`. The renderer picks the most specific drawable state for the current bitmask each repaint.

### 6.4 Themes

`docs/UI-Framework/Skinning-Theming.md` enumerates the shipped themes:

- `Theme.NONE` — no theming (default)
- `Theme.VOLTER` — 3 styles
- `Theme.UBUNTU` — 5 styles
- `Theme.ILLUMINA_LIGHT` — 100+ styles (modern Habbo light theme)
- `Theme.ILLUMINA_DARK` — 100+ styles (dark variant)

[com/sulake/core/window/theme/PropertyKeys.as](src/com/sulake/core/window/theme/PropertyKeys.as) lists ~80 themable property keys: `TEXT_COLOR`, `FONT_FACE`, `FONT_SIZE`, `BOLD`, `ITALIC`, `MARGIN_LEFT`, `MARGIN_TOP`, `PADDING_HORIZONTAL`, `PADDING_VERTICAL`, `SPACING`, `SELECTABLE`, `EDITABLE`, `TOOL_TIP_CAPTION`, etc.

### 6.5 Skin XML format (sketch)

A skin XML for a button might look like:

```xml
<bitmapskin>
  <state name="default">
    <slice src="btn_default_left"   pos="left"/>
    <slice src="btn_default_center" pos="center" stretch="x"/>
    <slice src="btn_default_right"  pos="right"/>
  </state>
  <state name="hovering"> ... </state>
  <state name="pressed">  ... </state>
  <state name="disabled"> ... </state>
</bitmapskin>
```

Slice `src` names are looked up in the *same* asset library that owns the skin (i.e. `HabboWindowManagerCom`'s manifest). A port replaces this with whatever its native composition primitive is (CSS background slices, 9-patch, atlas frames…).

### 6.6 Why skinning matters for a port

The default look — buttons, frames, item rows, scrollbars — comes **entirely from `HabboWindowManagerCom`'s embedded skin XMLs and PNGs** ([HabboWindowManagerCom.as:1-100](src/HabboWindowManagerCom.as)). Until you have those reproduced, no feature window will render correctly. A port should treat the WindowManager skin set as a "design system" and rebuild it once.

---

## 7. Event handling

(Detailed in `docs/UI-Framework/Event-Handling.md`; summary here.)

### 7.1 Event hierarchy

```
flash.events.Event
   │
WindowEvent                  // base; FOCUS, RESIZE, ACTIVATE, DESTROY, OPEN, CLOSE
   ├── WindowMouseEvent      // CLICK, DOUBLE_CLICK, DOWN, UP, OVER, OUT,
   │                         // ROLL_OVER, ROLL_OUT, MOVE, WHEEL,
   │                         // RIGHT_CLICK, HOVERING
   └── WindowKeyboardEvent   // KEY_DOWN, KEY_UP, KEY_PRESS
```

All in [com/sulake/core/window/events/](src/com/sulake/core/window/events/).

### 7.2 Pooling

Events are pooled for GC pressure:

```actionscript
var ev:WindowMouseEvent = WindowMouseEvent.allocate(type, window, related, localX, localY, ...);
window.dispatchEvent(ev);
ev.recycle();
```

A port should keep the pooling pattern — at 60 FPS, mouse events alone churn through thousands of allocations a second.

### 7.3 Event processors

| Processor | Source events |
|---|---|
| `MouseEventProcessor` | Stage `MouseEvent` |
| `KeyboardEventProcessor` | Stage `KeyboardEvent` |
| `TabletEventProcessor` | Stage touch events (mobile tablets) |

The mouse processor is the most interesting: it walks the window tree from root, hit-tests against each window's painted region (not just its rect — clipping and `params` matter), tracks the current `over` window for roll-over/out semantics, and tracks the down-target for click/release matching.

### 7.4 Dispatch

`WindowEventDispatcher` (one per `WindowController`) holds a `Dictionary<eventType, Array<{cb, priority}>>`. `dispatchEvent()` *copies* the array before iterating, so a listener can safely add or remove other listeners during dispatch.

### 7.5 Bubbling

Events bubble up the parent chain by default (subject to a window's `params` — `PARAM_INTERNAL_EVENT_HANDLING` blocks bubbling). A listener can call `event.stopPropagation()` (the AS3 default) to halt it.

---

## 8. The `binaryData/` manifest system

This is the single most important porting concept — and the least documented elsewhere.

### 8.1 The two-file pattern

Every embedded asset in the client is a pair:

```
HabboCatalogCom_manifest.as          ← AS3 wrapper class (5 lines)
HabboCatalogCom_manifest.bin         ← payload (XML or PNG bytes)
```

The wrapper is uniform:

```actionscript
package binaryData {
  import mx.core.ByteArrayAsset;

  [Embed(source="HabboCatalogCom_manifest.bin", mimeType="application/octet-stream")]
  public class HabboCatalogCom_manifest extends ByteArrayAsset {}
}
```

This is just AS3's standard way to bake a byte blob into the SWF: at compile time `mxmlc` reads the `.bin`, encodes it into the SWF as a tag, and exposes it as a class whose `new()` returns a `ByteArray` of the file contents.

### 8.2 Manifest payload format

A `*_manifest.bin` is XML (occasionally deflated) shaped like:

```xml
<library>
  <name>HabboCatalogCom</name>
  <assets>
    <asset name="club_center_xml"        mimeType="text/xml"/>
    <asset name="purchase_confirmation"  mimeType="text/xml"/>
    <asset name="layout_marketplace"     mimeType="text/xml"/>
    <asset name="bot_thumb_bg"           mimeType="image/png"/>
    <asset name="ctlg_arrow_down"        mimeType="image/png"/>
    ...
  </assets>
</library>
```

Each entry is a **logical name** + a **MIME type**. The MIME type drives which `IAsset` subclass wraps the payload (PNG → `BitmapDataAsset`, XML → `XmlAsset`, MP3 → `SoundAsset`, TTF → `TypeFaceAsset`, anything else → `UnknownAsset` / `TextAsset`).

### 8.3 Per-asset wrappers

For each `<asset>` in the manifest, there is a corresponding wrapper class in [src/binaryData/](src/binaryData/):

```
HabboCatalogCom_club_center_xml.as          // wraps the XML
HabboCatalogCom_club_center_xml.bin
HabboCatalogCom_bot_thumb_bg.as             // wraps the PNG
HabboCatalogCom_bot_thumb_bg.png            // (PNGs aren't always renamed to .bin)
```

That's 1055 wrapper `.as` files — one per asset across all components.

### 8.4 The asset library

[com/sulake/core/assets/](src/com/sulake/core/assets/) defines the runtime asset system:

| Class | Role |
|---|---|
| `IAsset` | Single asset: name, mime type, content, url, `setContent()`, `dispose()`. |
| `BitmapDataAsset` / `XmlAsset` / `SoundAsset` / `TextAsset` / `TypeFaceAsset` / `UnknownAsset` | Mime-specific wrappers. |
| `IAssetLibrary` | Per-component library: `getAssetByName(name)`, `setAsset(name, asset)`, `loadAssetFromFile(name, urlReq, mime?)`, `getAssetTypeDeclarationByMimeType(mime)`. |
| `AssetLibrary` | Concrete implementation. |
| `AssetLibraryCollection` | Multiple libraries chained — lookup falls through. |
| `AssetTypeDeclaration` | (mime, IAsset class) pair. |
| `AssetLoaderStruct` + `loaders/` | Network loader (URLLoader for XML/text, Loader for PNG/SWF, Sound for MP3). Dispatches `AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE` / `_ERROR`. |
| `IAssetReceiver` | Callback contract for code awaiting an async asset. |
| `IResourceManager` | Higher-level interpolating loader (see §9). |

### 8.5 Component init: walking the manifest

When a component initializes, the IoC ensures its `manifest:Class` is read:

```
new HabboCatalogCom.manifest()           // ByteArrayAsset → ByteArray
   ↓ XML parse
<library>
   <assets>
      <asset name="..." mimeType="..."/>
   </assets>
</library>
   ↓ for each asset:
//   look up the AS class binaryData.HabboCatalogCom_<name>
//   instantiate it, decode its bytes into the right IAsset wrapper
//   library.setAsset(name, asset)
```

After this, `library.getAssetByName("club_center_xml")` returns an `XmlAsset` containing the parsed window XML, ready for `WindowParser`.

### 8.6 Embedded vs. lazy

Some assets are *only* loaded on demand. The `loaders/` subfolder in `core/assets/` and the `LazyAssetProcessor` ([com/sulake/core/assets/LazyAssetProcessor.as](src/com/sulake/core/assets/LazyAssetProcessor.as)) handle:

- Embedded assets (already in memory) — looked up synchronously.
- File-loaded assets (downloaded via `loadAssetFromFile`) — loaded once, cached forever.
- Lazy assets — embedded but decoded on first access (e.g. heavy bitmaps).

### 8.7 Porting strategy for the manifest system

A port replaces this entire pipeline with whatever asset system the target platform offers:

- On the web: a JSON file per component listing `{name, type, url}` + a fetch + a decoder per MIME. Texture atlases for PNGs.
- In Unity: an `AssetBundle` per component plus a name → asset dictionary.
- The contract to preserve: **`getAssetByName(string) → asset`** — synchronous if cached, async with a callback if not.

Two extraction tools are visible in the repo:

```
tools/                    # build helpers
docs/Asset-Pipeline/      # describes the pipeline at a higher level
```

Inspect these for ready-made dump scripts before re-extracting from the SWF.

---

## 9. Image resolution (embedded vs. remote)

This is the single most useful section for a porter — it explains the **end-to-end answer to "where does this PNG come from?"**.

### 9.1 The two URI flavors

Window XMLs reference images in two ways:

1. **By logical asset name** — `<bitmap name="bot_thumb_bg"/>`
   Resolves directly via `assets.getAssetByName("bot_thumb_bg")`. No network. Fast.

2. **By interpolated URI** — `<bitmap assetUri="${image.library.url}reception/badge.png"/>`
   The `${...}` placeholders are resolved against the configuration map; the result is either still a logical name (rare) or a full `http(s)://...` URL.

### 9.2 The resolution function — `ResourceManager.retrieveAsset()`

Verbatim from [ResourceManager.as:38-77](src/com/sulake/habbo/window/ResourceManager.as):

```actionscript
public function retrieveAsset(k:String, _arg_2:IAssetReceiver):void {
  if (k == null || k.length == 0) return;
  var _local_3:String = this._Str_16848(k);   // _Str_16848 = interpolate()
  if (_local_3 == null) return;

  var _local_4:IAsset = this._windowManager.assets.getAssetByName(_local_3);
  if (_local_4 == null) {
    if (_local_3.substr(0, 7) == "http://" || _local_3.substr(0, 8) == "https://") {
      _local_5 = this._windowManager.assets.loadAssetFromFile(
                    _local_3, new URLRequest(_local_3));
      // ... register the receiver to be called back when the file loads
    }
  } else {
    if (_arg_2 != null) _arg_2.receiveAsset(_local_4, _local_3);
  }
}
```

The order is exact and matters:

1. **Interpolate.** Replace `${key}` with `HabboConfigurationManager.getProperty("key")`. Recurse up to `INTERPOLATION_DEPTH_LIMIT` levels because property values can themselves contain `${other}` placeholders.
2. **Try the local asset library.** If a logical name matches, deliver synchronously.
3. **Else, if it's HTTP(S), fetch.** `assets.loadAssetFromFile` issues a `URLRequest`, caches by name, and notifies all queued `IAssetReceiver` callbacks once it completes.
4. **Else, drop.** Anything that isn't local and isn't HTTP(S) is silently ignored.

### 9.3 The interpolator — `HabboConfigurationManager.interpolate()`

[HabboConfigurationManager.as:161-201](src/com/sulake/habbo/configuration/HabboConfigurationManager.as):

```actionscript
override public function interpolate(k:String):String {
  var pattern:RegExp = /\${([^}]*)}/g;
  var s:String = k;
  for (var depth:int = 0; depth < INTERPOLATION_DEPTH_LIMIT; depth++) {
    // replace every ${key} in s with getProperty(key)
    // bail if any key is unknown
    // stop when a pass produces no changes
  }
  return s;
}
```

Plus `updateUrlProtocol(url)` which rewrites `http://` → `https://` and `:8080/` → `:8443/` when `_useHttps` is set, called automatically before the URL is used.

### 9.4 The configuration source — `external_variables.txt`

[HabboConfigurationManager.as:208-222](src/com/sulake/habbo/configuration/HabboConfigurationManager.as) `initConfigurationDownload()` retrieves `external.variables.txt` (the URL is itself bootstrapped from an embedded localization config file plus flashvars), then parses each line:

```
# external_variables.txt (excerpt)
image.library.url=https://images.habbo.com/
image.library.catalogue.url=${image.library.url}catalogue/
image.library.badgepart.url=${image.library.url}badgeparts/
navigator.thumbnail.url_base=https://r.habbo-cdn.com/homeroom/
group.badge.url=https://habbo.com/habbo-imaging/badge/
flash.dynamic.avatar.download.url=https://r.habbo-cdn.com/avatardata/
flash.dynamic.avatar.download.configuration=avatar_config.xml
flash.dynamic.avatar.download.name.template=hh_*{0,1}_{1}.swf
external.figurepartlist.txt=https://r.habbo-cdn.com/avatardata/figurepartlist.txt
url.prefix=https://www.habbo.com
```

Newer servers may serve this as JSON; the manager auto-detects.

### 9.5 The configuration keys a port must populate

| Key | Used by | Resolves to |
|---|---|---|
| `image.library.url` | Most UI bitmaps (catalogue art, generic icons, hotel-view extras) | Generic UI image base |
| `image.library.catalogue.url` | Catalogue product art, club extended info, VIP banners | Catalogue images |
| `image.library.badgepart.url` | Group-badge editor (vector parts) | Badge-part PNGs |
| `navigator.thumbnail.url_base` | Auto-generated room thumbnails (`{thumbnail.url_base}{ownerId}/{roomId}.png`) | Room thumbnail server |
| `group.badge.url` | Group badge composition (`{group.badge.url}{badgeCode}.gif`) | Generated guild badges |
| `flash.dynamic.avatar.download.url` | Avatar action XML, figure XML, effectmap XML | Avatar metadata server |
| `flash.dynamic.avatar.download.configuration` | Avatar config filename (relative to above) | XML filename |
| `flash.dynamic.avatar.download.name.template` | SWF filename pattern (`hh_*{0,1}_{1}.swf`) | Asset SWF name template |
| `external.figurepartlist.txt` | Figure parts catalog | Figure parts data |
| `external.variables.txt` | The bootstrap config itself | Flat KV / JSON |
| `url.prefix` | All "open in browser" outbound links | Site root |
| Various `hotelview.*`, `notifications.*`, `feedback.*` | Targeted features | … |

### 9.6 The avatar special case

Avatars are not resolved through this generic path. [com/sulake/habbo/avatar/AvatarRenderManager.as](src/com/sulake/habbo/avatar/AvatarRenderManager.as) downloads:

1. `HabboAvatarActions.xml` — runtime actions (wave, sit, dance, …).
2. `figurepartlist.txt` — every available figure piece.
3. The two `hh_human_*.swf` libraries (`hh_human_body.swf`, `hh_human_item.swf`) registered at startup ([HabboMain.as:111-118](src/HabboMain.as)).
4. Per-set/figure SWFs named via `flash.dynamic.avatar.download.name.template` (e.g. `hh_human_hd_180.swf`).

These are merged into the asset library on completion and become the source of avatar parts that the room renderer composites.

### 9.7 Practical advice for a port

- **Build the property map first.** The whole UI breaks if `${image.library.url}` resolves to nothing.
- **Implement interpolation with depth-limited recursion**, exactly like AS3 does, to mirror chained values like `image.library.catalogue.url=${image.library.url}catalogue/`.
- **Implement the `name OR http(s) URL` dispatch in one place** — every porting of `<bitmap>` will go through it.
- **Rewrite `http://` → `https://` automatically** on modern servers; the existing client does this and modern hotels expect it.

---

## 10. The Habbo window manager

[com/sulake/habbo/window/](src/com/sulake/habbo/window/) is a thin Habbo-specific layer over the core window framework. Its public face is [IHabboWindowManager.as](src/com/sulake/habbo/window/IHabboWindowManager.as). Every other component reaches the UI through this interface.

### 10.1 The interface

Methods worth a port (paraphrased):

```actionscript
function createWindow(name:String, layoutKey:String, width:int, height:int, ...):IWindow;
function buildModalDialogFromXML(xml:XML, ...):IWindow;

// Pre-baked dialogs
function alert(...):IWindow;
function confirm(...):IWindow;
function simpleAlert(...):IWindow;

// Lookup / focus
function getWindowByName(name:String):IWindow;
function getActiveWindow():IWindow;

// Localization parameter substitution into a window's text
function registerLocalizationParameter(window:IWindow, key:String, value:String):void;

// Asset access (every other component reaches its bitmaps through this)
function get assets():IAssetLibrary;

// String interpolation (proxies HabboConfigurationManager)
function interpolate(s:String):String;
```

### 10.2 The 4-layer stage

`docs/UI-Framework/Window-Manager.md` describes the stage as four logical depth bands:

1. **Background** — splash, loading, full-screen content (room view).
2. **Main UI** — toolbars, navigator, friend bar, catalog, inventory frames.
3. **Overlays** — context menus, tooltips, drop menus, hover bubbles.
4. **Modals** — alerts, confirms, dialogs that lock the rest of the UI.

A port should implement these as four ordered z-buckets; modals usually also dim or grey out lower layers.

### 10.3 The default skin set

`HabboWindowManagerCom`'s manifest lists ~150 embedded XML/PNG entries that constitute the default look:

- `habbo_window_layout_button_xml`, `habbo_window_layout_frame_xml`, `habbo_window_layout_tab_button_xml`, …
- `habbo_skin_button_default_xml`, `habbo_skin_button_black_xml`, `habbo_skin_button_white_xml`, `habbo_skin_button_shiny_xml`
- `habbo_skin_frame_1_xml`, `habbo_skin_frame_3_xml`, `habbo_skin_frame_7_xml`
- per-state PNG slices for each of the above

A port reproducing the original look needs to extract or rebuild this set.

---

## 11. Catalog of feature components

For each component, the entry below lists: **purpose · main manager class · key window XMLs · sub-views/widgets**. All component classes are in [src/](src/); their bootstraps and managers are in `src/com/sulake/habbo/<name>/`. Manifest XMLs are listed by their AS3 static-field names — the actual key in the asset library is `HabboXxxCom_<field>`.

### 11.1 HabboCatalogCom — the storefront

- **Purpose**: front pages, item pages, purchase confirmations, club, gifts, marketplace, recycler, pets, sound machine.
- **Manager**: `HabboCatalog extends Component` (`IIDHabboCatalog`).
- **Key layouts** ([HabboCatalogCom.as:51-196](src/HabboCatalogCom.as)): `club_center_xml`, `layout_frontpage4`, `layout_marketplace`, `layout_marketplace_buy`, `layout_marketplace_sell`, `layout_pets`, `layout_vip_buy`, `layout_recycler`, `layout_soundmachine`, `purchase_confirmation`, `gift_wrapping`, `marketplace_offer_details`, `redeem_voucher`, `targeted_offer`, …
- **Sub-views**: `CatalogViewer` (root), `Purse` (currency widget), `PurchaseConfirmationDialog`, `GiftWrappingConfiguration`, `ClubGiftController`, `ClubOfferHandler`, `RecyclerLogic`, `MarketPlace`, `RoomPreviewer` (3-D preview of furniture).

### 11.2 HabboNavigatorCom — legacy room navigator

- **Purpose**: Older room browser (categories, public rooms, guest rooms), room creation, room settings, doorbell.
- **Manager**: `HabboNavigator extends Component` (`IIDHabboNavigator`).
- **Layouts** ([HabboNavigatorCom.as:69-107](src/HabboNavigatorCom.as)): `grs_main_window_xml`, `grs_front_page_search_big_xml`, `grs_guest_room_details_long_xml`, `grs_room_ads_details_phase_one_xml`, `roc_create_room_xml`, `ros_room_settings_xml`, `doorbell_xml`, `password_input_xml`.
- **Controllers**: `MainViewCtrl`, `RoomInfoViewCtrl`, `RoomCreateViewCtrl`, `RoomSettingsCtrl`.

### 11.3 HabboNewNavigatorCom — modern navigator

- **Purpose**: Replaces the legacy navigator on modern hotels (search, filters, favorites).
- **Manager**: `HabboNewNavigator extends Component` (`IIDHabboNewNavigator`).
- **Layouts** ([HabboNewNavigatorCom.as:10-14](src/HabboNewNavigatorCom.as)): `navigator_frame_2_xml`, `room_info_popup_bubble_xml`, `property_xml`, `tag_xml`.
- **Main view**: `NavigatorView`.

> Both navigators ship in the same SWF; which one is used is decided by configuration. The recent commit `c469b0f Fix legacy navigator visual layout parity from 2026 assets` applies to the legacy one.

### 11.4 HabboInventoryCom — inventory & trading

- **Purpose**: Furniture, badges, bots, pets, effects, clothing inventory; trading; "make marketplace offer".
- **Manager**: `HabboInventory extends Component` (`IIDHabboInventory`).
- **Layouts** ([HabboInventoryCom.as](src/HabboInventoryCom.as)): `inventory_xml`, `inventory_thumb_xml`, `inventory_effects_xml`, `inventory_trading_xml`, `inventory_trading_minimized_xml`, `make_marketplace_offer_xml`, plus 100+ effect icons (`fx_icon_1` … `fx_icon_192`).

### 11.5 HabboAvatarEditorCom — avatar/figure editor

- **Purpose**: Customize the player's avatar (figure parts, clothing, colors, effects, wardrobe slots).
- **Manager**: `HabboAvatarEditorManager extends Component` (`IIDHabboAvatarEditor`).
- **Layouts** ([HabboAvatarEditorCom.as](src/HabboAvatarEditorCom.as)): `AvatarEditor`, `AvatarEditorContent`, `Outfit`, `avatareditor_wardrobe_base`, `avatar_editor_effect_griditem_xml`, `avatar_editor_name_change`, `avatar_editor_name_change_item`.

### 11.6 HabboMessengerCom — direct messaging

- **Purpose**: Console messenger windows (tabs, message history, typing).
- **Manager**: `HabboMessenger extends Component` (`IIDHabboMessenger`).
- **Layouts** ([HabboMessengerCom.as](src/HabboMessengerCom.as)): `main_window_xml`, `msg_entry_xml`, `tab_entry_xml`, `messenger_xml`.

### 11.7 HabboFriendListCom — friend list

- **Purpose**: Friends, requests, online status, relationship categorization.
- **Manager**: `HabboFriendList extends Component` (`IIDHabboFriendList`).
- **Layouts** ([HabboFriendListCom.as](src/HabboFriendListCom.as)): `main_window_xml`, `friend_entry_xml`, `friend_request_entry_xml`, `avatar_popup_xml`, `relationship_chooser_xml`.

### 11.8 HabboFriendBarCom — sidebar / hotel-view widgets

- **Purpose**: The single biggest XML-bearing component. Provides the right-side friend bar, community goal banner, level-up promos, talent track UI, group forum, dynamic widget grid, and dozens of "landing view" hotel-view campaign panels.
- **Manager**: `HabboFriendBar extends Component` (`IIDHabboFriendBar`).
- **Layouts** ([HabboFriendBarCom.as:11-114](src/HabboFriendBarCom.as)): 70+ XMLs incl. `bar_xml`, `new_bar_xml`, `all_friends_tab_xml`, `search_friends_tab_xml`, `community_goal_xml`, `level_up_xml`, `talent_track_xml`, `groupforum_main_view_xml`, `groupforum_thread_list_item_xml`, `dynamic_widget_grid_xml`, `landing_view_generic_reception_xml`, `landing_view_furnimatic_xml`, etc.

### 11.9 HabboNotificationsCom — alerts, toasts, MOTD

- **Purpose**: All system-issued popups: error dialogs, info bubbles, alerts, mod warnings, MOTD, club-gift notice, safety lock, Discord activity dialogs.
- **Manager**: `HabboNotifications extends Component` (`IIDHabboNotifications`).
- **Layouts** ([HabboNotificationsCom.as](src/HabboNotificationsCom.as)): `habbo_notifications_config_xml`, `layout_notification_xml`, `layout_notification_popup_xml`, `motd_notification_xml`, `club_gift_notification_xml`, `safety_locked_notification_xml`, `discord_activity_dialog_xml`.

### 11.10 HabboToolbarCom — top/bottom toolbar + me-menu + extensions

- **Purpose**: The persistent toolbar, "me" menu, currency purse, settings, room tools button, and a number of ad/extension widgets (offers, video promos, phone-number 2FA, NUX gifts).
- **Manager**: `HabboToolbar extends Component` (`IIDHabboToolbar`).
- **Layouts** ([HabboToolbarCom.as:11-62](src/HabboToolbarCom.as)): `toolbar_view_xml`, `bottom_bar_left_xml`, `me_menu_view_xml`, `me_menu_new_view_xml`, `me_menu_settings_menu_xml`, `me_menu_sound_settings_xml`, `purse_xml`, `purse_indicator_credits_xml`, `roomtools_xml`, `settings_xml`, `extension_grid_xml`, `offer_extension_xml`, `video_offer_promotion_xml`, `phonenumber_collect_xml`, `phonenumber_verify_xml`, `returnusergifting_miniview_xml`, `nux_gift_selection_xml`.

### 11.11 HabboHelpCom — help center, guide tool, reporting

- **Purpose**: Help browser, guide tool (peer help), guardian chat-review system, abuse/bully reports, safety booklet, welcome screens.
- **Manager**: `HabboHelp extends Component` (`IIDHabboHelp`).
- **Layouts** ([HabboHelpCom.as](src/HabboHelpCom.as)): `main_help_xml`, `topics_flow_help_xml`, `welcome_screen_xml`, `welcome_name_change_xml`, `welcome_name_selection_xml`, `user_guide_disconnected_xml`, `guide_tool_xml`, `guide_accept_xml`, `guide_ongoing_xml`, `guardian_chat_review_vote_xml`, `guardian_chat_review_results_xml`, `report_window_xml`, `chat_report_xml`, `bully_report_xml`, `safety_booklet_xml`, `sanction_info_xml`.

### 11.12 HabboModerationCom — moderator tools

- **Purpose**: Internal moderator dashboard: report queue, evidence viewer, user info, room admin tools, message templates.
- **Manager**: `ModerationManager extends Component` (`IIDHabboModeration`).
- **Layouts** ([HabboModerationCom.as](src/HabboModerationCom.as)): `start_panel_xml`, `issue_browser_xml`, `user_info_xml`, `user_info_frame_xml`, `evidence_frame_xml`, `issue_handler_xml`, `roomtool_frame_xml`, `send_msgs_xml`.

### 11.13 HabboGroupsCom — guilds/groups

- **Purpose**: Group create/edit, member roster, custom badge editor.
- **Manager**: `HabboGroupsManager extends Component` (`IIDHabboGroupsManager`).
- **Layouts** ([HabboGroupsCom.as](src/HabboGroupsCom.as)): `group`, `group_info_window`, `group_management_window`, `guild_members_window`, `badge_editor`, `badge_color_item`, `badge_layer`, `badge_part_item`, `position_picker`, `position_grid`, `color_chooser_bg`, `color_chooser_fg`.

### 11.14 HabboGamesCom — games hub & leaderboards

- **Purpose**: Game center (lobby), leaderboards, achievements; SnowStorm (snowball-fight) HUD assets.
- **Manager**: `HabboGameManager extends Component` (`IIDHabboGameManager`).
- **Layouts** ([HabboGamesCom.as](src/HabboGamesCom.as)): `game_center_view_generic_xml`, `game_center_leaderboard_view_xml`, `game_center_teaser_view_xml`, `game_achievement_entry_xml`, `game_leaderboard_entry_xml`; SnowStorm: `snowwar_loading_background`, `snowwar_leaderboard`, `snowwar_exit_confirmation`, `snowwar_own_stats`, `snowwar_team_scores`, `snowwar_timer`.

### 11.15 HabboFreeFlowChatCom — chat bubbles

- **Purpose**: Floating in-room chat bubbles. Defines ~30 stylistic variants (normal in 7 colors, bot, guide, pirate, fortune teller, dragon, skeleton, santa, steampunk_pipe, ...).
- **Manager**: `HabboFreeFlowChat extends Component` (`IIDHabboFreeFlowChat`).
- **Per style assets** (4 each): `regpoints_<style>`, `bubble_base_<style>`, `bubble_pointer_<style>`, `selector_preview_<style>`. Master file: `chatstyles_xml`.

### 11.16 HabboRoomUICom — in-room widget host

> The most widget-rich component. See §12 for how room widgets differ from windows.

- **Purpose**: Hosts every in-room overlay UI (chat bubbles, info stand, doorbell, polls, vote, room queue, me-menu, effect picker, room-tools, plus **per-furniture widgets**).
- **Manager**: `RoomUI extends Component` (`IIDHabboRoomUI`).
- **Widget factory**: [com/sulake/habbo/ui/widget/RoomWidgetFactory.as:73-179](src/com/sulake/habbo/ui/widget/RoomWidgetFactory.as) is one big `switch (RoomWidgetEnum)` returning the right widget class. The full list (verified against the switch statement):

  | Enum value | Widget class |
  |---|---|
  | `CHAT_WIDGET` | `RoomChatWidget` |
  | `CHAT_INPUT_WIDGET` | `RoomChatInputWidget` |
  | `INFOSTAND` | `InfoStandWidget` |
  | `ME_MENU` | `MeMenuWidget` |
  | `FURNI_PLACEHOLDER` | `PlaceholderFurniWidget` |
  | `FURNI_CREDIT_WIDGET` | `CreditFurniWidget` |
  | `FURNI_STICKIE_WIDGET` | `StickieFurniWidget` |
  | `FURNI_PRESENT_WIDGET` | `PresentFurniWidget` |
  | `FURNI_TROPHY_WIDGET` | `TrophyFurniWidget` |
  | `FURNI_ACHIEVEMENT_RESOLUTION_ENGRAVING` | `AchievementResolutionTrophyFurniWidget` |
  | `FURNI_ECOTRONBOX_WIDGET` | `EcotronboxFurniWidget` |
  | `FURNI_PET_PACKAGE_WIDGET` | `PetPackageFurniWidget` |
  | `DOORBELL` | `DoorbellWidget` |
  | `LOADINGBAR` | `LoadingBarWidget` |
  | `ROOM_QUEUE` | `RoomQueueWidget` |
  | `ROOM_POLL` | `RoomPollWidget` |
  | `ROOM_VOTE` | `VotePollWidget` |
  | `USER_CHOOSER` | `UserChooserWidget` |
  | `FURNI_CHOOSER` | `FurniChooserWidget` |
  | `ROOM_DIMMER` | `DimmerFurniWidget` |
  | `FRIEND_REQUEST` | `FriendRequestWidget` |
  | `CLOTHING_CHANGE` | `ClothingChangeWidget` |
  | `CONVERSION_TRACKING` | `RoomWidgetBase` (no-op) |
  | `AVATAR_INFO` | `AvatarInfoWidget` |
  | `WELCOME_GIFT` | `WelcomeGiftWidget` |
  | `PLAYLIST_EDITOR_WIDGET` | `PlaylistEditorWidget` |
  | `SPAMWALL_POSTIT_WIDGET` | `SpamwallPostitWIdget` (sic) |
  | `EFFECTS` | `EffectsWidget` |
  | `MANNEQUIN` | `MannequinWidget` |
  | `FURNITURE_CONTEXT_MENU` | `FurnitureContextMenuWidget` |
  | `CAMERA` | `CameraWidget` |
  | `ROOM_BACKGROUND_COLOR` | `BackgroundColorFurniWidget` |
  | `CUSTOM_USER_NOTIFICATION` | `CustomUserNotificationWidget` |
  | `FRIEND_FURNI_CONFIRM` | `FriendFurniConfirmWidget` |
  | `FRIEND_FURNI_ENGRAVING` | `FriendFurniEngravingWidget` |
  | `HIGH_SCORE_DISPLAY` | `HighScoreDisplayWidget` |
  | `CUSTOM_STACK_HEIGHT` | `CustomStackHeightWidget` |
  | `YOUTUBE` | `YoutubeDisplayWidget` |
  | `RENTABLESPACE` | `RentableSpaceDisplayWidget` |
  | `VIMEO` | `VimeoDisplayWidget` |
  | `ROOM_TOOLS` | `RoomToolsWidget` |
  | `EXTERNAL_IMAGE` | `ExternalImageWidget` |
  | `WORD_QUIZZ` | `WordQuizWidget` (sic) |
  | `UI_HELP_BUBBLE` | `UiHelpBubblesWidget` |
  | `ROOM_THUMBNAIL_CAMERA` | `RoomThumbnailCameraWidget` |
  | `ROOM_LINK` | `RoomLinkWidget` |
  | `CRAFTING` | `CraftingWidget` |

  Widget implementations live under [com/sulake/habbo/ui/widget/](src/com/sulake/habbo/ui/widget/), one folder per family (`avatarinfo`, `camera`, `chatinput`, `chooser`, `contextmenu`, `crafting`, `doorbell`, `effects`, `friendrequest`, `furniture/*`, `infobuspolls`, `infostand`, `loadingbar`, `memenu`, `playlisteditor`, `poll`, `roomchat`, `roomlink`, `roomqueue`, `roomtools`, `uihelpbubbles`, `wordquiz`).

### 11.17 HabboLoadingScreen + HabboMain — splash & boot

- `HabboLoadingScreen` ([src/HabboLoadingScreen.as](src/HabboLoadingScreen.as)) is the pre-component splash with a progress bar, drawn before the IoC is even ready.
- `HabboMain` is described in §3.

### 11.18 OnBoardingHc — HC subscription onboarding

- Special multi-step flow used to guide a new HC subscriber through their first session. Split across:
  - [src/OnBoardingHcFlow.as](src/OnBoardingHcFlow.as) — orchestrator
  - [src/onBoardingHc/](src/onBoardingHc/), [src/onBoardingHcSteps/](src/onBoardingHcSteps/), [src/onBoardingHcUi/](src/onBoardingHcUi/) — the steps and views.

### 11.19 Infrastructure (mentioned for completeness, not detailed)

These don't render UI directly but provide services every UI component depends on:

| Component | Role |
|---|---|
| `HabboCommunicationCom` / `CoreCommunicationFrameworkLib` | TCP framing + typed message bus (composers in, parsers out). |
| `HabboCommunicationDemoCom` | Demo/replay mode. |
| `HabboLocalizationCom` | String catalog (key → localized text). |
| `HabboConfigurationCom` | The `external_variables.txt` map. |
| `HabboSoundManagerFlash10Com` | Audio mixer, jukebox playback. |
| `HabboQuestEngineCom` | Quests / achievements progression. |
| `HabboUserDefinedRoomEventsCom` | Wired/programmed-furniture event bus. |
| `HabboAdManagerCom` | Ad placement & tracking. |
| `HabboTrackingLib` | Analytics. |
| `HabboSessionDataManagerLib` | Player profile cache. |
| `HabboAvatarRenderLib` | Avatar compositor. |
| `HabboRoomEngineCom` / `RoomManagerLib` / `RoomSpriteRendererLib` / `HabboRoomObjectLogicLib` / `HabboRoomObjectVisualizationLib` / `HabboRoomSessionManagerLib` | Room rendering & session — *out of scope for this doc*. |

---

## 12. Room widget vs. window — the second UI tree

Habbo has **two parallel UI trees**:

1. **The window tree.** Free-floating, draggable, resizable, anchored to the screen. Owned by `HabboWindowManagerCom`. Catalogue, navigator, friends, settings, alerts, etc. live here.
2. **The widget tree.** Anchored to room objects (avatars, furniture, the room itself). Owned by `HabboRoomUICom`. Doorbells, info stands, vote panels, sticky notes, dimmer controls, jukebox UI, friend furni inscriptions, etc. live here.

### 12.1 Why two systems

- The **room** is its own coordinate space (isometric, animated, scrolled, zoomed). A widget that "belongs" to a furniture item must follow it through panning and zooming — implementing that as a free-floating window would be awkward.
- Widgets are **message-driven** by the `RoomEngine` — the engine fires events when an avatar is selected, a furni is clicked, a doorbell rings, etc., and the matching widget pops up automatically. They aren't user-chrome.
- Widgets need ad-hoc lifetimes — they appear and disappear as room state changes — so they're created/destroyed by an enum-keyed factory rather than persisted.

### 12.2 The contracts

| Concept | Window tree | Widget tree |
|---|---|---|
| Created by | `windowManager.createWindow(...)` | `RoomWidgetFactory.createWidget(enumKey, handler)` |
| Lives in | `HabboWindowManagerCom` | `HabboRoomUICom` |
| Anchored to | Stage (z-buckets) | Room objects (or screen overlay layer) |
| Lifecycle | User-driven (open/close) | Engine-driven (selection / event) |
| Event source | `WindowMouseEvent` | `RoomWidgetMessage` (custom message bus) |
| Communicates with engine via | Direct service calls | `IRoomWidgetMessageListener` |

`docs/UI-Framework/Widget-System.md` covers the message bus and handler model in detail.

### 12.3 Porting implication

A port needs **both**: a screen-anchored window tree and a room-anchored widget tree. They can share a renderer but not coordinate spaces or input dispatch.

---

## 13. Localization

[HabboLocalizationCom.as](src/HabboLocalizationCom.as) downloads one or more localization XML files from a URL stored in `external_variables.txt` (typically `external.texts.txt` or a JSON file). Each entry is an `id`/`text` pair, and runtime substitution accepts `%name%`-style placeholders.

Two consumption paths:

1. **Window XML caption / text attributes** — written as `${key.id}`. Resolved by the window manager at parse time using the localization manager's lookup.
2. **Programmatic** — `localization.getKey("key.id", fallback)` and `windowManager.registerLocalizationParameter(window, "name", value)` to fill `%name%` placeholders within already-rendered text.

A port can implement this with any standard i18n system (gettext, ICU, Intl) provided it preserves both lookup styles.

---

## 14. End-to-end traces

Two concrete walkthroughs showing how all the layers cooperate.

### 14.1 Trace A: "Open the catalog and show a purchase confirmation"

```
1. User clicks the toolbar's catalog icon.
   ↓
2. ButtonController detects WindowMouseEvent.CLICK; toolbar's listener
   asks IIDHabboCatalog → HabboCatalog.openCatalog().
   ↓
3. HabboCatalog calls windowManager.createWindow(
        name        = "catalog",
        layoutKey   = "purchase_confirmation",
        ...);
   ↓
4. WindowManager → assets.getAssetByName("HabboCatalogCom_purchase_confirmation_xml")
   returns the embedded XmlAsset.
   ↓
5. WindowParser.parseAndConstruct(xml, root) walks the XML:
      <window type="frame" ...>
        <window type="bitmap_wrapper"
                assetUri="${image.library.catalogue.url}products/sofa_red.png"/>
        <window type="label"  caption="${catalog.confirm.title}"/>
        <window type="button" caption="${catalog.confirm.ok}" name="ok_btn"/>
      </window>
   For each <window>, factory.create(typeID, styleID) makes the controller
   instance, attributes are applied, parent.addChild(child).
   ↓
6. The bitmap_wrapper child requests its image:
      ResourceManager.retrieveAsset(
          "${image.library.catalogue.url}products/sofa_red.png", this);
   ↓
7. ResourceManager interpolates:
      "${image.library.catalogue.url}products/sofa_red.png"
        → "https://images.habbo.com/catalogue/products/sofa_red.png"
   ↓
8. assets.getAssetByName(URL) returns null (not embedded).
   URL starts with "https://" → assets.loadAssetFromFile(URL, URLRequest).
   ↓
9. AssetLoader fetches the PNG; on complete, fires
   AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE; ResourceManager forwards to
   the BitmapWrapperController via IAssetReceiver.receiveAsset().
   ↓
10. BitmapWrapperController stores BitmapData, calls invalidate().
    On next paint, BitmapSkinRenderer.draw() blits the bitmap into
    the controller's rendering surface.
    ↓
11. User clicks ok_btn → ButtonController dispatches WindowMouseEvent.CLICK
    → HabboCatalog's listener composes a PurchaseFromCatalogComposer message
    → CommunicationCom sends it over the socket.
    ↓
12. Server replies with PurchaseOKMessageEvent → HabboCatalog's handler
    closes the window, opens a "purchase complete" notification.
```

The whole thing is stateful only at the window-tree leaves — there is no central state store mediating between server and view. Every message handler owns its own UI mutation.

### 14.2 Trace B: "Show a user's group badge in their info stand"

```
1. User clicks an avatar in the room.
   ↓
2. RoomEngine resolves the click to an RoomObject (avatar id).
   It dispatches a RoomEngineObjectEvent → RoomUI's listener.
   ↓
3. RoomUI calls
      RoomWidgetFactory.createWidget(RoomWidgetEnum.INFOSTAND, handler);
   which constructs InfoStandWidget(roomUI.windowManager, roomUI.assets, ...)
   ↓
4. InfoStandWidget builds its window from "infostand_xml" (embedded under
   HabboRoomUICom_infostand_xml) using exactly the same WindowParser pipeline.
   ↓
5. The widget asks its handler for the user's data
   (display name, badges, motto) via the widget-message bus.
   ↓
6. For each badge:
   widget creates a child <bitmap_wrapper assetUri="${group.badge.url}{code}.gif"/>
   ↓
7. ResourceManager interpolates → "https://habbo.com/habbo-imaging/badge/A1B2C3.gif"
      → not embedded → HTTPS download → BitmapData arrives → blit.
   ↓
8. Widget anchors itself near the avatar's screen position; on every frame,
   its parent updates the anchor against the camera.
```

Note the distinction: the *info stand window* is window-tree, but the *trigger* came from a widget event. This pattern is common — many "free-floating" panels are spawned by widgets in response to room interactions.

---

## 15. Porting checklist

A practical build order. Each step gates the next.

1. **External configuration loader.** Read `external_variables.txt`/JSON, build a flat `Map<string,string>`. Implement `interpolate(s)` with depth-limited recursion.
2. **Asset library.** Implement `getAssetByName`, `loadAssetFromFile`, mime → wrapper class table. Decode PNG/XML synchronously when bytes are local.
3. **Manifest parser.** Read each component's `*_manifest.bin` (XML); for each `<asset>`, fetch the bytes from the embedded payload (or a remote pack) and register into the library.
4. **`ResourceManager.retrieveAsset()` analog.** Combine #1 + #2: interpolate → local lookup → remote fetch on `http(s)`.
5. **Window model + controller skeleton.** A class with `name, x, y, width, height, state, style, color, blend, params, tags, parent, children, listeners`.
6. **Window factory + parser.** Tag-name → type-id table; recursive XML walker building the controller tree.
7. **Five fundamental controllers.** `Frame`, `Container`/`Region`, `BitmapWrapper`, `TextLabel`, `Button`. ~60% of all UI is just these.
8. **`BitmapSkinRenderer`.** State-aware bitmap composition with sliced/stretched parts. Implement window states (`HOVERING`, `PRESSED`, `DISABLED`, `SELECTED`, `FOCUSED`, `ACTIVE`, `DEFAULT`).
9. **Event dispatcher + mouse processor.** Hit-test the window tree; pooled mouse events; bubble up.
10. **Window manager façade.** `createWindow`, `alert`, `confirm`, layered z-buckets (background / main / overlays / modals).
11. **Localization.** Lookup + `${key}`/`%param%` substitution.
12. **Skin set.** Reproduce `HabboWindowManagerCom`'s default skins: button, frame, item-list row, scrollbar, dragbar, header. Until done, nothing renders right.
13. **Component runtime.** Tiny IoC: register classes, resolve `@ComponentDependency` graph, call `init()` in topological order.
14. **First feature: HabboToolbarCom.** Smallest end-to-end vertical slice — proves boot, manifest, window, skin, message bus.
15. **Then: HabboNotificationsCom + HabboCatalogCom.** Notifications exercises the modal/alert layer; Catalog exercises remote image loading at scale.

After those, every other component (inventory, navigator, friend list, messenger, friend bar, help, moderation, groups, games, chat, room UI) is variations on the same theme: read XML, bind message handlers, mutate windows.

### Things to plan for that aren't obvious

- **State-aware bitmap skins.** A button has up to 8 distinct artworks (one per state); the renderer must pick the most specific.
- **ItemList virtualization.** Catalogue / inventory / messenger lists can be long; the AS3 `ItemListController` does simple recycling — replicate it on day one.
- **DragBar coordinate semantics.** `DragBarController` translates mouse-down on a region into parent-frame movement. Get this wrong and every panel feels broken.
- **Modal stacking.** Multiple modals can be open (e.g. an alert on top of a confirm). The window manager keeps them in a stack and re-focuses on close.
- **Asset cache eviction.** The AS3 cache is "forever". A long-running web port must add LRU eviction for remote bitmaps to avoid memory growth.
- **Sound.** `HabboSoundManagerFlash10Com` is the only audio path; widgets and the catalogue both use it. Out of scope here but plan early.
- **Two parallel input streams.** Window manager owns input when over UI; room engine owns input when over the room. The hand-off rule is "topmost hit wins"; the two systems share a chain of responsibility.

---

*Document last revised against source as of branch `feature-branch`, commit `c469b0f84`. Verify file paths if the tree has moved since.*
