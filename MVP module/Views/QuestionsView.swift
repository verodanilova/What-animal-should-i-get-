//
//  QuestionsView.swift
//  What animal should i get?
//
//  Created by Tanya on 25.03.2021.
//

import UIKit

class QuestionsView: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var rangedStackView: UIStackView!
    
    @IBOutlet var singleButtons: [UIButton]!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider!
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var questions: [Question] = [] {
        didSet {
            let answersCount = Float(questions[questionIndex].answers.count - 1)
            rangedSlider.maximumValue = answersCount
        }
    }
    
    var questionIndex = 0
    var answersChoosen: [Answer] = []
    var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    private var presenter = QuestionsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getNetworkQuestions(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let resultsView = segue.destination as! ResultsView
        resultsView.answers = answersChoosen
        
    }
    
    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        
        guard let currentIndex = singleButtons.firstIndex(of: sender) else {
            return
        }
        
        presenter.anyButtonPresedAction(self,.singleButton,currentIndex)
    }
    
    @IBAction func multipleAnswerPressed() {
        presenter.anyButtonPresedAction(self,.multipleButton,1)
    }
    
    @IBAction func rangedAnswerButtonPressed(_ sender: Any) {
        presenter.anyButtonPresedAction(self,.rangedAnswerButton,1)
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func appearNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

