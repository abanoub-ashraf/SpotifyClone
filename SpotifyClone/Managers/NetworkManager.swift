import Foundation

final class NetworkManager {
    
    // MARK: - Variables -
    
    static let shared  = NetworkManager()
    
    // MARK: - Init -
    
    private init() {}
    
    // MARK: - Enums -
    
    private enum HTTPMethod: String {
        // String means each case will have a string value of its own name
        case GET
        case POST
    }
    
    private enum APIError: Error {
        case failedToGetData
    }
    
    // MARK: - Helper Functions -
    
    // a generic request that every api call will be building on top of it
    // instead of repeating those lines inside of many times
    //
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
    
    // MARK: - Users -
    
    // get the current logged in user
    //
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
    
    // MARK: - Browse -
    
    // get a list of the recommended genres
    //
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
    //
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
    
    // MARK: - Playlists -
    
    // get a list of spotify featured playlists
    //
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
    
    // get a single playlist of the feature dplaylists
    //
    public func getPlaylistDetails(
        for playlist: PlaylistModel,
        completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.EndPoints.getPlaylistDetails + playlist.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Albums -
    
    // get a list of new album releases featured in spotify
    //
    public func getNewAlbumsReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
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
    
    // get a single album of the new released albums
    //
    public func getAlbumDetails(
        for album: Album,
        completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.EndPoints.getAlbumDetails + album.id),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Categories -
    
    // get all categories to display them in the SearchController
    //
    public func getCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getCategories),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    // get the playlists of a single category
    //
    public func getCategoryPlaylists(
        category: CategoryModel,
        completion: @escaping (Result<[PlaylistModel], Error>) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.EndPoints.getCategoryPlaylists + category.id + "/playlists?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
}
