import SwiftUI

struct CurrencyPicker: View {

    // Байндинг для валюты, позволяющий читать и записывать её значение
    @Binding var currency: Currency
    
    // Функция, вызываемая при выборе валюты из списка
    let onChange: (Currency) -> Void
    
    var body: some View {
        
        // Picker - элемент SwiftUI для выбора значения из списка
        Picker("", selection: $currency) {
                        
            // ForEach - элемент SwiftUI, генерирующий набор View
            // из коллекции значений, обладающих уникальными идентификаторами
            ForEach(Currency.allCases) { currency in
                Text(currency.rawValue.uppercased())
            }
        }
        // Задает стиль Picker'а "колесо" или "барабан"
        .pickerStyle(.wheel)
        
        // Определяет функцию, вызываемую при выборе нового значения
        .onChange(of: currency, perform: onChange)
    }
}

// Структура, определяющая отображение компонента в панели preview.
struct CurrencyPicker_Previews: PreviewProvider {
    
    static let currencyBinding = Binding<Currency>(
        get: { .RUR },
        set: { _ = $0 }
    )
    
    static var previews: some View {
        CurrencyPicker(currency: currencyBinding, onChange: { _ in })
    }
}
