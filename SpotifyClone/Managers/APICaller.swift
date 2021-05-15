import Foundation

final class APICaller {
    
    // MARK: - Variables -
    
    static let shared  = APICaller()
    
    // MARK: - Init -
    
    private init() {}
    
    // MARK: - API Calls -
    
    // get the current user api call
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfileModel, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getCurrentUser),
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
    
    // get a list of new album releases featured in spotify
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getNewReleases),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // get a list of spotify featuredplaylists
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getFeaturedPlaylists),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // get a list of the recommended genres
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getRecommendedGenres),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // get recommendations based on given genres
    public func getRecommendations(
        genres: Set<String>,
        completion: @escaping (Result<RecommendationsResponse, Error>) -> Void
    ) {
        let seeds = genres.joined(separator: ",")
        
        createRequest(
            with: URL(string: Constants.EndPoints.getRecommendations + "&seed_genres=\(seeds)"),
            type: .GET
        ) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                    print(error)
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
