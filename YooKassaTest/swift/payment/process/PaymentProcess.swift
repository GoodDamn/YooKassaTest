//
//  Payment.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

class PaymentProcess {
    
    private let mJson: [String : Any]
    
    private var mPaymentSnap: PaymentSnapshot? = nil
    
    init(
        payment: Payment
    ) {
        mJson = [
            "amount": [
                "value": payment.price,
                "currency": payment
                    .currency
                    .rawValue
            ],
            "capture": payment
                .withCapture,
            "confirmation": [
                "type": "redirect",
                "return_url": "https://www.example.com/return_url"
            ],
            "description": payment
                .description
        ] as [String : Any]
    }
    
    public func start(
        completion: @escaping (PaymentSnapshot) -> Void
    ) {
        
        HttpUtils.requestJson(
            to: Keys.URL_PAYMENTS,
            header: HttpUtils.header(),
            body: mJson,
            method: "POST"
        ) { [weak self] json in
            guard let s = self else {
                return
            }
            
            s.mPaymentSnap = PaymentSnapshot(
                id: json["id"] as? String ?? ""
            )
            
            print(
                "Payment: Snapshot:",
                s.mPaymentSnap
            )
            
            print(
                "Payment: start:",
                json
            )
            
            completion(s.mPaymentSnap!)
        }
        
    }
    
}
