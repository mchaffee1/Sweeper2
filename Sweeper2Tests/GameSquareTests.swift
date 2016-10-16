import Quick
import Nimble

@testable import Sweeper2

enum Stupid {
  case Dumb
  case Dumber
}

class GameSquareTests: QuickSpec {
  override func spec() {
    describe("GameSquare initializer") {
      
      it("should update neighbor count on copy") {
        let neighborMineCount = 4
        
        let badNeighbor = GameSquare(withState: .Blank, withMine: true)
        let goodNeighbor = GameSquare(withState: .Blank, withMine: false)
        let neighbors = [GameSquare]([(repeatElement(goodNeighbor, count: neighborMineCount + 1)), (repeatElement(badNeighbor, count: neighborMineCount))].joined())
        
        let square = GameSquare(withProbability: 0).withNeighbors(neighbors).tap()
        expect(square.state).to(equal(GameSquareState.Cleared(withCount: neighborMineCount)))
      }
    }
    
    describe("GameSquare tap") {
      it("should change state to .Mine when tapping a mined square") {
        let square = GameSquare(withState: .Blank, withMine: true).tap()
        expect(square.state).to(equal(GameSquareState.Mine))
      }

      it("should change state to .Clear when tapping a clear square") {
        let neighborMineCount = 3
        let square = GameSquare(withState: .Blank, withMine: false, withNeighborMineCount: neighborMineCount).tap()
        expect(square.state).to(equal(GameSquareState.Cleared(withCount: neighborMineCount)))
      }
    }
  }

}
