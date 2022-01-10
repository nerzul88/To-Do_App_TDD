//
//  TaskManagerTests.swift
//  ToDoAppTests
//
//  Created by Александр Касьянов on 23.12.2021.
//

import XCTest
@testable import ToDoApp

class TaskManagerTests: XCTestCase {
    
    var sut: TaskManager!

    override func setUpWithError() throws {
        sut = TaskManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    //проверяем, что у менеджера нет выполненных и нет невыполненных задач
    
    func testInitTaskManagerWithZeroTasks() {
        XCTAssertEqual(sut.tasksCount, 0)
    }
    
    func testInitTaskManagerWithZeroDoneTasks() {
        XCTAssertEqual(sut.doneTasksCount, 0)
    }
    
    //при добавлении задачи counter увеличивается на 1
    func testAddTaskIncrementTasksCount() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        XCTAssertEqual(sut.tasksCount, 1)
    }
    
    //проверяем, что добавленный task и есть task по конкретному индексу
    func testTaskAtIndexIsAddedTask() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        let returnedTask = sut.task(at: 0)
        XCTAssertEqual(task.title, returnedTask.title)
    }
    
    //проверяем, что, обозначая задачу выполненной, количество задач меняется
    func testCheckTaskAtIndexChangesCount() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        sut.checkTask(at: 0)
        XCTAssertEqual(sut.tasksCount, 0)
        XCTAssertEqual(sut.doneTasksCount, 1)
    }
    
    //проверка на удаление task из массива
    func testCheckedTaskRemovedFromTasks() {
        let firstTask = Task(title: "Foo")
        let secondTask = Task(title: "Bar")
        sut.add(task: firstTask)
        sut.add(task: secondTask)
        sut.checkTask(at: 0)
        XCTAssertEqual(sut.task(at: 0), secondTask)
    }
    
    //проверяем, что выполненная задача попадает в массив выполненных задач
    func testDoneTaskAtReturnsChekedTask() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        sut.checkTask(at: 0)
        let returnedTask = sut.doneTask(at: 0)
        XCTAssertEqual(returnedTask, task)
    }
    
    //метод, позволяющий удалять все объекты из массивов
    func testRemoveAllResultsCountsBeZero() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Bar"))
        sut.checkTask(at: 0)
        sut.removeAll()
        XCTAssertTrue(sut.tasksCount == 0)
        XCTAssertTrue(sut.doneTasksCount == 0)
    }
    
    //проверка на уникальность значений в массиве
    func testAddingSameObjectDoesNotIncrementCount() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Foo"))
        XCTAssertTrue(sut.tasksCount == 1)
    }
}
