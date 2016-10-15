import Quick
import Nimble
@testable import Sweeper2

class GameBoardTests: QuickSpec {
  override func spec() {
    context("GameBoard") {
      describe("initializer") {
        it("should initialize with the proper dimensions") {
          let height = 10
          let width = 20
          let squareCount = 200
          
          let gameBoard = GameBoard(height: height, width: width, probability: 50)
          
          expect(gameBoard.height).to(equal(height))
          expect(gameBoard.width).to(equal(width))
          expect(gameBoard.squares.count).to(equal(squareCount))
        }
      }
      
      describe("squareAt") {
        it("should return nil for invalid indices") {
          let height = 10
          let width = 20
          let emptyRow =
        }
      }
    }
  }
  
  var boardWithOneCenterMine: GameBoard {
    let height = 5
    let width = 5
    let goodSquare = GameSquare(withState: .Blank, withMine: false)
    let emptyRow = GameRow(repeatElement(goodSquare, count: width))
    let badSquare = GameSquare(withState: .Blank, withMine: false)
  }
}
