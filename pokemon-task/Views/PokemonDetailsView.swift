import SwiftUI

/// Viser detaljert info (bilde, typer, høyde, vekt, stats) om ett enkelt
/// Pokemon, hentet via `PokemonDetailsRepository`.
///
/// Legg merke til at viewen selv IKKE gjør noe nettverkskall direkte —
/// den ber bare `repository` om å hente dataen (`fetchDetailedPokemon`),
/// og leser deretter resultatet fra `repository.pokemon`. All kompleksitet
/// rundt URL-er, JSON-dekoding og feilhåndtering er gjemt bort i
/// Service/Repository-laget.
struct PokemonDetailsView: View {

    /// Hvilket Pokemon vi skal vise info om, sendt inn utenfra
    /// (f.eks. fra PokedexView, via NavigationLink).
    let pokemonID: Int

    /// Henter den DELTE repository-instansen som ble satt opp med
    /// .environment(...) på app-nivå, i stedet for å lage en ny selv.
    @Environment(PokemonDetailsRepository.self) private var repository

    var body: some View {
        ScrollView {
            if let pokemon = repository.pokemon {
                makePokemonView(pokemon: pokemon)
            } else {
                // Vises mens dataen fortsatt lastes inn
                ProgressView()
                    .padding(.top, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Pokémon-info")
        // .task(id: pokemonID) kjører automatisk på nytt hvis pokemonID
        // endrer seg mens viewen fortsatt vises (samme mønster som i
        // PokedexView sin .task(id: pokemonID)).
        .task(id: pokemonID) {
            await fetchDetailedPokemon()
        }
    }

    /// Selve layouten som bygges når dataen faktisk har kommet inn.
    /// Skilt ut som egen funksjon for å holde `body` ryddig.
    private func makePokemonView(pokemon: PokemonInfo) -> some View {
        VStack(spacing: 16) {
            Text(pokemon.name.capitalized)
                .font(.system(.title, design: .rounded, weight: .bold))

            AsyncImage(url: URL(string: pokemon.sprites.regularImage)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 150)
            }

            HStack(spacing: 12) {
                ForEach(pokemon.types, id: \.type.name) { type in
                    Text(type.type.name.capitalized)
                        .font(.caption.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.forPokemonType(type.type.name))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }

            HStack(spacing: 40) {
                VStack {
                    Text(String(format: "%.1f m", Double(pokemon.height) / 10))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text("Height")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                VStack {
                    Text(String(format: "%.1f kg", Double(pokemon.weight) / 10))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                    Text("Weight")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Stats")
                    .font(.headline)

                ForEach(pokemon.stats, id: \.stat.name) { stat in
                    HStack {
                        Text(stat.stat.name.capitalized)
                        Spacer()
                        Text("\(stat.baseStat)")
                            .bold()
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    /// Kaller repository for å faktisk hente data. Bruker do/catch her
    /// (i motsetning til PokemonService, som bare kaster feilen videre)
    /// fordi dette ER stedet der feilen faktisk skal håndteres/stoppe.
    private func fetchDetailedPokemon() async {
        do {
            try await repository.fetchDetailedPokemon(id: pokemonID)
        } catch {
            print("Error: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailsView(pokemonID: 25)
            .environment(PokemonDetailsRepository())
    }
}
