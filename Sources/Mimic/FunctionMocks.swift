//
//  FunctionMocks.swift
//  Mimic
//
//  Created by Roman Gladkikh on 09.01.2025.
//

public typealias FunctionMock<ArgumentType, ReturnType> = (ArgumentType) -> ReturnType
public typealias ThrowingFunctionMock<ArgumentType, ReturnType> = (ArgumentType) throws -> ReturnType

public typealias AsyncFunctionMock<ArgumentType, ReturnType> = (ArgumentType) async -> ReturnType
public typealias ThrowingAsyncFunctionMock<ArgumentType, ReturnType> = (ArgumentType) async throws -> ReturnType
