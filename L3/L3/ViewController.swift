//
//  ViewController.swift
//  L3
//
//  Created by Milton Leung on 2019-02-20.
//  Copyright © 2019 ms. All rights reserved.
//

import UIKit
import Mapbox

class RadarPointAnnotation: MGLPointAnnotation {
  var location: Location? = nil
}

final class ViewController: UIViewController {
  fileprivate struct Constants {
    static let startingCoordinate: (lat: Double, long: Double) = (48.166666, -100.166666)
    static let maximumZoomLevel: Double = 16
    static let minimumZoomLevel: Double = 3
    static let maximumRadarScale: Double = 10
    static let pulseDuration: TimeInterval = 2.5
  }

  var mapView: MGLMapView?
  var locations: [Location] = []
  var maxValue: Double = 0

  let datasetLoader = DatasetLoader()
  let pulseColors = PulseColors()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupMap()
    fetchLocations()
    addCoordinates()
  }

  fileprivate func setupMap() {
    let url = URL(string: "mapbox://styles/miltonleung/cjse5srx71w1w1fpjejnfabhd")
    let mapView = MGLMapView(frame: view.bounds, styleURL: url)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.setCenter(CLLocationCoordinate2D(latitude: Constants.startingCoordinate.lat, longitude: Constants.startingCoordinate.long), zoomLevel: Constants.minimumZoomLevel, animated: false)
    mapView.allowsTilting = false
    mapView.maximumZoomLevel = Constants.maximumZoomLevel
    mapView.minimumZoomLevel = Constants.minimumZoomLevel
    mapView.delegate = self
    self.mapView = mapView
    view.addSubview(mapView)
  }

  private func fetchLocations() {
    self.locations = datasetLoader.locations
    self.maxValue = Double(locations.first?.sizeIndex ?? 0)
  }

  private func addCoordinates() {
    guard let mapView = mapView else { return }

    let annotations = locations.map { location -> MGLPointAnnotation in
      let annotation = RadarPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      annotation.location = location
      annotation.title = "test"
      return annotation
    }

    mapView.addAnnotations(annotations)
  }

  func createMarkerViews(color: PulseColor) -> (UIView, UIView, UIView) {

    // Dot view
    let dot = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    dot.layer.cornerRadius = 5
    dot.layer.borderWidth = 1
    dot.layer.borderColor = color.dotBorder
    dot.layer.backgroundColor = color.dotBackground

    func createPulse() -> UIView {
      let pulse = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
      pulse.layer.cornerRadius = 5
      pulse.layer.borderWidth = 1
      pulse.layer.borderColor = color.pulseBorder
      pulse.layer.backgroundColor = color.pulseBackground

      return pulse
    }

    return (dot, createPulse(), createPulse())
  }
}

extension ViewController: MGLMapViewDelegate {
  func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
    guard
      let radarAnnotation = annotation as? RadarPointAnnotation,
      let markerLocation = radarAnnotation.location
    else { return nil }

    let annotationView = MGLAnnotationView()
    annotationView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)

    let (dot, pulse1, pulse2) = createMarkerViews(color: pulseColors.getNextColor())


    let relativeSize = Double(markerLocation.sizeIndex) / maxValue
    if relativeSize < 0.10 {
      annotationView.addSubview(dot)

      return annotationView
    } else {
      annotationView.addSubview(pulse1)
      annotationView.addSubview(pulse2)
      annotationView.addSubview(dot)

      let transform = CGAffineTransform(scaleX: CGFloat(Constants.maximumRadarScale * relativeSize), y: CGFloat(Constants.maximumRadarScale * relativeSize))

      UIView.animate(withDuration: Constants.pulseDuration, delay: 0, options: [.repeat, .curveEaseOut], animations: {
        pulse1.transform = transform
        pulse1.layer.borderWidth /= 10
        pulse1.alpha = 0
      }, completion: { _ in
        pulse1.alpha = 1
      })

      UIView.animate(withDuration: Constants.pulseDuration, delay: Constants.pulseDuration / 2, options: [.repeat, .curveEaseOut], animations: {
        pulse2.transform = transform
        pulse2.layer.borderWidth /= 10
        pulse2.alpha = 0
      }, completion: { _ in
        pulse2.alpha = 1
      })

      return annotationView
    }
  }

  func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
    return nil
  }

  func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
    guard
      let radarAnnotation = annotation as? RadarPointAnnotation,
      let markerLocation = radarAnnotation.location
      else { return }

    print(markerLocation)
  }

  func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
    print("HI")
  }

  func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
    return true
  }
}

