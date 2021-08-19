//
//  MovieCreditsResult.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-18.
//

import Foundation

struct MovieCreditsResult: Decodable {
    let cast: [CastMember]?
    let crew: [CrewMember]?
    
    var castString: String? {
        guard let cast = cast else { return nil }
        return cast.map { "\($0.name) (\($0.character))" }.joined(separator: ", ")
    }
    
    var crewString: String? {
        guard let crew = crew else { return nil }
        return crew.map { "\($0.name) (\($0.job))" }.joined(separator: ", ")
    }
}
