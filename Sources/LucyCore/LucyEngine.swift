import Foundation

public class LucyEngine {
    private var board: Board
    private let searcher: Searcher

    public init() {
        self.board = Board()
        self.searcher = Searcher()
    }

    public func run() {
        while let command = readLine() {
            processCommand(command)
        }
    }

    private func processCommand(_ command: String) {
        let components = command.split(separator: " ")
        guard let cmd = components.first else { return }

        switch cmd {
        case "uci":
            print("id name Lucy")
            print("id author Intron014")
            print("uciok")
        case "isready":
            print("readyok")
        case "position":
            if components.count > 1 {
                setupPosition(Array(components.dropFirst()))
            }
        case "go":
            let move = searcher.findBestMove(board: board)
            print("bestmove \(move)")
        case "quit":
            exit(0)
        case "board":
            print(board.description)
        case "battle":
            battle()
        default:
            print("Unknown command: \(command)")
        }
    }

    private func setupPosition(_ args: [String.SubSequence]) {
        if args[0] == "startpos" {
            board.resetToStartPosition()
        } else if args[0] == "fen" {
            // Implement FEN parsing for dames
        }

        if let movesIndex = args.firstIndex(of: "moves") {
            for move in args[(movesIndex + 1)...] {
                board.makeMove(Move(from: String(move)))
            }
        }
    }

    private func battle(moves: Int = 50) {
        print("Starting a self-play battle for \(moves) moves")
        board.resetToStartPosition()
        
        var gameEvents: [String] = []
        
        for i in 1...moves {
            let move = searcher.findBestMove(board: board)
            
            print("Move \(i): \(board.currentPlayer) plays \(move)")
            let (captured, promoted) = board.makeMove(move)
            print(board.description)
            
            if let capturedPiece = captured {
                let capturedColor = capturedPiece.color == .white ? "White" : "Black"
                let capturedType = capturedPiece.type == .man ? "man" : "king"
                let toPosition = formatPosition(move.to)
                gameEvents.append("Move \(i): \(board.currentPlayer.description) captured a \(capturedColor) piece at \(toPosition)")
            }
            
            if promoted {
                let toPosition = formatPosition(move.to)
                gameEvents.append("Move \(i): \(board.currentPlayer.description) promoted a piece to king at \(toPosition)")
            }
            
            board.switchPlayer() 
            
            if board.isGameOver() {
                if let winner = board.winner() {
                    print("Game over! \(winner == .white ? "White" : "Black") wins!")
                } else {
                    print("Game over! It's a draw.")
                }
                break
            }
        }
        
        if !board.isGameOver() {
            print("Battle ended after \(moves) moves without a conclusion")
        }
        
        print("\nGame Events:")
        for event in gameEvents {
            print(event)
        }
    }

    private func formatPosition(_ position: Position) -> String {
        let file = Character(UnicodeScalar(97 + position.col)!)
        let rank = position.row + 1
        return "\(file)\(rank)"
    }
}