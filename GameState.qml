import QtQuick 2.15

Item {
    function getPieceAtPosition(position) {
        for (var i = 0; i < piecesModel.count; i++) {
            if (piecesModel.get(i).position === position) {
                return piecesModel.get(i);
            }
        }
        return null; // No piece at this position
    }

    function isPositionInBounds(col, row) {
        return col >= 0 && col < 8 && row >= 0 && row < 8;
    }

    function addIfValidMove(moves, col, row, color) {
        if (isPositionInBounds(col, row)) {
            var position = col + "," + row;
            var pieceAtPosition = getPieceAtPosition(position);
            if (!pieceAtPosition || pieceAtPosition.color !== color) {
                moves.push(position); // Add free square or capture enemy
            }
        }
    }

    function tracePath(col, row, dCol, dRow, maxSteps, color) {
        var moves = [];
        for (var step = 1; step <= maxSteps; step++) {
            var newCol = col + step * dCol;
            var newRow = row + step * dRow;

            if (!isPositionInBounds(newCol, newRow)) {
                break; // Stop at the edge of the board
            }

            var position = newCol + "," + newRow;
            var pieceAtPosition = getPieceAtPosition(position);

            if (pieceAtPosition) {
                if (pieceAtPosition.color !== color) {
                    moves.push(position); // Capture enemy piece
                }
                break; // Stop tracing further, as the path is blocked
            }

            moves.push(position); // Add free square
        }
        return moves;
    }

    function calculateValidMoves(piece, position, hasMoved, color) {
        var moves = [];
        var col = parseInt(position.split(",")[0]);
        var row = parseInt(position.split(",")[1]);

        switch (piece) {
            case "rook":
                moves = moves.concat(
                    tracePath(col, row, 1, 0, 8, color),  // Right
                    tracePath(col, row, -1, 0, 8, color), // Left
                    tracePath(col, row, 0, 1, 8, color),  // Down
                    tracePath(col, row, 0, -1, 8, color)  // Up
                );
                break;

            case "bishop":
                moves = moves.concat(
                    tracePath(col, row, 1, 1, 8, color),   // Bottom-right
                    tracePath(col, row, -1, -1, 8, color), // Top-left
                    tracePath(col, row, 1, -1, 8, color),  // Top-right
                    tracePath(col, row, -1, 1, 8, color)   // Bottom-left
                );
                break;

            case "queen":
                moves = moves.concat(
                    tracePath(col, row, 1, 0, 8, color),   // Right
                    tracePath(col, row, -1, 0, 8, color),  // Left
                    tracePath(col, row, 0, 1, 8, color),   // Down
                    tracePath(col, row, 0, -1, 8, color),  // Up
                    tracePath(col, row, 1, 1, 8, color),   // Bottom-right
                    tracePath(col, row, -1, -1, 8, color), // Top-left
                    tracePath(col, row, 1, -1, 8, color),  // Top-right
                    tracePath(col, row, -1, 1, 8, color)   // Bottom-left
                );
                break;

            case "knight":
                var knightMoves = [
                    [2, 1], [2, -1], [-2, 1], [-2, -1],
                    [1, 2], [1, -2], [-1, 2], [-1, -2]
                ];
                knightMoves.forEach(function(move) {
                    addIfValidMove(moves, col + move[0], row + move[1], color);
                });
                break;

            case "king":
                // Horizontal & Vertical moves (already handled)
                var directions = [
                    [1, 0], [-1, 0], [0, 1], [0, -1],
                    [1, 1], [-1, -1], [1, -1], [-1, 1]
                ];
                directions.forEach(function(dir) {
                    addIfValidMove(moves, col + dir[0], row + dir[1], color);
                });

                // Castling for both sides if conditions are met
                if (color === "white" && !piecesModel.get(4).hasMoved && !piecesModel.get(5).hasMoved && !hasMoved) { // Check if rooks and king haven't moved
                    // Kingside Castling (4,7 -> 6,7) and rook (7,7 -> 5,7)
                    if (!getPieceAtPosition("5,7") && !getPieceAtPosition("6,7")) {
                        moves.push("6,7");
                    }
                    // Queenside Castling (4,7 -> 2,7) and rook (0,7 -> 3,7)
                    if (!getPieceAtPosition("3,7") && !getPieceAtPosition("2,7") && !getPieceAtPosition("1,7")) {
                        moves.push("2,7");
                    }
                }
                if (color === "black" && !piecesModel.get(2).hasMoved && !piecesModel.get(3).hasMoved && !hasMoved) { // Same logic for black
                    if (!getPieceAtPosition("5,0") && !getPieceAtPosition("6,0")) {
                        moves.push("6,0");
                    }
                    if (!getPieceAtPosition("3,0") && !getPieceAtPosition("2,0") && !getPieceAtPosition("1,0")) {
                        moves.push("2,0");
                    }
                }
                break;

            case "pawn":
                var direction = (color === "white") ? -1 : 1;
                var forwardPos = col + "," + (row + direction);

                // Forward move
                if (!getPieceAtPosition(forwardPos)) {
                    moves.push(forwardPos);
                    // Starting row double move
                    if ((color === "white" && row === 6) || (color === "black" && row === 1)) {
                        var doubleForwardPos = col + "," + (row + 2 * direction);
                        if (!getPieceAtPosition(doubleForwardPos) && !getPieceAtPosition(forwardPos)) {
                            moves.push(doubleForwardPos);
                        }
                    }
                }

                // Captures
                [-1, 1].forEach(function(offset) {
                    var captureCol = col + offset;
                    var captureRow = row + direction;
                    if (isPositionInBounds(captureCol, captureRow)) {
                        var capturePos = captureCol + "," + captureRow;
                        var pieceAtCapture = getPieceAtPosition(capturePos);
                        if (pieceAtCapture && pieceAtCapture.color !== color) {
                            moves.push(capturePos); // Add valid capture position
                        }
                    }
                });
                break;
        }
        return moves;
    }

    // This function checks for a check on a king
    function checkForCheck() {
        var whiteKing = piecesModel.get(0);
        var blackKing = piecesModel.get(1);

        // Reset isInCheck for both kings
        whiteKing.isInCheck = false;
        blackKing.isInCheck = false;

        // Determine the current king and opponent's color
        var currentKing = (window.currentPlayer === "white") ? whiteKing : blackKing;
        var opponentColor = (window.currentPlayer === "white") ? "black" : "white";

        // Loop through the opponent's pieces and check if they can attack the king's position
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);
            if (piece.color === opponentColor) {
                var validMoves = calculateValidMoves(piece.piece, piece.position, piece.hasMoved, piece.color);
                if (validMoves.indexOf(currentKing.position) !== -1) {
                    currentKing.isInCheck = true;
                    checkForCheckmate(currentKing, opponentColor); // Check for checkmate after confirming the king is in check
                    return; // Exit early since the king is in check
                }
            }
        }
    }

    function checkForCheckmate(king, opponentColor) {
        console.log("Checking for checkmate...");

        // 1. Check if the king can move to escape safely
        var kingMoves = calculateValidMoves("king", king.position, king.hasMoved, king.color);
        for (var move of kingMoves) {
            // Simulate king's move
            var originalPosition = king.position;
            king.position = move;

            // Check if the move is safe
            var isSafe = !isSquareThreatened(move, opponentColor);

            // Revert the king's position
            king.position = originalPosition;

            if (isSafe) {
                console.log("King can escape to:", move);
                return false; // Not a checkmate if the king can escape safely
            }
        }

        // 2. Check if any allied piece can block or capture the threatening piece
        for (var j = 0; j < piecesModel.count; j++) {
            var piece = piecesModel.get(j);
            if (piece.color === king.color && piece.piece !== "king") {
                var validMoves = calculateValidMoves(piece.piece, piece.position, piece.hasMoved, piece.color);

                for (var move_ of validMoves) {
                    if (canBlockOrCapture(piece, move_, opponentColor)) {
                        console.log("Allied piece can block or capture at:", move_);
                        return false; // Not a checkmate if any piece can block or capture
                    }
                }
            }
        }

        console.log("Checkmate! The king cannot escape.");
        return true; // No escape possible, this is a checkmate
    }


    function isSquareThreatened(square, opponentColor, excludePiece = null) {
        // Check all opponent pieces
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);

            // Exclude a piece if specified (used for simulations)
            if (piece === excludePiece || piece.color !== opponentColor) continue;

            // Get the valid moves for this piece
            var validMoves = calculateValidMoves(piece.piece, piece.position, piece.hasMoved, piece.color);

            // Check if the square is under attack
            if (validMoves.includes(square)) {
                return true;
            }
        }
        return false; // No threats found
    }


    function canBlockOrCapture(pieceToMove, move, opponentColor) {
        var whiteKing = piecesModel.get(0);
        var blackKing = piecesModel.get(1);

        // Save original position
        var originalPosition = pieceToMove.position;
        var capturedPiece = null;

        // Check if a piece is at the destination square
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);
            if (piece.position === move && piece.color !== pieceToMove.color) {
                capturedPiece = piece;
                break;
            }
        }

        // Simulate the move
        pieceToMove.position = move;
        if (capturedPiece) capturedPiece.position = null; // Temporarily "remove" captured piece

        // Check if the king is still in check
        var isKingStillInCheck = isSquareThreatened(
            pieceToMove.color === "white" ? whiteKing.position : blackKing.position,
            opponentColor
        );

        // Revert the move
        pieceToMove.position = originalPosition;
        if (capturedPiece) capturedPiece.position = move;

        // Return true if the move resolves the check
        return !isKingStillInCheck;
    }
}
