import Foundation
import UIKit

struct Constants {
    
    // MARK: - API URLs -
    
    ///
    /// - SignIn URL
    ///
    /// - these three are for the sign in url that the auth controller loads inside a web view
    ///
    static let baseURL     = "https://accounts.spotify.com/authorize"
    static let redirectURI = "https://github.com/abanoub-ashraf/SpotifyClone"
    static let scopes      = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
      
    ///
    /// - API Token URL
    ///
    /// - for the two exchange code for token and the refresh token api calls
    ///
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    
    ///
    /// API BaseURL
    ///
    static let baseAPIURL = "https://api.spotify.com/v1"
    
    // MARK: - API EndPoints
    
    struct EndPoints {
        
        ///
        /// Users
        ///
        static let getCurrentUser = "\(Constants.baseAPIURL)/me"
        
        ///
        /// Browse
        ///
        static let getRecommendedGenres = "\(Constants.baseAPIURL)/recommendations/available-genre-seeds"
        static let getRecommendations   = "\(Constants.baseAPIURL)/recommendations?limit=40"
        
        ///
        /// Albums
        ///
        static let getNewReleases  = "\(Constants.baseAPIURL)/browse/new-releases?limit=50"
        static let getAlbumDetails = "\(Constants.baseAPIURL)/albums/"
        
        ///
        /// Playlists
        ///
        static let getFeaturedPlaylists = "\(Constants.baseAPIURL)/browse/featured-playlists?limit=50"
        static let getPlaylistDetails   = "\(Constants.baseAPIURL)/playlists/"
        
        ///
        /// Categories
        ///
        static let getCategories        = "\(Constants.baseAPIURL)/browse/categories?limit=50"
        static let getCategoryPlaylists = "\(Constants.baseAPIURL)/browse/categories/"
        
        ///
        /// Search
        ///
        static let search = "\(Constants.baseAPIURL)/search?limit=20&type=album,artist,playlist,track"
        
        ///
        /// Library
        ///
        static let getCurrentUserPlaylists = "\(Constants.baseAPIURL)/me/playlists?limit=50"
        static let createNewPlaylist       = "\(Constants.baseAPIURL)/users/"
        
    }
    
    // MARK: - CollectionViews
    
    ///
    /// collection view cells
    ///
    static let newReleasesCollectionViewCellIdentifier       = "NewReleasesCollectionViewCell"
    static let featuredPlaylistsCollectionViewCellIdentifier = "FeaturedPlaylistsCollectionViewCell"
    static let recommendedTracksCollectionViewCellIdentifier = "RecommendedTracksCollectionViewCell"
    static let albumTracksCollectionViewCellIdentifier       = "AlbumTracksCollectionViewCell"
    static let CategoryCollectionViewCellIdentifier          = "CategoryCollectionViewCell"
    
    ///
    /// sections headers
    ///
    static let playlistCollectionViewHeaderIdentifier = "PlaylistHeader"
    static let titleCollectionViewHeaderIdentifier    = "TitleHeader"
    
    // MARK: - TableViews
    
    static let searchResultDefaultTableCell  = "SearchResultDefaultTableCell"
    static let searchResultSubtitleTableCell = "SearchResultSubtitleTableCell"
    
    // MARK: - Images
    
    struct Images {
        ///
        /// image placeholders
        ///
        static let newReleasesPlaceholderImage = UIImage(named: "newReleasesPlaceholder")
        static let playlistsPlaceholderImage   = UIImage(named: "playlistsPlaceholder")
        static let personPlaceholderImage      = UIImage(named: "personPlaceholder")
        static let albumCoverPlaceholder       = UIImage(named: "albumCoverPlaceholder")

         static let pauseImage = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        
        static let playImage = UIImage(
            systemName: "play",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
    }
    
    // MARK: - Colors
    
    static let mainColor = UIColor(named: "mainColor")

}
