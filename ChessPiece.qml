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

    function calculateValidMoves(piece, position) {
        var moves = [];
        var col = parseInt(position.split(",")[0]);
        var row = parseInt(position.split(",")[1]);

        if (piece === "rook") {
            // Example: Add all horizontal and vertical moves
            for (var i = 0; i < 8; i++) {
                moves.push(i + "," + row);
                moves.push(col + "," + i);
            }
        }
        // Add logic for other pieces...

        return moves;
    }

}
