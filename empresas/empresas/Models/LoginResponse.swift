//
//  LoginResponse.swift
//  empresas
//
//  Created by Gustavo Chaves on 17/05/20.
//  Copyright © 2020 Gustavo Chaves. All rights reserved.
//

import Foundation

struct LoginResponse: Codable
{
    var success: Bool
    var investor: Investor?
    var enterprise: Enterprise?
    var errors: [String]?
}

struct Investor: Codable {
    let id: Int
    let investorName, email, city, country: String
    let balance: Int
    let photo: String
    let portfolio: Portfolio
    let portfolioValue: Int
    let firstAccess, superAngel: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case investorName = "investor_name"
        case email, city, country, balance, photo, portfolio
        case portfolioValue = "portfolio_value"
        case firstAccess = "first_access"
        case superAngel = "super_angel"
    }
}
struct Portfolio: Codable {
    let enterprisesNumber: Int
    let enterprises: [String]

    enum CodingKeys: String, CodingKey {
        case enterprisesNumber = "enterprises_number"
        case enterprises
    }
}

struct Headers {
    var token: String
    var uid: String
    var client: String
}
