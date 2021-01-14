import Foundation
import Mapbox

// These feed the callout
class MainAnnotation: MGLPointAnnotation {
    var subAnnotations: [SubAnnotation] = []
}


class SubAnnotation: Identifiable {
    var id = UUID()
    
    var name: String
    var description: String
    var rows: [(String, String)]
    init(nombre: String, desc: String, rows: [(String, String)]){
        name = nombre
        description = desc
        self.rows = rows
    }
}
