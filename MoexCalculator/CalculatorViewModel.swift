import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {

    private var model = CalculatorModel()
    
    enum State {
        case loading    // загрузка данных
        case content    // данные загружены
        case error      // ошибка загрузки данных
    }
    
    @Published var state: State = .loading
    
    @Published var topCurrency: Currency = .CNY
    @Published var bottomCurrency: Currency = .RUR
    
    @Published var topAmount: Double = 0
    @Published var bottomAmount: Double = 0
    
    // Загрузчик данных
    private let loader: MoexDataLoader
    
    // Хранилище подписок Combine
    private var subscriptions = Set<AnyCancellable>()
    
    // Инициализатор, принимающий переменную загрузчика
    init(with loader: MoexDataLoader = MoexDataLoader()) {
        self.loader = loader
        fetchData()
    }
    
    // Функция, запускающая запрос данных с помощью загрузчика
    // и устанавливающая переменную состояния state в зависимости
    // от результата загрузки
    private func fetchData() {
        loader.fetch().sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure = completion {
                    self.state = .error
                }
            },
            receiveValue: { [weak self] currencyRates in
                guard let self = self else { return }
                self.model.setCurrencyRates(currencyRates)
                self.state = .content
            })
        .store(in: &subscriptions)
    }
    
    func setTopAmount(_ amount: Double) {
        topAmount = amount
        updateBottomAmount()
    }
    
    func setBottomAmount(_ amount: Double) {
        bottomAmount = amount
        updateTopAmount()
    }
    
    func updateBottomAmount() {
        let topAmount = CurrencyAmount(currency: topCurrency, amount: topAmount)
        bottomAmount = model.convert(topAmount, to: bottomCurrency)
    }
    
    func updateTopAmount() {
        let bottomAmount = CurrencyAmount(currency: bottomCurrency, amount: bottomAmount)
        topAmount = model.convert(bottomAmount, to: topCurrency)
    }
}
