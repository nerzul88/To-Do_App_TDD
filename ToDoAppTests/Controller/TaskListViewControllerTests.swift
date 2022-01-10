//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Александр Касьянов on 23.12.2021.
//

import XCTest
@testable import ToDoApp

class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: String(describing: TaskListViewController.self))
        sut = vc as? TaskListViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //имеет ли контроллер table view
    func testWhenIsLoadedTableViewNotNil() {
//        let sut = TaskListViewController()
//        sut.loadViewIfNeeded() //_ = sut.view
        XCTAssertNotNil(sut.tableView)
    }
    
    //проверка наличия data provider после загрузки view controller
    func testWhenViewIsLoadedDataProviderIsNotNil() {
        
        XCTAssertNotNil(sut.dataProvider)
    }
    
    //проверка, что при загрузке view controller будет установлен делегат для table view
    func testWheViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }

    //проверка, что при загрузке view controller будет установлен data source для table view
    func testWheViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    //проверка, что делегатом и data source для table view будет data provider
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSource() {
        XCTAssertEqual(sut.tableView.delegate as? DataProvider,
                       sut.tableView.dataSource as? DataProvider)
    }
}
