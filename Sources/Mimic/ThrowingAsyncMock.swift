//
//  AsyncThrowingMock.swift
//  Mimic
//
//  Created by Roman Gladkikh on 09.01.2025.
//

public struct ThrowingAsyncMock<ArgumentType, ReturnType> {

    // MARK: State

    private var mockBehavior: ThrowingAsyncFunctionMock<ArgumentType, ReturnType>
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

    public mutating func setup(_ behavior: @escaping AsyncFunctionMock<ArgumentType, ReturnType>) {
        mockBehavior = behavior
    }

    public mutating func record(_ arguments: ArgumentType) async throws -> ReturnType {
        invocationsHistory.append(arguments)
        return try await mockBehavior(arguments)
    }
}

public extension ThrowingAsyncMock where ReturnType == Void {
    init() {
        self.mockBehavior = { _ in }
    }
}

public extension ThrowingAsyncMock where ArgumentType == Void {
    mutating func setup(_ behavior: @escaping () async throws -> ReturnType) {
        self.mockBehavior = { _ in try await behavior() }
    }
    
    mutating func record() async throws -> ReturnType {
        try await self.record(())
    }
}
