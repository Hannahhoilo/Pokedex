import SwiftUI

extension Color {
    static func forPokemonType(_ type: String) -> Color {
        switch type {
        case "fighting": return Color(red: 0.78, green: 0.20, blue: 0.42)
        case "psychic":  return Color(red: 0.94, green: 0.55, blue: 0.55)
        case "poison":   return Color(red: 0.65, green: 0.35, blue: 0.75)
        case "dragon":   return Color(red: 0.15, green: 0.45, blue: 0.75)
        case "ghost":    return Color(red: 0.45, green: 0.45, blue: 0.75)
        case "dark":     return Color(red: 0.40, green: 0.38, blue: 0.42)
        case "ground":   return Color(red: 0.78, green: 0.50, blue: 0.28)
        case "fire":     return Color(red: 0.94, green: 0.60, blue: 0.25)
        case "fairy":    return Color(red: 0.90, green: 0.65, blue: 0.90)
        case "water":    return Color(red: 0.40, green: 0.62, blue: 0.90)
        case "flying":   return Color(red: 0.62, green: 0.68, blue: 0.92)
        case "normal":   return Color(red: 0.68, green: 0.68, blue: 0.68)
        case "rock":     return Color(red: 0.72, green: 0.65, blue: 0.50)
        case "electric": return Color(red: 0.95, green: 0.82, blue: 0.25)
        case "bug":      return Color(red: 0.65, green: 0.75, blue: 0.30)
        case "grass":    return Color(red: 0.45, green: 0.68, blue: 0.35)
        case "ice":      return Color(red: 0.55, green: 0.85, blue: 0.78)
        case "steel":    return Color(red: 0.42, green: 0.55, blue: 0.62)
        default:         return Color.black
        }
    }
}
