import QtQuick 2.15

Item {
    property string piece
    property string color
    property string position
    property bool hasMoved

    width: parent.width / 8
    height: parent.height / 8

    Rectangle {
        anchors.fill: parent
        color: (window.selectedPiece === position) ? "lightblue" : "transparent"

        Image {
            source: "qrc:/pieces/images/" + piece + "_" + color + ".png"
            anchors.centerIn: parent
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        MouseArea {
            id: selectArea
            anchors.fill: parent
            onClicked: {
                // Ensure only the current player can select their pieces
                if (window.selectedPiece === position) {
                    // Deselect the piece if clicked again
                    window.selectedPiece = "";
                    window.highlightedMoves = [];
                } else if (color === window.currentPlayer) {
                    // Select the piece if it's the current player's turn
                    window.selectedPiece = position;
                    window.highlightedMoves = calculateValidMoves(piece, position, hasMoved);
                } else if (window.selectedPiece !== "" && color !== window.currentPlayer) {
                    // Select a piece to capture
                    window.pieceToCapture = position;
                }
            }
        }
    }

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

    function tracePath(col, row, dCol, dRow, maxSteps) {
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

    function calculateValidMoves(piece, position, hasMoved) {
        var moves = [];
        var col = parseInt(position.split(",")[0]);
        var row = parseInt(position.split(",")[1]);

        switch (piece) {
            case "rook":
                moves = moves.concat(
                    tracePath(col, row, 1, 0, 8),  // Right
                    tracePath(col, row, -1, 0, 8), // Left
                    tracePath(col, row, 0, 1, 8),  // Down
                    tracePath(col, row, 0, -1, 8)  // Up
                );
                break;

            case "bishop":
                moves = moves.concat(
                    tracePath(col, row, 1, 1, 8),   // Bottom-right
                    tracePath(col, row, -1, -1, 8), // Top-left
                    tracePath(col, row, 1, -1, 8),  // Top-right
                    tracePath(col, row, -1, 1, 8)   // Bottom-left
                );
                break;

            case "queen":
                moves = moves.concat(
                    tracePath(col, row, 1, 0, 8),   // Right
                    tracePath(col, row, -1, 0, 8),  // Left
                    tracePath(col, row, 0, 1, 8),   // Down
                    tracePath(col, row, 0, -1, 8),  // Up
                    tracePath(col, row, 1, 1, 8),   // Bottom-right
                    tracePath(col, row, -1, -1, 8), // Top-left
                    tracePath(col, row, 1, -1, 8),  // Top-right
                    tracePath(col, row, -1, 1, 8)   // Bottom-left
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

                console.log(`The king has moved: ${hasMoved}`)

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
}
