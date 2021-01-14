import Mapbox
import SwiftUI

// We need to use a UIView here, we can't subclass UIHostingController as it's a view controller.
class UIKitCalloutWrapper: UIView, MGLCalloutView {
    var delegate: MGLCalloutViewDelegate?
    
    var representedObject: MGLAnnotation

    // Allow the callout to remain open during panning.
    let dismissesAutomatically: Bool = false
    let isAnchoredToAnnotation: Bool = true

    // https://github.com/mapbox/mapbox-gl-native/issues/9228
    override var center: CGPoint {
        set {
            var newCenter = newValue
            newCenter.y -= bounds.midY
            super.center = newCenter
        }
        get {
            return super.center
        }
    }

    lazy var leftAccessoryView = UIView() /* unused */
    lazy var rightAccessoryView = UIView() /* unused */

    var childView: UIHostingController<SwiftUICalloutGeneral>!

    required init(representedObject: MainAnnotation) {
        self.representedObject = representedObject
        super.init(frame: .zero)

        // let's see if it shows
        backgroundColor = .systemPink
        let swiftUIView = SwiftUICalloutGeneral(annotations: representedObject)
        childView = UIHostingController(rootView: swiftUIView)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(childView.view)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - MGLCalloutView API
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        view.addSubview(self)

        // embed the swiftui view
        // we're using constraints here since we want the view we present to the map to flex to the size of
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        childView.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        childView.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        childView.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        childView.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // Now we stretch this view to match the resizable-child
        widthAnchor.constraint(equalTo: childView.view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: childView.view.heightAnchor).isActive = true
    }

    func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                }, completion: { [weak self] _ in
                    self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }

}
