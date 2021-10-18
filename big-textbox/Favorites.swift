//
//  FavoritesList.swift
//  big-textbox
//
//  Created by Chloe Nott on 10/17/21.
//

import Foundation

final class Favorites: ObservableObject {
    @Published var favorites: [String]
    
    // Load favorites from user defaults if there's any
    var defaults = UserDefaults.standard
    init() {
        self.favorites = defaults.object(forKey: "storedFavorites") as? [String] ?? []
    }
}
