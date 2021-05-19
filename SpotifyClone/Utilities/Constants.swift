import Foundation
import UIKit

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
    
    // MARK: - EndPoints -
    
    struct EndPoints {
        
        static let getCurrentUser       = "\(Constants.baseAPIURL)/me"
        static let getNewReleases       = "\(Constants.baseAPIURL)/browse/new-releases?limit=50"
        static let getFeaturedPlaylists = "\(Constants.baseAPIURL)/browse/featured-playlists?limit=50"
        static let getRecommendedGenres = "\(Constants.baseAPIURL)/recommendations/available-genre-seeds"
        static let getRecommendations   = "\(Constants.baseAPIURL)/recommendations?limit=40"
        
    }
    
    // MARK: - CollectionViewCells -
    
    static let newReleasesCollectionViewCellIdentifier       = "NewReleasesCollectionViewCell"
    static let featuredPlaylistsCollectionViewCellIdentifier = "FeaturedPlaylistsCollectionViewCell"
    static let recommendedTracksCollectionViewCellIdentifier = "RecommendedTracksCollectionViewCell"
    
    // MARK: - Colors -
    
    static let mainColor = UIColor(named: "mainColor")
    
    // MARK: - Images -
    
    static let newReleasesPlaceholderImage = UIImage(named: "newReleasesPlaceholder")
    static let playlistsPlaceholderImage   = UIImage(named: "playlistsPlaceholder")

}
