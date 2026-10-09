import SwiftUI

struct TabBarView: View {
    @State private var storeFavourites = StoreFavourites()
    @State private var searchText = ""

    var body: some View {
        TabView {
            Tab("Pokedex", systemImage: "house") {
                NavigationStack {
                    PokedexView()
                        .environment(storeFavourites)
                }
            }

            Tab("Favourites", systemImage: "heart") {
                NavigationStack {
                    FavouritesListView()
                        .environment(storeFavourites)
                }
            }
            .badge(storeFavourites.favouriteIDs.count)

            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    Text("Search")
                }
            }

        }
        .searchable(text: $searchText)
        .tabViewSearchActivation(.searchTabSelection)
        
    }
}

#Preview {
    TabBarView()
}

/*
 TODO:
 -errormelding til slette
 -infoside til pokemon
 - counter til hvor mange ganger man spinner ball 

 -flytte på elementer
 -filter på gen eller type ? 
 
 */

/*
 root med tabs og søk
 
 .environment(favoritesStore) er nøkkelen — den gjør at StoreFavourites-instansen sendes ned til hvilken som helst view i det subtreet, uten at du må sende den manuelt gjennom hver init.
 
 
 Root" betyr utgangspunktet — den øverste viewen i view-hierarkiet, den som "eier" alt det andre.

 Tenk på appen din som et tre
 
 TabBarView kalles "root" fordi det er den første viewen som vises når appen starter, og alt annet ligger inni eller under den.
 */
