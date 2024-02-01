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
        id: String,
        completion: @escaping (PaymentInfo) -> Void
    ) {
        
        var req = URLRequest(
            url: Keys.URL_PAYMENTS
                .appendingPathComponent(
                    id
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
            
            print(
                "PaymentProcess: RESPONSE:",
                resp
            )
            
            print(
                "PaymentProcess: ERROR: ",
                error
            )
            
            print(
                "PaymentProcess: DATA:",
                data
            )
            
            guard let data = data else {
                return
            }
            
            do {
                
                let json = try JSONSerialization
                    .jsonObject(
                        with: data
                    ) as! [String : Any]
                
                print(
                    "PaymentProcess: paymentInfo: JSON",
                    json
                )
                
                
                completion(
                    PaymentProcess
                        .extractPaymentInfo(
                            json
                    )
                )
                
                
            } catch {
                print(
                    "PaymentProcess: paymentINFO:JSON",
                    error
                )
            }
            
        }.resume()
        
        
    }
    
    private static func extractPaymentInfo(
        _ json: [String : Any]
    ) -> PaymentInfo {
        
        let id = json["id"] as! String
        
        let status = Status(
            rawValue: json["status"] as! String
        )
        
        let paid = json["paid"] as! Bool
        
        let amount = json["amount"] as! [String : String]
        
        let price = Float(
            amount["value"]! as String
        )
        
        let currency = Currency(
            rawValue: amount["currency"]!
                    as String
        )
        
        return PaymentInfo(
            id: id,
            status: status!,
            paid: paid,
            price: price!,
            currency: currency!
        )
        
    }
    
}
