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

struct QuizTopic: Codable {
    let title: String
    let desc: String
    let questions: [QuizQuestion]
}

struct QuizQuestion: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

var quizTopics: [QuizTopic] = [] // will be populated with api calls
let imgURLS = ["science_quiz", "deadpool_quiz", "math_quiz"]

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizTableCell
        let quiz = quizTopics[indexPath.row]
        cell.titleLabel.text = quiz.title
        cell.decriptionLabel.text = quiz.desc
        cell.iconImageView.image = UIImage(named: imgURLS[indexPath.row])
     
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.hidesBackButton = true
        self.fetchQuizData(from: "https://tednewardsandbox.site44.com/questions.json")
        print(quizTopics)
//        print(tableView.dequeueReusableCell(withIdentifier: "QuizCell")!) // reurns nil
    }
    
    @IBAction func btnAlert(_ sender: UIBarButtonItem!) {
        let alertController = UIAlertController(title: "Settings", message: "Enter data source URL", preferredStyle: .alert)
        
        alertController.addTextField { field in
            field.placeholder = "Enter URL"
            if let savedURL = UserDefaults.standard.string(forKey: "dataSourceURL") {
                field.text = savedURL
            }
            // need to check is url is epty?? Just make sure can't save empty url
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Check Now", style: .default, handler: {_ in
            //handler function for checking URL
            guard let fields = alertController.textFields, fields.count == 1 else {
                return
            }
            let urlField = fields[0]
            guard let url = urlField.text, !url.isEmpty else {
                return
            }
            UserDefaults.standard.set(url, forKey: "dataSourceURL")
            self.fetchQuizData(from: url)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // making http request
    func fetchQuizData(from urlStr: String) {
    
        guard let url = URL(string: urlStr) else {
            return
        }
        
        // issues the request (hit the api)
        (URLSession.shared.dataTask(with: url) {data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Download Failed", message: error.localizedDescription)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Download Failed", message: "No data returned")
                }
                return
            }
            // have data, try decoding
            do {
                quizTopics = try JSONDecoder().decode([QuizTopic].self, from: data) // converts bites to Response codable
                print("This is the response", quizTopics)
                // updates table view UI on
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Could not parse data")
                }
            }
            
        }).resume()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)  -> CGFloat{
            return 100
        }
    
    // segues
    var selectedQuiz: QuizTopic!
    var quizImg: String!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuiz = quizTopics[indexPath.row]
        quizImg = imgURLS[indexPath.row]
        performSegue(withIdentifier: "toQuestionScene", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestionScene" {
            if let destination = segue.destination as? QuestionViewController {
                destination.quizTopic = selectedQuiz
                destination.quizImg = quizImg
    
            }
        }
    }
}


