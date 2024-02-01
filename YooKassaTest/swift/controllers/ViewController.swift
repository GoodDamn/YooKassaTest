//
//  ViewController.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import UIKit

class ViewController
    : UIViewController {

    private let mPrice: Float = 169.00
    
    private var mPaymentProcess: PaymentProcess? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let h = view.frame.height
        
        let btn = UIButton(
            frame: CGRect(
                x: 0,
                y: 0.45*h,
                width: view.frame.width,
                height: 20
            )
        )
        
        btn.setTitle(
            "Pay \(mPrice) RUB",
            for: .normal
        )
        
        btn.setTitleColor(
            .systemBlue,
            for: .normal
        )
        
        btn.addTarget(
            self,
            action: #selector(
                onPay(_:)
            ),
            for: .touchUpInside
        )
        
        view.addSubview(btn)
    }

    @objc private func onPay(
        _ sender: UIButton
    ) {
        
        sender.setTitle(
            "Processing",
            for: .normal
        )
        sender.isEnabled = false
        
        let payment = Payment(
            price: mPrice,
            currency: .rub,
            description: "Подписка на 1 месяц"
        )
        
        mPaymentProcess = PaymentProcess(
            payment: payment
        )
        
        mPaymentProcess!.start{ [weak self] paymentSnap in
            
            DispatchQueue
                .main
                .async {
                    sender.isEnabled = true
                    self?.confirm(
                        paymentSnap
                    )
                }
        }
    }
    
    
    private func confirm(
        _ paymentSnap: PaymentSnapshot
    ) {
        
        let vc = WebConfirmationViewController()
        
        vc.mPaymentID = paymentSnap.id
        
        vc.mUrl = URL(
            string: paymentSnap
                .confirmUrl
        )
        
        navigationController?
            .pushViewController(
                vc,
                animated: true
            )
        
        mPaymentProcess = nil
        
    }
    
}

