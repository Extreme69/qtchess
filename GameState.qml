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

    // Function to check if a position is adjacent to the opponent's king
    function isAdjacent(col, row, opponentKingPosition) {
        var opponentKingCol = parseInt(opponentKingPosition.split(",")[0]);
        var opponentKingRow = parseInt(opponentKingPosition.split(",")[1]);

        var dx = Math.abs(opponentKingCol - col);
        var dy = Math.abs(opponentKingRow - row);

        // Kings cannot move next to each other, so the difference should not be 1 in both x and y axes
        return dx <= 1 && dy <= 1;
    }

    // Helper function to get moves that can block or capture the checking piece
    function getMovesThatCanBlockOrCapture(position) {
        var moves = [];
        var opponentColor = (window.currentPlayer === "white") ? "black" : "white";

        // Check if a piece is at the destination square
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);

            if(piece.position === position){
                break;
            }
        }

        console.log(piece.piece)
        console.log(piece.color)
        console.log(piece.position)

        var validMoves = calculateValidMoves(piece, false, false, true);
        // Only consider moves that are in the line of attack of the checking piece
        for (var move of validMoves) {
            if (canBlockOrCapture(piece, move, opponentColor)) {
                moves.push(move);
            }
        }

        console.log(moves)
        return moves;
    }

    function calculateValidMoves(piece, checkKing, checkPawnCaptures = false, smth) {
        var moves = [];

        var pieceType = piece.piece;
        var position = piece.position;
        var hasMoved = piece.hasMoved;
        var color = piece.color;

        var col = parseInt(position.split(",")[0]);
        var row = parseInt(position.split(",")[1]);

        var whiteKing = piecesModel.get(0);
        var blackKing = piecesModel.get(1);

        var opponentKing = (window.currentPlayer === "white") ? blackKing : whiteKing;
        var currentKing = (window.currentPlayer === "white") ? whiteKing : blackKing;

        var isInCheck = currentKing.isInCheck;

        switch (pieceType) {
            case "rook":
                    if (!isInCheck || smth) {
                        moves = moves.concat(
                            tracePath(col, row, 1, 0, 8, color),  // Right
                            tracePath(col, row, -1, 0, 8, color), // Left
                            tracePath(col, row, 0, 1, 8, color),  // Down
                            tracePath(col, row, 0, -1, 8, color)  // Up
                        );
                    } else {
                        // Restrict rook moves to only those that block the check or capture the threatening piece
                        moves = getMovesThatCanBlockOrCapture(piece.position);
                    }
                    break;

            case "bishop":
                if (!isInCheck || smth) {
                    moves = moves.concat(
                        tracePath(col, row, 1, 1, 8, color),   // Bottom-right
                        tracePath(col, row, -1, -1, 8, color), // Top-left
                        tracePath(col, row, 1, -1, 8, color),  // Top-right
                        tracePath(col, row, -1, 1, 8, color)   // Bottom-left
                    );
                } else {
                    // Restrict bishop moves to only those that block the check or capture the threatening piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
                break;

            case "queen":
                if (!isInCheck || smth) {
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
                } else {
                    // Restrict queen moves to only those that block the check or capture the threatening piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
                break;

            case "knight":
                if (!isInCheck || smth){
                var knightMoves = [
                    [2, 1], [2, -1], [-2, 1], [-2, -1],
                    [1, 2], [1, -2], [-1, 2], [-1, -2]
                ];
                knightMoves.forEach(function(move) {
                    addIfValidMove(moves, col + move[0], row + move[1], color);
                });    
                } else {
                    // Restrict knigh moves to only those that block the check or capture the threatening piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
                break;

            case "king":
                if(checkKing === false){
                    break;
                }

                var directions = [
                    [1, 0], [-1, 0], [0, 1], [0, -1],
                    [1, 1], [-1, -1], [1, -1], [-1, 1]
                ];

                directions.forEach(function(dir) {
                    var newCol = col + dir[0];
                    var newRow = row + dir[1];
                    if (isPositionInBounds(newCol, newRow)) {
                        var newPosition = newCol + "," + newRow;

                        // Check if the new position is under threat
                        if (!isSquareThreatened(newPosition, color === "white" ? "black" : "white")) {
                            var pieceAtPosition = getPieceAtPosition(newPosition);
                            // Only add valid moves (empty squares or capturing the opponent’s piece)
                            if (!pieceAtPosition || pieceAtPosition.color !== color) {
                                // Check if the new position is adjacent to the opponent's king
                                var isAdjacentToOpponentKing = isAdjacent(newCol, newRow, opponentKing.position);
                                if (!isAdjacentToOpponentKing) {
                                    moves.push(newPosition);
                                }
                            }
                        }
                    }
                });

                // Castling logic (remains unchanged)
                if (!hasMoved) {
                    if (color === "white" && !piecesModel.get(4).hasMoved && !piecesModel.get(5).hasMoved) {
                        // Kingside Castling (4,7 -> 6,7) and rook (7,7 -> 5,7)
                        if (!getPieceAtPosition("5,7") && !getPieceAtPosition("6,7") &&
                            !isSquareThreatened("4,7", "black") &&
                            !isSquareThreatened("5,7", "black") &&
                            !isSquareThreatened("6,7", "black")) {
                            moves.push("6,7");
                        }
                        // Queenside Castling (4,7 -> 2,7) and rook (0,7 -> 3,7)
                        if (!getPieceAtPosition("3,7") && !getPieceAtPosition("2,7") && !getPieceAtPosition("1,7") &&
                            !isSquareThreatened("2,7", "black") && !isSquareThreatened("3,7", "black") && !isSquareThreatened("4,7", "black")) {
                            moves.push("2,7");
                        }
                    }
                    if (color === "black" && !piecesModel.get(2).hasMoved && !piecesModel.get(3).hasMoved) {
                        if (!getPieceAtPosition("5,0") && !getPieceAtPosition("6,0") &&
                            !isSquareThreatened("4,0", "white") &&
                            !isSquareThreatened("5,0", "white") &&
                            !isSquareThreatened("6,0", "white")) {
                            moves.push("6,0");
                        }
                        if (!getPieceAtPosition("3,0") && !getPieceAtPosition("2,0") && !getPieceAtPosition("1,0") &&
                            !isSquareThreatened("2,0", "white") && !isSquareThreatened("3,0", "white") && !isSquareThreatened("4,0", "white")) {
                            moves.push("2,0");
                        }
                    }
                }
                break;


            case "pawn":
                if (!isInCheck || smth) {
                    var direction = (color === "white") ? -1 : 1;
                    var forwardPos = col + "," + (row + direction);

                    if(checkPawnCaptures === false){
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
                    }

                    // Captures
                    [-1, 1].forEach(function(offset) {
                        var captureCol = col + offset;
                        var captureRow = row + direction;
                        if (isPositionInBounds(captureCol, captureRow)) {
                            var capturePos = captureCol + "," + captureRow;
                            if(checkPawnCaptures === true){
                                moves.push(capturePos); // Add a capture position (only for simulating)
                            }

                            var pieceAtCapture = getPieceAtPosition(capturePos);
                            if (pieceAtCapture && pieceAtCapture.color !== color) {
                                moves.push(capturePos); // Add valid capture position
                            }
                        }
                    });
                } else {
                    // Restrict pawn moves to only those that block the check or capture the threatening piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
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
                // Skip the king itself in this check
                if (piece.piece === "king") continue;
                var validMoves = calculateValidMoves(piece, false);
                if (validMoves.indexOf(currentKing.position) !== -1) {
                    currentKing.isInCheck = true;
                    checkForCheckmate(currentKing, opponentColor); // Check for checkmate after confirming the king is in check
                    currentKing.hasMoved = true; // Change the hasMoved property so that the king cannot castle
                    return; // Exit early since the king is in check
                }
            }
        }
    }

    function checkForCheckmate(king, opponentColor) {
        console.log("Checking for checkmate...");

        // 1. Check if the king can move to escape safely
        var kingMoves = calculateValidMoves(king, true, false, true);
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
                var validMoves = calculateValidMoves(piece, false, false, true);
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

            // Calculate the valid moves for this piece
            var validMoves = [];

            // If it's a pawn, check for pawn captures
            if (piece.piece === "pawn") {
                validMoves = calculateValidMoves(piece, false, true, true);  // Pawn captures
            } else {
                validMoves = calculateValidMoves(piece, false, false, true);  // Regular piece moves
            }

            // Check if the square is under attack
            if (validMoves.includes(square)) {
                return true;
            }
        }

        return false;  // No threats found
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

        // If the king is not in check after the move, it means the move resolves the check
        return !isKingStillInCheck;
    }
}
