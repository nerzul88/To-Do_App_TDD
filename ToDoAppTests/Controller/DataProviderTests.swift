//
//  DataProviderTests.swift
//  ToDoAppTests
//
//  Created by Александр Касьянов on 23.12.2021.
//

import XCTest
@testable import ToDoApp

class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    var tableView: UITableView!
    var controler: TaskListViewController!

    override func setUpWithError() throws {
        sut = DataProvider()
        sut.taskManager = TaskManager()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controler = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as? TaskListViewController
        controler.loadViewIfNeeded()
        
        tableView = controler.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //проверяем, действительно ли в table view две секции
    func testNumberOfSectionsIsTwo() {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }
    
    //проверяем, что количество задач для выполнения равно количеству строк в первой секции table view
    func testNumberOfRowsInSectionZeroIsDoneTaskCount() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        sut.taskManager?.add(task: Task(title: "Bar"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    //проверяем, что количество задач для выполнения равно количеству строк во второй секции table view
    func testNumberOfRowsInSectionOneIsDoneTaskCount() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.checkTask(at: 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    //проверяем, какую ячейку получаем в методе cellForRowAt indexPath
    func testCellForRowAtIndexPathReturnsTaskCell() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        tableView.reloadData()
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is TaskCell)
    }
    
    //проверям, переиспользуется ли ячейка от table view
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mockTableView.reloadData()
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
    //проверяем, срабатывает ли метод configure в первой секции
    func testCellForRowInSectionZeroCallsConfigure() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        mockTableView.reloadData()
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockTaskCell
        XCTAssertEqual(cell.task, task)
    }
    //проверяем, срабатывает ли метод configure в первой секции
    func testCellForRowInSectionOneCallsConfigure() {
        let mockTableView = MockTableView.mockTableView(withDataSource: sut)
        
        let task = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        mockTableView.reloadData()
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockTaskCell
        XCTAssertEqual(cell.task, task)
    }
    //проверяем, что кнопка delete будет как done для первой секции
    func testDeleteButtonTitleSectionZeroShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(buttonTitle, "Done")
    }
    //проверяем, что кнопка delete будет как done для второй секции
    func testDeleteButtonTitleSectionOneShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        XCTAssertEqual(buttonTitle, "Undone")
    }
    //проверяем, что при нажатии кнопки done/undone task пербрасывается из одного массива в другой
    func testCheckingTaskChecksInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        tableView.dataSource?.tableView?(
            tableView,
            commit: .delete,
            forRowAt: IndexPath(row: 0, section: 0)
        )
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }
    
    func testUncheckingTaskUnchecksInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableView.reloadData()
        tableView.dataSource?.tableView?(
            tableView,
            commit: .delete,
            forRowAt: IndexPath(row: 0, section: 1)
        )
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
}


//двойник для table view, который будет использоваться для того, чтобы узнать переиспользуем ли мы ячейку или нет
extension DataProviderTests {
    //ограничиваем зону видимости класса
    class MockTableView: UITableView {
        var cellIsDequeued = false
        
        static func mockTableView(withDataSource dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 896), style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            return mockTableView
        }
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
    //присваивается ли ячейке свойство task для самозаполнения
    class MockTaskCell: TaskCell {
        var task: Task?
        
        override func configure(withTask task: Task) {
            self.task = task
        }
    }
    
}
