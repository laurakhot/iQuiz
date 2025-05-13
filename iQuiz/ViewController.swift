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

//let quizTopics = [
//    QuizTopic(title: "Mathematics", description: "This quiz will test your math ability", imageName: "math_quiz", questions: [QuizQuestion(question: "What is 2 + 2?", options: ["3", "4", "5"], answerIndex: 1), QuizQuestion(question: "What is 5 * 3?", options:["15", "20", "25"], answerIndex: 0), QuizQuestion(question: "What is 45 / 5?", options:["10", "9", "8"], answerIndex: 1)]),
//    QuizTopic(title: "Science", description: "This quiz will test your science knowledge", imageName: "science_quiz", questions: [QuizQuestion(question:"What is the powerhouse of the cell?", options:["nucleus", "ribosomes", "mitochondria"], answerIndex: 2), QuizQuestion(question:"What planet is closest to the sun?", options:["Venus", "Mercury", "Mars"], answerIndex: 1), QuizQuestion(question: "How do plants make food?", options:["photosynthesis", "hunting", "osmosis"], answerIndex: 0)]),
//    QuizTopic(title: "Marvel", description: "This quiz will test your DeadPool knowledge", imageName: "deadpool_quiz", questions: [QuizQuestion(question:"What is Thor's hammer made of?", options:["Uru", "Titanium", "Gold"], answerIndex:0), QuizQuestion(question:"Who is Deadpool?", options:["Tony Stark", "Peter Parker", "Wade Wilson"], answerIndex: 2), QuizQuestion(question: "What is Black Widow's real name?", options:["Natalie Portman", "Natasha Romanoff", "Yelena Belova"], answerIndex: 1)])]
let quizTopics: [QuizTopic] = [] // will be populated with api calls

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
        self.navigationItem.hidesBackButton = true
        self.fetchQuizData(from: "http://tednewardsandbox.site44.com/questions.json")
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
        // http logic
        // switch to other thread
        guard let url = URL(string: urlStr) else {
            return
        }
        
        var request = URLRequest(url: url)
        // method, body, headers
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "userId": 1,
            "title": "GET Request",
            "body": "Getting the quiz questions"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
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
            // try decoding
            do {
                let quizData = try JSONSerialization.jsonObject(with: data)
                // use JSONDecoder
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Could not parse data")
                }
            }
        }).resume()
    }
        // use codable object?
        
        
//        (URLSession.shared.dataTask(with: url) {data, response, error in guard let data = data, error == nil else {
//            return
//        }
//            do {
//                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            }
//            catch {
//                print(error)
//            }
//        }).resume()
    
    

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


