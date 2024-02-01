//
//  Payment.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation

class PaymentProcess {
    
    
    // 2d4d97f2-000f-5000-a000-1048c394dca9
    
    private let mJson: [String : Any]
    
    private var mPaymentSnap: PaymentSnapshot? = nil
    
    deinit {
        print("PaymentProcess: deinit()")
    }
    
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
                "return_url": Keys.URL_STR_RETURN
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
                print("PaymentProcess: requestJson: GC")
                return
            }
            
            let confirm = json["confirmation"] as? [String : String]
            
            let confirmUrl = confirm?["confirmation_url"] ?? "https://google.com"
            
            s.mPaymentSnap = PaymentSnapshot(
                id: json["id"] as? String ?? "",
                confirmUrl: confirmUrl
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
    
    
    public static func getPaymentInfo(
        completion: @escaping (PaymentSnapshot) -> Void
    ) {
        
        var req = URLRequest(
            url: Keys.URL_PAYMENTS
                .appendingPathComponent(
                    "2d4d97f2-000f-5000-a000-1048c394dca9"
                )
        )
        
        req.setValue(
            "Basic \(Keys.AUTH)",
            forHTTPHeaderField: "Authorization"
        )
        req.httpBody = nil
        
        URLSession.shared.dataTask(
            with: req
        ) { data, resp, error in
            
            
            
            
            print("PaymentProcess: pi: ",
                  data,
                  resp,
                  error
            )
            
        }.resume()
        
        
    }
    
}
