import SwiftUI
import AVFoundation // for sounds

struct PokemonForm: Identifiable {
    let id = UUID()
    let name: String
    let imageURL: URL?
}

struct PokedexView: View {
    @Environment(StoreFavourites.self) var storeFavourites
    
    @State var pokemonID = 1
    @State var jumpText = ""
    @State var searchText = ""
    @State var isShiny = false
    @State var pokemonName = ""
    @State var pokemonTypes: [String] = []
    @State var cryURL: URL?
    @State var audioPlayer: AVPlayer?
    @State var imageBounce = false
    @State var heartBounce = false
    @State var starBounce = false
    @State var regularImageURL: URL?
    @State var shinyImageURL: URL?
    @State var showStatsSheet = false
    @State var otherForms: [PokemonForm] = []
    @State var femaleImageURL: URL?
    @State var shinyFemaleImageURL: URL?
    @State var expandedImageURL: URL?
    @State var pokeballAnimation = 0.0
    
    
    var imageURL: URL {
        let baseURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
        var shinyPath: String = ""
        if isShiny {
            shinyPath = "shiny/"
        }
        return URL(string: "\(baseURL)\(shinyPath)\(pokemonID).png")!
    }
    
    var backgroundGradient: LinearGradient {
        let colors = pokemonTypes.map { Color.forPokemonType($0) }
        
        let topColor: Color
        let midColor: Color
        if colors.count >= 2 {
            topColor = colors[0]
            midColor = colors[1]
        } else if let firstColor = colors.first {
            topColor = firstColor
            midColor = firstColor
        } else {
            topColor = .black
            midColor = .black
        }
        
        return LinearGradient(
            stops: [
                .init(color: topColor, location: 0.0),
                .init(color: midColor.opacity(0.6), location: 0.55),
                .init(color: midColor.opacity(0.0), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Pokémon #\(pokemonID)")
                    .font(.title)
                
                Text(pokemonName.capitalized)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                AsyncImage(url: imageURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                .scaleEffect(imageBounce ? 1.15 : 1.0)
                .offset(y: imageBounce ? -12 : 0)
                .contentShape(Rectangle())
                /*
                 NavigationLink {
                 PokemonDetailView(pokemonID: pokemonID)
                 } label: {
                 AsyncImage(url: imageURL) { image in
                 image.resizable().scaledToFit()
                 } placeholder: {
                 ProgressView()
                 }
                 .frame(width: 200, height: 200)
                 .scaleEffect(imageBounce ? 1.15 : 1.0)
                 .offset(y: imageBounce ? -12 : 0)
                 .contentShape(Rectangle())
                 }
                 .simultaneousGesture(
                 TapGesture().onEnded {
                 playCry()
                 withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                 imageBounce = true
                 }
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                 withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                 imageBounce = false
                 }
                 }
                 }
                 )
                 */
                
                .onTapGesture {
                    playCry()
                    showStatsSheet = true
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                        imageBounce = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                            imageBounce = false
                        }
                    }
                }
                
                
                // SHEET ---------
                .sheet(isPresented: $showStatsSheet) {
                    ScrollView {
                        VStack(spacing: 20) {
                            Text(pokemonName.capitalized)
                                .font(.title)
                                .bold()
                            
                            HStack(spacing: 32) {
                                sheetSpriteImage(url: regularImageURL, label: "Normal")
                                sheetSpriteImage(url: shinyImageURL, label: "Shiny")
                            }
                            
                            if !otherForms.isEmpty {
                                Divider()
                                Text("Andre former")
                                    .font(.headline)
                                
                                ForEach(otherForms) { form in
                                    HStack {
                                        sheetSpriteImage(url: form.imageURL, label: form.name.capitalized)
                                    }
                                }
                            }
                            
                            if femaleImageURL != nil || shinyFemaleImageURL != nil {
                                Divider()
                                Text("♀")
                                    .font(.headline)
                                
                                HStack(spacing: 32) {
                                    if let femaleImageURL {
                                        sheetSpriteImage(url: femaleImageURL, label: "♀")
                                    }
                                    if let shinyFemaleImageURL {
                                        sheetSpriteImage(url: shinyFemaleImageURL, label: "Female Shiny")
                                    }
                                }
                            }
                            
                            Button {
                                showStatsSheet = false
                                expandedImageURL = nil
                            } label: {
                                Text("Close")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    .presentationDetents([.medium, .large])
                }
                
                // -----
                
                
                HStack(spacing: 24) {
                    Button {
                        isShiny.toggle()
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                            starBounce = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                                starBounce = false
                            }
                        }
                    } label: {
                        Image(systemName: isShiny ? "star.fill" : "star")
                            .font(.system(size: 28))
                            .foregroundStyle(.yellow)
                            .scaleEffect(starBounce ? 1.4 : 1.0)
                            .frame(width: 60, height: 50)
                    }
                    
                    Button {
                        storeFavourites.toggleFavourite(pokemonID)
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                            heartBounce = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                                heartBounce = false
                            }
                        }
                        
                    } label: {
                        Image(systemName: storeFavourites.isFavourite(pokemonID) ? "heart.fill" : "heart")
                            .font(.system(size: 28))
                            .foregroundStyle(.pink)
                            .scaleEffect(heartBounce ? 1.4 : 1.0)
                            .frame(width: 60, height: 50)
                    }
                }
                
                // NAV TO INFO
                NavigationLink {
                    PokemonDetailsView(pokemonID: pokemonID)
                } label: {
                    Label("More Info", systemImage: "info.circle")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.forPokemonType(pokemonTypes.first ?? ""), in: Capsule())
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                }
                // NAV END
                
                HStack(spacing: 16) {
                    Button {
                        changeID(by: -1)
                    } label: {
                        Label("Prev", systemImage: "chevron.left")
                    }
                    
                    Button {
                        changeID(by: 1)
                    } label: {
                        Label("Next", systemImage: "chevron.right")
                    }
                    
                    Button {
                        pokemonID = Int.random(in: 1...1010)
                    } label: {
                        Label("Random", systemImage: "shuffle")
                    }
                }
                
                PokeballView()
                    .rotationEffect(.degrees(pokeballAnimation))
                    .accessibilityHint("Picture of a pokeball.")
                    .padding(.leading)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            pokeballAnimation += 360
                        }
                    }
                
                VStack(spacing: 8) {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(.roundedBorder)

                    TextField("Jump to #", text: $jumpText)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            if let parsedNumber = Int(jumpText) {
                                pokemonID = min(max(parsedNumber, 1), 1010)
                            }
                        }
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: pokemonTypes)
        .task(id: pokemonID) {
            await fetchPokemonData()
            await fetchOtherForms()
        }
    }
    
    
    func changeID(by amount: Int) {
        pokemonID = min(max(pokemonID + amount, 1), 1010)
    }
    
    func fetchPokemonData() async {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PokemonInfo.self, from: data)
            pokemonName = decoded.name
            pokemonTypes = decoded.types.map { $0.type.name }
            
            if let legacyString = decoded.cries.legacy, let url = URL(string: legacyString) {
                cryURL = url
            } else if let latestString = decoded.cries.latest, let url = URL(string: latestString) {
                cryURL = url
            } else {
                cryURL = nil
            }
            
            regularImageURL = URL(string: decoded.sprites.regularImage)
            shinyImageURL = URL(string: decoded.sprites.shinyImage)
            femaleImageURL = decoded.sprites.femaleImage.flatMap { URL(string: $0) }
            shinyFemaleImageURL = decoded.sprites.shinyFemaleImage.flatMap { URL(string: $0) }
            /*flatMap er en metode som transformerer en optional-verdi til en annen optional-verdi, men unngår "dobbel-pakking" som ville skjedd med vanlig .map.*/
        } catch {
            pokemonName = ""
            pokemonTypes = []
            cryURL = nil
            regularImageURL = nil
            shinyImageURL = nil
            print("Kunne ikke hente data: \(error)")
        }
    }
    
    func playCry() {
        print("Trykket registrert! cryURL: \(String(describing: cryURL))")
        guard let cryURL else { return }
        audioPlayer = AVPlayer(url: cryURL)
        audioPlayer?.play()
    }
    
    func fetchOtherForms() async {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(pokemonID)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let species = try JSONDecoder().decode(PokemonSpecies.self, from: data)
            
            var forms: [PokemonForm] = []
            for variety in species.varieties where !variety.isDefault {
                guard let varietyURL = URL(string: variety.pokemon.url) else { continue }
                let (varietyData, _) = try await URLSession.shared.data(from: varietyURL)
                let varietyInfo = try JSONDecoder().decode(PokemonInfo.self, from: varietyData)
                let imageURL = URL(string: varietyInfo.sprites.regularImage)
                forms.append(PokemonForm(name: variety.pokemon.name, imageURL: imageURL))
            }
            otherForms = forms
        } catch {
            otherForms = []
            print("Could not get other forms: \(error)")
        }
    } // END fetchotherforms
    
    @ViewBuilder
    func sheetSpriteImage(url: URL?, label: String) -> some View {
        let isExpanded = (expandedImageURL != nil && expandedImageURL == url)
        
        VStack {
            AsyncImage(url: url) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(
                width: isExpanded ? nil : 120,
                height: isExpanded ? 260 : 120
            )
            .frame(maxWidth: isExpanded ? .infinity : 120)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                if isExpanded {
                    expandedImageURL = nil
                } else {
                    expandedImageURL = url
                }
            }
        }
    } // END viewbuilder
} // END struct


#Preview {
    PokedexView()
        .environment(StoreFavourites())
}

