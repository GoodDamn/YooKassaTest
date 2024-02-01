//
//  ViewController.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import UIKit

class ViewController
    : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        return
        
        let payment = Payment(
            price: 129.00,
            currency: .rub,
            description: "My Subscription"
        )
        
        let paymentProcess = PaymentProcess(
            payment: payment
        )
        
        paymentProcess.start{ paymentSnap in
            
            
        }
        
    }


    override func viewDidAppear(_ animated: Bool) {
        present(
            WebConfirmationViewController(),
            animated: true
        )
    }
    
}

