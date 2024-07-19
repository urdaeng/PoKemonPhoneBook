//
//  PokemonResult.swift
//  PhoneBook
//
//  Created by 강유정 on 7/15/24.
//

import Foundation

struct PokemonResult: Codable {
    // 가져오는 코드
    let pokemon: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}
