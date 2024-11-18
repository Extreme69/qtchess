import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Chess Game")

    Grid {
        id: chessBoard
        rows: 8
        columns: 8
        // Bind the width and height to the smaller dimension of the window to maintain square aspect ratio
        width: Math.min(window.width, window.height) * 0.8
        height: width // Maintain square shape
        anchors.centerIn: parent

        // Draw chessboard
        Repeater {
            model: 64
            Rectangle {
                width: chessBoard.width / 8
                height: chessBoard.height / 8
                color: (index + Math.floor(index / 8)) % 2 === 0 ? "white" : "black"
                border.color: "black"

                // Ensure each square is positioned correctly
                x: (index % 8) * (chessBoard.width / 8)
                y: Math.floor(index / 8) * (chessBoard.height / 8)
            }
        }

        // Place chess pieces using another Repeater
        Repeater {
            model: chessPiecesModel
            Image {
                source: type === "pawn" ? "qrc:/pieces/images/rook_white.png" : ""
                width: chessBoard.width / 8 * 0.8
                height: chessBoard.height / 8 * 0.8
                x: x * (chessBoard.width / 8)
                y: y * (chessBoard.height / 8)
            }
        }
    }

    // Chess pieces model
    ListModel {
        id: chessPiecesModel
        ListElement { type: "pawn"; x: 0; y: 1 } // White pawn at (0,1)
        ListElement { type: "pawn"; x: 1; y: 1 } // White pawn at (1,1)
        // Add more pieces here
    }

    Item {
        function isValidMove(piece, newX, newY) {
            // Example logic: pawns move forward
            if (piece.type === "pawn") {
                return (newX === piece.x && newY === piece.y + 1);
            }
            return false; // Placeholder for other pieces
        }
    }
}
