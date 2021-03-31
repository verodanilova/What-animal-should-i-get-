//
//  IntroductionView.swift
//  What animal should i get?
//
//  Created by Tanya on 25.03.2021.
//

import UIKit

class IntroductionView: UIViewController {
    
    @IBOutlet var startPollButton: UIButton!
    
    private let presenter = IntroductionPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        presenter.changeButton(self)
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue){}
}
