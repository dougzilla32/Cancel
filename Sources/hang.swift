#if !PMKCocoaPods
import PromiseKit
#endif

/**
 Runs the active run-loop until the provided promise resolves.
 
 Simply calls `hang` directly on the delegate promise, so the behavior is exactly the same with Promise and CancellablePromise.
 */
public func hang<T>(_ promise: CancellablePromise<T>) throws -> T {
    return try hang(promise.promise)
}
