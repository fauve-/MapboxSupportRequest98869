import Mapbox
import SwiftUI

// Plug ourselves into swiftui
struct ViewControllerRepresentable: UIViewControllerRepresentable{

    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // do nothing
    }
}

class ViewController: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .darkGray
        view.addSubview(mapView)

        // Set the map view‘s delegate property.
        mapView.delegate = self

        // Initialize and add the marker annotation.
        let mainAnnotation = MainAnnotation()
        mainAnnotation.subAnnotations = makeSubAnnotations()
        mainAnnotation.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        mainAnnotation.title = "Hello world!"

        // Add marker to the map.
        mapView.addAnnotation(mainAnnotation)
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Only show callouts for `Hello world!` annotation.
        return annotation.responds(to: #selector(getter: MGLAnnotation.title)) && annotation.title! == "Hello world!"
    }

    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        // Instantiate and return our custom callout view.
        return UIKitCalloutWrapper(representedObject: annotation as! MainAnnotation)
    }
    
    
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // Optionally handle taps on the callout.
        print("Tapped the callout for: \(annotation)")
     
        // Hide the callout.
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func makeSubAnnotations()-> [SubAnnotation] {
        var subs: [SubAnnotation] = []
        
        for i in 0..<10 {
            let name = "sub annotation \(i)"
            let description = "Herein we have an annotation which is displayed in a callout"
            let rows = (0...i).map{ ("Foo \($0)", "Bar \($0)")}
            subs.append(SubAnnotation(nombre: name, desc: description, rows: rows))
        }
        return subs
    }
}
