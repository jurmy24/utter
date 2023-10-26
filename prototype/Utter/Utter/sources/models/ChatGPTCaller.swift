//
//  ChatGPTCaller.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-19.
//

import Foundation
import OpenAISwift

struct Message {
    let content: String
    let sender: Sender
    let timestamp: Date
}

enum Sender {
    case user
    case chatGPT
    case admin
}

final class ChatGPTCaller: ObservableObject {
    //    init() {}
    private var openAIClient: OpenAISwift?
    @Published private(set) var chatHistory: [Message] = []
    private let systemPrompt: String = """
    You are Tim, a friendly language partner who loves engaging in casual and interesting conversations, especially about sports. You're here to support users in learning English by correcting major mistakes and helping them think of words when asked. You are not a formal assistant, so your interactions should be light, easy-going, and reflective of everyday conversation. Avoid being overly explanatory or giving excessively long responses. Be open to sharing about yourself, just like a normal human would, and engage in typical small talk rather than offering formal assistance or asking if you can help today. In addition, you should try to use filler words like 'ah', 'umm', 'hmm', and some common english expressions.
    Example Interaction:
    User: Hi! I'm trying to remember a word... It's something you use to cover yourself when it's raining.
    Tim: Hey! Hmm, I think you might be thinking of an umbrella. Right?
    User: Ah yes, an umbrella.
    Tim: Anyways, how's your day going? Have you been caught in the rain lately?
    """
    
    func setup(){
        let key = "sk-"
        //I'm currently using a pre-release version so it says makeDefultOpenAI instead of makeDefaultOpenAI. Arrhhh!
        openAIClient = OpenAISwift(config: OpenAISwift.Config.makeDefultOpenAI(api_key: key))
        
        // Add the admin prompt to the chat history
        chatHistory.append(Message(content: systemPrompt, sender: .admin, timestamp: Date()))
    }
    
    func send(text: String, completion: @escaping (String) -> Void){
        
        // Add user's message to chat history
        chatHistory.append(Message(content: text, sender: .user, timestamp: Date()))
        
        let chatToSend = formatInput()
        openAIClient?.sendChat(with: chatToSend, model: .chat(.chatgpt), temperature: 0.5, maxTokens: 50){response in // Result<OpenAI, OpenAIError>
            switch response {
            case .success(let success):
                let output = success.choices?.first?.message.content ?? ""
                self.chatHistory.append(Message(content: output, sender: .user, timestamp: Date()))
                print(output)
                completion(output)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func formatInput() -> [ChatMessage] {
        
        // Concatenate chat history with the system prompt
        let chatToSend: [ChatMessage] = chatHistory.map { message in
            switch message.sender {
            case .admin:
                return ChatMessage(role: .system, content: message.content)
            case .user:
                return ChatMessage(role: .user, content: message.content)
            case .chatGPT:
                return ChatMessage(role: .assistant, content: message.content)
            }
        }
        
        return chatToSend
    }
}
