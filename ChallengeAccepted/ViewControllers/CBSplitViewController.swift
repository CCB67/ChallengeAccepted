//
//  CBSplitViewController.swift
//  ChallengeAccepted
//
//  Created by Carl-Christopher Biebow on 20.07.18.
//  Copyright © 2018 Carl-Christopher Biebow. All rights reserved.
//

import UIKit

class CBSplitViewController: UISplitViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
        minimumPrimaryColumnWidth = 300.0
        maximumPrimaryColumnWidth = 300.0
    }
}
