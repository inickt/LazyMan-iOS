//
//  CastManager.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 12/20/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation
import LazyManCore
import GoogleCast

public protocol CastManagerType: AnyObject {
    var delegate: CastDelegate? { get set }
    var isConnected: Bool { get }
    func play(title: String, subtitle: String, url: URL)
}

public protocol CastDelegate: AnyObject {
    func castStateDidChange(newStatus isConnected: Bool)
}

public class CastManager: NSObject, CastManagerType, GCKRequestDelegate, GCKLoggerDelegate {

    // MARK: - Static public properties

    public static let shared: CastManagerType = CastManager()

    // MARK: - Properties

    public weak var delegate: CastDelegate?
    public var isConnected: Bool {
        return [GCKCastState.connected, GCKCastState.connecting].contains(self.castContext.castState)
    }

    // MARK: - Private Properties

    private let castContext: GCKCastContext
    private let castLogger: GCKLogger

    // MARK: - Initialization

    public init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        // Configure Chromecast
        let criteria = GCKDiscoveryCriteria(applicationID: chromecastAppID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        GCKCastContext.setSharedInstanceWith(options)
        self.castContext = GCKCastContext.sharedInstance()
        self.castLogger = GCKLogger.sharedInstance()
        super.init()

        self.castContext.useDefaultExpandedMediaControls = true

        // Enable logger.
        let filter = GCKLoggerFilter()
        filter.minimumLevel = .error
        self.castLogger.filter = filter
        self.castLogger.delegate = self

        notificationCenter.addObserver(self,
                                       selector: #selector(castStateDidChange),
                                       name: NSNotification.Name.gckCastStateDidChange,
                                       object: self.castContext)
    }

    public func play(title: String, subtitle: String, url: URL) {
        let metadata = GCKMediaMetadata()
        metadata.setString(title, forKey: kGCKMetadataKeyTitle)
        metadata.setString(subtitle, forKey: kGCKMetadataKeySubtitle)

        let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: url)
        mediaInfoBuilder.metadata = metadata
        let mediaInformation = mediaInfoBuilder.build()

        let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
        mediaLoadRequestDataBuilder.mediaInformation = mediaInformation

        if let request = self.castContext.sessionManager.currentSession?.remoteMediaClient?
            .loadMedia(with: mediaLoadRequestDataBuilder.build()) {
            request.delegate = self
        }
    }

    // MARK: - ChromeCast debug

    public func logMessage(_ message: String,
                           at level: GCKLoggerLevel,
                           fromFunction function: String,
                           location: String) {
        #if DEBUG
        print(function + " - " + message)
        #endif
    }

    @objc
    func castStateDidChange(notification: Notification) {
        self.delegate?.castStateDidChange(newStatus: self.isConnected)
    }
}
