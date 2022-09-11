//
//  DateFormatterHelper.swift
//  UniverseGalleryApp
//
//  Created by Kumar, Sawant on 09/09/22.
//

import Foundation

protocol DateParser {
    func parseToString(date: Date) -> String
    func parseToString(date: Date, format: String) -> String
}

protocol DateParserValidator {
    func validate(_ dateInString: String) -> String
}

class DateParserValidatorImpl : DateParserValidator {
    internal func validate(_ dateInString: String) -> String {
        if dateInString.isEmpty {
            fatalError("EMPTY DATE IN STRING")
        }
        return dateInString
    }
}


class DateFormatterHelper: DateParser {
    private var dateFormatter: DateFormatter!
    private var dateParserValidator: DateParserValidator!
    private let DEFAULT_FORMAT = "yyyy-MM-dd"
    
    init() {
        dateFormatter = DateFormatter()
        dateParserValidator = DateParserValidatorImpl()
        setDefaultFormat()
    }
    
    func parseToString(date: Date) -> String {
        let dateInString = dateFormatter.string(from: date)
        return dateParserValidator.validate(dateInString)
    }
    
    func parseToString(date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return parseToString(date: date)
    }
    
    private func setDefaultFormat() {
        dateFormatter.dateFormat = DEFAULT_FORMAT
    }
}
