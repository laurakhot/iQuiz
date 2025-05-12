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
    var selectedAnswer: Int?
    
    
    @IBOutlet var answerButtons: [UIButton]!
    
    @IBOutlet weak var quizNameLabel: UILabel!
    
    @IBOutlet weak var quizQuestionLabel: UILabel!
    @IBOutlet weak var quizImageIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizNameLabel.text = quizTopic.title
        quizImageIcon.image = UIImage(named: quizTopic.imageName)
        quizQuestionLabel.text = quizTopic.questions[currentQuestion].question
        for (i, button) in answerButtons.enumerated() {
            button.setTitle(quizTopic.questions[currentQuestion].options[i], for: .normal)
        }

        // Do any additional setup after loading the view.
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
