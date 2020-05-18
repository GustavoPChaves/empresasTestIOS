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
    
    func doLogin(email: String, password: String, completion: @escaping (LoginResponse, Headers) -> ()){
        let path = Endpoints.Login.doLogin.url
        let parameters = ["email": email, "password": password]
        var headers = Headers(token: "", uid: "", client: "")
        
        guard let url = URL(string: path) else {return}
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        catch let error{
            print(error.localizedDescription)
            completion(LoginResponse(success: false, investor: nil, enterprise: nil, errors: [error.localizedDescription] ), headers)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        authenticationHeaders.forEach({request.addValue($0, forHTTPHeaderField: authenticationHeadersDefaultsKey)})
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            
            do {
                //create json object from data
                //if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
                
                if let responseHeader = response as? HTTPURLResponse {
                    headers.token = responseHeader.value(forHTTPHeaderField: self.authenticationHeaders[0] ) ?? ""
                    headers.client = responseHeader.value(forHTTPHeaderField: self.authenticationHeaders[1]) ?? ""
                    headers.uid = responseHeader.value(forHTTPHeaderField: self.authenticationHeaders[2]) ?? ""
                }
                
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                //response.error = nil
                completion(response, headers)
                // handle json...
                //}
            } catch let error {
                print(error.localizedDescription)
                completion(LoginResponse(success: false, investor: nil, enterprise: nil, errors: [error.localizedDescription]), headers)
            }
        })
        task.resume()
    }
    
}
