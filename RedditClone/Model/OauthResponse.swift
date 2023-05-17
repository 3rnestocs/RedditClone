//
//  OauthResponse.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation

struct OAuthResponse: Codable {
    var code: String
    var state: String
}
