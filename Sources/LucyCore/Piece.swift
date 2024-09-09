public enum PieceColor {
    case white, black

    func opposite() -> PieceColor {
        return self == .white ? .black : .white
    }

    public var description: String {
        switch self {
        case .white:
            return "White"
        case .black:
            return "Black"
        }
    }
}

public enum PieceType {
    case man, king
}

public struct Piece: Hashable {
    public let color: PieceColor
    public var type: PieceType

    public var symbol: String {
        switch (color, type) {
        case (.white, .man): return "w"
        case (.white, .king): return "W"
        case (.black, .man): return "b"
        case (.black, .king): return "B"
        }
    }
}