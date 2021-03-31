//
//  ResultsPresenter.swift
//  What animal should i get?
//
//  Created by Tanya on 29.03.2021.
//

import Foundation

class ResultsPresenter {
    
    func updateResult(_ view: ResultsView) {
        
        var frequencyOfAnimals: [AnimalType: Int] = [:]
        let animals = view.answers.map { $0.type }
        
        for animal in animals {
            if let animalTypeCount = frequencyOfAnimals[animal] {
                frequencyOfAnimals[animal] = animalTypeCount + 1
            } else {
                frequencyOfAnimals[animal] = 1
            }
        }
        
        let sortedFrequencyOfAnimal = frequencyOfAnimals.sorted { $0.value > $1.value }
        guard let mostFrequencyAnimal = sortedFrequencyOfAnimal.first?.key else { return }
        
        updateUI(view, with: mostFrequencyAnimal)
    }
    
    func updateUI(_ view: ResultsView, with animal: AnimalType) {
        
        view.animalTypeLabel.text = "Your animal - \(animal.rawValue)!"
        view.discriptionLabel.text = animal.definitionAnimal
    }
}
