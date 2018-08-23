//
//  BonjourClient.swift
//  LResponder
//
//  Created by Lucca Lu on 2018/8/20.
//  Copyright © 2018 Lucca Lu. All rights reserved.
//

import UIKit

protocol BonjourClientDelegate {
    func connectedTo(_ socket: GCDAsyncSocket!)
    func disconnected()
    func handleBody(_ body: NSString?)
}

class BonjourClient: NSObject, NetServiceDelegate, NetServiceBrowserDelegate, GCDAsyncSocketDelegate {
    
    var delegate: BonjourClientDelegate!
    var service: NetService!
    var socket: GCDAsyncSocket!
    
    override init() {
        super.init()
//        self.startBroadCasting()
    }
    
    func startBroadCasting(name: String) {
        if self.service != nil {
            self.service.stop()
//            self.service.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
            self.service = nil
        }
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        var error: NSError?
        do {
            try self.socket.accept(onPort: 0)
//            self.service = NetService.init(domain: "local.", type: "_lresponder._tcp.", name: UIDevice.current.name, port: Int32(self.socket.localPort))
            self.service = NetService.init(domain: "local.", type: "_lresponder._tcp.", name: name, port: Int32(self.socket.localPort))
            self.service.delegate = self
            self.service.publish()
        } catch let error1 as NSError {
            error = error1
            print("Unable to create socket. Error \(error)")
        }
    }
    
    func parseHeader(_ data: Data) -> UInt {
        var out: UInt = 0
        (data as NSData).getBytes(&out, length: MemoryLayout<UInt>.size)
        return out
    }
    
    func handleResponseBody(_ data: Data) -> NSString? {
        if let message = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            return message
        }
        return nil
    }
    
    func send(_ data: Data) {
        var header = data.count
        let headerData = Data(bytes: &header, count: MemoryLayout<UInt>.size)
        self.socket.write(headerData, withTimeout: -1.0, tag: PacketTag.header.rawValue)
        self.socket.write(data, withTimeout: -1.0, tag: PacketTag.body.rawValue)
    }
    
    /// MARK: NSNetService Delegates
    
    func netServiceDidPublish(_ sender: NetService) {
        print("Bonjour service published. domain: \(sender.domain), type: \(sender.type), name: \(sender.name), port: \(sender.port)")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Unable to create socket. domain: \(sender.domain), type: \(sender.type), name: \(sender.name), port: \(sender.port), Error \(errorDict)")
    }
    
    /// MARK: GCDAsyncSocket Delegates
    
    func socket(_ sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Did accept new socket")
        self.socket = newSocket
        self.socket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1.0, tag: 0)
        self.delegate.connectedTo(newSocket)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket!, withError err: Error!) {
        print("socket did disconnect: error \(err)")
        if self.socket == socket {
            self.delegate.disconnected()
        }
    }
    
    func socket(_ sock: GCDAsyncSocket!, didRead data: Data!, withTag tag: Int) {
        print("did read data")
        
        if data.count == MemoryLayout<UInt>.size {
            let bodyLength: UInt = self.parseHeader(data)
            sock.readData(toLength: bodyLength, withTimeout: -1, tag: PacketTag.body.rawValue)
        } else {
            let body = self.handleResponseBody(data)
            self.delegate.handleBody(body)
            sock.readData(toLength: UInt(MemoryLayout<UInt>.size), withTimeout: -1, tag: PacketTag.header.rawValue)
        }
    }
    
    func socket(_ sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        print("did write data with tag: \(tag)")
    }
}
