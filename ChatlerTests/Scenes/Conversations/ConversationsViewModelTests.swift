//
//  ConversationsViewModelTests.swift
//  ChatlerTests
//
//  Created by Lucas Pereira on 15/08/21.
//

import XCTest
@testable import Chatler

class ConversationsViewModelTests: XCTestCase {
    private let service = ConversationsServiceMock()
    private let controller = ConversationsViewModelMock()
    private lazy var sut: ConversationsViewModelInput = {
        let sut = ConversationsViewModel()
        sut.output = controller
        sut.service = service
        return sut
    }()
    
    func testExample() throws {
        sut.loadConversations()
        
        XCTAssertEqual(controller.loadConversationsCount, 1)
    }

}

final class ConversationsViewModelMock: ConversationsViewModelOutput {
    var tableView: UITableView = UITableView()
    
    var loadConversationsCount = 0
    var showLoadingCount = 0
    var showLoadingWithTextCount = 0
    var hideLoadingWithCompletionCount = 0
    var hideLoadingCount = 0
    var dismissCount = 0
    var showErrorCount = 0
    
    
    func onLoadConversations(conversations: [Conversation]) {
        loadConversationsCount += 1
    }
    
    func showLoading() {
        showLoadingCount += 1
    }
    
    func showLoading(text: String) {
        showLoadingWithTextCount += 1
    }
    
    func hideLoading(completion: @escaping () -> ()) {
        hideLoadingWithCompletionCount += 1
    }
    
    func hideLoading() {
        hideLoadingCount += 1
    }
    
    func dismiss() {
        dismissCount += 1
    }
    
    func showError(_ errorMessage: String) {
        showErrorCount += 1
    }
}

final class ConversationsServiceMock: ConversationsServiceProtocol {
    func fetchConversations(completion: @escaping (Result<[Conversation], Error>) -> ()) {
        let result: (Result<[Conversation], Error>) = .success([])
        completion(result)
    }
}
