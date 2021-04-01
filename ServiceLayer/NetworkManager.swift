//
//  NetworkManager.swift
//  What animal should i get?
//
//  Created by Tanya on 26.03.2021.
//

import UIKit
import Alamofire

extension Question {
    
    static func getQuestionsNetwork(completionHandler: @escaping ([Question]?) -> Void) {
        
        let urlString = "https://www.googleapis.com/drive/v3/files/1jvtQz8jbQL43mZXgzl-tzSMAPwSygpiM/?key=AIzaSyB94CBGeUnPAElekWjSEGSeR8fsgcXp2X0&alt=media"
        
        if let url = URL(string: urlString) {
            AF.request(url)
                .validate()
                .responseData { dataResponse in
                    switch dataResponse.result {
                    case .success(let value):
                        let decoder = JSONDecoder()
                        
                        do {
                            let questionsFromJSON = try decoder.decode([Question].self, from: value)
                            print(questionsFromJSON)
                            DispatchQueue.main.async {
                                completionHandler(questionsFromJSON)
                            }
                        } catch {
                            let emptyQuestion: [Question] = [];                         completionHandler(emptyQuestion)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
}
