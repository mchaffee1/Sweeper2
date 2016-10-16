import Foundation
@testable import Sweeper2

struct TestableGameSquare: GameSquareType {
  let id: String
  let state: GameSquareState
  let tapCount: Int
  let hasMine: Bool
  let neighbors: [GameSquareType]
  func tap() -> GameSquareType {
    return TestableGameSquareBuilder()
      .copy(square: self)
      .with(tapCount: self.tapCount + 1)
      .with(state: self.hasMine ? .Mine : .Cleared(withCount: 0))
      .build()
  }
  func withNeighbors(_ neighbors: [GameSquareType]) -> GameSquareType {
    return TestableGameSquareBuilder()
      .copy(square: self)
      .with(neighbors: neighbors)
      .build()
  }
}

class TestableGameSquareBuilder {
  var id = ""
  var state = GameSquareState.Blank
  var tapCount = 0
  var neighbors = [GameSquareType]()
  var hasMine = false
  
  func with(id: String) -> TestableGameSquareBuilder {
    self.id = id
    return self
  }
  func with(state: GameSquareState) -> TestableGameSquareBuilder {
    self.state = state
    return self
  }
  func with(tapCount: Int) -> TestableGameSquareBuilder {
    self.tapCount = tapCount
    return self
  }
  func with(neighbors: [GameSquareType]) -> TestableGameSquareBuilder {
    self.neighbors = neighbors
    return self
  }
  func with(mine: Bool) -> TestableGameSquareBuilder {
    self.hasMine = mine
    return self
  }
  
  func copy(square: TestableGameSquare) -> TestableGameSquareBuilder {
    self.id = square.id
    self.state = square.state
    self.tapCount = square.tapCount
    self.neighbors = square.neighbors
    self.hasMine = square.hasMine
    return self
  }
  
  func build() -> TestableGameSquare {
    self.id = self.id == "" ? NSUUID().uuidString : self.id
    return TestableGameSquare(id: self.id, state: self.state, tapCount: self.tapCount, hasMine: self.hasMine, neighbors: self.neighbors)
  }
}
