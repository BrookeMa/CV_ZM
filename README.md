# CV_ZM

A collection of modular iOS component libraries (CocoaPods) originally built for a notepad/notes application. The full project has been removed — this repository preserves several foundational libraries developed during that time.

## Project Overview

All modules are written in **Objective-C**, target **iOS 8.0+**, and are distributed as **CocoaPods** pods. Each module includes a demo Xcode project for quick testing.

## Modules

### ZM_BaseLib

Core utilities, macros, categories, and UI helpers used across the entire project.

- **Macros & Constants** — `ZMCommonMacros`
- **Utilities** — File/disk helpers, date formatting, regex, network reachability, location services
- **UI Components** — Custom navigation bar, action sheets, base buttons
- **Categories** — Extensions for `NSString`, `NSDictionary`, `UILabel` (incl. HTML rendering), `UIColor`, `UIApplication`, etc.
- **Global State** — `ZMSystemGlobal`

**Dependencies:** Masonry, WebViewJavascriptBridge, RTRootNavigationController, ReactiveCocoa (≤ 2.5), JLRoutes, lottie-ios, IQKeyboardManager

---

### ZM_DataBase

Local database layer built on FMDB with schema migration support.

- Singleton-based database manager with configurable path and name
- Table existence checks, model/dictionary-driven table creation
- Full CRUD operations
- Schema migration via `ZMMigration` + FMDBMigrationManager

**Dependencies:** FMDB, FMDBMigrationManager

---

### ZM_Networking

Network abstraction layer wrapping AFNetworking (under the `XESNetwork` namespace).

- `XESNetworkBaseManager` / `XESNetworkRequest` for structured API calls
- Built-in reachability monitoring
- Request/response logging
- Form data handling

**Dependencies:** AFNetworking, MJExtension

---

### ZM_ThirdPartyLibraryExpand

Integrations and wrappers for common third-party services.

- **Routing** — `ZMRouterTools` / `ZMRouterPath` / `ZMRouterModel` (JLRoutes-based, plist-configurable schemes)
- **Social Sharing** — `ZMShareManager` / `ZMShareModel` (Umeng SDK — WeChat, QQ, Weibo)
- **Third-Party Login** — `ZMThirdLoginManager`
- **Analytics** — Umeng analytics integration

**Dependencies:** JLRoutes, YYKit, UMCommon, UMShare, UMAnalytics, and related Umeng SDKs

---

### ZM_Notepad_BaseLib

Business-level base library tailored for the notepad app, aggregating the modules above.

- **Base View Controllers** — `ZMNBaseViewController`, `ZMNErrorViewController`
- **User & Data** — `ZMNUserInfo`, `ZMNDataBaseManager`, `ZMNDataSynchronizationManager`
- **Security** — `ZMKeyChainManager` (via UICKeyChainStore)
- **Networking** — `ZMNServeConfig`, `ZMNNetworkRequest`, `ZMNResponseCheckTool`
- **Utilities** — `ZMNConstantsManager`, `UIViewController+ZMNBaseLibTools`

**Dependencies:** ZM_Networking, ZM_ThirdPartyLibraryExpand, ZM_DataBase, MMDrawerController, MBProgressHUD, Toast, UICKeyChainStore

## Repository Structure

```
CV_ZM/
├── ZM_BaseLib/
│   ├── ZM_BaseLib/                # Pod source code
│   ├── ZM_BaseLibDemo/            # Demo Xcode project
│   └── ZM_BaseLib.podspec
├── ZM_DataBase/
│   ├── ZM_DataBase/
│   ├── ZM_DataBaseDemo/
│   └── ZM_DataBase.podspec
├── ZM_Networking/
│   ├── ZM_Networking/
│   ├── ZM_NetworkingDemo/
│   └── ZM_Networking.podspec
├── ZM_ThirdPartyLibraryExpand/
│   ├── ZM_ThirdPartyLibraryExpand/
│   ├── ZM_ThirdPartyLibraryExpandDemo/
│   └── ZM_ThirdPartyLibraryExpand.podspec
└── ZM_Notepad_BaseLib/
    ├── ZM_Notepad_BaseLib/
    ├── ZM_Notepad_BaseLibDemo/
    └── ZM_Notepad_BaseLib.podspec
```

## Getting Started

1. Navigate to any `*Demo` directory:

```bash
cd ZM_BaseLib/ZM_BaseLibDemo
```

2. Install dependencies:

```bash
pod install
```

3. Open the workspace (not the `.xcodeproj`) in Xcode:

```bash
open *.xcworkspace
```

4. Select the demo target, build, and run.

> **Note:** `ZM_Notepad_BaseLib` references a private CocoaPods spec source. You may need network access to the internal spec repo or adjust the `Podfile` source URLs accordingly.

## Tech Stack

| Category | Technology |
|---|---|
| Language | Objective-C (ARC) |
| Platform | iOS 8.0+ |
| Dependency Management | CocoaPods |
| IDE | Xcode |
| Networking | AFNetworking |
| Database | FMDB + FMDBMigrationManager |
| UI Layout | Masonry |
| Reactive Programming | ReactiveCocoa (≤ 2.5) |
| JSON Modeling | MJExtension |
| Routing | JLRoutes |
| Analytics & Social | Umeng SDK |

## License

This repository is provided as-is for reference purposes.
