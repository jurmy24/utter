//
//  ChatGPTCaller.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-19.
//

import Foundation
import OpenAISwift

final class ChatModel: ObservableObject {
    // Singleton instance
    static let chatModel = ChatModel()
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
        let key = "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"
        
        //I'm currently using a pre-release version so it says makeDefultOpenAI instead of makeDefaultOpenAI. Arrhhh!
        openAIClient = OpenAISwift(config: OpenAISwift.Config.makeDefultOpenAI(api_key: key))
        
        // Add the admin prompt to the chat history
        chatHistory.append(Message(content: systemPrompt, sender: .admin, timestamp: Date(), aiPartner: "Tim"))
        
        // Here is an exmample chat for demonstration purposes
        chatHistory.append(Message(content: "Hello there, how are you?", sender: .user, timestamp: Date(), aiPartner: "Tim"))
        chatHistory.append(Message(content: "I'm doing great and yourself?", sender: .assistant, timestamp: Date(), aiPartner: "Tim"))
        chatHistory.append(Message(content: "All well all well. I would like to practice some english.", sender: .user, timestamp: Date(), aiPartner: "Tim"))
        chatHistory.append(Message(content: "Great to hear, I can help you with that. Anything you want to talk about? Perhaps sports?", sender: .assistant, timestamp: Date(), aiPartner: "Tim"))
        chatHistory.append(Message(content: "Sure I can talk about sports. But can we do it later, I need to leave now.", sender: .user, timestamp: Date(), aiPartner: "Tim"))
        chatHistory.append(Message(content: "Yes no worries, see you later!", sender: .assistant, timestamp: Date(), aiPartner: "Tim"))
        
    }
    
    func send(text: String, save: Bool = true, completion: @escaping (String) -> Void){
        
        if save{
            // Add user's message to chat history
            chatHistory.append(Message(content: text, sender: .user, timestamp: Date(), aiPartner: "Tim"))
        }
        
        let chatToSend = formatInput()
        openAIClient?.sendChat(with: chatToSend, model: .chat(.chatgpt), temperature: 0.5, maxTokens: 100){response in
            switch response {
            case .success(let success):
                let output = success.choices?.first?.message.content ?? ""
                self.chatHistory.append(Message(content: output, sender: .assistant, timestamp: Date(), aiPartner: "Tim"))
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
            case .assistant:
                return ChatMessage(role: .assistant, content: message.content)
            }
        }
        
        return chatToSend
    }
    
//    private func loadChatHistory() -> [Message] {
//        do {
//            let jsonData = try Data(contentsOf: fileURL)
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            let loadedMessages = try decoder.decode([Message].self, from: jsonData)
////            print(loadedMessages)
//        } catch {
//            print("Error reading or decoding from JSON:", error)
//        }
//    }
//    
//    private func writeChatHistory(messages: [Message]) {
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601 // For consistent date formatting
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        do {
//            let jsonData = try encoder.encode(messages)
//            try jsonData.write(to: fileURL)
//            // write jsonData to file
//        } catch {
//            print("Error encoding or writing chat history:", error)
//        }
//    }
//    
//    func writeData(_ totals: [Double]) -> Void {
//        do {
//            let fileURL = try FileManager.default
//                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                .appendingPathComponent("chatHistory.json")
//
//            try JSONEncoder()
//                .encode(totals)
//                .write(to: fileURL)
//        } catch {
//            print("error writing data")
//        }
//    }
}
