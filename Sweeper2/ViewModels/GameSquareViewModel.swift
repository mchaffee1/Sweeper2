protocol GameSquareViewModelType {
    var displayText: String { get }
}

struct GameSquareViewModel: GameSquareViewModelType {
    let square: GameSquare

    var displayText: String {
        switch self.square.state {
            case .Cleared(let count): return String(count)
            case .Mine: return "BAM"
            default: return ""
        }
    }
}
