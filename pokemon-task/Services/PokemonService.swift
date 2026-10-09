import Foundation

struct PokemonService {

    func fetchDetailedPokemon(using id: Int) async throws -> PokemonInfo {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(PokemonInfo.self, from: data)
    }
}
/// `PokemonService` har kun ett ansvar: å hente rådata fra PokeAPI.
///
/// Den vet ingenting om @State, SwiftUI, eller hvordan dataen skal vises —
/// den bygger bare URL-en, gjør selve nettverkskallet, sjekker at responsen
/// var vellykket (statuskode 200), og dekoder JSON-en til en `PokemonInfo`.
///
/// Fordelen med å skille dette ut fra selve viewen (slik vi gjorde i
/// PokedexView tidligere) er at flere views kan gjenbruke akkurat denne
/// koden uten å duplisere URL-bygging/feilhåndtering flere steder.
///
/// Bruker `async throws` i stedet for do/catch her inni — feilen sendes
/// videre ("propagerer") til den som kaller funksjonen (i vårt tilfelle:
/// `PokemonDetailRepository`), som selv avgjør hvordan feilen skal håndteres.
