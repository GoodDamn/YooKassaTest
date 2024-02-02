//
//  WebConfirmationViewController.swift
//  YooKassaTest
//
//  Created by GoodDamn on 31/01/2024.
//

import Foundation
import UIKit
import WebKit

class WebConfirmationViewController
    : UIViewController {
    
    var mUrl: URL? = nil
    var mPaymentID: String? = nil
    
    private var mWeb: WKWebView!

    override func loadView() {
        let config = WKWebViewConfiguration()
        mWeb = WKWebView(
            frame: .zero,
            configuration: config
        )
        
        mWeb.uiDelegate = self
        mWeb.navigationDelegate = self
        
        view = mWeb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = mUrl else {
            navigationController?
                .popViewController(
                    animated: true
                )
            return
        }
        
        let req = URLRequest(
            url: url
        )
        
        mWeb.load(req)
    }
    
    private func alert(
        _ msg: String
    ) {
        
        let c = UIAlertController(
            title: "Прервать операцию?",
            message: msg,
            preferredStyle: .alert
        )
        
        let payID = self.mPaymentID
        
        let action = UIAlertAction(
            title: "Да",
            style: .destructive
        ) { [weak self] action in
            
            
            if let payID = payID {
                let url = Keys.URL_PAYMENTS
                .appendingPathComponent(
                    payID
                ).appendingPathComponent(
                    "cancel"
                )
                
                HttpUtils.requestJson(
                    to: url,
                    header: HttpUtils
                        .header(),
                    body: ["":""],
                    method: "POST"
                ) { _ in}
            }
            
            
            self?.navigationController?
                .popViewController(
                    animated: true
                )
            
        }
        
        let actionCancel = UIAlertAction(
            title: "Отмена",
            style: .cancel
        )
        
        c.addAction(action)
        c.addAction(actionCancel)
        
        present(
            c,
            animated: true
        )
        
    }
    
}


extension WebConfirmationViewController
    : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if navigationAction.navigationType !=
            .linkActivated {
            decisionHandler(.allow)
            return
        }
        
        guard let redirUrl = navigationAction
            .request
            .url?
            .absoluteString else {
            
            decisionHandler(.allow)
            
            return
        }
        
        print(
            "WebView: LINK_URL:",
            redirUrl
        )
        
        if redirUrl == Keys.DEEP_LINK_SUB {
            PaymentProcess.getPaymentInfo(
                id: mPaymentID!
            ) { [weak self] info in
                
                if self == nil {
                    return
                }
                
                DispatchQueue.ui {
                    self!.processPayment(
                        info
                    )
                }
                
            }
            
        }
        
        decisionHandler(.cancel)
        
    }
    
    private func processPayment(
        _ info: PaymentInfo
    ) {
        if info.status == .success {
            // Register sub
            
            
            navigationController?
                .popViewController(
                    animated: true
                )
            return
        }
        
        alert(
            "Выполнение платежа будет прервано"
        )
    }
    
}

extension WebConfirmationViewController
    : WKUIDelegate {}


extension DispatchQueue {
    
    static func ui(
        execute: @escaping () -> Void
    ) {
        
        DispatchQueue
            .main
            .async(
                execute: execute
            )
        
    }
    
}
