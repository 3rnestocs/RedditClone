//
//  NetworkManager.swift
//  RedditClone
//
//  Created by Ernesto Jose Contreras Lopez on 15/5/23.
//

import Foundation
import Alamofire

// MARK: - Reusable API strings
enum API: String {
    case oauth = "https://www.reddit.com/api/v1/authorize"
    case accessToken = "https://www.reddit.com/api/v1/access_token"
    case redirectUri = "RedditClone://home"
    case clientID = "KCbKkJNmsWUutp-ICbJUzQ"
    case topPosts = "https://oauth.reddit.com/top"
}

class NetworkManager {
    // MARK: - Properties
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - Token header
    static let tokenHeader: HTTPHeaders = HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(Helper.accessToken)")])

    // MARK: - Public methods
    func request<T: Codable>(method: HTTPMethod = .get, api: API, parameters: [String: Any]? = nil, type: T.Type, headers: HTTPHeaders? = nil, completion: @escaping(Result<T?, Error>) -> Void) {
        
        guard let url = URL(string: api.rawValue) else { return }
        AF.request(url, method: method, parameters: parameters, headers: headers).responseData { [self] response in
            
            printRequestInfo(nil, response, parameters, headers: headers)
            
            switch response.response?.statusCode {
            case 200:
                guard let data = response.data else { return }
                let decodedData = try? JSONDecoder().decode(type, from: data)
                completion(.success(decodedData))
            default:
                if let error = response.error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func requestSecretClientID() {
        let params: [String: Any] = [
            "client_id" : API.clientID.rawValue,
            "state": "ios:com.3rnestocs.RedditClone (by /u/3rnestocs) redapp",
            "redirect_uri": API.redirectUri.rawValue,
            "response_type": "code",
            "duration": "temporary",
            "scope": "read"
        ]
        
        if let oauthUrl = getUrl(stringUrl: API.oauth.rawValue, parameters: params),
            let url = URL(string: oauthUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    func requestSessionToken(completion: @escaping(Bool) -> Void) {
        let params: [String: Any] = [
            "grant_type": "authorization_code",
            "code": Helper.secretClient,
            "redirect_uri": API.redirectUri.rawValue
        ]

        let auth = "\(API.clientID.rawValue):\(Helper.secretClient)"
        guard let loginData = auth.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        let headers = HTTPHeaders([
            "Authorization": "Basic \(base64LoginString)"
        ])
        
        request(method: .post, api: API.accessToken, parameters: params, type: AccessTokenResponse.self, headers: headers) { response in
            switch response {
            case .success(let model):
                UserDefaultsManager.shared.saveValue(model?.accessToken, type: .sessionToken)
                completion(true)
            case .failure(let error):
                completion(false)
                print("T3ST error", error)
            }
        }
    }
    
    func getQueryItems(_ urlString: String) -> [String : String] {
        var queryItems: [String : String] = [:]
        let components: NSURLComponents? = getURLComponents(urlString)
        for item in components?.queryItems ?? [] {
            queryItems[item.name] = item.value?.removingPercentEncoding
        }
        return queryItems
    }
    
    // MARK: - Helpers
    private func getUrl(method: HTTPMethod = .get, stringUrl: String, parameters: [String: Any] = [:], headers: HTTPHeaders? = nil) -> String? {
        guard var urlComponents = URLComponents(string: stringUrl) else {
            return nil
        }
        urlComponents.query = ""
        for (key, value) in parameters {
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
        return urlComponents.url?.absoluteString
    }
    
    private func getURLComponents(_ urlString: String?) -> NSURLComponents? {
        var components: NSURLComponents? = nil
        let linkUrl = URL(string: urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        if let linkUrl = linkUrl {
            components = NSURLComponents(url: linkUrl, resolvingAgainstBaseURL: true)
        }
        return components
    }
    
    private func printRequestInfo(_ service: String?, _ response: DataResponse<Data, AFError>, _ params: [String: Any]?, headers: HTTPHeaders? = nil) {
        print("❗️❗️❗️ T3ST Url:", response.request?.url)
        print("❗️❗️❗️ T3ST Header:", headers)
        print("❗️❗️❗️ T3ST Params:", params)
        print("❗️❗️❗️ T3ST Code:", response.response?.statusCode ?? 0)
        if let data = response.value {
            let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print("❗️❗️❗️ T3ST Response:", responseData)
        }
    }
}

