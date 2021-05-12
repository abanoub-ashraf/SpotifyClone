import Foundation

final class APICaller {
    
    // MARK: - Variables -
    
    static let shared  = APICaller()
    
    // MARK: - Init -
    
    private init() {}
    
    // MARK: - API Functions -
    
    //
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfileModel, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfileModel.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Enums -
    
    enum HTTPMethod: String {
        // String means each case will have a string value of its own name
        case GET
        case POST
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: - Helper Functions -
    
    // a generic request that every api call will be building on top of it
    // instead of repeating those lines inside of many times
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            
            completion(request)
        }
    }
}
