import Foundation

struct UserProfileModel: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let id: String
    let product: String
    let images: [UserImage]
}

struct UserImage: Codable {
    let url: String
}

/**
{
    country = EG;
    "display_name" = "Abanoub Ashraf";
    email = "abanoub.ashraf10@gmail.com";
    "explicit_content" =     {
        "filter_enabled" = 0;
        "filter_locked" = 0;
    };
    "external_urls" =     {
        spotify = "https://open.spotify.com/user/q8vf0xt7ln2i1ys502612e5yj";
    };
    followers =     {
        href = "<null>";
        total = 0;
    };
    href = "https://api.spotify.com/v1/users/q8vf0xt7ln2i1ys502612e5yj";
    id = q8vf0xt7ln2i1ys502612e5yj;
    images =     (
        {
            height = "<null>";
            url = "https://i.scdn.co/image/ab6775700000ee85edc41d31cce1fa03e303294f";
            width = "<null>";
        }
    );
    product = open;
    type = user;
    uri = "spotify:user:q8vf0xt7ln2i1ys502612e5yj";
}
*/
