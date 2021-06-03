import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [AlbumModel]
}

struct AlbumModel: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [ArtistModel]
}

/**
{
    albums =     {
        href = "https://api.spotify.com/v1/browse/new-releases?offset=0&limit=2";
        items =         (
            {
                "album_type" = single;
                artists =                 (
                    {
                        "external_urls" =                         {
                            spotify = "https://open.spotify.com/artist/6l3HvQ5sa6mXTsMTB19rO5";
                        };
                        href = "https://api.spotify.com/v1/artists/6l3HvQ5sa6mXTsMTB19rO5";
                        id = 6l3HvQ5sa6mXTsMTB19rO5;
                        name = "J. Cole";
                        type = artist;
                        uri = "spotify:artist:6l3HvQ5sa6mXTsMTB19rO5";
                    }
                );
                "available_markets" =                 (
                    XK,
                    ZA,
                    ZM,
                    ZW
                );
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/album/0WvwihMfA5E29MrLyNpJYF";
                };
                href = "https://api.spotify.com/v1/albums/0WvwihMfA5E29MrLyNpJYF";
                id = 0WvwihMfA5E29MrLyNpJYF;
                images =                 (
                {
                height = 640;
                url = "https://i.scdn.co/image/ab67616d0000b27339eacaff515486b4b531d2f4";
                width = 640;
                },
                {
                height = 300;
                url = "https://i.scdn.co/image/ab67616d00001e0239eacaff515486b4b531d2f4";
                width = 300;
                },
                {
                height = 64;
                url = "https://i.scdn.co/image/ab67616d0000485139eacaff515486b4b531d2f4";
                width = 64;
                }
                );
                name = "i n t e r l u d e";
                "release_date" = "2021-05-07";
                "release_date_precision" = day;
                "total_tracks" = 1;
                type = album;
                uri = "spotify:album:0WvwihMfA5E29MrLyNpJYF";
        },
            {
                "album_type" = album;
                artists =                 (
                    {
                        "external_urls" =                         {
                            spotify = "https://open.spotify.com/artist/64M6ah0SkkRsnPGtGiRAbb";
                        };
                        href = "https://api.spotify.com/v1/artists/64M6ah0SkkRsnPGtGiRAbb";
                        id = 64M6ah0SkkRsnPGtGiRAbb;
                        name = "Bebe Rexha";
                        type = artist;
                        uri = "spotify:artist:64M6ah0SkkRsnPGtGiRAbb";
                    }
                );
                "available_markets" =                 (
                    ZA,
                    ZM,
                    ZW
                );
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/album/1v0new1LT7TVddV7dBIAmo";
                };
                href = "https://api.spotify.com/v1/albums/1v0new1LT7TVddV7dBIAmo";
                id = 1v0new1LT7TVddV7dBIAmo;
                images =                 (
                {
                height = 640;
                url = "https://i.scdn.co/image/ab67616d0000b273f6a6f6a1485a9b163dedc618";
                width = 640;
                },
                {
                height = 300;
                url = "https://i.scdn.co/image/ab67616d00001e02f6a6f6a1485a9b163dedc618";
                width = 300;
                },
                {
                height = 64;
                url = "https://i.scdn.co/image/ab67616d00004851f6a6f6a1485a9b163dedc618";
                width = 64;
                }
                );
                name = "Better Mistakes";
                "release_date" = "2021-05-07";
                "release_date_precision" = day;
                "total_tracks" = 13;
                type = album;
                uri = "spotify:album:1v0new1LT7TVddV7dBIAmo";
        }
        );
        limit = 2;
        next = "https://api.spotify.com/v1/browse/new-releases?offset=2&limit=2";
        offset = 0;
        previous = "<null>";
        total = 99;
    };
}
*/
