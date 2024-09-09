import Foundation

public struct Board {
    public var pieces: [[Piece?]]
    public var currentPlayer: PieceColor

    public init() {
        pieces = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        currentPlayer = .white
        resetToStartPosition()
    }

    public mutating func resetToStartPosition() {
        currentPlayer = .white
        pieces = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        
        for row in 0..<3 {
            for col in stride(from: (row % 2 == 0 ? 1 : 0), to: 8, by: 2) {
                pieces[row][col] = Piece(color: .white, type: .man)
            }
        }
        
        for row in 5..<8 {
            for col in stride(from: (row % 2 == 0 ? 1 : 0), to: 8, by: 2) {
                pieces[row][col] = Piece(color: .black, type: .man)
            }
        }
        
    }

    public func isValidMove(_ move: Move) -> Bool {
        /// Check if the move is within the board boundaries
        guard move.from.row >= 0 && move.from.row < 8 &&
              move.from.col >= 0 && move.from.col < 8 &&
              move.to.row >= 0 && move.to.row < 8 &&
              move.to.col >= 0 && move.to.col < 8 else {
            return false
        }

        /// Check if there's a piece at the starting position
        guard let piece = pieces[move.from.row][move.from.col] else {
            return false
        }

        /// Check if the destination is empty
        guard pieces[move.to.row][move.to.col] == nil else {
            return false
        }

        let rowDiff = move.to.row - move.from.row
        let colDiff = move.to.col - move.from.col

        /// Check if the move is diagonal
        guard abs(rowDiff) == abs(colDiff) else {
            return false
        }

        /// Check if the piece is moving in the correct direction
        if piece.type == .man {
            if (piece.color == .white && rowDiff <= 0) || (piece.color == .black && rowDiff >= 0) {
                return false
            }
        }

        /// Check if the move is a single step or a capture
        if abs(rowDiff) == 1 {
            return true
        } else if abs(rowDiff) == 2 {
            /// Capture move
            let midRow = (move.from.row + move.to.row) / 2
            let midCol = (move.from.col + move.to.col) / 2
            guard let capturedPiece = pieces[midRow][midCol] else {
                return false
            }
            return capturedPiece.color != piece.color
        }

        return false
    }

    public mutating func makeMove(_ move: Move) -> (captured: Piece?, promoted: Bool) {
        guard isValidMove(move) else {
            return (captured: nil, promoted: false)
        }

        let piece = pieces[move.from.row][move.from.col]!
        pieces[move.to.row][move.to.col] = piece
        pieces[move.from.row][move.from.col] = nil

        var capturedPiece: Piece? = nil
        var promoted = false

        /// Capture logic
        if abs(move.to.row - move.from.row) == 2 {
            let midRow = (move.from.row + move.to.row) / 2
            let midCol = (move.from.col + move.to.col) / 2
            capturedPiece = pieces[midRow][midCol]
            pieces[midRow][midCol] = nil
        }

        /// King promotion
        if shouldPromoteToKing(piece: piece, row: move.to.row) {
            pieces[move.to.row][move.to.col] = Piece(color: piece.color, type: .king)
            promoted = true
        }

        return (captured: capturedPiece, promoted: promoted)
    }

    private func shouldPromoteToKing(piece: Piece, row: Int) -> Bool {
        if piece.type == .king {
            return false
        }
        return (piece.color == .white && row == 7) || (piece.color == .black && row == 0)
    }

    public func generateMoves(for color: PieceColor) -> [Move] {
        var moves: [Move] = []
        
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = pieces[row][col], piece.color == color {
                    moves.append(contentsOf: generateMovesForPiece(at: Position(row: row, col: col)))
                }
            }
        }
        
        return moves
    }

    private func generateMovesForPiece(at position: Position) -> [Move] {
        guard let piece = pieces[position.row][position.col] else {
            return []
        }
        
        var moves: [Move] = []
        let directions: [(Int, Int)] = piece.type == .man ? 
            (piece.color == .white ? [(1, -1), (1, 1)] : [(-1, -1), (-1, 1)]) :
            [(1, -1), (1, 1), (-1, -1), (-1, 1)]
        
        for direction in directions {
            moves.append(contentsOf: generateMovesInDirection(from: position, direction: direction))
        }
        
        return moves
    }

    private func generateMovesInDirection(from position: Position, direction: (Int, Int)) -> [Move] {
        var moves: [Move] = []
        let piece = pieces[position.row][position.col]!
        
        let newRow = position.row + direction.0
        let newCol = position.col + direction.1
        
        if isValidPosition(row: newRow, col: newCol) && pieces[newRow][newCol] == nil {
            moves.append(Move(from: position, to: Position(row: newRow, col: newCol)))
        }
        
        let captureRow = position.row + 2 * direction.0
        let captureCol = position.col + 2 * direction.1
        
        if isValidPosition(row: captureRow, col: captureCol) && pieces[captureRow][captureCol] == nil {
            let midRow = position.row + direction.0
            let midCol = position.col + direction.1
            
            if let capturedPiece = pieces[midRow][midCol], capturedPiece.color != piece.color {
                moves.append(Move(from: position, to: Position(row: captureRow, col: captureCol)))
            }
        }
        
        return moves
    }

    private func isValidPosition(row: Int, col: Int) -> Bool {
        return row >= 0 && row < 8 && col >= 0 && col < 8
    }

    public func evaluate() -> Int {
        var score = 0
        let pieceValues = [
            Piece(color: .white, type: .man): 1,
            Piece(color: .white, type: .king): 3,
            Piece(color: .black, type: .man): -1,
            Piece(color: .black, type: .king): -3
        ]
        
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = pieces[row][col] {
                    score += pieceValues[piece] ?? 0
                    
                    if piece.type == .man {
                        if piece.color == .white {
                            score += row / 2
                        } else {
                            score -= (7 - row) / 2
                        }
                    }
                    
                    if (2...5).contains(row) && (2...5).contains(col) {
                        score += piece.color == .white ? 1 : -1
                    }
                }
            }
        }
        
        return score
    }

    public func allLegalMoves() -> [Move] {
        return generateMoves(for: currentPlayer)
    }

    func isGameOver() -> Bool {
        return allLegalMoves().isEmpty
    }

    func winner() -> PieceColor? {
        if isGameOver() {
            return currentPlayer.opposite()
        }
        return nil
    }

    public mutating func switchPlayer() {
        currentPlayer = currentPlayer == .white ? .black : .white
    }
}

extension Board: CustomStringConvertible {
    public var description: String {
        let files = "   a b c d e f g h"
        let horizontalLine = "  +-+-+-+-+-+-+-+-+"
        var result = files + "\n" + horizontalLine + "\n"
        
        for row in (0..<8).reversed() {
            result += "\(row + 1) |"
            for col in 0..<8 {
                let piece = pieces[row][col]
                let symbol = piece?.symbol ?? ((row + col) % 2 == 0 ? " " : "·")
                result += symbol + "|"
            }
            result += "\n" + horizontalLine + "\n"
        }
        
        result += files
        return result
    }

    private func getPiece(at position: Position) -> Piece? {
        guard position.row >= 0 && position.row < 8 && position.col >= 0 && position.col < 8 else {
            return nil
        }
        return pieces[position.row][position.col]
    }
}