//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Laura Khotemlyansky on 5/11/25.
//

import UIKit

class FinishedViewController: UIViewController {
    
    var totalCorrect: Int!
    var quizTopic: QuizTopic!

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.text = "\(totalCorrect ?? 0)/\(quizTopic.questions.count)"
        var feedback = ""
        if Double(totalCorrect / quizTopic.questions.count) >= 0.8 {
            feedback = "Perfect!"
        } else {
            feedback = "Almost there! Try again next time."
        }
        feedbackLabel.text = feedback
        
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
        performSegue(withIdentifier: "backToHomeScene", sender: self)
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
