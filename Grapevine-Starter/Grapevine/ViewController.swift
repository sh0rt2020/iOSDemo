/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class ViewController: UIViewController {
  // MARK: - Variables
  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var appNameLabel: UILabel!
  @IBOutlet private weak var skipButton: UIButton!
  @IBOutlet private weak var appImageView: UIImageView!
  @IBOutlet private weak var welcomeLabel: UILabel!
  @IBOutlet private weak var summaryLabel: UILabel!
  @IBOutlet private weak var pageControl: UIPageControl!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    appImageView.hidden = true
//    welcomeLabel.hidden = true
//    summaryLabel.hidden = true
//    pageControl.hidden = true
    

    let views = ["iconImageView": iconImageView,
                 "appNameLabel": appNameLabel,
                 "skipButton": skipButton,
                 "appImageView": appImageView,
                 "welcomeLabel": welcomeLabel,
                 "summaryLabel": summaryLabel,
                 "pageControl": pageControl]
    
    iconImageView.backgroundColor = UIColor.redColor()
    appNameLabel.backgroundColor = UIColor.redColor()
    skipButton.backgroundColor = UIColor.redColor()
    
    var allConstraints = [NSLayoutConstraint]()
    
    let nameLabelVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-23-[appNameLabel]", options:[], metrics:nil, views:views)
    allConstraints += nameLabelVerticalConstraints
    
    let iconImageViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[iconImageView(30)]", options:[], metrics:nil, views:views)
    allConstraints += iconImageViewVerticalConstraints
    
    let skipButtonVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[skipButton]", options:[], metrics:nil, views:views)
    allConstraints += skipButtonVerticalConstraints
    
    let topRowHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImageView(30)]-[appNameLabel]-[skipButton]-15-|", options:[], metrics:nil, views:views)
    allConstraints += topRowHorizontalConstraints
    
    let summaryLabelHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[summaryLabel]-15-|", options: [], metrics: nil, views: views)
    allConstraints += summaryLabelHorizontalConstraints
    
    let welcomeHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-15-[welcomeLabel]-15-|",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += welcomeHorizontalConstraints
    
    let iconToImageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[iconImageView]-10-[appImageView]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += iconToImageVerticalConstraints
    
    let imageToWelcomeVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[appImageView]-10-[welcomeLabel]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += imageToWelcomeVerticalConstraints
    
    let summaryLabelVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[welcomeLabel]-4-[summaryLabel]",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += summaryLabelVerticalConstraints
    
    let summaryToPageVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[summaryLabel]-15-[pageControl(9)]-15-|",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += summaryToPageVerticalConstraints
    
    NSLayoutConstraint.activateConstraints(allConstraints)
  }
}
