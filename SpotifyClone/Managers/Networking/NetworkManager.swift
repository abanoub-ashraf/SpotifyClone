import Foundation

final class NetworkManager {
    
    // MARK: - Variables
    
    static let shared  = NetworkManager()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Helper Functions
    
    ///
    /// a generic request that every api call will be building on top of it
    /// instead of repeating those lines inside of many times
    ///
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
    
    // MARK: - Users
    
    ///
    /// get the current logged in user
    ///
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
    
    // MARK: - Browse
    
    ///
    /// get a list of the recommended genres
    ///
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
    
    ///
    /// get recommendations based on given genres
    ///
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
    
    // MARK: - Playlists
    
    ///
    /// get a list of spotify featured playlists
    ///
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
    
    ///
    /// get a single playlist of the feature dplaylists
    ///
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
    
    // MARK: - Albums
    
    ///
    /// get a list of new album releases featured in spotify
    ///
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
    
    ///
    /// get a single album of the new released albums
    ///
    public func getAlbumDetails(
        for album: AlbumModel,
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
    
    // MARK: - Categories
    
    ///
    /// get all categories to display them in the SearchController
    ///
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
    
    ///
    /// get the playlists of a single category
    ///
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
    
    // MARK: - Search
    
    ///
    /// search for tracks, artists, albums, and playlists
    ///
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        // encode the url so if the suer enter a space it turns into a %20
        //
        let urlString = Constants.EndPoints.search + "&q=" + (query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        createRequest(
            with: URL(string: urlString),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
                    
                    /// this new struct will be an enum of 4 cases
                    /// the array of this struct represents the 4 elements in the SearchResultsResponse
                    /// each element has an array so this struct array will be of 4 arrays elements
                    ///
                    var searchResults: [SearchResult] = []
                    
                    /// each case is an element of the SearchResult enum array
                    /// each case represents an array of its own
                    /// make an array of (each case's array) from the results array we decoded from the api
                    ///
                    searchResults.append(contentsOf: results.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: results.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: results.artists.items.compactMap({ .artist(model: $0) }))
                    searchResults.append(contentsOf: results.playlists.items.compactMap({ .playlist(model: $0) }))
                    
                    completion(.success(searchResults))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - Library

    //---------------------------------------------------------------
    // Current User's Playlists
    //---------------------------------------------------------------
    
    ///
    /// get the current user's playlists from the api
    ///
    public func getCurrentUserPlaylists(completion: @escaping (Result<[PlaylistModel], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getCurrentUserPlaylists),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                    completion(.success(results.items))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    ///
    /// create a new playlist by the current user
    ///
    public func createNewPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        ///
        /// get the current user data first cause we need the current user's id
        ///
        getCurrentUserProfile { [weak self] result in
            switch result {
                case .success(let profile):
                    ///
                    /// pass the id of the current user to our actual api call to create a new playlist
                    ///
                    let urlString = Constants.EndPoints.createNewPlaylist + "\(profile.id)/playlists"
                    
                    self?.createRequest(
                        with: URL(string: urlString),
                        type: .POST
                    ) { baseRequest in
                        var request = baseRequest
                        
                        ///
                        /// this api call is a post request so we need a body which is the name
                        /// of the playlist we wanna create
                        ///
                        let jsonBody = ["name": name]
                        
                        ///
                        /// set the body of the api call with the name of the playlist we wanna create
                        ///
                        request.httpBody = try? JSONSerialization.data(
                            withJSONObject: jsonBody,
                            options: .fragmentsAllowed
                        )
                        
                        let task = URLSession.shared.dataTask(with: request) { data, _, error in
                            guard let data = data, error == nil else {
                                completion(false)
                                return
                            }
                            
                            do {
                                ///
                                /// this api call returns true if the new playlist is created and false
                                /// if it isn't so we converted the json into a dictionary and checked on the id
                                /// field of it, if it's not nil then we created a playlist
                                ///
                                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                if let response = result as? [String: Any], response["id"] as? String != nil {
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                            } catch {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        }
                        
                        task.resume()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    //---------------------------------------------------------------
    // Current User's Saved Labums
    //---------------------------------------------------------------
    
    ///
    /// get the saved albums of the current user
    ///
    public func getCurrentUserSavedAlbums(completion: @escaping (Result<[AlbumModel], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getCurrentUserSavedAlbums),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    completion(.success(result.items.compactMap({ $0.album })))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    ///
    /// save an album to the library
    ///
    public func saveAlbumToLibrary(album: AlbumModel, completion: @escaping (Bool) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.saveAlbumToLibrary + "?ids=\(album.id)"),
            type: .PUT
        ) { baseRequest in
            var request = baseRequest
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let _ = data,
                    let code = (response as? HTTPURLResponse)?.statusCode,
                    error == nil
                else {
                    completion(false)
                    return
                }
                
                completion(code == 200 ? true : false)
            }
            
            task.resume()
        }
    }
    
    public func removeAlbumFromLibrary(album: AlbumModel, completion: @escaping (Bool) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.removeAlbumFromLibrary + "?ids=\(album.id)"),
            type: .DELETE
        ) { baseRequest in
            var request = baseRequest
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let _ = data,
                    error == nil,
                    let code = (response as? HTTPURLResponse)?.statusCode
                else {
                    completion(false)
                    return
                }
                                
                completion(code == 200 ? true : false)
            }
            
            task.resume()
        }
    }
    
    // MARK: - Tracks
    
    ///
    /// add a track to a playlist
    ///
    public func addTrackToPlaylist(
        track: AudioTrackModel,
        playlist: PlaylistModel,
        completion: @escaping (Bool) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.EndPoints.addTrackToPlaylist + "\(playlist.id)/tracks"),
            type: .POST
        ) { baseRequest in
            var request = baseRequest
            
            let jsonBody = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: .fragmentsAllowed)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                    print(error.localizedDescription)
                }
            }
            
            task.resume()
        }
    }
    
    ///
    /// remove a track from a playlist
    ///
    public func removeTrackFromPlaylist(
        track: AudioTrackModel,
        playlist: PlaylistModel,
        completion: @escaping (Bool) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.EndPoints.removeTrackFromPlaylist + "\(playlist.id)/tracks"),
            type: .DELETE
        ) { baseRequest in
            var request = baseRequest
            
            let jsonBody = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: .fragmentsAllowed)
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                    print(error.localizedDescription)
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - Artists
    
    public func getArtistDetails(
        for artist: ArtistModel,
        completion: @escaping (Result<ArtistModel, Error>) -> Void
    ) {
        createRequest(
            with: URL(string: Constants.EndPoints.getArtistDetails + "\(artist.id)"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let artistData = try JSONDecoder().decode(ArtistModel.self, from: data)
                                        
                    completion(.success(artistData))
                } catch {
                    print(error.localizedDescription)
                    
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getArtistAlbums(for artist: ArtistModel, completion: @escaping (Result<[AlbumModel], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.EndPoints.getArtistAlbums + "\(artist.id)/albums?limit=50"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(AlbumsResponse.self, from: data)
                    
                    completion(.success(results.items))
                } catch {
                    print(error.localizedDescription)
                    
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }

}
