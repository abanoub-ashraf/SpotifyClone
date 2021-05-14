import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistsResponse
}

struct PlaylistsResponse: Codable {
    let items: [PlaylistModel]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

/**
{
    message = "Editor's picks";
    playlists =     {
        href = "https://api.spotify.com/v1/browse/featured-playlists?timestamp=2021-05-13T17%3A23%3A20&offset=0&limit=2";
        items =         (
                        {
                collaborative = 0;
                description = "Listen to all the tracks you've been missing. Cover: The Weeknd";
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DX0s5kDXi1oC5";
                };
                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX0s5kDXi1oC5";
                id = 37i9dQZF1DX0s5kDXi1oC5;
                images =                 (
                                        {
                        height = "<null>";
                        url = "https://i.scdn.co/image/ab67706f00000003ca64210a23622427ec19c4a6";
                        width = "<null>";
                    }
                );
                name = "Hit Rewind";
                owner =                 {
                    "display_name" = Spotify;
                    "external_urls" =                     {
                        spotify = "https://open.spotify.com/user/spotify";
                    };
                    href = "https://api.spotify.com/v1/users/spotify";
                    id = spotify;
                    type = user;
                    uri = "spotify:user:spotify";
                };
                "primary_color" = "<null>";
                public = "<null>";
                "snapshot_id" = MTYyMDkyNjU3NiwwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl;
                tracks =                 {
                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX0s5kDXi1oC5/tracks";
                    total = 75;
                };
                type = playlist;
                uri = "spotify:playlist:37i9dQZF1DX0s5kDXi1oC5";
            },
                        {
                collaborative = 0;
                description = "Rock legends and epic songs that continue to inspire generations.";
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/playlist/37i9dQZF1DWXRqgorJj26U";
                };
                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DWXRqgorJj26U";
                id = 37i9dQZF1DWXRqgorJj26U;
                images =                 (
                                        {
                        height = "<null>";
                        url = "https://i.scdn.co/image/ab67706f00000003519fc8771d90f496501a4da3";
                        width = "<null>";
                    }
                );
                name = "Rock Classics";
                owner =                 {
                    "display_name" = Spotify;
                    "external_urls" =                     {
                        spotify = "https://open.spotify.com/user/spotify";
                    };
                    href = "https://api.spotify.com/v1/users/spotify";
                    id = spotify;
                    type = user;
                    uri = "spotify:user:spotify";
                };
                "primary_color" = "<null>";
                public = "<null>";
                "snapshot_id" = MTYxNzgyNDgxNiwwMDAwMDA1ODAwMDAwMTc4YWRkZjliYjcwMDAwMDE3M2ZlNjNkYjRm;
                tracks =                 {
                    href = "https://api.spotify.com/v1/playlists/37i9dQZF1DWXRqgorJj26U/tracks";
                    total = 145;
                };
                type = playlist;
                uri = "spotify:playlist:37i9dQZF1DWXRqgorJj26U";
            }
        );
        limit = 2;
        next = "https://api.spotify.com/v1/browse/featured-playlists?timestamp=2021-05-13T17%3A23%3A20&offset=2&limit=2";
        offset = 0;
        previous = "<null>";
        total = 12;
    };
}
*/
