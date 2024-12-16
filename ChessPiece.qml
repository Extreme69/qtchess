import QtQuick 2.15

Item {
	// Define properties for the chess piece component
    property string piece		// The type of piece (e.g., "king", "queen", "pawn", etc.)
    property string color		// The color of the piece (e.g., "white", "black")
    property string position	// The position of the piece on the board (e.g., "0,1")
    property bool hasMoved		// Tracks if the piece has moved during the game

    width: parent.width / 8
    height: parent.height / 8
	
	// GameState instance is used to calculate valid moves for pieces
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
		
		// MouseArea is used to capture the click events on the square
        MouseArea {
            id: selectArea
            anchors.fill: parent
            onClicked: {
                // If the piece is already selected, deselect it and remove highlighted moves
                if (window.selectedPiece === position) {
                    // Deselect the piece if clicked again
                    window.selectedPiece = "";
                    window.highlightedMoves = [];
                } else if (color === window.currentPlayer) {
                    // If it's the current player's turn and they clicked their piece, select the piece
                    window.selectedPiece = position;
                    var checkKing = false;
                    if(piece === "king"){
                        checkKing = true; // Set checkKing flag to true if the piece is a king
                    }
					
					// Calculate the valid moves for the selected piece and highlight them
                    window.highlightedMoves = gameState.calculateValidMoves(parent.parent, checkKing, false, false, true);
                } else if (window.selectedPiece !== "" && color !== window.currentPlayer) {
                    // If a piece is selected and the current player clicks an opponent's piece, select it to capture
                    window.pieceToCapture = position;
                }
            }
        }
    }
}
