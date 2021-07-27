import Foundation

struct LibraryPlaylistsResponse: Codable {
    let items: [PlaylistModel]
}


/**
 {
    href = "https://api.spotify.com/v1/users/q8vf0xt7ln2i1ys502612e5yj/playlists?offset=0&limit=50";
    items =     (
        {
            collaborative = 0;
            description = "";
            "external_urls" =             {
                spotify = "https://open.spotify.com/playlist/11k8uW0iQWFaBGyqBbPgGI";
            };
            href = "https://api.spotify.com/v1/playlists/11k8uW0iQWFaBGyqBbPgGI";
            id = 11k8uW0iQWFaBGyqBbPgGI;
            images =             (
            {
            height = 640;
            url = "https://i.scdn.co/image/ab67616d0000b273f907de96b9a4fbc04accc0d5";
            width = 640;
            }
            );
            name = "My Playlist #3";
            owner =             {
                "display_name" = "Abanoub Ashraf";
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/user/q8vf0xt7ln2i1ys502612e5yj";
                };
                href = "https://api.spotify.com/v1/users/q8vf0xt7ln2i1ys502612e5yj";
                id = q8vf0xt7ln2i1ys502612e5yj;
                type = user;
                uri = "spotify:user:q8vf0xt7ln2i1ys502612e5yj";
            };
            "primary_color" = "<null>";
            public = 0;
            "snapshot_id" = NCwwNWViZjdlMWVhMzY4NWVlMzM2NWUwNWU3MTg1M2UyNTI1ODE5OWIx;
            tracks =             {
                href = "https://api.spotify.com/v1/playlists/11k8uW0iQWFaBGyqBbPgGI/tracks";
                total = 3;
            };
            type = playlist;
            uri = "spotify:playlist:11k8uW0iQWFaBGyqBbPgGI";
        },
        {
            collaborative = 0;
            description = test;
            "external_urls" =             {
                spotify = "https://open.spotify.com/playlist/1P0t10fPRvpw0BIonb87Ci";
            };
            href = "https://api.spotify.com/v1/playlists/1P0t10fPRvpw0BIonb87Ci";
            id = 1P0t10fPRvpw0BIonb87Ci;
            images =             (
            {
            height = 640;
            url = "https://mosaic.scdn.co/640/ab67616d0000b273095191f6b96fd9eff585befcab67616d0000b2734471db1db53e3124151f280bab67616d0000b27375af9fb0fa8dc8f3adef6905ab67616d0000b273c80c5250bbf0812e0c3dad0e";
            width = 640;
            },
            {
            height = 300;
            url = "https://mosaic.scdn.co/300/ab67616d0000b273095191f6b96fd9eff585befcab67616d0000b2734471db1db53e3124151f280bab67616d0000b27375af9fb0fa8dc8f3adef6905ab67616d0000b273c80c5250bbf0812e0c3dad0e";
            width = 300;
            },
            {
            height = 60;
            url = "https://mosaic.scdn.co/60/ab67616d0000b273095191f6b96fd9eff585befcab67616d0000b2734471db1db53e3124151f280bab67616d0000b27375af9fb0fa8dc8f3adef6905ab67616d0000b273c80c5250bbf0812e0c3dad0e";
            width = 60;
            }
            );
            name = "My Playlist #2";
            owner =             {
                "display_name" = "Abanoub Ashraf";
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/user/q8vf0xt7ln2i1ys502612e5yj";
                };
                href = "https://api.spotify.com/v1/users/q8vf0xt7ln2i1ys502612e5yj";
                id = q8vf0xt7ln2i1ys502612e5yj;
                type = user;
                uri = "spotify:user:q8vf0xt7ln2i1ys502612e5yj";
            };
            "primary_color" = "<null>";
            public = 0;
            "snapshot_id" = OCw0MjM2MDI5ODZiMzFiOTJlOGZhMDExNDY1ZTZmOWViMTk1ZmM2YmFh;
            tracks =             {
                href = "https://api.spotify.com/v1/playlists/1P0t10fPRvpw0BIonb87Ci/tracks";
                total = 6;
            };
            type = playlist;
            uri = "spotify:playlist:1P0t10fPRvpw0BIonb87Ci";
        },
        {
            collaborative = 0;
            description = "Beautiful songs to break your heart...";
            "external_urls" =             {
                spotify = "https://open.spotify.com/playlist/37i9dQZF1DX7qK8ma5wgG1";
            };
            href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX7qK8ma5wgG1";
            id = 37i9dQZF1DX7qK8ma5wgG1;
            images =             (
            {
            height = "<null>";
            url = "https://i.scdn.co/image/ab67706f000000033c6c5a76712dd683af373183";
            width = "<null>";
            }
            );
            name = "Sad Songs";
            owner =             {
                "display_name" = Spotify;
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/user/spotify";
                };
                href = "https://api.spotify.com/v1/users/spotify";
                id = spotify;
                type = user;
                uri = "spotify:user:spotify";
            };
            "primary_color" = "<null>";
            public = 0;
            "snapshot_id" = MTYyNjc5MzE3MywwMDAwMDA4MzAwMDAwMTdhYzQ2ZGUwYTEwMDAwMDE3MTU5NjI5ZDI4;
            tracks =             {
                href = "https://api.spotify.com/v1/playlists/37i9dQZF1DX7qK8ma5wgG1/tracks";
                total = 60;
            };
            type = playlist;
            uri = "spotify:playlist:37i9dQZF1DX7qK8ma5wgG1";
        },
        {
            collaborative = 0;
            description = "";
            "external_urls" =             {
                spotify = "https://open.spotify.com/playlist/0Xh9VOQWY8jXM6FCEMZ8RW";
            };
            href = "https://api.spotify.com/v1/playlists/0Xh9VOQWY8jXM6FCEMZ8RW";
            id = 0Xh9VOQWY8jXM6FCEMZ8RW;
            images =             (
            {
            height = 640;
            url = "https://mosaic.scdn.co/640/ab67616d0000b2730c13d3d5a503c84fcc60ae94ab67616d0000b2736eb0b9e73adcf04e4ed3eca4ab67616d0000b273a108e07c661f9fc54de9c43aab67616d0000b273ad8a1115cf43f3ca4617226e";
            width = 640;
            },
            {
            height = 300;
            url = "https://mosaic.scdn.co/300/ab67616d0000b2730c13d3d5a503c84fcc60ae94ab67616d0000b2736eb0b9e73adcf04e4ed3eca4ab67616d0000b273a108e07c661f9fc54de9c43aab67616d0000b273ad8a1115cf43f3ca4617226e";
            width = 300;
            },
            {
            height = 60;
            url = "https://mosaic.scdn.co/60/ab67616d0000b2730c13d3d5a503c84fcc60ae94ab67616d0000b2736eb0b9e73adcf04e4ed3eca4ab67616d0000b273a108e07c661f9fc54de9c43aab67616d0000b273ad8a1115cf43f3ca4617226e";
            width = 60;
            }
            );
            name = Favorites;
            owner =             {
                "display_name" = "Abanoub Ashraf";
                "external_urls" =                 {
                    spotify = "https://open.spotify.com/user/q8vf0xt7ln2i1ys502612e5yj";
                };
                href = "https://api.spotify.com/v1/users/q8vf0xt7ln2i1ys502612e5yj";
                id = q8vf0xt7ln2i1ys502612e5yj;
                type = user;
                uri = "spotify:user:q8vf0xt7ln2i1ys502612e5yj";
            };
            "primary_color" = "<null>";
            public = 1;
            "snapshot_id" = "MTAsYjE1M2NjMDJkMzE1NjM1YjZmNjg5MjM5MTZjZjQ5MGEyOGNkYWJhZA==";
            tracks =             {
                href = "https://api.spotify.com/v1/playlists/0Xh9VOQWY8jXM6FCEMZ8RW/tracks";
                total = 9;
            };
            type = playlist;
            uri = "spotify:playlist:0Xh9VOQWY8jXM6FCEMZ8RW";
        }
    );
    limit = 50;
    next = "<null>";
    offset = 0;
    previous = "<null>";
    total = 4;
}
*/
