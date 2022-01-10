//
//  TaskTests.swift
//  ToDoAppTests
//
//  Created by Александр Касьянов on 23.12.2021.
//

import XCTest
@testable import ToDoApp

class TaskTests: XCTestCase {
    //проверка на инициализацию по заголовку
    func testInitTaskWithTitle() {
        let task = Task(title: "Foo")
        //проверяем, что объект существует
        XCTAssertNotNil(task)
    }
    //можем ли создать task при помощи заголовка и описания
    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: "Foo", description: "Bar")
        //проверяем, что объект существует
        XCTAssertNotNil(task)
    }
    //действительно ли установлен title
    func testWhenGiveTitleSetsTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertEqual(task.title, "Foo")
    }
    //действительно ли есть description
    func testWhenGivenDescriptionSetsDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertEqual(task.description, "Bar")
    }
    //task будет иметь дату
    func testTaskInitsWithDate() {
        let task = Task(title: "Foo")
        XCTAssertNotNil(task.date)
    }
    
    func testWhenGivenLocationSetsLocation() {
        let location = Location(name: "Foo")
        let task = Task(title: "Bar",
                        description: "Baz",
                        location: location)
        XCTAssertEqual(location, task.location)
    }
    
}
