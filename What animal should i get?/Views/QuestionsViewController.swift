//
//  QuestionsViewController.swift
//  What animal should i get?
//
//  Created by Tanya on 25.03.2021.
//

import UIKit

class QuestionsViewController: UIViewController {
    
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
    
    private var questions: [Question] = [] {
        didSet {
            let answersCount = Float(questions[questionIndex].answers.count - 1)
            rangedSlider.maximumValue = answersCount
        }
    }
    
    private var questionIndex = 0
    private var answersChoosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getNetworkQuestions()
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsVC = segue.destination as! ResultsViewController
       resultsVC.answers = answersChoosen
    }
    
    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        
        guard let currentIndex = singleButtons.firstIndex(of: sender) else {
            return
        }
        
        let currentAnswer = currentAnswers[currentIndex]
        answersChoosen.append(currentAnswer)
        
       nextQuestion()
        
    }
    
    
    @IBAction func multipleAnswerPressed() {
        
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChoosen.append(answer)
            }
        }
        
    nextQuestion()
        
    }
    
    
    @IBAction func rangedAnswerButtonPressed(_ sender: Any) {
        
        let index = lrintf(rangedSlider.value)
        answersChoosen.append(currentAnswers[index])
        
      nextQuestion()
    }
}

extension QuestionsViewController {
    
    func updateUI() {
        
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        guard questionIndex < questions.count else {
            print("questionIndex: \(questionIndex)")
            print("questions.count: \(questionIndex)")
            return
        }
        
        let currentQuestion = questions[questionIndex]
        questionLabel.text = currentQuestion.text
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        questionProgressView.setProgress(totalProgress, animated: true)
        
        title = "Question № \(questionIndex + 1) in \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleAnswers(with: currentAnswers)
        case .multiple: showMultipleAnswers(with: currentAnswers)
        case .ranged: showRangedAnswers(with: currentAnswers)
        }
    }
    
    func showSingleAnswers(with answers: [Answer]) {
        activityIndicator.isHidden = true
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    func showMultipleAnswers(with answers: [Answer]) {
        activityIndicator.isHidden = true
        multipleStackView.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    func showRangedAnswers(with answers: [Answer]) {
        activityIndicator.isHidden = true
        rangedStackView.isHidden = false
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
    
    func getNetworkQuestions() {
        activityIndicator.startAnimating()
        updateUI() //  создать новую функцию для скрытия всех элементов экрана
        
      Question.getQuestionsNetwork(){ [self]
          questionsFromJSON in
      
          if let networkQuestinos = questionsFromJSON {
               for element in networkQuestinos{
                    questions.append(element)
                }
                print(questions as Any)
            }
            
            activityIndicator.hidesWhenStopped = true
            updateUI()
        }
    }
}

