//
//  GameViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import WebKit

class GameViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var webViewContainer: UIView!
    
    private var webView: WKWebView!
    
    var game: Game?
    
    let url = URL(string: "http://hlslive-akc.med2.med.nhl.com/hdnts=exp=1519619493~acl=/*~id=nhlGatewayId:4475557~data=57770903~hmac=e98ba0444ddff6651a72e8248e4306b6b4a7f231c69c9d2117d8d755b1a0c7cf/88514ea6992584d84a28bedec0b62f39/ls03/nhl/2018/02/25/NHL_GAME_VIDEO_CHICBJ_M2_VISIT_20180225_1518627735893/master_wired60.m3u8")
    
    override func loadView() {
        super.loadView()
        
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        
        self.webView = WKWebView(frame: self.webViewContainer.frame, configuration: config)
        self.webView.navigationDelegate = self
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.webView!.isOpaque = false
        self.webView!.backgroundColor = UIColor.clear
        self.webView!.scrollView.backgroundColor = UIColor.clear
        self.webView.scrollView.isScrollEnabled = false
        self.webView.allowsBackForwardNavigationGestures = false
        self.webView.allowsLinkPreview = false
        
        self.webViewContainer.addSubview(self.webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshButton.isEnabled = false
        
        if let awayShort = self.game?.awayTeam.shortName, let homeShort = self.game?.homeTeam.shortName {
            self.navigation.title = awayShort + " at " + homeShort
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func playPressed(_ sender: Any) {
        self.refreshButton.isEnabled = true
        self.playButton.isEnabled = false

        UIView.animate(withDuration: 0.2, animations: {
            self.playButton.alpha = 0.0
        }) { (true) in
            self.playButton.isHidden = true
        }
        
        
        if let validURL = self.url {
            self.webView.load(URLRequest(url: validURL))
        }
        
    }
    
    
    @IBAction func refreshPressed(_ sender: Any) {
        
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
}
