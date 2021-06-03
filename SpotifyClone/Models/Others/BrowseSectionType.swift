import Foundation

/// each case gonna be an array of elements for each section in the collection view
enum BrowseSectionType {
    /// each case will have that title variable we defined underneath the cases
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistsCellViewModel])
    case recommendedTracks(viewModels: [RecommendedTracksCellViewModel])
    
    /// use the value of this title to set the title of each section of the collection view
    var title: String {
        switch self {
            case .newReleases:
                return "New Released Albums"
            case .featuredPlaylists:
                return "Featured Playlists"
            case .recommendedTracks:
                return "Recommended Tracks"
        }
    }
}
