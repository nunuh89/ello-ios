//
//  APIKeys.swift
//  Ello
//
//  Created by Sean Dougherty on 11/26/14.
//  Copyright (c) 2014 Ello. All rights reserved.
//

import Foundation
import Pods

// Mark: - API Keys

public struct APIKeys {
    let key: String
    let secret: String

    // MARK: Shared Keys

    private struct SharedKeys {
        static var instance = APIKeys()
    }

    public static var sharedKeys: APIKeys {
        get {
        return SharedKeys.instance
        }

        set (newSharedKeys) {
            SharedKeys.instance = newSharedKeys
        }
    }

    // MARK: Methods

    public var stubResponses: Bool {
        return countElements(key) == 0 || countElements(secret) == 0
    }

    // MARK: Initializers

    public init(key: String, secret: String) {
        self.key = key
        self.secret = secret
    }

    public init(keys: ElloKeys) {
        self.init(key: keys.elloAPIClientKey() ?? "", secret: keys.elloAPIClientSecret() ?? "")
    }

    public init() {
        let keys = ElloKeys()
        self.init(keys: keys)
    }
}
