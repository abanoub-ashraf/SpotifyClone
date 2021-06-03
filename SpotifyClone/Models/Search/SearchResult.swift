import Foundation

/// each case takes an array of what we got from the search, in the SearchResultsResponse file
///
enum SearchResult {
    case artist(model: ArtistModel)
    case album(model: AlbumModel)
    case track(model: AudioTrackModel)
    case playlist(model: PlaylistModel)
}
