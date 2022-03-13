//
//  Download.swift
//  imdbsee
//
//  Created by Gilles David on 08/03/2022.
//

import Foundation

enum Networkresponse<T: Codable> {
    case Success(response: T)
    case Failure(failure: RequestError)
}

enum RequestError: Error {
    case returnZero
    case returnNil
    case statusCodeWrong
    case decodeError
}

class Download {
    
    public static let shared = Download()
    private var task: URLSessionDataTask?
    init() {}
    
    // 4 XCTest
    private var session = URLSession(configuration: .default)
    init(session: URLSession){
        self.session = session
    }
    
    public func downloadVideoImdb(url: String, completionHandler: @escaping (Networkresponse<[ResponseVideoImdb]>) -> Void){
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(Networkresponse.Failure(failure: RequestError.returnNil))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.Failure(failure: RequestError.statusCodeWrong))
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(ResponseItemVideoImdb.self, from: data) else{
                completionHandler(.Failure(failure: RequestError.decodeError))
                return
            }
            completionHandler(.Success(response: responseJSON.items))
        }
        task?.resume()
    }
    
    
}
