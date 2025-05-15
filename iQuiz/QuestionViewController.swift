//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Laura Khotemlyansky on 5/11/25.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var quizTopic: QuizTopic!
    var currentQuestion: Int = 0
    var selectedAnswer: Int!
    var totalCorrect: Int = 0
    var quizImg: String!
    
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBOutlet weak var quizNameLabel: UILabel!
    
    @IBOutlet weak var quizQuestionLabel: UILabel!
    @IBOutlet weak var quizImageIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizNameLabel.text = quizTopic.title
        quizImageIcon.image = UIImage(named: quizImg)
        quizQuestionLabel.text = quizTopic.questions[currentQuestion].text
        for (i, button) in answerButtons.enumerated() {
            button.setTitle(quizTopic.questions[currentQuestion].answers[i], for: .normal)
        }
        
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
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        selectedAnswer = sender.tag
        
        for button in answerButtons {
            if button == sender {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.systemBlue, for: .normal)
                
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let selected = selectedAnswer else {
            return
        }
        
        let isCorrect = (selected == Int(quizTopic.questions[currentQuestion].answer)! - 1)
        
        performSegue(withIdentifier: "toAnswerScene", sender: isCorrect)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswerScene",
            let destination = segue.destination as? AnswerViewController,
            let isCorrect = sender as? Bool {
                destination.isCorrect = isCorrect
                if isCorrect {
                    totalCorrect += 1
                }
                destination.totalCorrect = totalCorrect
                destination.quizTopic = self.quizTopic
                destination.currentQuestion = self.currentQuestion
            destination.correctAnswer = Int(quizTopic.questions[currentQuestion].answer)! - 1
                destination.selectedAnswer = self.selectedAnswer
                destination.isLastQuestion = (quizTopic.questions.count == currentQuestion + 1)
            destination.quizImg = quizImg
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
