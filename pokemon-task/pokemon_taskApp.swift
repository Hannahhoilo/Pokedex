import SwiftUI

@main
struct pokemon_taskApp: App {
    @State private var pokemonDetailsRepository = PokemonDetailsRepository()

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(pokemonDetailsRepository)
        }
    }
}
