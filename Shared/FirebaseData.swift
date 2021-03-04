import Foundation
import Firebase
import FirebaseDatabase

class FIRData<Type: FIRModeledData>: ObservableObject {
    
    @Published private(set) var collection: [Type] = []
    
    init() { watch() }
    
    private func watch() {
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        
        DB.shared.ref.child(Type.collectionName + "/\(uid)").observe(.childChanged, with: { snap in
            if let d = Type.create(from: snap.value) {
                if let i = self.collection.firstIndex(where: { $0.id.uuidString == snap.key }){
                    self.collection[i] = d
                }
            }
        })
        
        DB.shared.ref.child(Type.collectionName + "/\(uid)").observe(.childAdded, with: { snap in
            if let d = Type.create(from: snap.value) {
                self.collection.append(d)
            }
        })
        
        DB.shared.ref.child(Type.collectionName + "/\(uid)").observe(.childRemoved, with: { snap in
            if let i = self.collection.firstIndex(where: { $0.id.uuidString == snap.key }){
                self.collection.remove(at: i)
            }
        })
    }
    
    deinit {
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        DB.shared.ref.child(Type.collectionName + "/\(uid)").removeAllObservers()
    }
}

