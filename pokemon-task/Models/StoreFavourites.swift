import SwiftUI

@Observable
class StoreFavourites {
    var favouriteIDs: [Int] = []

    func isFavourite(_ id: Int) -> Bool {
        favouriteIDs.contains(id)
    }

    func toggleFavourite(_ id: Int) {
        if let index = favouriteIDs.firstIndex(of: id) {
            favouriteIDs.remove(at: index)
        } else {
            favouriteIDs.append(id)
        }
    }

    func removeFavourite(at offsets: IndexSet) {
        favouriteIDs.remove(atOffsets: offsets)
    }
}


/*
 Delt state, shared state, brukes av flere views
 
 Understreken _ i func toggleFavorite(_ id: Int) handler om argument label — altså hva du skriver foran verdien når du kaller funksjonen, i motsetning til id, som er navnet du bruker inni funksjonen.

 Swift har to forskjellige navn per parameter:

 Argument label — brukes av den som kaller funksjonen (utenfor)
 Parameter name — brukes inni funksjonskroppen (innenfor)
 
 @Observable (den nye Swift-makroen, tilgjengelig fra iOS 17) gjør at enhver view som leser favoriteIDs automatisk oppdaterer seg når listen endres — uansett hvor i view-hierarkiet den befinner seg.
 */
