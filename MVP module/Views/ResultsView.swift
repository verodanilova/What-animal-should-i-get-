//
//  ResultsView.swift
//  What animal should i get?
//
//  Created by Tanya on 25.03.2021.
//

import UIKit

class ResultsView: UIViewController {
    
    @IBOutlet var animalTypeLabel: UILabel!
    @IBOutlet var discriptionLabel: UILabel!
    
    var answers: [Answer] = []
    
    private let presenter = ResultsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        presenter.updateResult(self)
    }
}




