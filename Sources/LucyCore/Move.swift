public struct Position {
    public let row: Int
    public let col: Int
}

public struct Move: CustomStringConvertible {
    public let from: Position
    public let to: Position

    public init(from: String) {
        let fromCol = Int(from[from.startIndex].asciiValue! - 97)
        let fromRow = Int(from[from.index(from.startIndex, offsetBy: 1)].asciiValue! - 49)
        let toCol = Int(from[from.index(from.startIndex, offsetBy: 2)].asciiValue! - 97)
        let toRow = Int(from[from.index(from.startIndex, offsetBy: 3)].asciiValue! - 49)

        self.from = Position(row: fromRow, col: fromCol)
        self.to = Position(row: toRow, col: toCol)
    }

    public init(from: Position, to: Position) {
        self.from = from
        self.to = to
    }

    public var description: String {
        let fromFile = Character(UnicodeScalar(97 + from.col)!)
        let fromRank = from.row + 1
        let toFile = Character(UnicodeScalar(97 + to.col)!)
        let toRank = to.row + 1
        return "\(fromFile)\(fromRank) to \(toFile)\(toRank)"
    }
}

