import Foundation

/// turn a given string into a date
/// then turn that date back to a better formatted string again
extension DateFormatter {
    
    /// first convert the date into a string
    // better be static cause we better create it once cause it's a heavy object on memory
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // this string should match the date string comes from the api
        dateFormatter.dateFormat = "YYY-MM-dd"
        return dateFormatter
    }()
    
    /// to display the converted string in a different style
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
}

extension String {
    
    /// convert the string into a date
    static func formattedDate(string: String) -> String {
        // create a date from the given string
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        /// we created .displayDateFormatter above
        return DateFormatter.displayDateFormatter.string(from: date)
    }
    
}
