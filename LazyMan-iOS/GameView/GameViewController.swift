//
//  GameViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import WebKit

protocol GameViewControllerType: class
{
    var gameTitle: String { get set }
    
    func playURL(url: URL)
    func showError(message: String)
}

class GameViewController: UIViewController, GameViewControllerType
{
    // MARK: - IBOutlets
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var webViewContainer: UIView!
    
    private var webView: WKWebView!
    
    var presenter: GamePresenterType!
    var gameTitle: String = ""
    {
        didSet
        {
            self.navigation.title = gameTitle
        }
    }
    
    @IBAction func refreshPressed(_ sender: Any)
    {
        self.presenter.reloadPressed()
    }
    
    override func loadView()
    {
        super.loadView()
        self.presenter.gameView = self
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.requiresUserActionForMediaPlayback = false
        
        self.webView = WKWebView(frame: self.webViewContainer.frame, configuration: config)
        self.webView.navigationDelegate = self
                self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.webView.translatesAutoresizingMaskIntoConstraints = false
                self.webView.isOpaque = false
                self.webView.backgroundColor = .black
                self.webView.scrollView.isScrollEnabled = false
                self.webView.allowsBackForwardNavigationGestures = false
                self.webView.allowsLinkPreview = false
        
        self.webViewContainer.addSubview(self.webView)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.presenter.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        if !self.presenter.selectingOption { self.webView.loadHTMLString("", baseURL: nil) }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "gameOptions", let gameSettings = segue.destination as? GameSettingsViewController
        {
            gameSettings.presenter = self.presenter
            self.presenter.gameSettingsView = gameSettings
        }
    }
    
    func playURL(url: URL)
    {
        let htmlString = """
        <body style=\"margin:0px;padding:0px;overflow:hidden;background-color:#000000\">
            <video title=\"\(self.gameTitle)\" style=\"min-width:100%;min-height:100%;\" controls playsinline autoplay>
                <source src=\"\(url.absoluteString)\">
            </video>
        </body>
        """
        
        self.webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func showError(message: String)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let atrributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor : UIColor.white])
        alert.setValue(atrributedMessage, forKey: "attributedMessage")
        
        self.present(alert, animated: true, completion: nil)
        
        alert.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
    }
}

extension GameViewController: WKNavigationDelegate
{
    // MARK: - WKNavigationDelegate
    
    /**
     * Allows iOS to play the nonsecure stream from broken https certificates
     */
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
}
