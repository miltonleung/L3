//
//  PanelViewController.swift
//  L3
//
//  Created by Milton Leung on 2019-02-28.
//  Copyright (c) 2019 ms. All rights reserved.
//

import UIKit
import ChameleonFramework

final class PanelViewController: UIViewController {
  @IBOutlet weak var panelView: PanelView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var numberOfJobsButton: UIButton!
  @IBOutlet weak var devSalaryButton: UIButton!
  @IBOutlet weak var monthlyRentButton: UIButton!
  @IBOutlet weak var adjustedDevSalaryButton: UIButton!
  @IBOutlet weak var exploreButton: UIButton!

  @IBOutlet weak var panelViewCompactHeight: NSLayoutConstraint!

  var backgroundView: UIView?

  var viewModel: PanelViewModel

  init(viewModel: PanelViewModel) {
    self.viewModel = viewModel
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
    setupTheme()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
      switch traitCollection.horizontalSizeClass {
      case .compact:
        setupForCompactEnvironment()
      case .unspecified: fallthrough
      case .regular:
        setupForRegularEnvironment()
      }
    }
  }

  func configure() {
    self.view.backgroundColor = .clear

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

    titleLabel.text = viewModel.title
    titleLabel.font = Font.bold(size: 18)

    numberOfJobsButton.setTitle(viewModel.numberOfJobsButtonTitle, for: .normal)
    numberOfJobsButton.titleLabel?.font = Font.bold(size: 16)
    numberOfJobsButton.titleLabel?.textAlignment = .center
    numberOfJobsButton.layer.cornerRadius = 6.8
    devSalaryButton.setTitle(viewModel.devSalaryButtonTitle, for: .normal)
    devSalaryButton.titleLabel?.font = Font.bold(size: 16)
    devSalaryButton.titleLabel?.textAlignment = .center
    devSalaryButton.layer.cornerRadius = 6.8
    monthlyRentButton.setTitle(viewModel.monthlyRentButtonTitle, for: .normal)
    monthlyRentButton.titleLabel?.font = Font.bold(size: 16)
    monthlyRentButton.titleLabel?.textAlignment = .center
    monthlyRentButton.layer.cornerRadius = 6.8
    adjustedDevSalaryButton.setTitle(viewModel.adjustedDevSalaryButtonTitle, for: .normal)
    adjustedDevSalaryButton.titleLabel?.font = Font.bold(size: 16)
    adjustedDevSalaryButton.titleLabel?.textAlignment = .center
    adjustedDevSalaryButton.layer.cornerRadius = 6.8

    unselectAllButtons()
    selectButton(button: numberOfJobsButton)
    exploreButton.setTitle(viewModel.exploreButtonTitle, for: .normal)
    exploreButton.titleLabel?.font = Font.bold(size: 18)
    exploreButton.layer.cornerRadius = 8
  }

  fileprivate func unselectAllButtons() {
    switch currentTheme {
    case .dark:
      numberOfJobsButton.setTitleColor(Colors.darkSeg, for: .normal)
      devSalaryButton.setTitleColor(Colors.darkSeg, for: .normal)
      monthlyRentButton.setTitleColor(Colors.darkSeg, for: .normal)
      adjustedDevSalaryButton.setTitleColor(Colors.darkSeg, for: .normal)
    case .light:
      numberOfJobsButton.setTitleColor(Colors.lightSeg, for: .normal)
      devSalaryButton.setTitleColor(Colors.lightSeg, for: .normal)
      monthlyRentButton.setTitleColor(Colors.lightSeg, for: .normal)
      adjustedDevSalaryButton.setTitleColor(Colors.lightSeg, for: .normal)
    }

    numberOfJobsButton.layer.borderWidth = 1.8
    numberOfJobsButton.backgroundColor = UIColor.clear

    devSalaryButton.layer.borderWidth = 1.8
    devSalaryButton.backgroundColor = UIColor.clear

    monthlyRentButton.layer.borderWidth = 1.8
    monthlyRentButton.backgroundColor = UIColor.clear

    adjustedDevSalaryButton.layer.borderWidth = 1.8
    adjustedDevSalaryButton.backgroundColor = UIColor.clear
  }

  fileprivate func selectButton(button: UIButton) {
    switch currentTheme {
    case .dark:
      button.backgroundColor = Colors.darkSeg.withAlphaComponent(0.72)
    case .light:
      button.backgroundColor = Colors.lightSeg.withAlphaComponent(0.72)
    }

    button.setTitleColor(Colors.whiteText, for: .normal)
    button.layer.borderWidth = 0
  }

  func setButtonState(button: UIButton) {
    unselectAllButtons()
    selectButton(button: button)
  }

  func setupForCompactEnvironment() {
    panelView.layer.cornerRadius = 15

    switch traitCollection.verticalSizeClass {
    case .compact:
      panelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    case .unspecified: fallthrough
    case .regular:
      panelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    panelViewCompactHeight.constant += view.safeAreaInsets.bottom
  }

  func setupForRegularEnvironment() {
    panelView.layer.cornerRadius = 23
    panelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
  }
}

extension PanelViewController: Themeable {
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

      titleLabel.textColor = Colors.darkHeader
      numberOfJobsButton.layer.borderColor = Colors.darkSeg.cgColor
      devSalaryButton.layer.borderColor = Colors.darkSeg.cgColor
      monthlyRentButton.layer.borderColor = Colors.darkSeg.cgColor
      adjustedDevSalaryButton.layer.borderColor = Colors.darkSeg.cgColor
      exploreButton.setTitleColor(Colors.darkActionText, for: .normal)
      exploreButton.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: exploreButton.frame, andColors: [Colors.darkActionTop, Colors.darkActionBottom])
    case .light:
      panelView.layer.shadowOffset = CGSize(width: 0, height: 2)
      panelView.layer.shadowColor = Colors.lightPanelShadow.cgColor
      panelView.layer.shadowOpacity = 1
      panelView.layer.shadowRadius = 9
      panelView.layer.borderWidth = 0

      backgroundView?.backgroundColor = Colors.lightPanelBackground

      titleLabel.textColor = Colors.lightHeader
      numberOfJobsButton.layer.borderColor = Colors.lightSeg.cgColor
      devSalaryButton.layer.borderColor = Colors.lightSeg.cgColor
      monthlyRentButton.layer.borderColor = Colors.lightSeg.cgColor
      adjustedDevSalaryButton.layer.borderColor = Colors.lightSeg.cgColor
      exploreButton.setTitleColor(Colors.lightActionText, for: .normal)
      exploreButton.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: exploreButton.frame, andColors: [Colors.lightActionTop, Colors.lightActionBottom])
    }
    switch viewModel.selectedButton {
    case .sizeIndex:
      setButtonState(button: numberOfJobsButton)
    case .averageDevSalary:
      setButtonState(button: devSalaryButton)
    case .averageMonthlyRent:
      setButtonState(button: monthlyRentButton)
    case .averageAdjustedDevSalary:
      setButtonState(button: adjustedDevSalaryButton)
    }
  }
}

// MARK: IBActions
extension PanelViewController {
  @IBAction private func numberOfJobsButtonTapped() {
    viewModel.locationFilterTapped(filter: .sizeIndex)
    setButtonState(button: numberOfJobsButton)
  }

  @IBAction private func devSalaryButtonTapped() {
    viewModel.locationFilterTapped(filter: .averageDevSalary)
    setButtonState(button: devSalaryButton)
  }

  @IBAction private func monthlyRentButtonTapped() {
    viewModel.locationFilterTapped(filter: .averageMonthlyRent)
    setButtonState(button: monthlyRentButton)
  }

  @IBAction private func adjustedDevSalaryButtonTapped() {
    viewModel.locationFilterTapped(filter: .averageAdjustedDevSalary)
    setButtonState(button: adjustedDevSalaryButton)
  }

  @IBAction private func exploreButtonTapped() {
    viewModel.onExploreButtonTapped?()
  }
}
