//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Laura Khotemlyansky on 5/11/25.
//

import UIKit

class AnswerViewController: UIViewController {
    
    var quizTopic: QuizTopic!
    var currentQuestion: Int!
    var isCorrect: Bool!
    var isLastQuestion: Bool!
    var totalCorrect: Int!
    var correctAnswer: Int!
    var selectedAnswer: Int!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (i, button) in answerButtons.enumerated() {
            button.setTitle(quizTopic.questions[currentQuestion].options[i], for: .normal)
            button.setTitleColor(.white, for: .normal)
            if (button.tag == correctAnswer) {
                button.backgroundColor = .systemGreen
            } else if button.tag == selectedAnswer {
                button.backgroundColor = .systemRed
            }
        }
        
        if isCorrect {
            resultLabel.text = "You  are correct!"
        } else {
            resultLabel.text = "You are incorrect!"
        }
        
        questionLabel.text = quizTopic.questions[currentQuestion].question
        
        
        //back btn
        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backBtnPressed)
        )
                
        navigationItem.leftBarButtonItem = backBtn

        // Do any additional setup after loading the view.
    }
    
    @objc func backBtnPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if self.isLastQuestion {
            performSegue(withIdentifier: "toFinishedScene", sender: self)
        } else {
            performSegue(withIdentifier: "backToQuestionScene", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToQuestionScene",
           let destination = segue.destination as? QuestionViewController{
            destination.quizTopic = self.quizTopic
            destination.currentQuestion = self.currentQuestion + 1
            destination.totalCorrect = self.totalCorrect
        }
        if segue.identifier == "toFinishedScene",
           let destination = segue.destination as? FinishedViewController {
            destination.totalCorrect = self.totalCorrect
            destination.quizTopic = self.quizTopic
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
