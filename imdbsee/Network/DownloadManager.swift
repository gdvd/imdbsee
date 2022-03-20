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
    case messageError(msg: String)
}
enum ResultData{
    case Success(response: Data)
    case Failure(failure: RequestError)
}

class DownloadManager {
    
    public static let shared = DownloadManager()
    private var task: URLSessionDataTask?
    init() {}
    
    // 4 XCTest
    private var session = URLSession(configuration: .default)
    init(session: URLSession){
        self.session = session
    }
    
    // Wikipedia
    public func downloadInfoWiki(url: String, completionHandler: @escaping (Networkresponse<ResponseWiki>) -> Void){
        
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
            guard let responseJSON = try? JSONDecoder().decode(ResponseWiki.self, from: data) else{
                completionHandler(.Failure(failure: RequestError.decodeError))
                return
            }
            completionHandler(.Success(response: responseJSON))
        }
        task?.resume()
    }
    
    // Youtube
    public func downloadInfoYoutube(url: String, completionHandler: @escaping (Networkresponse<ResponseYoutube>) -> Void){
        
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
            guard let responseJSON = try? JSONDecoder().decode(ResponseYoutube.self, from: data) else{
                completionHandler(.Failure(failure: RequestError.decodeError))
                return
            }
            completionHandler(.Success(response: responseJSON))
        }
        task?.resume()
    }
    
    // Image
    public func downloadImage(url: String, completionHandler: @escaping (ResultData) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(ResultData.Failure(failure: RequestError.returnNil))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(ResultData.Failure(failure: RequestError.statusCodeWrong))
                return
            }
            completionHandler(ResultData.Success(response: data))
        }
        task?.resume()
    }
    
    // Request Top Film
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
    
    // Request Search Film
    public func searchVideoImdb(url: String, completionHandler: @escaping (Networkresponse<[ResultSearch]>) -> Void){
        
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
            guard let responseJSON = try? JSONDecoder().decode(ResponseSearch.self, from: data) else{
                completionHandler(.Failure(failure: RequestError.decodeError))
                return
            }
            guard let responseResult = responseJSON.results else {
                if let msgErr = responseJSON.errorMessage {
                    completionHandler(.Failure(failure: RequestError.messageError(msg: msgErr)))
                } else {
                    completionHandler(.Failure(failure: RequestError.decodeError))
                }
                return
            }
            completionHandler(.Success(response: responseResult))
        }
        task?.resume()
    }
}
