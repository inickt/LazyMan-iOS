//
//  GameViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import AVKit
import LazyManCore

protocol GameViewType: AnyObject {

    var gameTitle: String { get set }

    func playURL(url: URL)
    func showError(message: String)
    func setQuality(text: String?)
    func setFeed(text: String)
    func setCDN(text: String)
}

class GameViewController: UIViewController, GameViewType {

    // MARK: - IBOutlets

    @IBOutlet private var navigation: UINavigationItem!
    @IBOutlet private var refreshButton: UIBarButtonItem!
    private var playerVC: AVPlayerViewController?

    // MARK: - Properties

    var presenter: GamePresenterType?
    var gameTitle: String = "" {
        didSet {
            self.navigation.title = gameTitle
        }
    }
    private weak var gameSettingsView: GameSettingsViewController?
    private var hidden = false

    // MARK: - IBActions

    @IBAction private func refreshPressed(_ sender: Any) {
        self.presenter?.reload()
    }

    // MARK: - Lifecycle

    override func loadView() {
        // swiftlint:disable:previous prohibited_super_call
        // TODO: - Clean this up, remove super call (crashed without it though...)
        super.loadView()
        self.presenter?.gameView = self
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: pauseNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.load()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hidden = false
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameOptions", let gameSettings = segue.destination as? GameSettingsViewController {
            gameSettings.presenter = self.presenter
            self.gameSettingsView = gameSettings
        } else if segue.identifier == "player", let playerVC = segue.destination as? AVPlayerViewController {
            self.playerVC = playerVC
        }
    }

    // MARK: GameViewType

    func playURL(url: URL) {
        let asset = AVURLAsset(url: url)
        asset.resourceLoader.setDelegate(self.presenter, queue: DispatchQueue(label: "Loader"))
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        self.playerVC?.player = player

        if !self.hidden {
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            player.play()
        }
    }

    func showError(message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)

        let atrributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor: UIColor.white])
        alert.setValue(atrributedMessage, forKey: "attributedMessage")

        self.present(alert, animated: true, completion: nil)

        alert.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
    }

    func setQuality(text: String?) {
        self.gameSettingsView?.setQuality(text: text)
    }

    func setFeed(text: String) {
        self.gameSettingsView?.setFeed(text: text)
    }

    func setCDN(text: String) {
        self.gameSettingsView?.setCDN(text: text)
    }

    // MARK: - Private

    @objc
    private func pause() {
        self.playerVC?.player?.pause()
        self.hidden = true
    }
}
