import Foundation

struct ArtistModel: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
