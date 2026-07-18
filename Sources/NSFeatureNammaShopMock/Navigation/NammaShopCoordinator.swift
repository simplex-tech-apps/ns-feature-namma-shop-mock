//
//  NammaShopCoordinator.swift
//  NSFeatureNammaShopMock
//
//  Created by apple on 12/07/26.
//

import SwiftData
import SwiftUI
import NammaAppUI

@MainActor
struct NammaShopViewFactory {
    @ViewBuilder
    func buildPage(_ page: NammaShopCoordinatorPage) -> some View {
        switch page {
        case .landingPage(let nammaShopViewModel):
            NammaShopView(nammaShopViewModel: nammaShopViewModel)
        }
    }
    
    @ViewBuilder
    func buildSheet(_ sheet: NammaShopCoordinatorSheet) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func buildCover(_ cover: NammaShopCoordinatorCover) -> some View {
        EmptyView()
    }
}

enum NammaShopCoordinatorPage: Hashable {
    case landingPage(NammaShopViewModel)
}

enum NammaShopCoordinatorSheet: String, Identifiable {
    var id: String { rawValue }
    case noSheet
}

enum NammaShopCoordinatorCover: String, Identifiable {
    var id: String { rawValue }
    case noCover
}

extension EnvironmentValues {
    @Entry var NammaShopCoordinator: NammaShopCoordinator?
    @Entry var NammaShopViewModel: NammaShopViewModel?
}

@Observable
class NammaShopCoordinator: NSObject {
    var path: NavigationPath = NavigationPath()
    var sheet: NammaShopCoordinatorSheet?
    var cover: NammaShopCoordinatorCover?
    private(set) var currenScreen: [NammaShopCoordinatorPage] = []
    
    func push(page: NammaShopCoordinatorPage) {
        currenScreen.append(page)
        path.append(page)
    }
    
    func pop(_ last: Int = 1) {
        currenScreen.removeLast()
        path.removeLast(last)
    }
    
    func popToRoot() {
        currenScreen.removeAll()
        path.removeLast(path.count)
    }
    
    func present(sheet: NammaShopCoordinatorSheet) {
        self.sheet = sheet
    }
    
    func present(cover: NammaShopCoordinatorCover) {
        self.cover = cover
    }
    
    func popSheet() {
        withAnimation(.spring()) {
            self.sheet = nil
        }
    }
    
    func popCover() {
        self.cover = nil
    }
}

public struct NammaShopCoordinatorView: View {
    @State
    private var nammaShopCoordinator = NammaShopCoordinator()
    @State
    private var nammaShopViewModel: NammaShopViewModel = NammaShopViewModel()
    @State
    private var appTheme = AppThemeManager.shared
    
    let nammaShopViewFactory: NammaShopViewFactory = NammaShopViewFactory()
    
    public init() {}
    
    public var body: some View {
        nammaShopViewFactory.buildPage(.landingPage(nammaShopViewModel))
            .navigationDestination(for: NammaShopCoordinatorPage.self) {
                nammaShopViewFactory.buildPage($0)
            }
            .sheet(item: $nammaShopCoordinator.sheet) { nammaShopViewFactory.buildSheet($0).presentationBackground(appTheme.current.secondary).presentationDetents([.medium]).presentationCornerRadius(24)
            }
            .fullScreenCover(item: $nammaShopCoordinator.cover) {
                nammaShopViewFactory.buildCover($0)
            }
    }
}
