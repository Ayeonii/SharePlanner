//
//  HttpApiManager.swift
//  SharePlanner
//
//  Created by Ayeon on 2023/01/05.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class HttpAPIManager {
    class var headers: HTTPHeaders {
        let headers : HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    class func callRequest<T>(api: String,
                                    method: Alamofire.HTTPMethod,
                                    param : Encodable? = nil,
                                    body: Encodable? = nil,
                                    responseClass:T.Type) -> Observable<T>
    where T: Decodable {
        do {
            guard let url = try makeURLWithQueryParams(urlStr: api, param: param) else { return Observable.error(ApiError.inValidUrl) }
            let urlRequest = try URLRequest(url: url, method: method, body: body, headers: headers)
            
            return callApi(request: AF.request(urlRequest), responseClass: responseClass)
        } catch {
            return Observable.error(error)
        }
    }
    
    static func makeURLWithQueryParams(urlStr: String, param: Encodable?) throws -> URL? {
        var queryParams: [String: Any] = [:]
        guard let param = param else { return URLComponents(string: urlStr)?.url }
        
        do {
            let paramData = try JSONEncoder().encode(param)
            if let paramObject = try JSONSerialization.jsonObject(with: paramData, options: .allowFragments) as? [String: Any] {
                queryParams = paramObject
            }
            
            var urlComponents = URLComponents(string: urlStr)
            var urlQueryItems: [URLQueryItem] = []
            
            for (key, value) in queryParams {
                urlQueryItems.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            
            if urlQueryItems.count > 0 {
                urlComponents?.queryItems = urlQueryItems
            }
            
            guard let url = urlComponents?.url else {
                throw ApiError.inValidUrl
            }
            
            return url
        } catch {
            throw ApiError.encodingError(error)
        }
    }
    
    static func callApi<T>(request : DataRequest, responseClass : T.Type) -> Observable<T>
    where T: Decodable {
        return Observable.create { observer -> Disposable in
            request.responseData { (responseData) in
                switch responseData.result {
                case .success(let data) :
                    guard let statusCode = responseData.response?.statusCode else { return }
                    switch statusCode {
                    case (200..<300):
                        do {
                            let result = try JSONDecoder().decode(responseClass, from: data)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch {
                            observer.onError(ApiError.decodingError(error))
                        }
                    case (400..<500):
                        if let msg = JSON(responseData)["message"].string {
                            observer.onError(ApiError.client(statusCode, msg))
                        } else {
                            observer.onError(ApiError.client(statusCode, "UnExpected Error"))
                        }
                        
                    default:
                        if let msg = JSON(responseData)["message"].string {
                            observer.onError(ApiError.server(statusCode, msg))
                        } else {
                            observer.onError(ApiError.server(statusCode, "UnExpected Error"))
                        }
                    }
                case .failure(let error) :
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension URLRequest {
    init(url: URL, method: Alamofire.HTTPMethod, body: Encodable?, headers: HTTPHeaders) throws {
        try self.init(url: url, method: method, headers: headers)
        self.timeoutInterval = TimeInterval(30)
        self.httpBody = try makeBody(body: body)
    }
    
    func makeBody(body: Encodable?) throws -> Data? {
        guard let body = body else { return nil }
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            return try jsonEncoder.encode(body)
        } catch {
            throw ApiError.encodingError(error)
        }
    }
}
