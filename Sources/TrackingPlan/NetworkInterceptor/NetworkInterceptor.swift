//
//  NetworkInterceptor.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/5/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

protocol RequestRefirer {
    func refireURLRequest(urlRequest: URLRequest)
}

protocol RequestEvaluator: AnyObject {
    func isActionAllowed(urlRequest: URLRequest) -> Bool
}

protocol SniffableRequestHandler {
    func sniffRequest(urlRequest: URLRequest)
}

protocol RedirectableRequestHandler {
    func redirectedRequest(originalUrlRequest: URLRequest) -> URLRequest
}

struct RequestSniffer {
     let requestEvaluator: RequestEvaluator
     let handlers: [SniffableRequestHandler]
     init(requestEvaluator: RequestEvaluator, handlers: [SniffableRequestHandler]) {
        self.requestEvaluator = requestEvaluator
        self.handlers = handlers
    }
}

struct RequestRedirector {
     let requestEvaluator: RequestEvaluator
     let redirectableRequestHandler: RedirectableRequestHandler
     init(requestEvaluator: RequestEvaluator, redirectableRequestHandler: RedirectableRequestHandler) {
        self.requestEvaluator = requestEvaluator
        self.redirectableRequestHandler = redirectableRequestHandler
    }
}

class NetworkInterceptor: NSObject {
    
    static let shared = NetworkInterceptor()
    let networkRequestInterceptor = NetworkRequestInterceptor()
    var config: NetworkInterceptorConfig?
    
    public func setup(config: NetworkInterceptorConfig){
        self.config = config
    }
    
    @objc public func startRecording(){
        self.networkRequestInterceptor.startRecording()
    }
    
    @objc public func stopRecording(){
        self.networkRequestInterceptor.stopRecording()
    }
    
    func sniffRequest(urlRequest: URLRequest){
        guard let config = self.config else {
            return
        }
        for sniffer in config.requestSniffers {
            if sniffer.requestEvaluator.isActionAllowed(urlRequest: urlRequest) {
                for handler in sniffer.handlers {
                    handler.sniffRequest(urlRequest: urlRequest)
                }
            }
        }
    }
    
    func isRequestRedirectable(urlRequest: URLRequest) -> Bool {
        guard let config = self.config else {
            return false
        }
        for redirector in config.requestRedirectors {
            if redirector.requestEvaluator.isActionAllowed(urlRequest: urlRequest) {
                return true
            }
        }
        return false
    }
    
    func redirectedRequest(urlRequest: URLRequest) -> URLRequest? {
        guard let config = self.config else {
            return nil
        }
        for redirector in config.requestRedirectors {
            if redirector.requestEvaluator.isActionAllowed(urlRequest: urlRequest) {
                return redirector.redirectableRequestHandler.redirectedRequest(originalUrlRequest: urlRequest)
            }
        }
        return nil
    }
    
}

extension NetworkInterceptor: RequestRefirer {
    func refireURLRequest(urlRequest: URLRequest) {
        var request = urlRequest
        request.addValue("true", forHTTPHeaderField: "Refired")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else {
                return
            }
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            } catch _ as NSError {
            }
            if error != nil{
                return
            }
        }
        task.resume()
        
    }
}
