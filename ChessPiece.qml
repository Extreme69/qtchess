import QtQuick 2.15

Item {
    property string piece
    property string color
    property string position
    property bool hasMoved

    width: parent.width / 8
    height: parent.height / 8

    GameState {
        id: gameState // Instance of ChessPiece component
    }

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
                    var checkKing = false;
                    if(piece === "king"){
                        checkKing = true;
                    }
                    window.highlightedMoves = gameState.calculateValidMoves(parent.parent, checkKing, false, false);
                } else if (window.selectedPiece !== "" && color !== window.currentPlayer) {
                    // Select a piece to capture
                    window.pieceToCapture = position;
                }
            }
        }
    }
}
