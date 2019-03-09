//
//  CityViewController.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

enum PanelPosition {
  case top, middle, bottom
}

final class CityViewController: UIViewController {
  fileprivate struct Constants {
    static let backThreshold: CGFloat = 0.17
    static let scrollTopInset: CGFloat = 20
    static let panelBottomPositionHeight: CGFloat = 100
  }

  @IBOutlet weak var dragIndicator: UIView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var panelView: PanelView!
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.register(CityHeaderCell.self)
      tableView.register(CityImageCell.self)
      tableView.register(CityStatisticsCell.self)
      tableView.register(CityCompanyHeaderCell.self)
      tableView.register(CityCompaniesCell.self)
    }
  }
  @IBOutlet weak var actionButtonCompactBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var panelViewCompactTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var panelViewCompactHeightConstraint: NSLayoutConstraint!

  var panelTopPosition: CGFloat!
  var panelMiddlePosition: CGFloat!
  var panelBottomPosition: CGFloat!
  var currentPosition: PanelPosition = .top

  var backPanGesture: UIPanGestureRecognizer?
  var panGesture: UIPanGestureRecognizer?

  var backgroundView: UIView?

  var viewModel: CityViewModel

  init(viewModel: CityViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    stopObservingTheme()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.flashScrollIndicators()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updatePanelPositions()
    configure()
    setupTheme()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updatePanelPositions()

    switch traitCollection.horizontalSizeClass {
    case .compact:
      setupForCompactEnvironment()
    case .unspecified: fallthrough
    case .regular:
      setupForRegularEnvironment()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
      switch traitCollection.horizontalSizeClass {
      case .compact:
        setupForCompactEnvironment()
      case .unspecified: fallthrough
      case .regular:
        setupForRegularEnvironment()
      }
    }
  }

  fileprivate func updatePanelPositions() {
    let safeArea = view.safeAreaLayoutGuide.layoutFrame

    panelTopPosition = safeArea.origin.y + 20
    panelMiddlePosition = safeArea.origin.y + safeArea.height - 230
    panelBottomPosition = safeArea.origin.y + safeArea.height - 100
  }

  func configure() {
    self.view.backgroundColor = .clear

    panelView.layer.cornerRadius = 23
    panelView.layer.masksToBounds = true

    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = panelView.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    panelView.insertSubview(blurEffectView, at: 0)

    let backgroundView = UIView()
    backgroundView.frame = panelView.bounds
    backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.backgroundView = backgroundView
    panelView.insertSubview(backgroundView, aboveSubview: blurEffectView)

    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.scrollIndicatorInsets = UIEdgeInsets(top: Constants.scrollTopInset, left: 0, bottom: 0, right: 0)

    let backPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBackPanGesture(sender:)))
    panelView.addGestureRecognizer(backPanGesture)
    self.backPanGesture = backPanGesture

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
    panGesture.delegate = self
    tableView.addGestureRecognizer(panGesture)
    self.panGesture = panGesture

    closeButton.setTitle(nil, for: .normal)

    dragIndicator.layer.cornerRadius = 3.5
    dragIndicator.layer.masksToBounds = true
    dragIndicator.isUserInteractionEnabled = false

    actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    actionButton.titleLabel?.font = Font.bold(size: 18)
    actionButton.layer.cornerRadius = 8
  }

  @objc func handleBackPanGesture(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: panelView)
    if translation.x > panelView.frame.width * Constants.backThreshold && !isBeingDismissed {
      sender.setTranslation(.zero, in: panelView)
      panelView.removeGestureRecognizer(sender)
      viewModel.onBackPanned?()
    }
  }

  func setupForCompactEnvironment() {
    let safeArea = view.safeAreaLayoutGuide.layoutFrame

    panelView.layer.cornerRadius = 15
    panelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    actionButtonCompactBottomConstraint.constant += view.safeAreaInsets.bottom

    panGesture?.isEnabled = true

    panelViewCompactTopConstraint.isActive = false

    switch currentPosition {
    case .top:
      panelView.frame = CGRect(x: 0, y: panelTopPosition, width: panelView.frame.width, height: safeArea.height + view.safeAreaInsets.bottom -  panelTopPosition)
      panelViewCompactTopConstraint.constant = panelTopPosition
    case .middle:
      panelView.frame = CGRect(x: 0, y: panelMiddlePosition, width: panelView.frame.width, height: safeArea.height + view.safeAreaInsets.bottom -  panelTopPosition)
      panelViewCompactTopConstraint.constant = panelMiddlePosition
    case .bottom:
      panelView.frame = CGRect(x: 0, y: panelBottomPosition, width: panelView.frame.width, height: safeArea.height + view.safeAreaInsets.bottom -  panelTopPosition)
      panelViewCompactTopConstraint.constant = panelBottomPosition
    }

    self.tableView.isScrollEnabled = self.panelView.frame.origin.y == panelTopPosition
  }

  func setupForRegularEnvironment() {
    panelView.layer.cornerRadius = 23
    panelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]

    panGesture?.isEnabled = false
  }
}

extension CityViewController {
  private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
    return (initialVelocity / 1000.0) * decelerationRate / (1.0 - decelerationRate)
  }

  private func nearestPosition(positionY: CGFloat) -> (PanelPosition, CGFloat)? {
    guard let topPosition = panelTopPosition,
      let middlePosition = panelMiddlePosition,
      let bottomPosition = panelBottomPosition
      else { return nil }

    if abs(positionY - topPosition) < abs(positionY - bottomPosition)
      && abs(positionY - topPosition) < abs(positionY - middlePosition) {
      return (.top, topPosition)
    } else if abs(positionY - middlePosition) < abs(positionY - bottomPosition)
      && abs(positionY - middlePosition) < abs(positionY - topPosition) {
      return (.middle, middlePosition)
    } else {
      return (.bottom, bottomPosition)
    }
  }

  private func calculateDuration(origin: CGFloat, velocity: CGFloat, destination: CGFloat) -> TimeInterval {
    return TimeInterval(abs(destination - origin) / velocity)
  }

  @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
    guard let panelTopPosition = panelTopPosition,
      let panelBottomPosition = panelBottomPosition,
      let panelMiddlePosition = panelMiddlePosition,
      let backPanGesture = backPanGesture
      else { return }

    switch sender.state {
    case .began, .changed:

      if tableView.contentOffset.y <= 0 {
        tableView.isScrollEnabled = false
        backPanGesture.isEnabled = true
        let translation = sender.translation(in: panelView).y


        let newPosition = max(panelTopPosition, min(panelView.frame.origin.y + translation, panelBottomPosition))

        panelView.frame.origin.y = newPosition

        sender.setTranslation(.zero, in: panelView)
      }
    case .ended:
      guard tableView.contentOffset.y <= 0 else { return }
      let decelerationRate = UIScrollView.DecelerationRate.normal
      let velocity = sender.velocity(in: panelView).y

      let projectedPosition = panelView.frame.origin.y + project(initialVelocity: velocity, decelerationRate: decelerationRate.rawValue)

      guard let (newPosition, newOrigin) = nearestPosition(positionY: projectedPosition) else { return }
      let duration = calculateDuration(origin: panelView.frame.origin.y,
                                       velocity: velocity,
                                       destination: newOrigin)

      self.view.layoutIfNeeded()
      UIView.animate(withDuration: min(0.3, duration), delay: 0, options: .curveEaseOut, animations: {
        self.panelView.frame.origin.y = newOrigin
        self.view.layoutIfNeeded()
      }, completion: { _ in
        self.tableView.isScrollEnabled = self.panelView.frame.origin.y == panelTopPosition
        backPanGesture.isEnabled = true
        self.currentPosition = newPosition
      })

    default:
      return
    }
  }
}

extension CityViewController: Themeable {
  func onThemeChanged(theme: Theme) {
    switch theme {
    case .dark:
      panelView.layer.shadowOffset = CGSize(width: 0, height: 8)
      panelView.layer.shadowColor = Colors.darkPanelShadow.cgColor
      panelView.layer.shadowOpacity = 1
      panelView.layer.shadowRadius = 13
      panelView.layer.borderWidth = 3
      panelView.layer.borderColor = Colors.darkPanelBorder.cgColor

      backgroundView?.backgroundColor = Colors.darkPanelBackground

      actionButton.setTitleColor(Colors.darkActionText, for: .normal)
      actionButton.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: actionButton.frame, andColors: [Colors.darkActionTop, Colors.darkActionBottom])

      closeButton.setImage(#imageLiteral(resourceName: "darkCloseButton").withRenderingMode(.alwaysOriginal), for: .normal)

      dragIndicator.backgroundColor = Colors.darkDragIndicator
    case .light:
      panelView.layer.shadowOffset = CGSize(width: 0, height: 2)
      panelView.layer.shadowColor = Colors.lightPanelShadow.cgColor
      panelView.layer.shadowOpacity = 1
      panelView.layer.shadowRadius = 9
      panelView.layer.borderWidth = 0

      backgroundView?.backgroundColor = Colors.lightPanelBackground

      actionButton.setTitleColor(Colors.lightActionText, for: .normal)
      actionButton.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: actionButton.frame, andColors: [Colors.lightActionTop, Colors.lightActionBottom])

      closeButton.setImage(#imageLiteral(resourceName: "lightCloseButton").withRenderingMode(.alwaysOriginal), for: .normal)

      dragIndicator.backgroundColor = Colors.lightDragIndicator
    }
  }
}

// MARK: IBActions
extension CityViewController {
  @IBAction private func closeButtonTapped() {
    viewModel.onCloseTapped?()
  }

  @IBAction private func actionButtonTapped() {
    viewModel.onActionTapped?()
  }
}

extension CityViewController: UITableViewDataSource {
  enum Section: Int {
    case header, statistics, company

    static let count = 3
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return Section.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else { fatalError() }
    switch section {
    case .header:
      if indexPath.row == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityHeaderCell", for: indexPath) as? CityHeaderCell else { fatalError() }
        cell.configure(viewModel: viewModel.cityHeaderCellViewModel)

        return cell
      } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityImageCell", for: indexPath) as? CityImageCell else { fatalError() }
        cell.configure(viewModel: viewModel.cityImageCellViewModel)

        return cell
      }
    case .statistics:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityStatisticsCell", for: indexPath) as? CityStatisticsCell else { fatalError() }
      cell.configure(viewModel: viewModel.cityStatisticsCellViewModel)

      return cell
    case .company:
      if indexPath.row == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCompanyHeaderCell", for: indexPath) as? CityCompanyHeaderCell else { fatalError() }
        cell.configure(viewModel: viewModel.cityCompanyHeaderViewModel)

        return cell
      } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCompaniesCell", for: indexPath) as? CityCompaniesCell else { fatalError() }
        cell.configure(viewModel: viewModel.cityCompaniesViewModel)

        return cell
      }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let section = Section(rawValue: section) else { fatalError() }
    switch section {
    case .header:
      return viewModel.isImageAvailable ? 2 : 1
    case .statistics:
      return 1
    case .company:
      return 2
    }
  }
}

extension CityViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = Section(rawValue: indexPath.section) else { fatalError() }
    switch section {
    case .header:
      if indexPath.row == 0 {
        return 103
      } else {
        return 144
      }
    case .statistics:
      let numberOfRows = Double(viewModel.numberOfStatistics) / 2
      return CGFloat(ceil(numberOfRows)) * CityStatisticsCell.Constants.cellHeight + CityStatisticsCell.Constants.verticalPadding
    case .company:
      if indexPath.row == 0 {
        return 36
      } else {
        let numberOfRows = Double(viewModel.numberOfCompanies) / 2
        return CGFloat(ceil(numberOfRows)) * CityCompaniesCell.Constants.cellHeight
      }
    }
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let section = Section(rawValue: indexPath.section) else { fatalError() }
    switch section {
    case .header: return
    case .statistics: return
    case .company: return
    }
  }
}

extension CityViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
