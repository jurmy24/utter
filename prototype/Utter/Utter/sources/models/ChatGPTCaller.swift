//
//  ChatGPTCaller.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-19.
//

import Foundation
import OpenAISwift

final class ChatGPTCaller: ObservableObject {
//    init() {}
    private var client: OpenAISwift?
    
    func setup(){
        let key = "sk-"
        client = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: key))
    }
    
    func send(text: String, completion: @escaping (String) -> Void){
        
        client?.sendCompletion(with: text) { result in // Result<OpenAI, OpenAIError>
            switch result {
            case .success(let success):
                let output = success.choices?.first?.text ?? ""
                completion(output)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
