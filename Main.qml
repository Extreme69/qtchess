import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    title: qsTr("Chess Game")
    visibility: Window.Maximized

    property string currentPlayer: "white"
    property string selectedPiece: "" // Track selected piece
    property string pieceToCapture: "" // Track enemy piece to capture
    property var highlightedMoves: []

    // Define pieces as a ListModel
    ListModel {
        id: piecesModel
        ListElement { piece: "king"; color: "white"; position: "4,7"; hasMoved: false }
        ListElement { piece: "king"; color: "black"; position: "4,0"; hasMoved: false }
        ListElement { piece: "rook"; color: "black"; position: "0,0"; hasMoved: false }
        ListElement { piece: "rook"; color: "black"; position: "7,0"; hasMoved: false }
        ListElement { piece: "rook"; color: "white"; position: "0,7"; hasMoved: false }
        ListElement { piece: "rook"; color: "white"; position: "7,7"; hasMoved: false }
        ListElement { piece: "knight"; color: "black"; position: "1,0"; hasMoved: false }
        ListElement { piece: "bishop"; color: "black"; position: "2,0"; hasMoved: false }
        ListElement { piece: "queen"; color: "black"; position: "3,0"; hasMoved: false }
        ListElement { piece: "bishop"; color: "black"; position: "5,0"; hasMoved: false }
        ListElement { piece: "knight"; color: "black"; position: "6,0"; hasMoved: false }
        ListElement { piece: "knight"; color: "white"; position: "1,7"; hasMoved: false }
        ListElement { piece: "bishop"; color: "white"; position: "2,7"; hasMoved: false }
        ListElement { piece: "queen"; color: "white"; position: "3,7"; hasMoved: false }
        ListElement { piece: "bishop"; color: "white"; position: "5,7"; hasMoved: false }
        ListElement { piece: "knight"; color: "white"; position: "6,7"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "0,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "1,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "2,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "3,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "4,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "5,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "6,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "black"; position: "7,1"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "0,6"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "1,6"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "2,6"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "3,6"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "4,6"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "5,6"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "6,6"; hasMoved: false }
        ListElement { piece: "pawn"; color: "white"; position: "7,6"; hasMoved: false }
    }

    // This function will be triggered when the pieceToCapture changes
    function handleCapture() {
        if (window.pieceToCapture !== "") {
            // Find the enemy piece to capture
            for (var i = 0; i < piecesModel.count; i++) {
                var enemyPiece = piecesModel.get(i);
                if (enemyPiece.position === window.pieceToCapture && enemyPiece.color !== window.currentPlayer) {
                    // Capture the piece
                    console.log("Capturing enemy piece at " + window.pieceToCapture);
                    // Remove the captured piece from the model
                    piecesModel.remove(i);
                    break;  // Exit after removing the piece
                }
            }
            // Reset the pieceToCapture after the capture
            window.pieceToCapture = "";
        }
    }

    // Handle the movement of a piece
    function handlePieceMovement(piece, targetPosition) {
        // Ensure the target position is within highlighted moves
        if (window.highlightedMoves.indexOf(targetPosition) === -1) {
            console.log("Invalid move: " + targetPosition + " is not highlighted.");
            return;
        }

        var selectedPieceIndex = -1;
        for (var i = 0; i < piecesModel.count; i++) {
            if (piecesModel.get(i).position === piece) {
                selectedPieceIndex = i;
                break;
            }
        }

        if (selectedPieceIndex !== -1) {
            var selectedPiece = piecesModel.get(selectedPieceIndex);

            // If the move is castling, move the rook and the king
            if (selectedPiece.piece === "king" && (targetPosition === "6,7" || targetPosition === "2,7" || targetPosition === "6,0" || targetPosition === "2,0")) {

                var rookPosition, newRookPosition;

                if (selectedPiece.color === "white") {
                    rookPosition = (targetPosition === "6,7") ? "7,7" : "0,7"; // White's rook positions for castling
                    newRookPosition = (targetPosition === "6,7") ? "5,7" : "3,7";
                } else if (selectedPiece.color === "black") {
                    rookPosition = (targetPosition === "6,0") ? "7,0" : "0,0"; // Black's rook positions for castling
                    newRookPosition = (targetPosition === "6,0") ? "5,0" : "3,0";
                }

                // Move the king
                piecesModel.set(selectedPieceIndex, {
                    piece: selectedPiece.piece,
                    color: selectedPiece.color,
                    position: targetPosition,
                    hasMoved: true
                });

                // Find and move the rook
                for (var j = 0; j < piecesModel.count; j++) {
                    var rook = piecesModel.get(j);
                    if (rook.position === rookPosition && rook.piece === "rook" && rook.color === selectedPiece.color) {
                        piecesModel.set(j, {
                            piece: rook.piece,
                            color: rook.color,
                            position: newRookPosition,
                            hasMoved: true
                        });
                        break;
                    }
                }
            } else if (selectedPiece.piece === "king" || selectedPiece.piece === "rook") {
                // If the piece is a room or a king mark it as moved
                piecesModel.set(selectedPieceIndex, {
                    piece: selectedPiece.piece,
                    color: selectedPiece.color,
                    position: targetPosition,
                    hasMoved: true
                });
            }else {
                // Standard move handling
                piecesModel.set(selectedPieceIndex, {
                    piece: selectedPiece.piece,
                    color: selectedPiece.color,
                    position: targetPosition
                });
            }
            // Debug: Log the 'hasMoved' property for all kings and rooks
            for (var k = 0; k < piecesModel.count; k++) {
                var pieceToCheck = piecesModel.get(k);
                if (pieceToCheck.piece === "king" || pieceToCheck.piece === "rook") {
                    console.log(`Piece: ${pieceToCheck.piece}, Color: ${pieceToCheck.color}, HasMoved: ${pieceToCheck.hasMoved}`);
                }
            }

            // Deselect the piece and reset highlights
            window.selectedPiece = "";
            window.highlightedMoves = [];

            // Switch turn after the move
            window.currentPlayer = (window.currentPlayer === "white") ? "black" : "white";
        }
    }


    // Automatically call handleCapture whenever pieceToCapture changes
    onPieceToCaptureChanged: {
        if(window.selectedPiece !== ""){
            // Piece not selected
            if(window.pieceToCapture !== ""){
                var thePiecePos = window.pieceToCapture

                handleCapture();
                // If a capture occurred, handle the movement
                handlePieceMovement(window.selectedPiece, thePiecePos);
            }
        }
    }

    TurnDisplay {
        currentPlayer: window.currentPlayer  // Pass currentPlayer to TurnDisplay
    }

    Rectangle {
        id: boardContainer
        width: Math.min(window.width, window.height) * 0.8
        height: width
        anchors.centerIn: parent
        border.color: "black"
        border.width: width * 0.07
        color: "transparent"

        Grid {
            id: chessBoard
            rows: 8
            columns: 8
            width: boardContainer.width - 10
            height: boardContainer.height - 10
            anchors.centerIn: boardContainer

            // Draw chessboard
            Repeater {
                model: 64
                Rectangle {
                    width: chessBoard.width / 8
                    height: chessBoard.height / 8
                    color: (index + Math.floor(index / 8)) % 2 === 0 ? "#ecede8" : "#c2c18f"
                    border.color: "black"
                    x: (index % 8) * (chessBoard.width / 8)
                    y: Math.floor(index / 8) * (chessBoard.height / 8)

                    // Extract row and column from index
                    property int row: Math.floor(index / 8)
                    property int col: index % 8

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (window.selectedPiece !== "") {
                                var selectedPieceIndex = -1;
                                for (var i = 0; i < piecesModel.count; i++) {
                                    if (piecesModel.get(i).position === window.selectedPiece) {
                                        selectedPieceIndex = i;
                                        break;
                                    }
                                }

                                if (selectedPieceIndex !== -1) {
                                    var selectedPiece = piecesModel.get(selectedPieceIndex);
                                    var targetPosition = col + "," + row;

                                    // Handle the piece movement to the target position
                                    handlePieceMovement(selectedPiece.position, targetPosition);
                                }
                            }
                        }
                    }
                }
            }

            // Highlights
            Repeater {
                model: 64
                Rectangle {
                    width: chessBoard.width / 8
                    height: chessBoard.height / 8
                    color: (window.highlightedMoves.indexOf(index % 8 + "," + Math.floor(index / 8)) !== -1)
                           ? Qt.rgba(153/255, 204/255, 255/255, 0.5) // #99CCFF with 50% transparency
                           : "transparent"
                    z: 1
                    x: (index % 8) * (chessBoard.width / 8)
                    y: Math.floor(index / 8) * (chessBoard.height / 8)
                }
            }

            // Define chess pieces using ChessPiece component
            Repeater {
                model: piecesModel
                delegate: ChessPiece {
                    piece: model.piece
                    color: model.color
                    position: model.position
                    hasMoved: model.hasMoved
                    x: (parseInt(model.position.split(',')[0])) * (chessBoard.width / 8)
                    y: (parseInt(model.position.split(',')[1])) * (chessBoard.height / 8)
                }
            }

            // Use ChessboardLabels component
            ChessboardLabels {}
        }
    }
}
