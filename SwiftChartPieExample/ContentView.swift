//
//  ContentView.swift
//  SwiftChartPieExample
//
//  Created by Toomas Vahter on 26.10.2023.
//

import Charts
import Observation
import SwiftUI

struct ContentView: View {
  @State private var viewModel: ViewModel

  init(countries: [CoffeeExport] = CoffeeExport.data) {
    self.viewModel = ViewModel(countries: countries)
  }

  var body: some View {
    VStack {
      Text(viewModel.title)
      Chart(viewModel.countries, id: \.country) { element in
        let isSelected = viewModel.isSelected(element)
        SectorMark(angle: .value("Bag", element.bags),
                   outerRadius: .ratio(isSelected ? 1 : 0.9),
                   angularInset: isSelected ? 2 : 0)
        .foregroundStyle(by: .value("Country", element.country))
        .cornerRadius(3)
      }
      .chartAngleSelection(value: $viewModel.rawSelection)
      .chartForegroundStyleScale(domain: .automatic, range: Self.chartColors)
      .onChange(of: viewModel.rawSelection, viewModel.updateCountrySelection)
      .frame(height: 300)
      .animation(.bouncy, value: viewModel.selectedCountry)
    }
    .padding()
  }

  private static let chartColors: [Color] = [
    .red, .green, .blue, .yellow, .purple, .indigo, .brown, .mint, .orange, .pink, .cyan
  ]
}

extension ContentView {
  @Observable final class ViewModel {
    let countries: [CoffeeExport]

    init(countries: [CoffeeExport]) {
      self.countries = countries
    }

    var rawSelection: Int?
    private(set) var selectedCountry: CoffeeExport?

    func isSelected(_ country: CoffeeExport) -> Bool {
      country == selectedCountry
    }

    var title: String {
      guard let selectedCountry else { return "Select a Country" }
      return selectedCountry.country
    }

    func updateCountrySelection() {
      guard let rawSelection else { return }
      let country = self.selectedCountry(for: rawSelection)
      guard country != selectedCountry else { return }
      selectedCountry = country
    }

    private func selectedCountry(for value: Int) -> CoffeeExport {
      var total = 0
      for element in countries {
        total += element.bags
        if value <= total {
          return element
        }
      }
      return countries.last!
    }
  }
}

struct CoffeeExport: Equatable {
  let country: String
  let bags: Int
}

extension CoffeeExport {
  static var data: [CoffeeExport] = [
    CoffeeExport(country: "Brazil", bags: 44_200_000),
    CoffeeExport(country: "Vietnam", bags: 27_500_000),
    CoffeeExport(country: "Colombia", bags: 13_500_000),
    CoffeeExport(country: "Indonesia", bags: 11_000_000),
    CoffeeExport(country: "Honduras", bags: 9_600_000),
    CoffeeExport(country: "Ethiopia", bags: 6_400_000),
    CoffeeExport(country: "India", bags: 5_800_000),
    CoffeeExport(country: "Uganda", bags: 4_800_000),
    CoffeeExport(country: "Mexico", bags: 3_900_000),
    CoffeeExport(country: "Guatemala", bags: 3_400_000),

    CoffeeExport(country: "Others", bags: 19_209_000),
  ]
}

#Preview {
  ContentView()
}
