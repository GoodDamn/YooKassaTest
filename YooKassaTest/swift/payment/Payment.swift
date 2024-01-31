//
//  Payment.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

class Payment {
    
    private let mJson: [String : Any]
    
    init(
        price: Float,
        currency: Currency,
        description: String,
        withCapture: Bool = true
    ) {
        mJson = [
            "amount": [
                "value": price,
                "currency": currency.rawValue
            ],
            "capture": withCapture,
            "confirmation": [
                "type": "redirect",
                "return_url": "https://www.example.com/return_url"
            ],
            "description": description
        ] as [String : Any]
    }
    
    public func start(
        completion: @escaping () -> Void
    ) {
        
        HttpUtils.requestJson(
            to: KeyUtils.URL_PAYMENTS,
            header: HttpUtils.header(),
            body: mJson,
            method: "POST"
        ) { json in
           
            print(
                "Payment: start:",
                json
            )
            
        }
        
    }
    
}
