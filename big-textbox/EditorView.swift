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

            // The big text display area. Big text shows here.
            VStack {
                Text((textToShow.isEmpty && !showEditor) ? "..." : textToShow)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .lineLimit(textToShow.filter{ $0 == " " }.count + 1)
                    .multilineTextAlignment(.leading)
                    .onTapGesture { showEditor.toggle() }
            }
            .blur(radius: showEditor ? 10 : 0)
            .opacity(showEditor ? 0.7 : 1.0)
            .animation(.easeInOut(duration: transitionDuration), value: showEditor)
            
            //The text editor area. The user edits the text here. Appears as overlay.
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
                                            showEditor.toggle()
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
