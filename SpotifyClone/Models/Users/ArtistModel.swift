import Foundation

struct ArtistModel: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
    let followers: Followers?
    let genres: [String]?
    let popularity: Int?
}

/**
{
    "external_urls" =     {
        spotify = "https://open.spotify.com/artist/3TVXtAsR1Inumwj472S9r4";
    };
    followers =     {
        href = "<null>";
        total = 56123464;
    };
    genres =     (
        "canadian hip hop",
        "canadian pop",
        "hip hop",
        "pop rap",
        rap,
        "toronto rap"
    );
    href = "https://api.spotify.com/v1/artists/3TVXtAsR1Inumwj472S9r4";
    id = 3TVXtAsR1Inumwj472S9r4;
    images =     (
    {
    height = 640;
    url = "https://i.scdn.co/image/ab6761610000e5eb9d6c72d285ab349ce7a93529";
    width = 640;
    },
    {
    height = 320;
    url = "https://i.scdn.co/image/ab676161000051749d6c72d285ab349ce7a93529";
    width = 320;
    },
    {
    height = 160;
    url = "https://i.scdn.co/image/ab6761610000f1789d6c72d285ab349ce7a93529";
    width = 160;
    }
    );
    name = Drake;
    popularity = 98;
    type = artist;
    uri = "spotify:artist:3TVXtAsR1Inumwj472S9r4";
}
*/
