//
//  Endpoints.swift
//  empresas
//
//  Created by Gustavo Chaves on 17/05/20.
//  Copyright © 2020 Gustavo Chaves. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://empresas.ioasys.com.br/api/v1"
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
                return "/users/auth/sign_in"
            }
        }
    }
    
    enum Enterprises: Endpoint {
        case getEnterprises(Int, String)

        var path: String {
            switch self {
            case .getEnterprises(let type, let name):
                return "enterprises?enterprise_types=\(type)&name=\(name)"
            }
        }
    }
    
}
