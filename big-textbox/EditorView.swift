import SwiftUI

struct EditorView: View {
    @State private var textToShow: String = String()
    @State private var showEditor = true
    let transitionDuration = 0.2
    var body: some View {
        
        ZStack {

            //The big text display area. Big text shows here.
            //Text displayed gets resized to fit on one screen without scrolling.
            //Area blurs in/out of focus depending on showEditor toggle.
            Text(textToShow.isEmpty ? "Tap to Open Editor" : textToShow)
                .font(.system(size: 140))
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {showEditor.toggle()}
                .blur(radius: showEditor ? 20 : 0)
                .opacity(showEditor ? 0.7 : 1.0)
                .animation(.easeInOut(duration: transitionDuration))
            
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
                            Button(action: {showEditor.toggle()}, label: {
                                Text("Done")
                            })
                            .foregroundColor(.blue)
                        }
                        TextEditor(text: $textToShow)
                            .colorMultiply(Color(white: 0.85).opacity(0.8))
                            .cornerRadius(10.0)
                            .frame(maxHeight: 120)
                    }
                    .padding([.leading, .bottom, .trailing])
                    Spacer()
                }
                .transition(AnyTransition.move(edge: .top))
                .animation(.easeInOut(duration: transitionDuration))
            }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
