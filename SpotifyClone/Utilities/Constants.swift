import Foundation

struct Constants {
    
    // MARK: - API URLs -
    
    /// SignIn URL
    // these three are for the sign in url that the auth controller loads inside a web view
    static let baseURL     = "https://accounts.spotify.com/authorize"
    static let redirectURI = "https://github.com/abanoub-ashraf/SpotifyClone"
    static let scopes      = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
      
    /// API Token URL
    // for the two exchange code for token and the refresh token api calls
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    
    /// API BaseURL
    static let baseAPIURL = "https://api.spotify.com/v1"
    
    // MARK: - CollectionViewCells -
    
    static let newReleasesCollectionViewCellIdentifier       = "NewReleasesCollectionViewCell"
    static let featuredPlaylistsCollectionViewCellIdentifier = "FeaturedPlaylistsCollectionViewCell"
    static let recommendedTracksCollectionViewCellIdentifier = "RecommendedTracksCollectionViewCell"

}
