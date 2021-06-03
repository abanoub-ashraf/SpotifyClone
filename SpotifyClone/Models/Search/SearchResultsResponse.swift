import Foundation

struct SearchResultsResponse: Codable {
    let albums: SearchAlbumsResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumsResponse: Codable {
    let items: [AlbumModel]
}

struct SearchArtistsResponse: Codable {
    let items: [ArtistModel]
}

struct SearchPlaylistsResponse: Codable {
    let items: [PlaylistModel]
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrackModel]
}
