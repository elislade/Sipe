import Foundation
import Combine
import Firebase
import FirebaseDatabase
import CoreLocation

class FIRData: ObservableObject {
    let errors = PassthroughSubject<String, Never>()
    
    @Published private(set) var user:User? = nil
    @Published private(set) var signingIn = false
    @Published private(set) var posts:[Post] = []
    @Published private(set) var tags:[Tag] = []
    
    private let auth = Auth.auth()
    private let ref = Database.database().reference()
    private let dateFormatter:ISO8601DateFormatter
    private var didChangeAuthHandle:AuthStateDidChangeListenerHandle?
    
    init() {
        dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        didChangeAuthHandle = auth.addStateDidChangeListener({ auth, user in
            self.user = user
        })
        
        watch("tags", type:Tag.self)
        watch("posts", type:Post.self)
    }
    
    func signIn() {
        // creates a new user
        // need to store user locally for restore
        // after signing out
        
        if auth.currentUser == nil && !signingIn {
            self.signingIn = true
            auth.signInAnonymously() { (authResult, error) in
                self.user = authResult?.user
                self.watch("tags", type:Tag.self)
                self.watch("posts", type:Post.self)
                self.signingIn = false
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        self.posts = []
        self.tags = []
        ref.child("posts").removeAllObservers()
        ref.child("tags").removeAllObservers()
    }
    
    func watch<T:FIRModeledData>(_ path:String, type: T.Type){
        ref.child(path).observe(.childChanged, with: { snap in
            if let v = snap.value as? [String : Any] {
                if let d = T(snap.key, dict: v, ctx: self) {
                    if path == "posts" {
                        if let i = self.posts.firstIndex(where: { $0.id == snap.key }){
                            self.posts[i] = d as! Post
                        }
                    } else if path == "tags"{
                        if let i = self.tags.firstIndex(where: { $0.id == snap.key }){
                            self.tags[i] = d as! Tag
                        }
                    }
                }
            }
        })
        
        ref.child(path).observe(.childAdded, with: { snap in
            if let d = T(snap.key, dict: snap.value as! [String : Any], ctx: self) {
                if path == "posts"{ self.posts.append(d as! Post)}
                else if path == "tags"{ self.tags.append(d as! Tag)}
            }
        })
        
        ref.child(path).observe(.childRemoved, with: { snap in
            if let i = self.posts.firstIndex(where: { $0.id == snap.key }){
                if path == "posts"{ self.posts.remove(at: i) }
                else if path == "tags"{ self.tags.remove(at: i)}
            }
        })
    }
    
    func create(_ path: String, dict: [String:Any]) {
        ref.child(path).setValue(dict)
    }
    
    func update(_ path:String, dict: [String:Any]) {
        ref.child(path).setValue(dict)
    }
    
    func delete(_ path:String) {
        ref.child(path).removeValue{ err, db in
            if let e = err {
                self.errors.send(e.localizedDescription)
            }
        }
    }
    
    deinit {
        ref.child("posts").removeAllObservers()
        ref.child("tags").removeAllObservers()
        
        if let handle = didChangeAuthHandle {
            auth.removeStateDidChangeListener(handle)
        }
    }
}

protocol FIRModeledData {
    var id:String { get }
    var context:FIRData? { get set }
    
    init?(_ id:String, dict:[String:Any], ctx:FIRData)
    var asDict:[String:Any]{ get }
}

extension FIRModeledData {
    var collectionName:String {
        "\(type(of: self))s".lowercased()
    }
    
    func create() {
        context?.create("\(collectionName)/\(id)", dict: asDict)
    }
    
    func update() {
        context?.update("\(collectionName)/\(id)", dict: asDict)
    }
    
    func delete() {
        context?.delete("\(collectionName)/\(id)")
    }
}




//MARK: - Post

extension FIRData {
    
    struct Post:FIRModeledData {
        let id:String
        let createdOn:Date
        let title:String
        let content:String
        let tags:[Tag]
        let location:Location?
        
        weak var context:FIRData?
        
        init(_ ctx:FIRData, id:String = UUID().uuidString, title:String, content:String, loc:Location? = nil, date:Date = Date(), tags:[Tag] = []){
            self.id = id
            self.context = ctx
            self.title = title
            self.content = content
            self.createdOn = date
            self.tags = tags
            self.location = loc
        }
        
        init?(_ id: String, dict:[String: Any], ctx:FIRData) {
            guard
                let t = dict["title"] as? String,
                let c = dict["content"] as? String,
                let d = dict["createdOn"] as? String,
                let date = ctx.dateFormatter.date(from: d + "+0000")
            else { return nil }
            
            self.id = id
            self.context = ctx
            self.title = t
            self.content = c
            self.createdOn = date
            self.tags = (dict["tags"] as? [String : [String:Any]])?.values.compactMap { Tag($0["id"] as! String, dict: $0, ctx: ctx) } ?? []
            if let loc = dict["location"] as? [String: Any] {
                self.location = Location(loc["id"] as! String, dict: loc, ctx: ctx)
            } else {
                self.location = nil
            }
            //self.location = Location(dict["location"], dict: dict["location"], ctx: ctx)
        }
        
        var asDict:[String:Any]{
            var _tags:[String: [String: Any]] = [:]
            for tag in tags { _tags[tag.id] = tag.asDict }
            
            return [
                "id" : id,
                "title" : title,
                "content" : content,
                "createdOn" : context?.dateFormatter.string(from: createdOn) ?? "",
                "tags" : _tags,
                "location": location?.asDict ?? false
            ]
        }
    }
}




//MARK: - Tag

extension FIRData {
    
    struct Tag:FIRModeledData {
        let id:String
        weak internal var context:FIRData?
        
        let name:String
        let color:OSColor
        
        init(_ ctx:FIRData, id:String = UUID().uuidString, name:String, color:OSColor){
            self.id = id
            self.context = ctx
            self.name = name
            self.color = color
        }
        
        init?(_ id: String, dict: [String : Any], ctx: FIRData) {
            guard
                let n = dict["name"] as? String,
                let c = dict["colorString"] as? String
            else { return nil }
            
            let comps = c.split(separator: ",").compactMap{ Double($0) }.map{ CGFloat($0 / 255) }
            self.id = id
            self.name = n
            self.color = OSColor(red: comps[0], green: comps[1], blue: comps[2], alpha: 1)
        }
        
        func string(from:OSColor) -> String {
            var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: nil)
            return "\(Int(r * 255)),\(Int(g * 255)),\(Int(b * 255))"
        }
        
        var asDict: [String : Any] {[
            "id": id,
            "name": name,
            "colorString": string(from: color)
        ]}
        
    }
}




//MARK: - Location

extension FIRData {
    
    struct Location:FIRModeledData {
        let id:String
        weak internal var context:FIRData?
        
        let coord:CLLocationCoordinate2D
        
        init(_ ctx:FIRData, id:String = UUID().uuidString, coord:CLLocationCoordinate2D){
            self.id = id
            self.context = ctx
            self.coord = coord
        }
        
        init?(_ id: String, dict: [String : Any], ctx: FIRData) {
            guard
                let lat = dict["lat"] as? Double,
                let long = dict["long"] as? Double
            else { return nil }
     
            self.id = id
            self.coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        var asDict: [String : Any] {[
            "id": id,
            "lat": coord.latitude,
            "long": coord.longitude
        ]}
        
    }
}
