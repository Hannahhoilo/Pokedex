import Foundation

/// `PokemonDetailRepository` er mellomlaget mellom `PokemonService` (som
/// bare henter rå data) og selve UI-en (som skal vise dataen).
///
/// Den er markert `@Observable`, som betyr at enhver view som leser
/// `pokemon`-propertyen automatisk oppdaterer seg når verdien endrer seg —
/// akkurat samme prinsipp som `StoreFavourites` bruker for favorittlisten.
///
/// Fordi den er en KLASSE (ikke en struct), kan én og samme instans deles
/// mellom flere views via `.environment(...)`, slik at alle som leser fra
/// den ser samme, oppdaterte data.
///
/// `private(set)` betyr at hvem som helst kan LESE `pokemon` utenfra, men
/// bare koden inni selve `PokemonDetailRepository` kan faktisk SETTE den —
/// dette hindrer at en view "jukser" og endrer dataen direkte, den må gå
/// via `fetchDetailedPokemon(id:)`.
@Observable
class PokemonDetailsRepository {

    private(set) var pokemon: PokemonInfo?

    /// Repository "eier" sin egen Service-instans, og bruker den til å
    /// faktisk gjøre nettverkskallet. Viewen selv trenger aldri å vite at
    /// PokemonService eksisterer.
    private let pokemonService = PokemonService()

    func fetchDetailedPokemon(id: Int) async throws {
        pokemon = try await pokemonService.fetchDetailedPokemon(using: id)
    }
}


// forventet at alle repositories man lager følger en protokol!!!

