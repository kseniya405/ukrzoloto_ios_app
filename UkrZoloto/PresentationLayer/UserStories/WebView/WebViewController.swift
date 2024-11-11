//
//  WebViewController.swift
//  UkrZoloto
//
//  Created by Anna Nosach on 9/2/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit
@preconcurrency import WebKit
import PKHUD

protocol WebViewControllerOutput: AnyObject {
  func back(from: WebViewController)
  func successRedirect(from: WebViewController)
}

enum NavigationStyle {
  case back
  case close
}

class WebViewController: LocalizableViewController, NavigationButtoned {
  
  // MARK: - Public variables
  var output: WebViewControllerOutput!
  
  // MARK: - Private variables
  private var webView = WKWebView()
  private let url: URL
  private let redirectURL: URL?
  private let titleLocalizator: KeyLocalizator?
  private let style: NavigationStyle
  
  // MARK: - Life cycle
  init(url: URL,
       redirectURL: URL? = nil,
       style: NavigationStyle = .back,
       shouldDisplayOnFullScreen: Bool,
       titleLocalizator: KeyLocalizator? = nil) {
    self.url = url
    self.redirectURL = redirectURL
    self.style = style
    self.titleLocalizator = titleLocalizator
    super.init(shouldDisplayOnFullScreen: shouldDisplayOnFullScreen)
  }
  
  override func loadView() {
		webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureWebView()
    localize()
  }
  
  deinit {
    webView.stopLoading()
    webView.navigationDelegate = nil
  }
  
  private func configureNavigationBar() {
    switch style {
    case .back:
      addNavigationButton(#selector(didTapOnBack),
                          button: ButtonsFactory.backButtonForNavigationItem())
    case .close:
      addNavigationButton(#selector(didTapOnBack),
                          button: ButtonsFactory.closeButtonForNavigationItem())
    }
    
  }
  
  private func configureWebView() {
    webView.load(URLRequest(url: url))
  }
  
  // MARK: - Localization
  override func localize() {
    navigationItem.title = titleLocalizator?.localizedString()
  }
  
  // MARK: - Actions
  @objc private func didTapOnBack() {
    output.back(from: self)
  }
  
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView,
               decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let redirectURL = redirectURL else {
      decisionHandler(.allow)
      return
    }
    if redirectURL == navigationAction.request.url {
      output.successRedirect(from: self)
    }
    decisionHandler(.allow)
  }
  
  func webView(_ webView: WKWebView,
               didFail navigation: WKNavigation!,
               withError error: Error) {
    print(error)
    HUD.hide()
  }
  
  func webView(_ webView: WKWebView,
               didFailProvisionalNavigation navigation: WKNavigation!,
               withError error: Error) {
    print(error)
    HUD.hide()
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    HUD.showProgress()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    HUD.hide()
  }
}
