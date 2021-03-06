import PMKCancel
import PromiseKit
import Foundation
import XCTest

extension XCTestExpectation {
    open func fulfill(error: Error) {
        fulfill()
    }
}

class AfterTests: XCTestCase {
    func fail() { XCTFail() }
    
    func testZero() {
        let ex2 = expectation(description: "")
        let cc2 = afterCC(seconds: 0).done(fail).catch(policy: .allErrors, ex2.fulfill)
        cc2.cancel()
        waitForExpectations(timeout: 2, handler: nil)
        
        let ex3 = expectation(description: "")
        let cc3 = afterCC(.seconds(0)).done(fail).catch(policy: .allErrors, ex3.fulfill)
        cc3.cancel()
        waitForExpectations(timeout: 2, handler: nil)
        
//        #if !SWIFT_PACKAGE
//        let ex4 = expectation(description: "")
//        __PMKAfter(0).done { _ in ex4.fulfill() }.silenceWarning()
//        waitForExpectations(timeout: 2, handler: nil)
//        #endif
    }
    
    func testNegative() {
        let ex2 = expectation(description: "")
        let cc2 = afterCC(seconds: -1).done(fail).catch(policy: .allErrors, ex2.fulfill)
        cc2.cancel()
        waitForExpectations(timeout: 2, handler: nil)
        
        let ex3 = expectation(description: "")
        let cc3 = afterCC(.seconds(-1)).done(fail).catch(policy: .allErrors, ex3.fulfill)
        cc3.cancel()
        waitForExpectations(timeout: 2, handler: nil)
        
//        #if !SWIFT_PACKAGE
//        let ex4 = expectation(description: "")
//        __PMKAfter(-1).done{ _ in ex4.fulfill() }.silenceWarning()
//        waitForExpectations(timeout: 2, handler: nil)
//        #endif
    }
    
    func testPositive() {
        let ex2 = expectation(description: "")
        let cc2 = afterCC(seconds: 1).done(fail).catch(policy: .allErrors, ex2.fulfill)
        cc2.cancel()
        waitForExpectations(timeout: 2, handler: nil)
        
        let ex3 = expectation(description: "")
        let cc3 = afterCC(.seconds(1)).done(fail).catch(policy: .allErrors, ex3.fulfill)
        cc3.cancel()
        waitForExpectations(timeout: 2, handler: nil)
        
        #if !SWIFT_PACKAGE
        let ex4 = expectation(description: "")
        __PMKAfter(1).done{ _ in ex4.fulfill() }.silenceWarning()
        waitForExpectations(timeout: 2, handler: nil)
        #endif
    }

    func testCancellableAfter() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // Test the normal 'after' function
        let exComplete = expectation(description: "after completes")
        let afterPromise = after(seconds: 0)
        afterPromise.done {
            exComplete.fulfill()
        }.catch { error in
            XCTFail("afterPromise failed with error: \(error)")
        }
        
        let exCancelComplete = expectation(description: "after completes")
        
        // Test `afterCC` to ensure it is fulfilled if not cancelled
        let cancelIgnoreAfterPromise = afterCC(seconds: 0)
        cancelIgnoreAfterPromise.done {
            exCancelComplete.fulfill()
        }.catch(policy: .allErrors) { error in
            XCTFail("cancellableAfterPromise failed with error: \(error)")
        }
        
        // Test `afterCC` to ensure it is cancelled
        let cancellableAfterPromise = afterCC(seconds: 0)
        cancellableAfterPromise.done {
            XCTFail("cancellableAfter not cancelled")
        }.catch(policy: .allErrorsExceptCancellation) { error in
            XCTFail("cancellableAfterPromise failed with error: \(error)")
        }.cancel()
        
        // Test `afterCC` to ensure it is cancelled and throws a `CancellableError`
        let exCancel = expectation(description: "after cancels")
        let cancellableAfterPromiseWithError = afterCC(seconds: 0)
        cancellableAfterPromiseWithError.done {
            XCTFail("cancellableAfterWithError not cancelled")
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? exCancel.fulfill() : XCTFail("unexpected error \(error)")
        }.cancel()
        
        wait(for: [exComplete, exCancelComplete, exCancel], timeout: 1)
    }
    
    func testCancelForPromise_Done() {
        let exComplete = expectation(description: "done is cancelled")
        
        let promise = CancellablePromise<Void> { seal in
            seal.fulfill(())
        }
        promise.done { _ in
            XCTFail("done not cancelled")
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? exComplete.fulfill() : XCTFail("error: \(error)")
        }
        
        promise.cancel()
        
        wait(for: [exComplete], timeout: 1)
    }
    
    func testCancelForGuarantee_Done() {
        let exComplete = expectation(description: "done is cancelled")
        
        afterCC(seconds: 0).done { _ in
            XCTFail("done not cancelled")
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? exComplete.fulfill() : XCTFail("error: \(error)")
        }.cancel()
        
        wait(for: [exComplete], timeout: 1)
    }
}
