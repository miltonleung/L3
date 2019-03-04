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
  }

  @IBOutlet weak var panelView: PanelView!
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.register(CityHeaderCell.self)
      tableView.register(CityImageCell.self)
      tableView.register(CityStatisticsCell.self)
      tableView.register(CityActionCell.self)
    }
  }

  var viewModel: CityViewModel

  init(viewModel: CityViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  func configure() {
    self.view.backgroundColor = .clear

    panelView.layer.cornerRadius = 23
    panelView.layer.masksToBounds = true
//    panelView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 0.3304291524)
    panelView.layer.shadowOffset = CGSize(width: 0, height: 2)
    panelView.layer.shadowColor = #colorLiteral(red: 0.2823529412, green: 0.2823529412, blue: 0.2823529412, alpha: 0.934369649)
    panelView.layer.shadowOpacity = 1
    panelView.layer.shadowRadius = 9

    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = panelView.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    panelView.insertSubview(blurEffectView, at: 0)

    let backgroundView = UIView()
    backgroundView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    backgroundView.alpha = 0.8
    backgroundView.frame = panelView.bounds
    backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    panelView.insertSubview(backgroundView, aboveSubview: blurEffectView)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
    panelView.addGestureRecognizer(panGesture)

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

extension CityViewController: UITableViewDataSource {
  enum Section: Int {
    case header, statistics, action, company//company, action

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
    case .company: fatalError()
    case .action:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityActionCell", for: indexPath) as? CityActionCell else { fatalError() }
      cell.configure(viewModel: viewModel.cityActionCellViewModel)

      return cell
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
    case .action:
      return 1
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
      return 0
    case .action:
      return 89
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
    case .action: return
    }
  }
}

