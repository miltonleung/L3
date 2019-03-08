//
//  CityViewController.swift
//  L3
//
//  Created by Milton Leung on 2019-03-01.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit

final class CityViewController: UIViewController {
  fileprivate struct Constants {
    static let backThreshold: CGFloat = 0.17
    static let scrollTopInset: CGFloat = 20
  }

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
    configure()
    setupTheme()
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

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
    panelView.addGestureRecognizer(panGesture)

    closeButton.setTitle(nil, for: .normal)

    actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    actionButton.titleLabel?.font = Font.bold(size: 18)
    actionButton.layer.cornerRadius = 8
  }

  @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: panelView)
    if translation.x > panelView.frame.width * Constants.backThreshold && !isBeingDismissed {
      sender.setTranslation(.zero, in: panelView)
      panelView.removeGestureRecognizer(sender)
      viewModel.onBackPanned?()
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

