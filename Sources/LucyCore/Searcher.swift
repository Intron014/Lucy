public class Searcher {
    private let maxDepth = 4

    public func findBestMove(board: Board) -> Move {
        let (_, bestMove) = minimax(board: board, depth: maxDepth, maximizingPlayer: board.currentPlayer == .white)
        return bestMove!
    }

    private func minimax(board: Board, depth: Int, maximizingPlayer: Bool) -> (Int, Move?) {
        if depth == 0 {
            return (board.evaluate(), nil)
        }

        let currentPlayer = maximizingPlayer ? PieceColor.white : PieceColor.black
        let moves = board.generateMoves(for: currentPlayer)
        if moves.isEmpty {
            return (board.evaluate(), nil)
        }

        var bestMove: Move?
        var bestValue = maximizingPlayer ? Int.min : Int.max

        for move in moves {
            var newBoard = board
            newBoard.makeMove(move)
            let (value, _) = minimax(board: newBoard, depth: depth - 1, maximizingPlayer: !maximizingPlayer)

            if maximizingPlayer {
                if value > bestValue {
                    bestValue = value
                    bestMove = move
                }
            } else {
                if value < bestValue {
                    bestValue = value
                    bestMove = move
                }
            }
        }

        return (bestValue, bestMove)
    }
}