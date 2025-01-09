//
//  Mock.swift
//  Mimic
//
//  Created by Roman Gladkikh on 09.01.2025.
//

public struct Mock<ArgumentType, ReturnType> {

    // MARK: State

    private var mockBehavior: FunctionMock<ArgumentType, ReturnType>
    public private(set) var invocationsHistory: [ArgumentType] = []
    
    // MARK: Lifecycle

    public init() {
        self.mockBehavior = { _ in
            preconditionFailure("Mock should be initialized.")
        }
    }

    // MARK: Public API

    public mutating func setup(returnValue: ReturnType) {
        mockBehavior = { _ in returnValue }
    }

    public mutating func setup(_ behavior: @escaping FunctionMock<ArgumentType, ReturnType>) {
        mockBehavior = behavior
    }

    public mutating func record(_ arguments: ArgumentType) -> ReturnType {
        invocationsHistory.append(arguments)
        return mockBehavior(arguments)
    }
}

public extension Mock where ReturnType == Void {
    init() {
        self.mockBehavior = { _ in }
    }
}

public extension Mock where ArgumentType == Void {
    mutating func setup(_ behavior: @escaping () -> ReturnType) {
        self.mockBehavior = { _ in behavior() }
    }
    
    mutating func record() -> ReturnType {
        self.record(())
    }
}
