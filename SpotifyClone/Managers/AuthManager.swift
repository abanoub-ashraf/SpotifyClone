import Foundation

final class AuthManager {
    
    // MARK: - Init -
    
    private init() {}
    
    // MARK: - Variables -
    
    static let shared = AuthManager()
    
    //
    private var refreshingToken = false
    
    //
    private var onRefreshBlocks = [((String) -> Void)]()
    
    /// this is the url that the web view inside the auth manager will load for sign the user in
    /// it'll redirect to the redirectURI with a code attached to it which we will exchange for token
    public var signInURL: URL? {
        let stringUrl = "\(Constants.baseURL)?response_type=code&client_id=\(Config.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: stringUrl)
    }
    
    // if the access token is not nil then the user still signed in
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    // the access token we cached using UserDefaults
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    // the refresh token we cached using UserDefaults
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    // the expiration date we cached using UserDefaults
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    // refresh the token when it's only 5 minutes left till it expires
    // now we gurante that we always have a valid token
    private var shouldRefreshToken: Bool {
        // if there's no tokenExpirationDate return false
        guard let expirationDate = tokenExpirationDate else {
            // return false cause we shouldn't refresh the token if we don't even have one
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        // if the current data + 5 minutes is less than the expiration date of the token
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    // MARK: - Methods -
    
    // an api call for requesting access token from the api using a code we got from the authentication page
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        var components = URLComponents()
        // the body of the request has to contain these three fields
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // the header of the request, the content-type field
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // the body of the request using the query items we made above
        request.httpBody = components.query?.data(using: .utf8)
        
        // an Authorization header field that has to be base64 encoded
        // 1- the string value of the base64 header value
        let basicToken = Config.clientID+":"+Config.clientSecret
        // 2- make a data out of the string value above
        let data = basicToken.data(using: .utf8)
        // 3- make a base64String from the data above
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        // set the header value for this Authorization field
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        // now create the web request itself
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                // get the json form of the data to see how the response looks like
                // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                // print("SUCCESS: \(json)")
                
                // decode the json response and cache it using UserDefaults
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    // provide a valid token to be used with api calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        // if we're not refreshing then proceed
        guard !refreshingToken else {
            // if we're refreshing, append completion to be executed once the refreshing has completed
            // we doing that cause we don't wanna redandantly refresh
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            // if shouldRefreshToken is true then we should refresh
            // this function will request a refresh token (a new access token) and cach it
            refreshIfNeeded { [weak self] success in
                // if success, and we got new token, send the token to the completion
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            // if shouldRefreshToken is not true then we shouldn't refresh and return the current token
            completion(token)
        }
    }
    
    /**
     * make an api call to reqeust a refresh token
     * the completion handler is optional cause when we check for the isSignedIn variable
       inside the AppDelegate, if the user is signed in we wanna refresh the token
       without needing the completion handler there
     */
    public func refreshIfNeeded(completion: ((Bool) -> Void)?) {
        // if we not refreshing the token, proceed to the rest of the function's body
        guard !refreshingToken else {
            return
        }
        
        // if this varibale's true, proceed, if it's not, then get out of the function
        guard shouldRefreshToken else {
            // this means we shouldn't refresh the token cause it's still valide
            completion?(true)
            return
        }
        
        // if we don't have refreshToken then stop
        // the old refresh token is required in order to get a new one
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        /// an API Call for refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        // now we are refreshing the token
        refreshingToken = true
        
        var components = URLComponents()
        // the body of the request has to contain these two fields
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // the header of the request, the content-type field
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // the body of the request using the query items we made above
        request.httpBody = components.query?.data(using: .utf8)
        
        // an Authorization header field that has to be base64 encoded
        // 1- the string value of the base64 header value
        let basicToken = Config.clientID+":"+Config.clientSecret
        // 2- make a data out of the string value above
        let data = basicToken.data(using: .utf8)
        // 3- make a base64String from the data above
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        // set the header value for this Authorization field
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        // now create the web request itself
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            // now the refreshing is done so stop it
            self?.refreshingToken = false
            
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                // get the json form of the data to see how the response looks like
                // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                // print("SUCCESS: \(json)")
                
                // decode the json response and cache it using UserDefaults
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed the Token")
                
                // execute each completion block and pass back the access token we got to it
                self?.onRefreshBlocks.forEach {
                    $0(result.access_token)
                }
                
                // now remove everything so we don't redandantly call one of the blocks again
                self?.onRefreshBlocks.removeAll()
                
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    
    // cache the decoded json response of the exchangeCodeForToken() function above
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        // unwrap this first before saving it in the UserDefaults
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(
            // the current time the user logs in + the number of seconds it expires in
            Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate"
        )
    }
    
}
