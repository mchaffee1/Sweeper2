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
          let gameBoard = TestBoard.board()
          expect(gameBoard.squareAt(x: -1, y: -1)).to(beNil())
          expect(gameBoard.squareAt(x: 0, y: gameBoard.height)).to(beNil())
          expect(gameBoard.squareAt(x:gameBoard.width, y:0)).to(beNil())
        }
      }
      
      describe("squareAt") {
        it("should return the same square for two calls to squareAt") {
          let gameBoard = TestBoard.board()
          let firstSquare = gameBoard.squareAt(x: 0, y: 0) as! TestableGameSquare
          let otherSquare = gameBoard.squareAt(x: 1, y: 1) as! TestableGameSquare
          let sameSquare = gameBoard.squareAt(x: 0, y: 0) as! TestableGameSquare
          
          expect(firstSquare).notTo(beNil())
          expect(otherSquare.id).notTo(equal(firstSquare.id))
          expect(sameSquare.id).to(equal(firstSquare.id))
        }
      }
      
      describe("tap()") {
        it("should pass tap to the correct square only") {
          let (x, y) = TestBoard.goodIndex
          
          let tappedBoard = TestBoard.board().tap(x: x, y: y)
          let tappedSquare = tappedBoard.squareAt(x: x, y: y) as! TestableGameSquare
          expect(tappedSquare.tapCount).to(equal(1))
          let tappedSquareCount = (tappedBoard as! GameBoard).squares.reduce(0, { base, square in
            return base + (square as! TestableGameSquare).tapCount
          })
          expect(tappedSquareCount).to(equal(1))
        }
        
        it("should change state to Lost and reveal all squares after tapping a mine") {
          let (x, y) = TestBoard.badIndex
          
          let tappedBoard = TestBoard.board().tap(x: x, y: y)
          let tappedSquare = tappedBoard.squareAt(x: x, y: y) as! TestableGameSquare
          expect(tappedSquare.tapCount).to(equal(1))
          let tappedSquareCount = (tappedBoard as! GameBoard).squares.reduce(0, { base, square in
            return base + (square as! TestableGameSquare).tapCount
          })
          expect(tappedSquareCount).to(equal(TestBoard.squareCount))
          expect(tappedBoard.state).to(equal(GameBoardState.Lose))
        }
        
        it("should change state to Win after tapping all non-mine") {
          let(badX, badY) = TestBoard.badIndex
          
          var board = TestBoard.board()
          
          for x in 0..<board.width {
            for y in 0..<board.height {
              if (x, y) != (badX, badY) {
                board = board.tap(x: x, y: y) as! GameBoard
              }
            }
          }
          
          expect(board.state).to(equal(GameBoardState.Win))
        }
      }
    }
  }
}

class TestBoard {
  private typealias `Self` = TestBoard
  static let width = 5
  static let height = 5
  static let squareCount = Self.width * Self.height
  
  static let goodIndex = (x: 1, y: 1)
  static let badIndex = (x: 2, y: 2)
  
  static func goodSquare() -> TestableGameSquare {
    return TestableGameSquareBuilder().build()
  }
  
  static func badSquare() -> TestableGameSquare {
    return TestableGameSquareBuilder().with(mine: true).build()
  }
  
  static func emptyRow() -> [TestableGameSquare] {
    return (0..<width).map{ _ in goodSquare() }
  }
  
  static func badRow() -> [TestableGameSquare] {
    return [goodSquare(), goodSquare(), badSquare(), goodSquare(), goodSquare()]
  }
  
  static func board() -> GameBoard {
    let rows = [emptyRow(), emptyRow(), badRow(), emptyRow(), emptyRow()]
    return GameBoard(withSquareRows: rows)
  }
}
