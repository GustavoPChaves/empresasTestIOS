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
    enum AuthenticationHeaders: String{
        case token = "access-token"
        case client = "client"
        case uid = "uid"
    }
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

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            
            do {
                if let responseHeader = response as? HTTPURLResponse {
                    headers.token = responseHeader.value(forHTTPHeaderField: AuthenticationHeaders.token.rawValue) ?? ""
                    headers.client = responseHeader.value(forHTTPHeaderField: AuthenticationHeaders.client.rawValue) ?? ""
                    headers.uid = responseHeader.value(forHTTPHeaderField: AuthenticationHeaders.uid.rawValue) ?? ""
                }
                
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)

                completion(response, headers)
            } catch let error {
                print(error.localizedDescription)
                completion(LoginResponse(success: false, investor: nil, enterprise: nil, errors: [error.localizedDescription]), headers)
            }
        })
        task.resume()
    }
    
    func getEnterprises(type: Int, name: String, headers: Headers, completion: @escaping (EnterpriseResponse?) -> ()){
        let path = Endpoints.Enterprises.getEnterprises(type, name).url
        
        guard let url = URL(string: path) else {return}
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(headers.token, forHTTPHeaderField: AuthenticationHeaders.token.rawValue)
        request.addValue(headers.client, forHTTPHeaderField: AuthenticationHeaders.client.rawValue)
        request.addValue(headers.uid, forHTTPHeaderField: AuthenticationHeaders.uid.rawValue)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            
            do {
                
//              let json = try JSONSerialization.jsonObject(with: data, options: [])
//              print(json)
                
                let response = try JSONDecoder().decode(EnterpriseResponse.self, from: data)
                completion(response)
            } catch let error {
                print(error.localizedDescription)
                completion(nil)
            }
        })
        task.resume()
    }
    
}
