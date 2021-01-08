//
//  Service.swift
//  NYTPImageCache
//
//  Created by Besta, Balaji (623-Extern) on 08/01/21.
//

import Foundation

//let path = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
let path = "https://picsum.photos/list"
let imagePath = "https://picsum.photos/200/300?image="
//MARK:- NetworkError
enum NetworkError: Error {
    case url
    case server
    case timeout
    }

//MARK:- Service
struct Service {
    //MARK: - GCD implemented
    static func fetchServerInfoData(_ completion: @escaping (Result<[ImageModelElement]?, NetworkError>) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            let result = self.makeAPICall()
          DispatchQueue.main.async {
              switch result {
              case .success(_):
                    completion(result)
                 case let .failure(error):
                    print("error :: ",error)
                    completion(result)
                 }
             }
         }
    }
    //MARK:- API Call
    static func makeAPICall() -> Result<[ImageModelElement]?, NetworkError> {
        
            guard let url = URL(string: path) else {
                return .failure(.url)
            }
            var result: Result<[ImageModelElement]?, NetworkError>!
            
            let semaphore = DispatchSemaphore(value: 0)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    result = .failure(.server)
                    return}
                do{

//                    let str = String(decoding: data, as: UTF8.self)
//                    print("str :: ",str)
                    
                    let infomodelObjects = try JSONDecoder().decode([ImageModelElement].self, from: data)
                    result = .success(infomodelObjects)
                    
                }
                catch let jsonErr{
                    print(jsonErr.localizedDescription)
                    result = .failure(.server)
                    
                }
                //Catch the error handling
                
//             catch DecodingError.keyNotFound(let key, let context) {
//                Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
//            } catch DecodingError.valueNotFound(let type, let context) {
//                Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
//            } catch DecodingError.typeMismatch(let type, let context) {
//                Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
//            } catch DecodingError.dataCorrupted(let context) {
//                Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
//            } catch let error as NSError {
//                NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
//            }
                
    
                semaphore.signal()
            }.resume()
        if semaphore.wait(timeout: .now() + 15) == .timedOut {
                result = .failure(.timeout)
            }
            return result
    }
}
