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
  @IBOutlet weak var exploreButton: UIButton!

  var viewModel: PanelViewModel

  init(viewModel: PanelViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  func configure() {
    self.view.backgroundColor = .clear

    panelView.layer.cornerRadius = 23
    panelView.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 0.87)
    panelView.layer.shadowOffset = CGSize(width: 0, height: 2)
    panelView.layer.shadowColor = #colorLiteral(red: 0.2823529412, green: 0.2823529412, blue: 0.2823529412, alpha: 0.934369649)
    panelView.layer.shadowOpacity = 1
    panelView.layer.shadowRadius = 9

    titleLabel.text = viewModel.title
    titleLabel.textColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
    titleLabel.font = Font.bold(size: 18)

    numberOfJobsButton.setTitle(viewModel.numberOfJobsButtonTitle, for: .normal)
    numberOfJobsButton.titleLabel?.font = Font.bold(size: 16)
    numberOfJobsButton.titleLabel?.textAlignment = .center
    numberOfJobsButton.layer.borderColor = #colorLiteral(red: 0.3294117647, green: 0.5215686275, blue: 0.8823529412, alpha: 1)
    numberOfJobsButton.layer.cornerRadius = 6.8
    devSalaryButton.setTitle(viewModel.devSalaryButtonTitle, for: .normal)
    devSalaryButton.titleLabel?.font = Font.bold(size: 16)
    devSalaryButton.titleLabel?.textAlignment = .center
    devSalaryButton.layer.borderColor = #colorLiteral(red: 0.3294117647, green: 0.5215686275, blue: 0.8823529412, alpha: 1)
    devSalaryButton.layer.cornerRadius = 6.8

    monthlyRentButton.setTitle(viewModel.monthlyRentButtonTitle, for: .normal)
    monthlyRentButton.titleLabel?.font = Font.bold(size: 16)
    monthlyRentButton.titleLabel?.textAlignment = .center
    monthlyRentButton.layer.borderColor = #colorLiteral(red: 0.3294117647, green: 0.5215686275, blue: 0.8823529412, alpha: 1)
    monthlyRentButton.layer.cornerRadius = 6.8

    unselectAllButtons()
    selectButton(button: numberOfJobsButton)
    exploreButton.setTitle(viewModel.exploreButtonTitle, for: .normal)
    exploreButton.titleLabel?.font = Font.bold(size: 18)
    exploreButton.setTitleColor(#colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1), for: .normal)
    exploreButton.layer.cornerRadius = 8
    exploreButton.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: exploreButton.frame, andColors: [#colorLiteral(red: 0.831372549, green: 0.3098039216, blue: 0.5176470588, alpha: 0.85), #colorLiteral(red: 0.7764705882, green: 0.2196078431, blue: 0.4039215686, alpha: 0.85)])
  }

  fileprivate func unselectAllButtons() {
    numberOfJobsButton.setTitleColor(#colorLiteral(red: 0.3294117647, green: 0.5215686275, blue: 0.8823529412, alpha: 1), for: .normal)
    numberOfJobsButton.layer.borderWidth = 1.8
    numberOfJobsButton.backgroundColor = UIColor.clear

    devSalaryButton.setTitleColor(#colorLiteral(red: 0.3294117647, green: 0.5215686275, blue: 0.8823529412, alpha: 1), for: .normal)
    devSalaryButton.layer.borderWidth = 1.8
    devSalaryButton.backgroundColor = UIColor.clear

    monthlyRentButton.setTitleColor(#colorLiteral(red: 0.3294117647, green: 0.5215686275, blue: 0.8823529412, alpha: 1), for: .normal)
    monthlyRentButton.layer.borderWidth = 1.8
    monthlyRentButton.backgroundColor = UIColor.clear
  }

  fileprivate func selectButton(button: UIButton) {
    button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    button.layer.borderWidth = 0
    button.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.5215686275, blue: 0.8823529412, alpha: 1)
  }
}

// MARK: IBActions
extension PanelViewController {
  @IBAction private func numberOfJobsButtonTapped() {
    viewModel.locationFilterTapped(filter: .sizeIndex)
    unselectAllButtons()
    selectButton(button: numberOfJobsButton)
  }

  @IBAction private func devSalaryButtonTapped() {
    viewModel.locationFilterTapped(filter: .averageDevSalary)
    unselectAllButtons()
    selectButton(button: devSalaryButton)
  }

  @IBAction private func monthlyRentButtonTapped() {
    viewModel.locationFilterTapped(filter: .averageMonthlyRent)
    unselectAllButtons()
    selectButton(button: monthlyRentButton)
  }

  @IBAction private func exploreButtonTapped() {
    viewModel.onExploreButtonTapped?()
  }
}
