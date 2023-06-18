import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsCount = 10
    
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService : StatisticService?
    
    // MARK: - Lifecycle
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImpl()
        alertPresenter = AlertPresenterImpl(viewController: self)
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion?.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self  = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsCount - 1 {
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsCount)
        let alertModel = AlertModel(
            title: "Игра окончена!",
            message: makeResultMessage(),
            buttonText: "ОК",
            buttonAction: { [ weak self ] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return ""
        }
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlayCountLine =
        "Количетсво сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        let components: [String] = [
            currentGameResultLine,
            totalPlayCountLine,
            bestGameInfoLine,
            averageAccuracyLine
        ]
        
        let resultMassege = components.joined(separator: "\n")
        return resultMassege
    }
}
extension MovieQuizViewController: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = self.convert(model: question)
        self.show(quiz: viewModel)
    }
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
}




