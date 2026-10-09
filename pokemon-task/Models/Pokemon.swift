import Foundation

struct PokemonType: Decodable {
    let type: TypeName
}

struct TypeName: Decodable {
    let name: String
}

struct PokemonCries: Decodable {
    let latest: String?
    let legacy: String?
}

struct Sprites: Decodable {
    let regularImage: String
    let shinyImage: String
    let femaleImage: String?
    let shinyFemaleImage: String?

    enum CodingKeys: String, CodingKey {
        case regularImage = "front_default"
        case shinyImage = "front_shiny"
        case femaleImage = "front_female"
        case shinyFemaleImage = "front_shiny_female"
    }
}

struct PokemonStat: Decodable {
    let baseStat: Int
    let stat: StatName

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatName: Decodable {
    let name: String
}

struct PokemonInfo: Decodable {
    let name: String
    let types: [PokemonType]
    let cries: PokemonCries
    let sprites: Sprites
    let height: Int
    let weight: Int
    let stats: [PokemonStat]
}

// Regional forms / Other
struct PokemonSpecies: Decodable {
    let varieties: [Variety]
}

struct Variety: Decodable {
    let isDefault: Bool
    let pokemon: VarietyReference

    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case pokemon
    }
}

struct VarietyReference: Decodable {
    let name: String
    let url: String
}


/*/
 In Swift, Foundation is the essential, core framework that provides a base layer of data types, internationalization utilities, and operating system services. While Swift's standard library handles basic tasks like standard text manipulation or basic logic, the Apple Foundation Documentation outlines the deeper capabilities needed to build functional, cross-platform apps.
 
 
 
 
 Enum forklart

 En enum (enumeration) er en type som representerer ett valg blant et fast sett med muligheter. Tenk på det som en offisiell liste over gyldige alternativer:

 swift
 enum Retning {
     case nord
     case sør
     case øst
     case vest
 }

 En variabel av typen Retning kan kun være én av disse fire verdiene — aldri noe annet, aldri flere samtidig. Sammenlign med en String, der du teoretisk kunne skrive "nordvest" eller "opp" eller stave feil — en enum lar Swift-kompilatoren garantere at bare gyldige verdier finnes.*/
