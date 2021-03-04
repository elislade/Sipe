import Foundation
import CoreLocation
import CoreGraphics

//MARK: - Post
    
struct Post: FIRModeledData {
    let id: UUID
    let createdOn: Date
    let title: String
    let content: String
    let tags: [Tag]
    let location: Location?
    
    init(id: UUID = UUID(), createdOn: Date = Date(), title: String, content: String, tags: [Tag] = [], location: Location? = nil) {
        self.id = id
        self.createdOn = createdOn
        self.title = title
        self.content = content
        self.tags = tags
        self.location = location
    }
}


//MARK: - Tag

struct Tag: FIRModeledData {
    let id: UUID
    let name: String
    var color: [Double]
    
    var cgColor: CGColor {
        CGColor(
            red: CGFloat(color[0]),
            green: CGFloat(color[1]),
            blue: CGFloat(color[2]),
            alpha: CGFloat(color[3])
        )
    }
    
    init(id: UUID = UUID(), name: String, color: CGColor){
        self.id = id
        self.name = name
        self.color = color.components?.map{ Double($0) } ?? [0,0,0,1]
    }
}


//MARK: - Location

struct Location: FIRModeledData {
    let id: UUID
    let coord: [Double]
    
    var coord2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coord[0], longitude: coord[1])
    }
    
    init(id: UUID = UUID(), coord: CLLocationCoordinate2D) {
        self.id = id
        self.coord = [coord.latitude, coord.longitude]
    }
}
