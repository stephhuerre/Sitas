//
//  APIService.swift
//  Sitas
//
//  Created by steph on 4/29/21.
//

import Foundation
import Alamofire

class APIService {
  static let shared = APIService()

  // MARK: - public functions
  func fetchPlanes(completion: @escaping ([Plane]?, String?) -> Void) {
    AF.request(Sitas.API.url)
      .responseDecodable(of: [Plane].self) { response in
      guard response.error == nil else {
        DispatchQueue.main.async {
          completion(nil, response.error?.errorDescription)
        }
        return
      }
      guard let planes = response.value else {
        debugPrint("response not in cars format \(response.value.debugDescription)")
        DispatchQueue.main.async {
          completion(nil, response.error.debugDescription)
        }
        return
      }
      DispatchQueue.main.async {
        completion(planes, nil)
      }
    }
  }
}
