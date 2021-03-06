import Foundation

enum GameSquareState {
  case Blank
  case Cleared(withCount: Int)
  case Mine
}

func ==(lhs: GameSquareState, rhs: GameSquareState) -> Bool {
  switch (lhs, rhs) {
  case (.Cleared(withCount: let leftCount), .Cleared(withCount: let rightCount)): return leftCount == rightCount
  case (.Blank, .Blank): return true
  case (.Mine, .Mine): return true
  default: return false
  }
}

extension GameSquareState: Equatable { }

protocol GameSquareType {
  var state: GameSquareState { get }
  var hasMine: Bool { get }
  func tap() -> GameSquareType
  func withNeighbors(_ neighbors: [GameSquareType]) -> GameSquareType
}

struct GameSquare: GameSquareType {
  let state: GameSquareState
  let hasMine: Bool
  private let neighborMineCount: Int
  
  init(withProbability probability: Int) {
    self.state = .Blank
    self.hasMine = Int(arc4random_uniform(100)) < probability
    self.neighborMineCount = 0
  }
  
  init(withState state: GameSquareState, withMine hasMine: Bool, withNeighborMineCount neighborMineCount: Int = 0) {
    self.state = state
    self.hasMine = hasMine
    self.neighborMineCount = neighborMineCount
  }
  
  func withNeighbors(_ neighbors: [GameSquareType]) -> GameSquareType {
    let neighborMineCount = neighbors.filter({ square in
      guard let gameSquare = square as? GameSquare else { return false }
      return gameSquare.hasMine
    }).count
    return GameSquare(withState: self.state, withMine: self.hasMine, withNeighborMineCount: neighborMineCount)
  }
  
  func tap() -> GameSquareType {
    let newState: GameSquareState = self.hasMine ? .Mine : .Cleared(withCount: self.neighborMineCount)
    return GameSquare(withState: newState, withMine: self.hasMine, withNeighborMineCount: self.neighborMineCount)
  }
}
