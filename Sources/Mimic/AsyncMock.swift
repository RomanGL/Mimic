//
//  AsyncMock.swift
//  Mimic
//
//  Created by Roman Gladkikh on 09.01.2025.
//

public struct AsyncMock<ArgumentType, ReturnType> {

    // MARK: State

    private var mockBehavior: AsyncFunctionMock<ArgumentType, ReturnType>
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

    public mutating func record(_ arguments: ArgumentType) async -> ReturnType {
        invocationsHistory.append(arguments)
        return await mockBehavior(arguments)
    }
}

public extension AsyncMock where ReturnType == Void {
    init() {
        self.mockBehavior = { _ in }
    }
}

public extension AsyncMock where ArgumentType == Void {
    mutating func setup(_ behavior: @escaping () async -> ReturnType) {
        self.mockBehavior = { _ in await behavior() }
    }
    
    mutating func record() async -> ReturnType {
        await self.record(())
    }
}
