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

struct QuizTopicStruct: Codable {
    let title: String
    let desc: String
    let questions: [QuizQuestionStruct]
}

struct QuizQuestionStruct: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

class QuizTopic: NSObject, NSCoding {
    let title: String
    let desc: String
    let questions: [QuizQuestion]
    
    init(title: String, desc: String, questions: [QuizQuestion]) {
        self.title = title
        self.desc = desc
        self.questions = questions
    }
    
    convenience init(from structModel: QuizTopicStruct) {
        let convertedQuestions = structModel.questions.map{ QuizQuestion(from: $0)}
        self.init(title: structModel.title, desc: structModel.desc, questions: convertedQuestions)
    }
    
    // decoding (reading)
    required convenience init?(coder decoder: NSCoder) {
        guard let title = decoder.decodeObject(forKey: "title") as? String,
              let desc = decoder.decodeObject(forKey:"desc") as? String,
                let questions = decoder.decodeObject(forKey: "questions") as? [QuizQuestion]
        else { return nil }
        
        self.init(title: title, desc: desc, questions: questions)
    }
    
    // encoder (writing)
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(desc, forKey: "desc")
        coder.encode(questions, forKey: "questions")
    }
}

class QuizQuestion: NSObject, NSCoding {
    let text: String
    let answer: String
    let answers: [String]
    
    init(text: String, answer: String, answers: [String]) {
        self.text = text
        self.answer = answer
        self.answers = answers
    }
    
    convenience init(from structModel: QuizQuestionStruct) {
        self.init(text: structModel.text, answer: structModel.answer, answers: structModel.answers)
    }
    
    // decoder (reading)
    required convenience init?(coder decoder: NSCoder) {
        guard let text = decoder.decodeObject(forKey: "text") as? String,
              let answer = decoder.decodeObject(forKey: "answer") as? String,
              let answers = decoder.decodeObject(forKey: "answers") as? [String]
        else { return nil }
        
        self.init(text: text, answer: answer, answers: answers)
    }
    
    // encoder (writing)
    func encode(with coder: NSCoder) {
        coder.encode(text, forKey: "text")
        coder.encode(answer, forKey: "answer")
        coder.encode(answers, forKey: "answers")
    }
}


// global vars
//var link = UserDefaults.standard.string(forKey: "dataSourceURL")

let quizFile = NSHomeDirectory() +  "/Documents/archive.quiz"
var quizTopics: [QuizTopic] = []
let imgURLS = ["science_quiz", "deadpool_quiz", "math_quiz"]

class ViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return quizTopics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "QuizCell",
                for: indexPath
            ) as! QuizTableCell
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
        
        print("Current source URL", UserDefaults.standard.string(forKey: "dataSourceURL") ?? "nothing")
        
        if UserDefaults.standard.string(forKey: "dataSourceURL") == nil {
            UserDefaults.standard.set(
                "https://tednewardsandbox.site44.com/questions.json",
                forKey: "dataSourceURL"
            )
        }
        
        if let saved = NSKeyedUnarchiver.unarchiveObject(withFile: quizFile) as? [QuizTopic] {
            quizTopics = saved
            tableView.reloadData()
        } else {
            self.fetchQuizData(from: UserDefaults.standard.string(forKey: "dataSourceURL")!)
            }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshSettings),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func refreshSettings() {
        if let updatedURL = UserDefaults.standard.string(forKey: "dataSourceURL") {
            print("Updated URL from Settings:", updatedURL)
            // could also auto-referesh here
        }
    }

    @IBAction func loadData(_ sender: UIBarButtonItem!) {
//        print("url from load method: ", UserDefaults.standard.string(forKey: "dataSourceURL") ?? "nothing")
        guard let urlStr = UserDefaults.standard.string(forKey: "dataSourceURL"), !urlStr.isEmpty else {
            showAlert(title: "Error", message: "No data source URL set in settings")
//            print("in the else in the guard")
            return
        }
        fetchQuizData(from: urlStr)
    }

    @IBAction func btnAlert(_ sender: UIBarButtonItem!) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
    }

    // store data
    func storeData() {
        NSKeyedArchiver.archiveRootObject(quizTopics, toFile: quizFile)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        self.present(alert, animated: true)
    }

    // making http request
    func fetchQuizData(from urlStr: String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        // issues the request (hit the api)
        (URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Download Failed",
                        message: error.localizedDescription
                    )
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Download Failed",
                        message: "No data returned"
                    )
                }
                return
            }
            // have data, try decoding
            do {
                let structs = try JSONDecoder().decode(
                    [QuizTopicStruct].self,
                    from: data
                )  // converts bites to Response codable
                print("This is the response", quizTopics)
                // convert to quiztopic coder type
                quizTopics = structs.map { QuizTopic(from: $0) }
                self.storeData()
                // updates table view UI on
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.showAlert(title: "Success!", message: "Table data loaded")
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(
                        title: "Error",
                        message: "Could not parse data"
                    )
                }
            }
        }).resume()
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 100
    }

    // segues
    var selectedQuiz: QuizTopic!
    var quizImg: String!
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
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
