import Mimic
import MimicMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self
]

final class MimicTests: XCTestCase {
    func testMock() async {
        let summator = SummatorMock()
        
        summator.sumXYMock.setup { $0 + $1 }
        summator.asyncSumXYAsyncMock.setup { $0 + $1 }

        XCTAssertEqual(summator.sum(x: 5, y: 10), 15)
        XCTAssertEqual(summator.sum(x: 1, y: 999), 1000)
        XCTAssertEqual(summator.sum(x: -10, y: 20), 10)

        let sum1 = await summator.asyncSum(x: 5, y: 10)
        let sum2 = await summator.asyncSum(x: 1, y: 999)
        let sum3 = await summator.asyncSum(x: -10, y: 20)
        XCTAssertEqual(sum1, 15)
        XCTAssertEqual(sum2, 1000)
        XCTAssertEqual(sum3, 10)
    }
}

protocol ISummator {
    func sum(x: Int, y: Int) -> Int
    func asyncSum(x: Int, y: Int) async -> Int
}

final class SummatorMock: ISummator {
    var sumXYMock = Mock<(x: Int, y: Int), Int>()
    func sum(x: Int, y: Int) -> Int {
        return sumXYMock.record((x, y))
    }

    var asyncSumXYAsyncMock = AsyncMock<(x: Int, y: Int), Int>()
    func asyncSum(x: Int, y: Int) async -> Int {
        await asyncSumXYAsyncMock.record((x, y))
    }
}
