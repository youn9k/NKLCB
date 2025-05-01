import SwiftUI

struct CollectionView: UIViewRepresentable {
    let layout: UICollectionViewLayout
    var items: [String]
    
    func makeCoordinator() -> Cordinator {
        Cordinator(items: items)
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        context.coordinator.items = items
        uiView.reloadData()
    }
    
    class Cordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        var items: [String]
        
        init(items: [String]) {
            self.items = items
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return items.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            return UICollectionViewCell()
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 120, height: 40)
        }
    }
}
