//
//  OktaLoginUtility.swift
//  one-to-one-sdk-demo
//
//  Created by Pontus Jacobsson on 2022-11-24.
//

import UIKit
import WebAuthenticationUI

class OktaLoginUtility: NSObject {
    static var shared = OktaLoginUtility()

    private var _credential: Credential?

    var credential: Credential? {
        _credential ?? Credential.default
    }

    @discardableResult
    func login(anchor: WebAuthentication.WindowAnchor?) async throws -> Credential {
        let token = try await webAuthentication(anchor)
        return try saveToken(token)
    }

    func signOut() {
        try? credential?.remove()
        _credential = nil
    }
}

private extension OktaLoginUtility {
    func saveToken(_ token: Token) throws -> Credential {
        let credential = try Credential.store(token)
        _credential = credential
        return credential
    }

    func webAuthentication(_ anchor: WebAuthentication.WindowAnchor?) async throws -> Token {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try WebAuthentication().signIn(from: anchor) { result in
                    continuation.resume(with: result)
                }
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
}
