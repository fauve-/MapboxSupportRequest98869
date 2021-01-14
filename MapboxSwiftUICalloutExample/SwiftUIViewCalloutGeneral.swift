import SwiftUI

// The main event of our efforts. With mimic a NavigationView, since we don't need all the drama that comes with a real one.
struct SwiftUICalloutGeneral: View {
    let annotations: MainAnnotation
    @State var selectedAnnotation: SubAnnotation? = nil
    var body: some View {

        VStack{
            // Show the drill-in.
            // This resizes the SwiftUI view
            if let selected = selectedAnnotation {
                // psudeo-navigation
                VStack {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .frame(width: 18, height: 22)

                        Text("Back")
                            .font(.system(size: 17))
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .onTapGesture {
                        self.selectedAnnotation = nil
                    }
                    
                    VStack {
                        Text(selected.description)
                        ForEach(0..<selected.rows.count){
                            idx in
                            HStack{
                                Text(selected.rows[idx].0)
                                Text(selected.rows[idx].0)
                            }
                        }
                    }

                }
            } else {
                // Show all
                ForEach(0..<annotations.subAnnotations.count){
                    idx in
                    HStack {
                        Text(annotations.subAnnotations[idx].name)
                            .font(.system(size: 15, weight: .semibold))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                            .frame(width: 18, height: 22)
                        Divider()
                    }
                    .onTapGesture {
                        selectedAnnotation = annotations.subAnnotations[idx]
                    }
                }
            }
        }
        .frame(width: 264)
    }
}
