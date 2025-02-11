import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var viewModel: CalculatorViewModel // 1
    @State private var isPickerPresented = false
    
    var body: some View {
    
        List {  // 2
            
            CurrencyInput(
                currency: viewModel.topCurrency,
                amount: viewModel.topAmount,
                calculator: viewModel.setTopAmount,
                tapHandler: { isPickerPresented.toggle() }
            )
            
            CurrencyInput(
                currency: viewModel.bottomCurrency,
                amount: viewModel.bottomAmount,
                calculator: viewModel.setBottomAmount,
                tapHandler: { isPickerPresented.toggle() }
            )
        }
        .foregroundColor(.accentColor)
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $isPickerPresented) {
            
            VStack(spacing: 16) {
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(.secondary)
                    .frame(width: 60, height: 6)
                    .onTapGesture {
                        isPickerPresented = false
                    }
                
                HStack {
                    CurrencyPicker(currency: $viewModel.topCurrency, onChange: { _ in didChangeTopCurrency() })
                    CurrencyPicker(currency: $viewModel.bottomCurrency, onChange: { _ in didChangeBottomCurrency() })
                }
            }
            .presentationDetents([.fraction(0.3)])
        }
    }

    private func didChangeTopCurrency() {
        viewModel.updateTopAmount()
    }
    
    private func didChangeBottomCurrency() {
        viewModel.updateBottomAmount()
    }
    
}

struct CalculatorView_Previews: PreviewProvider { // 14
    static var previews: some View {
        CalculatorView()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
