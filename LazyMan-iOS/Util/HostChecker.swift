//
//  HostChecker.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class HostChecker
{
    static func checkHosts(error: ((String) -> ())?)
    {
        DispatchQueue.global(qos: .background).async {
            guard let address = self.getServerAddress() else
            {
                DispatchQueue.main.async {
                    error?("The server is down or unreachable. No games will be able to be played.")
                }
                return
            }
            
            let nhlCorrect = self.checkNHLHosts(correct: address)
            let mlbCorrect = self.checkMLBHosts(correct: address)
            
            DispatchQueue.main.async {
                let errorString = " host file changes are not correctly made. Try editing your /etc/hosts file or confirm that Surge 3 is running."
                
                if !nhlCorrect && !mlbCorrect
                {
                    error?("NHL and MLB" + errorString)
                }
                else if !nhlCorrect
                {
                    error?("NHL" + errorString)
                }
                else if !mlbCorrect
                {
                    error?("MLB" + errorString)
                }
                else
                {
                    print("Host changes are configured correctly.")
                }
            }
        }
    }
    
    private static func getServerAddress() -> String?
    {
        return self.urlToIP(host: "freegamez.ga") ?? self.urlToIP(host: "powersports.ml")
    }
    
    private static func checkNHLHosts(correct: String) -> Bool
    {
        return self.urlToIP(host: "mf.svc.nhl.com") == correct
    }
    
    private static func checkMLBHosts(correct: String) -> Bool
    {
        return (self.urlToIP(host: "mlb-ws-mf.media.mlb.com") == correct) && (self.urlToIP(host: "playback.svcs.mlb.com") == correct)
    }
    
    private static func urlToIP(host: String) -> String?
    {
        let host = CFHostCreateWithName(nil, host as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?, let theAddress = addresses.firstObject as? NSData
        {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0
            {
                return String(cString: hostname)
            }
        }
        return nil
    }
}


