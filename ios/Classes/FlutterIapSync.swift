import Foundation
import StoreKit

/// Asks the App Store for this Apple ID's latest transactions (`AppStore.sync()`), which Restore needs: without it
/// StoreKit answers only from this device's copy. Kept in its own file so StoreKit's `Product` and `Transaction` never
/// clash with OpenIAP's types in the plugin.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
enum FlutterIapSync {
    /// Nil once synced; otherwise the OpenIAP error code and message. Cancelling Apple's sign-in prompt is
    /// `user-cancelled`, so apps can tell it from a store that can't be reached.
    @MainActor
    static func sync() async -> (code: String, message: String)? {
        do {
            try await AppStore.sync()
            return nil
        } catch StoreKitError.userCancelled {
            return ("user-cancelled", "The App Store sign-in was cancelled")
        } catch {
            return ("service-error", error.localizedDescription)
        }
    }
}
