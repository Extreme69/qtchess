import QtQuick 2.15

Item {
    property string piece
    property string color
    property string position

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
                    window.highlightedMoves = calculateValidMoves(piece, position);
                } else if (window.selectedPiece !== "" && color !== window.currentPlayer) {
                    // Select a piece to capture
                    window.pieceToCapture = position;
                }
            }
        }
    }

    // Helper function to calculate horizontal moves
    function horizontalMoves(row) {
        var result = [];
        for (var i = 0; i < 8; i++) {
            result.push(i + "," + row);
        }
        return result;
    }

    // Helper function to calculate vertical moves
    function verticalMoves(col) {
        var result = [];
        for (var i = 0; i < 8; i++) {
            result.push(col + "," + i);
        }
        return result;
    }

    // Helper function to calculate diagonal moves
    function diagonalMoves(col, row) {
        var result = [];
        for (var i = 1; i < 8; i++) {
            if (col + i < 8 && row + i < 8) result.push((col + i) + "," + (row + i));  // Bottom-right
            if (col + i < 8 && row - i >= 0) result.push((col + i) + "," + (row - i));  // Top-right
            if (col - i >= 0 && row + i < 8) result.push((col - i) + "," + (row + i));  // Bottom-left
            if (col - i >= 0 && row - i >= 0) result.push((col - i) + "," + (row - i));  // Top-left
        }
        return result;
    }

    function calculateValidMoves(piece, position) {
        var moves = [];
        var col = parseInt(position.split(",")[0]);
        var row = parseInt(position.split(",")[1]);

        switch (piece) {
            case "rook":
                // Add all horizontal and vertical moves
                moves = moves.concat(horizontalMoves(row), verticalMoves(col));
                break;

            case "bishop":
                // Add all diagonal moves
                moves = moves.concat(diagonalMoves(col, row));
                break;

            case "queen":
                // Queen combines rook and bishop moves
                moves = moves.concat(horizontalMoves(row), verticalMoves(col), diagonalMoves(col, row));
                break;

            case "king":
                // King moves one square in any direction
                var directions = [
                    [1, 0], [-1, 0], [0, 1], [0, -1], // Horizontal & Vertical
                    [1, 1], [-1, -1], [1, -1], [-1, 1] // Diagonal
                ];
                directions.forEach(function(dir) {
                    var newCol = col + dir[0];
                    var newRow = row + dir[1];
                    if (newCol >= 0 && newCol < 8 && newRow >= 0 && newRow < 8) {
                        moves.push(newCol + "," + newRow);
                    }
                });
                break;

            case "knight":
                // Knight moves in an "L" shape
                var knightMoves = [
                    [2, 1], [2, -1], [-2, 1], [-2, -1],
                    [1, 2], [1, -2], [-1, 2], [-1, -2]
                ];
                knightMoves.forEach(function(move) {
                    var newCol = col + move[0];
                    var newRow = row + move[1];
                    if (newCol >= 0 && newCol < 8 && newRow >= 0 && newRow < 8) {
                        moves.push(newCol + "," + newRow);
                    }
                });
                break;

            case "pawn":
                // Pawn moves: one square forward, and optionally two if on starting row
                var direction = (color === "white") ? -1 : 1;  // White moves up (-1), black moves down (+1)
                if (row + direction >= 0 && row + direction < 8) {
                    moves.push(col + "," + (row + direction));  // Forward move
                }
                // Starting row two-square move
                if ((color === "white" && row === 6) || (color === "black" && row === 1)) {
                    if (row + 2 * direction >= 0 && row + 2 * direction < 8) {
                        moves.push(col + "," + (row + 2 * direction));
                    }
                }
                // Captures
                if (col - 1 >= 0 && row + direction >= 0 && row + direction < 8) {
                    moves.push((col - 1) + "," + (row + direction));  // Capture left
                }
                if (col + 1 < 8 && row + direction >= 0 && row + direction < 8) {
                    moves.push((col + 1) + "," + (row + direction));  // Capture right
                }
                break;
        }

        return moves;
    }

}
