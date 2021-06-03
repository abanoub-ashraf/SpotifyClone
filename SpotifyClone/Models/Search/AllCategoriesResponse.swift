import Foundation

struct AllCategoriesResponse: Codable {
    let categories: CategoriesModel
}

struct CategoriesModel: Codable {
    let items: [CategoryModel]
}

struct CategoryModel: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}

/**
{
    categories =     {
        href = "https://api.spotify.com/v1/browse/categories?offset=0&limit=2";
        items =         (
                        {
                href = "https://api.spotify.com/v1/browse/categories/toplists";
                icons =                 (
                                        {
                        height = 275;
                        url = "https://t.scdn.co/media/derived/toplists_11160599e6a04ac5d6f2757f5511778f_0_0_275_275.jpg";
                        width = 275;
                    }
                );
                id = toplists;
                name = "Top Lists";
            },
                        {
                href = "https://api.spotify.com/v1/browse/categories/at_home";
                icons =                 (
                                        {
                        height = "<null>";
                        url = "https://t.scdn.co/images/04da469dd7be4dab96659aa1fa9f0ac9.jpeg";
                        width = "<null>";
                    }
                );
                id = "at_home";
                name = "At Home";
            }
        );
        limit = 2;
        next = "https://api.spotify.com/v1/browse/categories?offset=2&limit=2";
        offset = 0;
        previous = "<null>";
        total = 49;
    };
}
*/
