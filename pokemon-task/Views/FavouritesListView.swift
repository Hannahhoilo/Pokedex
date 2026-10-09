import SwiftUI

struct FavouritesListView: View {
    @Environment(StoreFavourites.self) var storeFavourites
    @State private var pokemonNames: [Int: String] = [:]

    @State private var isShowingDeleteAlert = false
    @State private var pendingDeleteID: Int?
    @State private var pendingDeleteName: String?

    var body: some View {
        List {
            ForEach(storeFavourites.favouriteIDs, id: \.self) { id in
                HStack {
                    AsyncImage(url: imageURL(for: id)) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)

                    Text(pokemonNames[id]?.capitalized ?? "Pokémon #\(id)")
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        pendingDeleteID = id
                        pendingDeleteName = pokemonNames[id]?.capitalized ?? "Pokémon #\(id)"
                        isShowingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete { offsets in
                if let index = offsets.first {
                    pendingDeleteID = storeFavourites.favouriteIDs[index]
                    isShowingDeleteAlert = true
                }
            }
        }
        .navigationTitle("Favourites")
        .task {
            for id in storeFavourites.favouriteIDs where pokemonNames[id] == nil {
                await fetchName(for: id)
            }
        }
        .alert("Remove \(pendingDeleteName ?? "this pokemon") from favourites?", isPresented: $isShowingDeleteAlert) {
            makeAlertButtons()
        } message: {
            Text("This change can not be reversed.")
        }
    }

    @ViewBuilder
    private func makeAlertButtons() -> some View {
        Button(role: .destructive) {
            if let pendingDeleteID {
                storeFavourites.toggleFavourite(pendingDeleteID)
            }
            pendingDeleteID = nil
        } label: {
            Text("Delete")
        }

        Button(role: .cancel) {
            pendingDeleteID = nil
        } label: {
            Text("Cancel")
        }
    }

    func imageURL(for id: Int) -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
    }

    func fetchName(for id: Int) async {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PokemonInfo.self, from: data)
            pokemonNames[id] = decoded.name
        } catch {
            print("Kunne ikke hente navn for #\(id): \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        FavouritesListView()
            .environment(StoreFavourites())
    }
}
