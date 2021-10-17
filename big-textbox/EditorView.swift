import SwiftUI

struct EditorView: View {
    @State private var textToShow: String = String()
    @State private var showEditor = false
    @FocusState private var isFocused: Bool
    let transitionDuration = 0.2
    var body: some View {
        
        ZStack {

            //The big text display area. Big text shows here.
            //Text displayed gets resized to fit on one screen without scrolling.
            //Area blurs in/out of focus depending on showEditor toggle.
            Text((textToShow.isEmpty && !showEditor) ? "Tap to Open Editor" : textToShow)
                .font(.system(size: 140))
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: showEditor ? 10 : 0)
                .opacity(showEditor ? 0.7 : 1.0)
                .onTapGesture { showEditor.toggle() }
                .animation(.easeInOut(duration: transitionDuration), value: showEditor)
            
            //The text editor area. The user edits the text here.
            //Intent is to have, in most use cases, all of the text in the editing area visible at once when editing with keyboard open.
            //Appears on top of the big text display area when showEditor toggles to true.
            //showEditor toggles when user taps on "Done" or taps in the big text display area.
            if showEditor {
                VStack {
                    VStack {
                        HStack{
                            Text("Big Text Editor")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                showEditor.toggle()
                            }, label: {
                                Text("Done")
                            })
                            .foregroundColor(.blue)
                        }
                        TextEditor(text: $textToShow)
                            .colorMultiply(Color(white: 0.85).opacity(0.8))
                            .cornerRadius(10.0)
                            .frame(maxHeight: 120)
                            .focused($isFocused)
                            .onAppear {
                                //  https://stackoverflow.com/questions/68073919/swiftui-focusstate-how-to-give-it-initial-value
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.05) {
                                    isFocused = true
                                }
                            }
                    }
                    .padding([.leading, .bottom, .trailing])
                    Spacer()
                }
            }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
