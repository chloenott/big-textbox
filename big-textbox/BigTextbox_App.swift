import SwiftUI

@main
//Purpose of this app is to solve the amusingly common problem I have of: "I wish I could order food in person without repeating myself, because I have a quiet voice and the mask makes me even quieter." Plus, germs spread from talking, so visual communication seems like a good idea anyway.
//The app simply shows the large font text of whatever is typed in the editor and resizes it as needed to fit on the screen.
//Future wishlist: add dark mode and favorites.
struct BigTextbox_App: App {
    @StateObject private var favoritesObject = Favorites()
    
    var body: some Scene {
        WindowGroup {
            EditorView()
                .environmentObject(favoritesObject)
        }
    }
}
