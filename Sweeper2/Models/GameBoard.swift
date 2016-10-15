
typealias GameRow = [GameSquareType]

protocol GameBoardType {
  init(height: Int, width: Int, probability: Int)
  var height: Int { get }
  var width: Int { get }
  func squareAt(x: Int, y: Int) -> GameSquare?
}

struct GameBoard: GameBoardType {
  let squares: [GameSquareType]
  let height: Int
  let width: Int
  
  init(height: Int, width: Int, probability: Int) {
    self.height = height
    self.width = width
    var squares = [GameSquare]()
    for _ in 0..<height*width {
      squares.append(GameSquare(withProbability: probability))
    }
    self.squares = squares
  }
  
  init(withSquareRows rows: [GameRow]) {
    self.height = rows.count
    self.width = rows.map({$0.count}).min() ?? 0

    var squares = [GameSquareType]()
    for row in rows {
      squares = squares + GameRow(row[0..<self.width])
    }
    
    self.squares = squares
  }
  
  func squareAt(x: Int, y: Int) -> GameSquare? {
    guard x >= 0 && x < self.width
      && y >= 0 && y < self.height else { return nil }
  
    return nil
//    return self.squares[y * self.width + x]
  }
}

