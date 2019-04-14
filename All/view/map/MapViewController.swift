//
//  MapViewController.swift
//  codeACity2
//
//  Created by Isaac Douglas on 13/04/19.
//  Copyright © 2019 codeACity2. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var itemList: [ItemMap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Mapa"
        let location1 = CLLocationCoordinate2D(latitude: -8.063920263040421, longitude: -34.87925793975592)
        let location2 = CLLocationCoordinate2D(latitude: -8.055445210456666, longitude: -34.87094409763813)
        let location3 = CLLocationCoordinate2D(latitude: -8.208965354386233, longitude: -35.51045682281256)
        let um = ItemMap.init(name: "Santo Antônio", location: location1, zoom: 15, kml: "Santo_antonio")
        let dois = ItemMap.init(name: "Recife", location: location2, zoom: 14.5, kml: "Recife_antigo")
        let tres = ItemMap.init(name: "Municipios", location: location3, zoom: 8, kml: "Municipios_PE")
        itemList = [um, dois, tres]
        
        self.initLocation()
        self.initCamera()
        placesClient = GMSPlacesClient.shared()
        initCarousel()
    }
    
    func initCamera() {
        // Camera e mapView
        guard let settings = Session.settings else { return }
        let latitude = Double(settings.initialLatitude)!
        let longitude = Double(settings.initialLongitude)!
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: Float(settings.zoom))
        mapView.animate(to: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        let bottomMapViewPadding = collectionView.frame.height
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: bottomMapViewPadding, right: 0)
    }
    
    func initLocation() {
        // Localizacao do usuario
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
//    func teste() {
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error) in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let placeLikelihoodList = placeLikelihoodList else { return }
//            placeLikelihoodList.likelihoods.forEach({ placeLikelihood in
//                print(placeLikelihood.place.name ?? "")
//                print(placeLikelihood.place.formattedAddress?.components(separatedBy: ", ").joined() ?? "")
//                print(placeLikelihood.place.types ?? "")
//                print("")
//            })
//        })
//    }
    
    func getLink(location: CLLocationCoordinate2D, radius: Int, type: PlaceType) -> String {
        let key = Session.settings!.apiGoogle
        return "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&type=\(type.rawValue)&key=\(key)"
    }
    
    func getAdress(location: CLLocationCoordinate2D) {
        GMSGeocoder().reverseGeocodeCoordinate(location) { response, error in
            DispatchQueue.main.async {
                guard let address = response?.firstResult() else { return }
                print(address.thoroughfare ?? "SEM ENDERECO")
            }
        }
    }
    
    func kml(name: String) {
        let path = Bundle.main.path(forResource: name, ofType: "kml")
        let url = URL(fileURLWithPath: path!)
        let kmlParser = GMUKMLParser(url: url)
        kmlParser.parse()
        let renderer = GMUGeometryRenderer(map: mapView,
                                       geometries: kmlParser.placemarks,
                                       styles: kmlParser.styles)
        renderer.render()
    }
    
    internal func moveCamera(at location: CLLocationCoordinate2D, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: zoom)
        mapView.animate(to: camera)
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        let urlNew = getLink(location: coordinate, radius: 2000, type: .restaurant)
        
        URLSession.shared.get(urlNew, onErron: { error in
            print(error.localizedDescription)
        }, onSucess: { (nearby: GoogleNearby) in
            if nearby.status == "OK" {
                let teste = nearby.status
                print(teste)
            }
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        print("Minha Localização")
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        self.currentLocation = location
        print("Location: \(location)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
