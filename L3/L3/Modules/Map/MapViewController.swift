//
//  MapViewController.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit
import Mapbox

class RadarPointAnnotation: MGLPointAnnotation {
  var location: Location? = nil
}

class CompanyPointAnnotation: MGLPointAnnotation {
  var company: CityCompany? = nil
}

final class MapViewController: UIViewController {
  fileprivate struct Constants {
    static let startingCoordinate: (lat: Double, long: Double) = (48.166666, -100.166666)
    static let maximumZoomLevel: Double = 16
    static let minimumZoomLevel: Double = 3
    static let maximumRadarScale: Double = 12
    static let pulseDuration: TimeInterval = 2.5
    static let cityViewingDistance: Double = 18265
    static let startingViewingDistance: Double = 9351822
    static let rightContentInset: CGFloat = 332
  }

  @IBOutlet weak var panelModelView: PassthroughContainerView!

  @IBOutlet weak var quickActionView: UIView!
  @IBOutlet weak var quickNightButton: UIButton!
  @IBOutlet weak var quickInfoButton: UIButton!
  @IBOutlet weak var quickAboutButton: UIButton!

  let pulseColors = PulseColors()
  
  var mapView: MGLMapView?
  fileprivate var maxValue: Double = 0
  fileprivate var attributionButtonFrame: CGRect = .zero
  fileprivate var previousAnnotation: RadarPointAnnotation?
  fileprivate var currentAnnotation: RadarPointAnnotation?
  fileprivate var selectedCompanies: [MGLAnnotationView] = []

  var viewModel: MapViewModel

  init(viewModel: MapViewModel) {
    self.viewModel = viewModel
    viewModel.setCoordinatorDelegate()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    stopObservingTheme()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    setupQuickAction()
    setupTheme()
    setupMap()
    setupPanel()
    viewModel.fetchLocations()
  }

  fileprivate func setupMap() {
    let url = URL(string: "mapbox://styles/miltonleung/cjse5srx71w1w1fpjejnfabhd")
    let mapView = MGLMapView(frame: view.bounds, styleURL: url)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    let camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: Constants.startingCoordinate.lat, longitude: Constants.startingCoordinate.long), acrossDistance: Constants.startingViewingDistance, pitch: 0, heading: 0)
    mapView.setCamera(camera, withDuration: 0, animationTimingFunction: nil, edgePadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -Constants.rightContentInset))

    mapView.allowsTilting = false
    mapView.allowsRotating = false
    mapView.maximumZoomLevel = Constants.maximumZoomLevel
    mapView.minimumZoomLevel = Constants.minimumZoomLevel

    mapView.delegate = self
    self.mapView = mapView
    view.insertSubview(mapView, at: 0)

    let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.mapViewTapped(sender:)))
    for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
      singleTap.require(toFail: recognizer)
    }
    mapView.addGestureRecognizer(singleTap)
  }

  func setupPanel() {
    let navigationController = viewModel.panelCoordinator.navigationController
    viewModel.panelCoordinator.start()
    addChild(navigationController)
    navigationController.view.frame = panelModelView.bounds
    panelModelView.addSubview(navigationController.view)
    navigationController.didMove(toParent: self)
  }

  func setupQuickAction() {
    quickActionView.layer.cornerRadius = 7
    quickActionView.layer.masksToBounds = true

    quickNightButton.setTitle(nil, for: .normal)
    quickInfoButton.setTitle(nil, for: .normal)
    quickInfoButton.setImage(#imageLiteral(resourceName: "quickActionInfo").withRenderingMode(.alwaysTemplate), for: .normal)
    quickAboutButton.setTitle(nil, for: .normal)
    quickAboutButton.setImage(#imageLiteral(resourceName: "quickActionAbout").withRenderingMode(.alwaysTemplate), for: .normal)
  }

  func configure() {
    attributionButtonFrame = CGRect(x: view.frame.width - 30, y: view.frame.height - 30, width: 22, height: 22)

    viewModel.onLocationsUpdated = updateMapCoordinates
    viewModel.onCameraChange = moveCamera(to:)
    viewModel.onEmptyCities = resetCompanies
    viewModel.onCityCompanySelected = flashSelectedCompany
  }

  private func updateMapCoordinates() {
    self.maxValue = calculateMaxValue(location: viewModel.locations.first)

    guard let mapView = mapView else { return }

    let annotations = viewModel.locations.map { location -> MGLPointAnnotation in
      let annotation = RadarPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      annotation.location = location
      return annotation
    }

    mapView.removeAnnotations(mapView.annotations ?? [])
    mapView.addAnnotations(annotations)
  }

  func moveCamera(to location: Location) {
    if let lastSelectedAnnotation = previousAnnotation {
      mapView?.addAnnotation(lastSelectedAnnotation)
    }
    removeCompanyAnnotations()
    let camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), acrossDistance: Constants.cityViewingDistance, pitch: 0, heading: 0)
    mapView?.fly(to: camera, completionHandler: {
      self.showCityCompanies(location: location)
    })
  }
}

// MARK: City Companies
extension MapViewController {
  private func getAnnotation(for location: Location) -> RadarPointAnnotation? {
    if let selectedLocationAnnotation = mapView?.annotations?.first(where: { annotation in
      if let selectedAnnotation = annotation as? RadarPointAnnotation,
        let selectedLocation = selectedAnnotation.location {
        return selectedLocation == location
      }
      return false
    }), let selectedRadarAnnotation = selectedLocationAnnotation as? RadarPointAnnotation {
      return selectedRadarAnnotation
    } else {
       return nil
    }
  }

  private func getAnnotation(for cityCompany: CityCompany) -> MGLAnnotationView? {
    for companyView in selectedCompanies {
      guard let companyAnnotation = companyView.annotation as? CompanyPointAnnotation,
        let company = companyAnnotation.company
        else { continue }
      if company == cityCompany {
        return companyView
      }
    }
    return nil
  }

  func showCityCompanies(location: Location) {
    if let selectedAnnotation = getAnnotation(for: location) {
      previousAnnotation = currentAnnotation
      currentAnnotation = selectedAnnotation
      mapView?.removeAnnotation(selectedAnnotation)

      if let previousAnnotation = previousAnnotation {
        mapView?.addAnnotation(previousAnnotation)
      }
    }

    let annotations = location.notableCompanies.map { company -> [MGLPointAnnotation] in
      return company.addresses.map { address -> MGLPointAnnotation in
        let annotation = CompanyPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        annotation.company = company
        return annotation
      }
    }.flatMap { $0 }

    mapView?.addAnnotations(annotations)
  }

  func removeCompanyAnnotations() {
    let companyAnnotations = selectedCompanies
      .filter { $0.annotation is CompanyPointAnnotation }

    UIView.animate(withDuration: 0.3, animations: {
      companyAnnotations.forEach { annotation in
        annotation.alpha = 0
      }
    }, completion: { _ in
      self.mapView?.removeAnnotations(self.selectedCompanies.compactMap { $0.annotation as? CompanyPointAnnotation })
      self.selectedCompanies.removeAll()
    })
  }

  func resetCompanies() {
    if let currentAnnotation = currentAnnotation {
      mapView?.addAnnotation(currentAnnotation)
    }

    previousAnnotation = nil
    currentAnnotation = nil
    removeCompanyAnnotations()
  }

  func flashSelectedCompany(cityCompany: CityCompany) {
    guard let selectedCompany = getAnnotation(for: cityCompany),
      let companySuperview = selectedCompany.superview
      else { return }
    companySuperview.bringSubviewToFront(selectedCompany)

    guard let dot = selectedCompany.subviews.last else { return }

    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.autoreverses = true
    scaleAnimation.duration = 0.5
    scaleAnimation.repeatCount = 2
    scaleAnimation.fromValue = 1
    scaleAnimation.toValue = 3
    scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    dot.layer.add(scaleAnimation, forKey: nil)
  }
}

// MARK: Location Sort Methods
extension MapViewController {
  func calculateMaxValue(location: Location?) -> Double {
    switch viewModel.locationFilter {
    case .sizeIndex:
      return Double(location?.sizeIndex ?? 0)
    case .averageDevSalary:
      return location?.averageDevSalary ?? 0
    case .averageMonthlyRent:
      return location?.averageMonthlyRent ?? 0
    }
  }

  func sizeIsDot(location: Location) -> Bool {
    switch viewModel.locationFilter {
    case .sizeIndex:
      return Double(location.sizeIndex) / maxValue < 0.25
    case .averageDevSalary:
      return location.averageDevSalary / maxValue < 0.85
    case .averageMonthlyRent:
      guard let monthlyRent = location.averageMonthlyRent else { return true }
      return monthlyRent / maxValue  < 0.60
    }
  }

  func calculatePulseRelativeSize(location: Location) -> Double {
    switch viewModel.locationFilter {
    case .sizeIndex:
      return sqrt(Double(location.sizeIndex)) / sqrt(maxValue)
    case .averageDevSalary:
      return location.averageDevSalary / maxValue
    case .averageMonthlyRent:
      guard let monthlyRent = location.averageMonthlyRent else { return 0 }
      return sqrt(monthlyRent) / sqrt(maxValue)
    }
  }
}

extension MapViewController: Themeable {
  func onThemeChanged(theme: Theme) {
    switch theme {
    case .dark:
      quickActionView.backgroundColor = Colors.darkPanelBackground
      quickActionView.layer.borderWidth = 1
      quickActionView.layer.borderColor = Colors.darkPanelBorder.cgColor
      quickActionView.layer.shadowOffset = CGSize(width: 0, height: 8)
      quickActionView.layer.shadowColor = Colors.darkPanelShadow.cgColor
      quickActionView.layer.shadowOpacity = 1
      quickActionView.layer.shadowRadius = 13

      quickNightButton.setImage(#imageLiteral(resourceName: "quickActionDay").withRenderingMode(.alwaysTemplate), for: .normal)
      quickNightButton.imageView?.tintColor = Colors.darkQuickActionButtonColor
      quickInfoButton.imageView?.tintColor = Colors.darkQuickActionButtonColor
      quickAboutButton.imageView?.tintColor = Colors.darkQuickActionButtonColor

    case .light:
      quickActionView.backgroundColor = Colors.lightPanelBackground
      quickActionView.layer.borderWidth = 0
      quickActionView.layer.shadowOffset = CGSize(width: 0, height: 2)
      quickActionView.layer.shadowColor = Colors.lightPanelShadow.cgColor
      quickActionView.layer.shadowOpacity = 1
      quickActionView.layer.shadowRadius = 9

      quickNightButton.setImage(#imageLiteral(resourceName: "quickActionNight").withRenderingMode(.alwaysTemplate), for: .normal)
      quickNightButton.imageView?.tintColor = Colors.lightQuickActionButtonColor
      quickInfoButton.imageView?.tintColor = Colors.lightQuickActionButtonColor
      quickAboutButton.imageView?.tintColor = Colors.lightQuickActionButtonColor
    }
  }
}

// MARK: IBActions
extension MapViewController {
  @IBAction private func quickNightButtonTapped() {
    ThemeManager.shared.switchTheme()
  }

  @IBAction private func quickInfoButtonTapped() {

  }

  @IBAction private func quickAboutButtonTapped() {

  }


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
      if let closestAnnotation = closestAnnotations.first, let location = closestAnnotation.location {
        viewModel.locationTapped(location: location)
      }
    }
  }
}

// MARK: Marker Factory
extension MapViewController {
  func createLocationMarkerViews(color: PulseColor, isSmall: Bool = false) -> (UIView, UIView, UIView) {

    // Dot view
    let dot = isSmall
      ? UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
      : UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    dot.layer.cornerRadius = isSmall ? 4 : 5
    dot.layer.borderWidth = 1
    dot.layer.borderColor = color.dotBorder
    dot.layer.backgroundColor = color.dotBackground
    dot.layer.shouldRasterize = true
    dot.layer.rasterizationScale = UIScreen.main.scale

    func createPulse() -> UIView {
      let pulse = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
      pulse.layer.cornerRadius = pulse.frame.height / 2
      pulse.layer.borderWidth = 1
      pulse.layer.borderColor = color.pulseBorder
      pulse.layer.backgroundColor = color.pulseBackground
      pulse.layer.shouldRasterize = true
      pulse.layer.rasterizationScale = UIScreen.main.scale * 12

      return pulse
    }

    return (dot, createPulse(), createPulse())
  }

  func createCityMarkerViews(color: PulseColor) -> UIView {
    let dot = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
    dot.layer.cornerRadius = dot.frame.height / 2
    dot.layer.borderWidth = 1.2
    dot.layer.borderColor = color.pulseBorder
    dot.layer.backgroundColor = color.pulseBackground.copy(alpha: 0.9)
    dot.layer.shouldRasterize = true
    dot.layer.rasterizationScale = UIScreen.main.scale * 4
    return dot
  }
}

extension MapViewController: MGLMapViewDelegate {
  private func createAnnotationView(_ mapView: MGLMapView, for annotation: RadarPointAnnotation) -> MGLAnnotationView? {
    guard let markerLocation = annotation.location
      else { return nil }

    let (identifier, nextColor) = pulseColors.getNextColor()

    if sizeIsDot(location: markerLocation) {
      if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
        return annotationView
      } else {
        let annotationView = MGLAnnotationView(reuseIdentifier: identifier)
        annotationView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)

        let (dot, _, _) = createLocationMarkerViews(color: nextColor, isSmall: true)
        annotationView.addSubview(dot)

        return annotationView
      }
    } else {
      let annotationView = MGLAnnotationView()
      annotationView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
      let (dot, pulse1, pulse2) = createLocationMarkerViews(color: nextColor)
      annotationView.addSubview(pulse1)
      annotationView.addSubview(pulse2)
      annotationView.addSubview(dot)

      let pulseRelativeSize = calculatePulseRelativeSize(location: markerLocation)
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

  private func createAnnotationView(_ mapView: MGLMapView, for annotation: CompanyPointAnnotation) -> MGLAnnotationView? {
    var (identifier, nextColor) = pulseColors.getNextColor()
    identifier = "city" + identifier

    if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {

      selectedCompanies.append(annotationView)

      return annotationView
    } else {
      let annotationView = MGLAnnotationView(reuseIdentifier: identifier)
      annotationView.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
      annotationView.alpha = 0

      let dot = createCityMarkerViews(color: nextColor)
      annotationView.addSubview(dot)

      selectedCompanies.append(annotationView)

      return annotationView
    }
  }

  func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
    if let radarAnnotation = annotation as? RadarPointAnnotation {
      return createAnnotationView(mapView, for: radarAnnotation)
    } else if let companyAnnotation = annotation as? CompanyPointAnnotation {
      return createAnnotationView(mapView, for: companyAnnotation)
    } else {
      return nil
    }
  }

  func mapView(_ mapView: MGLMapView, didAdd annotationViews: [MGLAnnotationView]) {
    selectedCompanies
      .filter { $0.annotation is CompanyPointAnnotation }
      .forEach { annotation in
        guard let dot = annotation.subviews.last else { return }
        dot.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
          dot.transform = .identity
          annotation.alpha = 1
        }, completion: nil)
    }
  }

  func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
    return nil
  }

  func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
    guard
      let radarAnnotation = annotation as? RadarPointAnnotation,
      let location = radarAnnotation.location
      else { return }

    viewModel.locationTapped(location: location)
  }

  func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
    if reason == .programmatic {
      mapView.setContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: panelModelView.frame.width - 20), animated: animated)
      if mapView.attributionButton.frame != attributionButtonFrame {
        mapView.attributionButton.frame = attributionButtonFrame
      }
    }
  }
}
