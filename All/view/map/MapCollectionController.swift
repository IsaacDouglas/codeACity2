//
//  MapCollectionController.swift
//  codeACity2
//
//  Created by Isaac Douglas on 14/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import Foundation

extension MapViewController {

    internal func initCarousel() {
        
        backView.backgroundColor = .clear
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .normal
        collectionView.register(cell: MapCollectionViewCell.self)
        
        guard let first = self.itemList.first else { return }
        self.moveCamera(at: first.location, zoom: first.zoom)
        self.mapView.clear()
        self.kml(name: first.kml)
        first.predios.forEach({ predio in
            let marker = Marker(position: predio.location)
            marker.item = first
            marker.predio = predio
            marker.map = self.mapView
            marker.title = predio.name
        })
    }

    private func percent() -> CGFloat {
        return 0.8
    }
}

extension MapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath) as! MapCollectionViewCell
        cell.lbTitle.text = itemList[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width * percent(), height: size.height * percent())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let size = collectionView.frame.size
        let offset: CGFloat = (size.width - (size.width * percent())) / 2
        return UIEdgeInsets(top: 0, left: offset, bottom: 0, right: offset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let sec: Double = abs(velocity.x) > 0.1 ? 0.5 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
            let indexOfMajorCell = self.indexOfMajorCell(scrollView: scrollView)
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            let item = self.itemList[indexPath.row]
            self.moveCamera(at: item.location, zoom: item.zoom)
            self.mapView.clear()
            self.kml(name: item.kml)
            item.predios.forEach({ predio in
                let marker = Marker(position: predio.location)
                marker.item = item
                marker.predio = predio
                marker.map = self.mapView
                marker.title = predio.name
            })
        }
    }
    
    private func indexOfMajorCell(scrollView: UIScrollView) -> Int {
        let itemWidth = collectionView.frame.size.width * percent()
        let proportionalOffset = scrollView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
}
