import Foundation

/// struct for each section in the table view of the settings controller
struct Section {
    let title: String
    let options: [Option]
}

/// struct for the options of each section above
struct Option {
    let title: String
    // a handler for every given option
    // it's gonna fer called from the didSelectRowAt() function
    let handler: () -> Void
}
