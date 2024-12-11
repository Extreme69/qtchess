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

    function addIfValidMove(moves, col, row) {
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
                    addIfValidMove(moves, col + move[0], row + move[1]);
                });
                break;

            case "king":
                // Horizontal & Vertical moves (already handled)
                var directions = [
                    [1, 0], [-1, 0], [0, 1], [0, -1],
                    [1, 1], [-1, -1], [1, -1], [-1, 1]
                ];
                directions.forEach(function(dir) {
                    addIfValidMove(moves, col + dir[0], row + dir[1]);
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

    // This functions checks for a check on a king
    function checkForCheck() {
        var whiteKingPosition = piecesModel.get(0).position
        var blackKingPosition = piecesModel.get(1).position

        var kingPosition = (window.currentPlayer === "white") ? whiteKingPosition : blackKingPosition;
        var opponentColor = (window.currentPlayer === "white") ? "black" : "white";

        // Loop through the opponent's pieces and check if they can attack the king's position
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);
            if (piece.color === opponentColor) {
                var validMoves = calculateValidMoves(piece.piece, piece.position, piece.hasMoved, piece.color);
                if (validMoves.indexOf(kingPosition) !== -1) {
                    console.log("The king is in check.")
                    return true;  // King is in check
                }
            }
        }
        console.log("The king is not in check.")
        return false;  // King is not in check
    }
}
