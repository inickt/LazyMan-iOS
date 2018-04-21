//
//  HostCheck.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class HostCheck
{
    
    static func test()
    {
        let host = CFHostCreateWithName(nil,"mf.svc.nhl.com" as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let numAddress = String(cString: hostname)
                print(numAddress)
            }
        }
    }
    
    
    
    
    static func urlToIP(_ url:URL) -> String? {
        guard let hostname = url.host else {
            return nil
        }
        
        guard let host = hostname.withCString({gethostbyname($0)}) else {
            return nil
        }
        
        guard host.pointee.h_length > 0 else {
            return nil
        }
        
        var addr = in_addr()
        memcpy(&addr.s_addr, host.pointee.h_addr_list[0], Int(host.pointee.h_length))
        
        guard let remoteIPAsC = inet_ntoa(addr) else {
            return nil
        }
        
        return String.init(cString: remoteIPAsC)
    }
    
//    urlToIP(URL(string: "http://mf.svc.nhl.com/")!)
//    URL(string: "http://mf.svc.nhl.com/")!.host
}


