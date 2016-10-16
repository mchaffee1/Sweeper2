
typealias GameRow = [GameSquareType]

enum GameBoardState {
  case Play
  case Win
  case Lose
}

protocol GameBoardType {
  init(height: Int, width: Int, probability: Int)
  var state: GameBoardState { get }
  var height: Int { get }
  var width: Int { get }
  func squareAt(x: Int, y: Int) -> GameSquareType?
  func tap(x: Int, y: Int) -> GameBoardType
}

struct GameBoard: GameBoardType {
  let state: GameBoardState
  let squares: [GameSquareType]
  let height: Int
  let width: Int
  
  init(height: Int, width: Int, probability: Int) {
    self.state = .Play
    self.height = height
    self.width = width
    var squares = [GameSquare]()
    for _ in 0..<height*width {
      squares.append(GameSquare(withProbability: probability))
    }
    self.squares = squares
  }
  
  init(height: Int, width: Int, squares: [GameSquareType], state: GameBoardState) {
    self.height = height
    self.width = width
    self.squares = squares
    self.state = state
  }
  
  init(withSquareRows rows: [GameRow]) {
    self.state = .Play
    self.height = rows.count
    self.width = rows.map({$0.count}).min() ?? 0

    var squares = [GameSquareType]()
    for row in rows {
      squares = squares + GameRow(row[0..<self.width])
    }
    
    self.squares = squares
  }
  
  func squareAt(x: Int, y: Int) -> GameSquareType? {
    let squareIndex = self.squareIndex(x: x, y: y)
    guard squareIndex >= 0 else { return nil }
    return squares[squareIndex]
  }
  
  private func squareIndex(x: Int, y: Int) -> Int {
    guard x >= 0 && x < self.width
      && y >= 0 && y < self.height else { return -1 }
    
    return y * width + x
  }
  
  func tap(x: Int, y: Int) -> GameBoardType {
    guard let tappedSquare = squareAt(x: x, y: y)?.tap() else { return self }
    
    var squares = self.squares
    squares[squareIndex(x: x, y: y)] = tappedSquare
    
    if tappedSquare.state == .Mine {
      return copyWithLoss()
    }

    return copy(squares: squares, state: state).testForWin()
  }

  private func copyWithLoss() -> GameBoardType {
    let squares = self.squares.map{ square in
      return square.state == .Blank ? square.tap() : square
    }
    
    return copy(squares: squares, state: .Lose)
  }
  
  private func testForWin() -> GameBoardType {
    guard state == .Play else { return self }
    
    if squares.first(where: { $0.state == .Blank && !$0.hasMine }) == nil {
      return copy(squares: self.squares, state: .Win)
    }
    
    return self
  }
  
  private func copy(squares: [GameSquareType], state: GameBoardState) -> GameBoard {
    return GameBoard(height: self.height, width: self.width, squares: squares, state: state)
  }
}

