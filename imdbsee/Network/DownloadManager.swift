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
    public func downloadImg(){
        var semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://imdb-api.com/en/API/Title/k_1234567/tt1832382")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in 
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }
        task.resume()
        semaphore.wait()
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
