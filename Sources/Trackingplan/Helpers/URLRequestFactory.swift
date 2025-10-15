//
//  URLRequestFactory.swift
//  NetworkInterceptor
//
// MIT License
//
// Copyright (c) 2018 Kenneth Poon
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

class URLRequestFactory {

    public func createURLRequest(originalUrlRequest: URLRequest, url: URL) -> URLRequest {
        var urlString = "\(url.absoluteString)\(originalUrlRequest.url!.path)"
        if let query = originalUrlRequest.url?.query {
            urlString = "\(urlString)?\(query)"
        }
        let redirectedRequest = URLRequest(url: URL(string: urlString)!)
        return configureRequest(redirectedRequest, from: originalUrlRequest)
    }

    public func createURLRequest(originalUrlRequest: URLRequest) -> URLRequest {
        let redirectedRequest = URLRequest(url: originalUrlRequest.url!)
        return configureRequest(redirectedRequest, from: originalUrlRequest)
    }

    private func configureRequest(
        _ request: URLRequest,
        from originalRequest: URLRequest
    ) -> URLRequest {
        var configured = request

        if originalRequest.httpBodyStream != nil {
            if hasReusableStream(urlRequest: originalRequest) {
                // This is safe to read
                let httpBodyStreamData = originalRequest.getHttpBodyStreamData()
                configured.httpBody = httpBodyStreamData
            } else {
                // Direct httpBodyStream usage has no reusable stream (reading exhausts it).
                // Do not read as it can only be consumed once.
                // See: https://github.com/trackingplan/tp/issues/12013
                let mutableRequest =
                    (configured as NSURLRequest).mutableCopy() as! NSMutableURLRequest
                URLProtocol.setProperty(
                    "YES",
                    forKey: "TrackingplanBodyIncomplete",
                    in: mutableRequest
                )
                configured = mutableRequest as URLRequest
            }
        } else {
            configured.httpBody = originalRequest.httpBody
        }

        // Copy other request properties
        configured.httpMethod = originalRequest.httpMethod!
        configured.allHTTPHeaderFields = originalRequest.allHTTPHeaderFields
        configured.cachePolicy = originalRequest.cachePolicy

        return configured
    }

    /// Checks if the httpBodyStream is reusable by testing if multiple accesses return different instances.
    ///
    /// iOS converts httpBody to httpBodyStream in URLProtocol, creating fresh instances on each access.
    /// This instances are safe to read.
    ///
    /// - Parameter urlRequest: The URLRequest to check for stream reusability.
    /// - Returns: `true` if the stream returns different instances (reusable), `false` otherwise.
    ///
    /// - SeeAlso: [Stack Overflow discussion](https://stackoverflow.com/questions/36555018)
    public func hasReusableStream(urlRequest: URLRequest) -> Bool {
        guard let stream = urlRequest.httpBodyStream,
            let otherStream = urlRequest.httpBodyStream
        else {
            return false
        }
        return stream !== otherStream
    }
}
