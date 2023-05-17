//
//  AccessTokenResponse.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation

struct AccessTokenResponse: Codable {
    let accessToken, tokenType: String
//    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
//        case refreshToken = "refresh_token"
    }
}
