import Foundation

enum GameSquareState {
  case Blank
  case Cleared(withCount: Int)
  case Mine
}

struct GameSquare {
  let state: GameSquareState
  private let hasMine: Bool
  private let neighborMineCount: Int
  
  init(withProbability probability: Int, withNeighbors neighbors: [GameSquare]) {
    self.state = .Blank
    self.hasMine = Int(arc4random_uniform(100)) <= probability
    self.neighborMineCount = 0
  }
  
  init(withState state: GameSquareState, withMine hasMine: Bool, withNeighborMineCount neighborMineCount: Int) {
    self.state = state
    self.hasMine = hasMine
    self.neighborMineCount = neighborMineCount
  }
  
  func withNeighbors(_ neighbors: [GameSquare]) -> GameSquare {
    let neighborMineCount = neighbors.filter({$0.hasMine}).count
    return GameSquare(withState: self.state, withMine: self.hasMine, withNeighborMineCount: neighborMineCount)
  }
  
}
