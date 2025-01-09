//
//  ThrowingMock.swift
//  Mimic
//
//  Created by Roman Gladkikh on 09.01.2025.
//

public struct ThrowingMock<ArgumentType, ReturnType> {

    // MARK: State

    private var mockBehavior: ThrowingFunctionMock<ArgumentType, ReturnType>
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

    public mutating func setup(_ behavior: @escaping ThrowingFunctionMock<ArgumentType, ReturnType>) {
        mockBehavior = behavior
    }

    public mutating func record(_ arguments: ArgumentType) throws -> ReturnType {
        invocationsHistory.append(arguments)
        return try mockBehavior(arguments)
    }
}

public extension ThrowingMock where ReturnType == Void {
    init() {
        self.mockBehavior = { _ in }
    }
}

public extension ThrowingMock where ArgumentType == Void {
    mutating func setup(_ behavior: @escaping () throws -> ReturnType) {
        self.mockBehavior = { _ in try behavior() }
    }
    
    mutating func record() throws -> ReturnType {
        try self.record(())
    }
}
