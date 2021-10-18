import SwiftUI

struct EditorView: View {
    @State private var textToShow: String = String()
    @State private var showEditor = true
    @FocusState private var isFocused: Bool
    @EnvironmentObject var favoritesObject: Favorites
    var defaults = UserDefaults.standard
    let transitionDuration = 0.1
    
    var body: some View {
        
        ZStack {

            //The big text display area. Big text shows here.
            //Text displayed gets resized to fit on one screen without scrolling.
            //Area blurs in/out of focus depending on showEditor toggle.
            Text((textToShow.isEmpty && !showEditor) ? "..." : textToShow)
                .font(.system(size: 130))
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { showEditor.toggle() }
                .blur(radius: showEditor ? 10 : 0)
                .opacity(showEditor ? 0.7 : 1.0)
                .animation(.easeInOut(duration: transitionDuration), value: showEditor)
            
            //The text editor area. The user edits the text here.
            //Intent is to have, in most use cases, all of the text in the editing area visible at once when editing with keyboard open.
            //Appears on top of the big text display area when showEditor toggles to true.
            //showEditor toggles when user taps on "Done" or taps in the big text display area.
            if showEditor {
                VStack {
                    VStack {
                        
                        // The Clear / Add to Favorites / Done buttons above the textbox.
                        HStack{
                            Button(action: {
                                self.textToShow = ""
                                }, label: {
                                    Text("Clear")
                                })
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            Button(action: {
                                    favoritesObject.favorites.append(self.textToShow)
                                    favoritesObject.favorites = Array(Set(favoritesObject.favorites))   // Prevent duplicates.
                                    defaults.set(favoritesObject.favorites, forKey: "storedFavorites")   // Update user defaults for persistence.
                                }, label: {
                                    Text("Add to Favorites")
                                })
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Button(action: {
                                showEditor.toggle()
                                }, label: {
                                    Text("Done")
                                })
                                .foregroundColor(.blue)
                        }
                        
                        // The textbox
                        TextEditor(text: $textToShow)
                            .colorMultiply(Color(white: 0.8).opacity(0.9))
                            .cornerRadius(10.0)
                            .frame(maxHeight: 120)
                            .focused($isFocused)
                            .onAppear {
                                //  https://stackoverflow.com/questions/68073919/swiftui-focusstate-how-to-give-it-initial-value
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                                    isFocused = true
                                }
                            }
                        
                        Divider()
                        
                        // Favorites list
                        List {
                            Section(header: Text("Favorites")) {
                                ForEach(favoritesObject.favorites, id: \.self) {favorite in
                                    HStack {
                                        Button(action: {
                                            self.textToShow = favorite
                                        }, label: {
                                            HStack {
                                                Text(favorite)
                                                    .foregroundColor(.blue)
                                                    .contentShape(Rectangle())
                                                Spacer()
                                            }
                                        })
                                            .buttonStyle(BorderlessButtonStyle())
                                        
                                        
                                        Button(action: {
                                            favoritesObject.favorites.removeAll(where: { $0 == favorite })
                                            defaults.set(favoritesObject.favorites, forKey: "storedFavorites")   // Update user defaults for persistence.
                                        }, label: {
                                            Image(systemName: "trash")
                                        })
                                            .foregroundColor(.gray)
                                            .buttonStyle(BorderlessButtonStyle())
                                    }
                                }
                            }
                        }
                        .cornerRadius(10.0)
                        .opacity(0.9)
                        
                    }
                    .padding([.leading, .bottom, .trailing])
                    Spacer()
                }
            }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static let favoritesObject = Favorites()
    
    static var previews: some View {
        EditorView()
            .environmentObject(favoritesObject)
    }
}
