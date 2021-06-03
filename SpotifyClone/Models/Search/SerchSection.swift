import Foundation

/// each section of the table view inside the SearchResultsController
/// each section will ahve a title and array of items
///
struct SearchSection {
    let title: String
    let results: [SearchResult]
}
