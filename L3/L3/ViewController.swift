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
    static let maximumRadarScale: Double = 12
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

    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.mapViewTapped(sender:)))
    for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
      singleTap.require(toFail: recognizer)
    }
    mapView.addGestureRecognizer(singleTap)
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
      return annotation
    }

    mapView.addAnnotations(annotations)
  }

  func createMarkerViews(color: PulseColor, isSmall: Bool = false) -> (UIView, UIView, UIView) {

    // Dot view
    let dot = isSmall
      ? UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
      : UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    dot.layer.cornerRadius = isSmall ? 4 : 5
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

// MARK: IBActions
extension ViewController {
  @objc func mapViewTapped(sender: UIGestureRecognizer) {
    if sender.state == .ended {

      guard
        let mapView = mapView,
        let senderView = sender.view else { return }

      let point = sender.location(in: sender.view!)
      let touchCoordinate = mapView.convert(point, toCoordinateFrom: senderView)
      let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)

      // Get all annotations within a rect the size of a touch (44x44).
      let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
      let visibleAnnotations = mapView.visibleAnnotations(in: touchRect) ?? []
      let possibleAnnotations = visibleAnnotations.compactMap { $0 as? RadarPointAnnotation }

      // Select the closest feature to the touch center.
      let closestAnnotations = possibleAnnotations.sorted(by: {
        return CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: touchLocation) < CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: touchLocation)
      })
      if let selectedAnnotations = closestAnnotations.first {
        print(selectedAnnotations.location)
      }
    }
  }
}

extension ViewController: MGLMapViewDelegate {
  func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
    guard
      let radarAnnotation = annotation as? RadarPointAnnotation,
      let markerLocation = radarAnnotation.location
    else { return nil }

    let (identifier, nextColor) = pulseColors.getNextColor()
//    let (dot, pulse1, pulse2) = createMarkerViews(color: nextColor)


    let relativeSize = Double(markerLocation.sizeIndex) / maxValue
    if relativeSize < 0.10 {
      if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
        return annotationView
      } else {
        let annotationView = MGLAnnotationView(reuseIdentifier: identifier)
        annotationView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)

        let (dot, _, _) = createMarkerViews(color: nextColor, isSmall: true)
        annotationView.addSubview(dot)

        return annotationView
      }
    } else {
      let annotationView = MGLAnnotationView()
      annotationView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
      let (dot, pulse1, pulse2) = createMarkerViews(color: nextColor)
      annotationView.addSubview(pulse1)
      annotationView.addSubview(pulse2)
      annotationView.addSubview(dot)

      let pulseRelativeSize = sqrt(Double(markerLocation.sizeIndex)) / sqrt(maxValue)
      let transform = CGAffineTransform(scaleX: CGFloat(Constants.maximumRadarScale * pulseRelativeSize), y: CGFloat(Constants.maximumRadarScale * pulseRelativeSize))

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
}

