//
//  NetworkManager.swift
//  SoloLearnTask
//
//  Created by Tigran  Simonyan on 4/23/19.
//  Copyright © 2019 Tigran  Simonyan. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    private let BASE_URL = "https://content.guardianapis.com/search?api-key=c852c34d-5488-4340-9cfa-91811ca3c4dd&show-fields=bodyText,thumbnail,headline&show-tags=contributor&page-size=20&page="

    static let instance = NetworkManager()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    private init() {}
    
    func retrieveData(for page: Int, completion: @escaping ([ArticleModel]) -> Void) {
        let urlPath = "\(BASE_URL)\(page)"
        
        let alamofireManager = Alamofire.SessionManager.default
        alamofireManager.session.configuration.timeoutIntervalForRequest = 2
        alamofireManager.request(urlPath, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .failure(let error):
                print("There are error whily getting product from server: \(error.localizedDescription)")
                completion([])
            case .success(_):
                if let data = try? JSONDecoder().decode(Dictionary<String, DataModel>.self, from: response.data ?? Data()), let dataResponse = data["response"] {
                    completion(dataResponse.results)
                } else {
                    completion([])
                }
            }
        }
    }
    
//    func retrieveData<T: Codable>(for page: Int) -> Observable<T> {
//        let urlPath = "\(BASE_URL)\(page)"
//
//        let url = URL(string: urlPath)!
//
//        return Observable<T>.create({ observer -> Disposable in
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                do {
//                    let data = try JSONDecoder().decode(Dictionary<String, T>.self, from: data ?? Data())
//                    observer.onNext(data["response"]!)
//                } catch let error {
//                    observer.onError(error)
//                }
//                observer.onCompleted()
//            }
//            task.resume()
//
//            return Disposables.create {
//                task.cancel()
//            }
//        })
//
//    }
}
