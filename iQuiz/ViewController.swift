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

struct QuizTopic {
    let title: String
    let description: String
    let imageName: String
}

let quizTopics = [QuizTopic(title: "Mathematics", description: "This quiz will test your math ability", imageName: "math_quiz"), QuizTopic(title: "Science", description: "This quiz will test your science knowledge", imageName: "science_quiz"), QuizTopic(title: "Marvel", description: "This quiz will test your DeadPool knowledge", imageName: "deadpool_quiz")]

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
        

}

