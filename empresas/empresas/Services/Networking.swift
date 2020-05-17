//
//  Networking.swift
//  empresas
//
//  Created by Gustavo Chaves on 17/05/20.
//  Copyright © 2020 Gustavo Chaves. All rights reserved.
//

import Foundation

class Networking{
    static let shared = Networking()
     let authenticationHeaders = ["access-token", "client", "uid"]
     let authenticationHeadersDefaultsKey = "authenticationHeaders"
    
    func doLogin(email: String, password: String, completion: @escaping (LoginResponse) -> ()){
        let path = Endpoints.Login.doLogin.url
        let parameters = ["email": email, "password": password]
        
        guard let url = URL(string: path) else {return}
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error{
            print(error.localizedDescription)
            completion(LoginResponse(success: false, investor: nil, enterprise: nil, errors: [error.localizedDescription] ))
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        authenticationHeaders.forEach({request.addValue($0, forHTTPHeaderField: authenticationHeadersDefaultsKey)})
        
        print(request.allHTTPHeaderFields)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

               guard error == nil else {
                   return
               }

               guard let data = data else {
                   return
               }
            if let response = response as? HTTPURLResponse {
                // Read all HTTP Response Headers
                //print("All headers: \(response.allHeaderFields)")
                // Read a specific HTTP Response Header by name
                self.authenticationHeaders.forEach({print("Specific header: \(response.value(forHTTPHeaderField: $0) ?? " header not found")")})
            }
            
            do {
                   //create json object from data
                   //if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                print(json)
                       let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                       //response.error = nil
                completion(response)
                       // handle json...
                   //}
               } catch let error {
                   print(error.localizedDescription)
                completion(LoginResponse(success: false, investor: nil, enterprise: nil, errors: [error.localizedDescription]))
               }
           })
           task.resume()
    }
    
}
