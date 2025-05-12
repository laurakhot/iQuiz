//
//  ViewController.swift
//  iQuiz
//
//  Created by Laura Khotemlyansky on 5/4/25.
//

import UIKit

class QuizTableCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var decriptionLabel: UILabel!
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let answerIndex: Int
}

struct QuizTopic {
    let title: String
    let description: String
    let imageName: String
    let questions: [QuizQuestion]
}

let quizTopics = [
    QuizTopic(title: "Mathematics", description: "This quiz will test your math ability", imageName: "math_quiz", questions: [QuizQuestion(question: "What is 2 + 2?", options: ["1", "2", "3"], answerIndex: 1), QuizQuestion(question: "What is 5 * 3?", options:["15", "20", "25"], answerIndex: 0)]),
    QuizTopic(title: "Science", description: "This quiz will test your science knowledge", imageName: "science_quiz", questions: [QuizQuestion(question:"What is the powerhouse of the cell?", options:["nucleus", "ribosomes", "mitochondria"], answerIndex: 2), QuizQuestion(question:"What planet is closest to the sun?", options:["Venus", "Mercury", "Mars"], answerIndex: 1)]),
    QuizTopic(title: "Marvel", description: "This quiz will test your DeadPool knowledge", imageName: "deadpool_quiz", questions: [QuizQuestion(question:"What is Thor's hammer made of?", options:["Uru", "Titanium", "Gold"], answerIndex:0), QuizQuestion(question:"Who is Deadpool?", options:["Tony Stark", "Peter Parker", "Wade Wilson"], answerIndex: 2)])]

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizTableCell
        let quiz = quizTopics[indexPath.row]
        cell.titleLabel.text = quiz.title
        cell.decriptionLabel.text = quiz.description
        cell.iconImageView.image = UIImage(named: quiz.imageName)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        print(tableView.dequeueReusableCell(withIdentifier: "QuizCell")!) // reurns nil
    }
    
    @IBAction func btnAlert(_ sender: UIBarButtonItem!) {
        let alertController = UIAlertController(title: "Alert", message: "Settings go here", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)  -> CGFloat{
            return 100
        }
    
    
    // segues
    var selectedQuiz: QuizTopic!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuiz = quizTopics[indexPath.row]
        performSegue(withIdentifier: "toQuestionScene", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestionScene" {
            if let destination = segue.destination as? QuestionViewController {
                destination.quizTopic = selectedQuiz
            }
        }
    }
}

