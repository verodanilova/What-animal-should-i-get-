//
//  QuestionsPresenter.swift
//  What animal should i get?
//
//  Created by Tanya on 26.03.2021.
//

import Foundation

class QuestionsPresenter {
    
    func updateUI(_ view: QuestionsView) {
        
        for stackView in [view.singleStackView, view.multipleStackView, view.rangedStackView] {
            stackView?.isHidden = true
        }
        
        guard view.questionIndex < view.questions.count else {
            print("questionIndex: \(view.questionIndex)")
            print("questions.count: \(view.questionIndex)")
            return
        }
        
        let currentQuestion = view.questions[view.questionIndex]
        view.questionLabel.text = currentQuestion.text
        
        let totalProgress = Float(view.questionIndex) / Float(view.questions.count)
        
        view.questionProgressView.setProgress(totalProgress, animated: true)
        
        view.title = "Question № \(view.questionIndex + 1) in \(view.questions.count)"
        
        showCurrentAnswers(view,for: currentQuestion.type)
    }
    
    func showCurrentAnswers(_ view: QuestionsView, for type: ResponseType) {
        
        switch type {
        case .single: showSingleAnswers(view,with: view.currentAnswers)
        case .multiple: showMultipleAnswers(view,with: view.currentAnswers)
        case .ranged: showRangedAnswers(view,with: view.currentAnswers)
        }
    }
    
    func showSingleAnswers(_ view: QuestionsView,with answers: [Answer]) {
        
        view.activityIndicator.isHidden = true
        view.singleStackView.isHidden = false
        
        for (button, answer) in zip(view.singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    func showMultipleAnswers(_ view: QuestionsView,with answers: [Answer]) {
        
        view.activityIndicator.isHidden = true
        view.multipleStackView.isHidden = false
        
        for (label, answer) in zip(view.multipleLabels, answers) {
            label.text = answer.text
        }
    }
    
    func showRangedAnswers(_ view: QuestionsView, with answers: [Answer]) {
        
        view.activityIndicator.isHidden = true
        view.rangedStackView.isHidden = false
        view.rangedLabels.first?.text = answers.first?.text
        view.rangedLabels.last?.text = answers.last?.text
    }
    
    func hideScreen(_ view: QuestionsView) {
        
        view.hideNavigationBar()
        view.questionProgressView.isHidden = true
        view.questionLabel.isHidden = true
        updateUI(view)
        view.activityIndicator.startAnimating()
    }
    
    func showScreen(_ view: QuestionsView) {
        
        view.activityIndicator.hidesWhenStopped = true
        view.appearNavigationBar()
        view.questionProgressView.isHidden = false
        view.questionLabel.isHidden = false
        updateUI(view)
    }
    
    func getNetworkQuestions(_ view: QuestionsView) {
        
        hideScreen(view)
        
        Question.getQuestionsNetwork() {
            questionsFromJSON in
            
            if let networkQuestinos = questionsFromJSON {
                for element in networkQuestinos {
                    view.questions.append(element)
                }
                
                print(view.questions as Any)
            }
            
            self.showScreen(view)
        }
    }
    
    func nextQuestion(_ view: QuestionsView) {
        
        view.questionIndex += 1
        
        if view.questionIndex < view.questions.count {
            updateUI(view)
        } else {
            view.performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
    
    func anyButtonPresedAction(_ view: QuestionsView,_ typeButton: typesButton,_ currentIndex: Int) {
        
        switch typeButton {
        case .singleButton:
            let currentAnswer = view.currentAnswers[currentIndex]
            view.answersChoosen.append(currentAnswer)
        case .multipleButton:
            for (multipleSwitch, answer) in zip(view.multipleSwitches, view.currentAnswers) {
                if multipleSwitch.isOn {
                    view.answersChoosen.append(answer)
                }
            }
        case .rangedAnswerButton:
            let index = lrintf(view.rangedSlider.value)
            view.answersChoosen.append(view.currentAnswers[index])
        }
        
        nextQuestion(view)
    }
    
    enum typesButton {
        case singleButton
        case multipleButton
        case rangedAnswerButton
    }
}

