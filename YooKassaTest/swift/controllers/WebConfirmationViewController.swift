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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        
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
        
        let config = WKWebViewConfiguration()
        mWeb = WKWebView(
            frame: view.frame,
            configuration: config
        )
        
        mWeb.uiDelegate = self
        mWeb.navigationDelegate = self
    
        mWeb.load(req)
        
        view.addSubview(mWeb)
        
        let b = view.frame.height * 0.1
        
        let btnClose = UIButton(
            frame: CGRect(
                x: 0,
                y: view.frame.height - b,
                width: view.frame.width,
                height: b
            )
        )
        
        btnClose.setTitle(
            "Вернуться",
            for: .normal
        )
        
        btnClose.backgroundColor = .systemBlue
        
        btnClose.addTarget(
            self,
            action: #selector(
                onClickBtnClose(_:)
            ),
            for: .touchUpInside
        )
        
        view.addSubview(btnClose)
        
    }
    
    
    @objc private func onClickBtnClose(
        _ sender: UIButton
    ) {
        
        guard let id = mPaymentID else {
            return
        }
        
        sender.isEnabled = false
        
        PaymentProcess.getPaymentInfo(
            id: id
        ) { [weak self] info in
            
            print(
                "WebView:",
                info
            )
            
            DispatchQueue.ui {
                if info.status == .success {
                    self?.navigationController?
                        .popViewController(
                            animated: true
                        )
                    return
                }
                
                
                self?.alert(
                    "Выполнение платежа будет прервано"
                )
                
                sender.isEnabled = true
            }
            
        }
        
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
        if navigationAction
            .navigationType != .other {
            decisionHandler(.allow)
            return
        }
        
        guard let redirUrl = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        let p = redirUrl.absoluteString
        
        print(
            "WebView: REDIR_URL:",
            p
        )
        
        decisionHandler(.allow)
        
    }
    
}

extension WebConfirmationViewController
    : WKUIDelegate {
    
}


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
