//
//  KeyUtils.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

class Keys {
    
    public static let AUTH = "123456:API_KEY".data(
        using: .utf8
    )!.base64EncodedString()
    
    public static let URL_PAYMENTS = URL(
        string: "https://api.yookassa.ru/v3/payments"
    )!
}
