//
//  Endpoints.swift
//  empresas
//
//  Created by Gustavo Chaves on 17/05/20.
//  Copyright © 2020 Gustavo Chaves. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://empresas.ioasys.com.br/api/v1/users/auth"
}

protocol Endpoint {
    var path: String { get }
    var url: String { get }
}

extension Endpoint {
    var url: String {
        get {
            return "\(API.baseUrl)/\(path)"
        }
    }
}

enum Endpoints {
    
    enum Login: Endpoint {
        case doLogin
        
        var path: String {
            switch self {
            case .doLogin:
                return "sign_in"
            }
        }
    }
    
//    enum Statements: Endpoint {
//        case getStatements(Int)
//
//        var path: String {
//            switch self {
//            case .getStatements(let userId):
//                return "statements/\(userId)"
//            }
//        }
//    }
    
}
