import Foundation

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
    
}

struct PlaylistItem: Codable {
    let track: AudioTrackModel
}

/// this is the tracks property in the PlaylistDetailsResponse file
/**
 "tracks": {
     "href": "https://api.spotify.com/v1/users/spotify/playlists/59ZbFPES4DQwEjBpWHzrtC/tracks",
     "items": [
         {
             "added_at": "2014-09-01T04:21:28Z",
             "added_by": {
                 "external_urls": {
                     "spotify": "http://open.spotify.com/user/spotify"
                 },
                 "href": "https://api.spotify.com/v1/users/spotify",
                 "id": "spotify",
                 "type": "user",
                 "uri": "spotify:user:spotify"
             },
             "is_local": false,
             "track": {
                 "album": {
                     "album_type": "single",
                     "available_markets": [
                         "AD",
                         "AR",
                         "AT",
                         "AU",
                         "BE",
                         "BG",
                         "BO",
                         "BR",
                         "CH",
                         "CL",
                         "CO",
                         "CR",
                         "CY",
                         "CZ",
                         "DK",
                         "DO",
                         "EC",
                         "EE",
                         "ES",
                         "FI",
                         "FR",
                         "GB",
                         "GR",
                         "GT",
                         "HK",
                         "HN",
                         "HU",
                         "IE",
                         "IS",
                         "IT",
                         "LI",
                         "LT",
                         "LU",
                         "LV",
                         "MC",
                         "MT",
                         "MY",
                         "NI",
                         "NL",
                         "NO",
                         "NZ",
                         "PA",
                         "PE",
                         "PH",
                         "PL",
                         "PT",
                         "PY",
                         "RO",
                         "SE",
                         "SG",
                         "SI",
                         "SK",
                         "SV",
                         "TR",
                         "TW",
                         "UY"
                     ],
                     "external_urls": {
                         "spotify": "https://open.spotify.com/album/5GWoXPsTQylMuaZ84PC563"
                     },
                     "href": "https://api.spotify.com/v1/albums/5GWoXPsTQylMuaZ84PC563",
                     "id": "5GWoXPsTQylMuaZ84PC563",
                     "images": [
                         {
                             "height": 640,
                             "url": "https://i.scdn.co/image/47421900e7534789603de84c03a40a826c058e45",
                             "width": 640
                         },
                         {
                             "height": 300,
                             "url": "https://i.scdn.co/image/0d447b6faae870f890dc5780cc58d9afdbc36a1d",
                             "width": 300
                         },
                         {
                             "height": 64,
                             "url": "https://i.scdn.co/image/d926b3e5f435ef3ac0874b1ff1571cf675b3ef3b",
                             "width": 64
                         }
                     ],
                     "name": "I''m Not The Only One",
                     "type": "album",
                     "uri": "spotify:album:5GWoXPsTQylMuaZ84PC563"
                 },
                 "artists": [
                     {
                         "external_urls": {
                             "spotify": "https://open.spotify.com/artist/2wY79sveU1sp5g7SokKOiI"
                         },
                         "href": "https://api.spotify.com/v1/artists/2wY79sveU1sp5g7SokKOiI",
                         "id": "2wY79sveU1sp5g7SokKOiI",
                         "name": "Sam Smith",
                         "type": "artist",
                         "uri": "spotify:artist:2wY79sveU1sp5g7SokKOiI"
                     }
                 ],
                 "available_markets": [
                     "AD",
                     "AR",
                     "AT",
                     "AU",
                     "BE",
                     "BG",
                     "BO",
                     "BR",
                     "CH",
                     "CL",
                     "CO",
                     "CR",
                     "CY",
                     "CZ",
                     "DK",
                     "DO",
                     "EC",
                     "EE",
                     "ES",
                     "FI",
                     "FR",
                     "GB",
                     "GR",
                     "GT",
                     "HK",
                     "HN",
                     "HU",
                     "IE",
                     "IS",
                     "IT",
                     "LI",
                     "LT",
                     "LU",
                     "LV",
                     "MC",
                     "MT",
                     "MY",
                     "NI",
                     "NL",
                     "NO",
                     "NZ",
                     "PA",
                     "PE",
                     "PH",
                     "PL",
                     "PT",
                     "PY",
                     "RO",
                     "SE",
                     "SG",
                     "SI",
                     "SK",
                     "SV",
                     "TR",
                     "TW",
                     "UY"
                 ],
                 "disc_number": 1,
                 "duration_ms": 204732,
                 "explicit": false,
                 "external_ids": {
                     "isrc": "GBUM71403920"
                 },
                 "external_urls": {
                     "spotify": "https://open.spotify.com/track/4i9sYtSIlR80bxje5B3rUb"
                 },
                 "href": "https://api.spotify.com/v1/tracks/4i9sYtSIlR80bxje5B3rUb",
                 "id": "4i9sYtSIlR80bxje5B3rUb",
                 "name": "I''m Not The Only One - Radio Edit",
                 "popularity": 45,
                 "preview_url": "https://p.scdn.co/mp3-preview/dd64cca26c69e93ea78f1fff2cc4889396bb6d2f",
                 "track_number": 1,
                 "type": "track",
                 "uri": "spotify:track:4i9sYtSIlR80bxje5B3rUb"
             }
         }
     ],
     "limit": 100,
     "next": "https://api.spotify.com/v1/users/spotify/playlists/59ZbFPES4DQwEjBpWHzrtC/tracks?offset=100&limit=100",
     "offset": 0,
     "previous": null,
     "total": 105
 }
*/
