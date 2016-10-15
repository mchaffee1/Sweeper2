
struct GameBoard {
  let squares: [GameSquare]
  let height: Int
  let width: Int
  
  init(height: Int, width: Int) {
    self.height = height
    self.width = width
    let squares = [GameSquare](repeatElement(GameSquare(), count: height * width))
  }

}
