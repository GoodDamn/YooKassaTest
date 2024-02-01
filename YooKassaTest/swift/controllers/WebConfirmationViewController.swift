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
    
}


extension WebConfirmationViewController
    : WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if navigationAction.navigationType != .other {
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
        
        if p.contains(
            Keys.URL_STR_RETURN_DOMAIN
        ) {
            print(
                "IT'S PAID"
            )
            decisionHandler(
                .cancel
            )
            return
        }
        
        decisionHandler(.allow)
        
    }
    
}

extension WebConfirmationViewController
    : WKUIDelegate {
    
}
