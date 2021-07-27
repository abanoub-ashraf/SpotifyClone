import UIKit
import WebKit

/// this controller will load the authentication web page inside a webview
class AuthController: UIViewController {
    
    // MARK: - UI
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    // MARK: - Variables
    
    /**
     * tells the welcome controller wether the user has successfully signed in or not
     * this gonna be called from the welcome contrtoller when this controller gets pushed
       on top of tthe welcome controller by the didTapSignIn() function in the welcome controller
     */
    public var completionHandler: ((Bool) -> Void)?
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = Constants.mainColor
        
        /**
         * once the web page redirtects to our redirectUri or any error occurs,
           this will help us detect all those events
         * make this controller conforms to the WKNavigationDelegate
         */
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        // let the webview load the sign in url
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }

}

// MARK: - WKNavigationDelegate

extension AuthController: WKNavigationDelegate {
    
    /**
     * inside this function, we load the authentication web page
     * if that success, it takes us to the redirectURI with a code attached to it as query parametar
     * extract that code and make an api call with to replace it with an access token
     */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // the url of the redirect page that will have the code attached to it
        guard let url = webView.url else { return }
        
        // extract the code attached to the url above, it's a query parameter
        guard
            let code = URLComponents(string: url.absoluteString)?
                .queryItems?
                .first(where: { $0.name == "code" })?
                .value
        else { return }
        
        // to hide the page we're redirect to after we get the code
        webView.isHidden = true
        
        print("The Sign In Code: \(code)")
        
        // first api call that exchange the code we got from loading the sign in url in a web page
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if navigationAction.navigationType == .backForward {
//            decisionHandler(.cancel)
//        }
//    }
//
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        decisionHandler(.cancel)
//    }
    
}
