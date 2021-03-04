import Foundation
import Combine
import Firebase
import FirebaseDatabase

struct DB {
    static let shared: DB = { DB() }()
    
    let ref = Database.database().reference()
    let errors = PassthroughSubject<String, Never>()
    
    func create(_ path: String, dict: [String: Any]) {
        ref.child(path).setValue(dict)
    }
    
    func update(_ path: String, dict: [String: Any]) {
        ref.child(path).setValue(dict)
    }
    
    func delete(_ path: String) {
        ref.child(path).removeValue{ err, db in
            if let e = err {
                self.errors.send(e.localizedDescription)
            }
        }
    }
}

protocol FIRModeledData: Codable {
    var id: UUID { get }
}

extension FIRModeledData {
    
    static var collectionName: String {
        "\(Self.self)s".lowercased()
    }
    
    static func create(from dict: Any?) -> Self? {
        guard
            let dict = dict,
            let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed),
            let obj = try? decoder.decode(Self.self, from: data)
        else { return nil }
        
        return obj
    }
    
    static var encoder: JSONEncoder {
        let c = JSONEncoder()
        c.dateEncodingStrategy = .iso8601
        return c
    }
    
    static var decoder: JSONDecoder {
        let c = JSONDecoder()
        c.dateDecodingStrategy = .iso8601
        return c
    }
    
    var uid: String {
        Auth.auth().currentUser!.uid
    }
    
    func create() {
        DB.shared.create("\(Self.collectionName)/\(uid)/\(id.uuidString)", dict: asDict)
    }
    
    func update() {
        DB.shared.update("\(Self.collectionName)/\(uid)/\(id.uuidString)", dict: asDict)
    }
    
    func delete() {
        DB.shared.delete("\(Self.collectionName)/\(uid)/\(id.uuidString)")
    }
    
    var asDict: [String: Any] {
        guard
            let d = try? Self.encoder.encode(self),
            let json = try? JSONSerialization.jsonObject(with: d, options: .fragmentsAllowed) as? [String: Any]
        else { return [:] }
        
        return json
    }
}
