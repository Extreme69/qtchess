import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    title: qsTr("Chess Game")
    visibility: Window.Maximized
	
	// Properties to track the game state and player actions
    property string currentPlayer: "white"		// Set the starting player to white
    property string selectedPiece: "" 			// Track the selected piece
    property string pieceToCapture: ""			// Track the enemy piece to capture
    property var highlightedMoves: []			// Array to store highlighted valid moves

    property int whiteTime: 300                 // 5 minutes (in seconds)
    property int blackTime: 300                 // 5 minutes (in seconds)

    // Timer for White's turn
    Timer {
        id: whiteTimer
        interval: 1000 // 1 second interval
        running: window.currentPlayer === "white" && !gameState.gameOver
        repeat: true
        onTriggered: {
            window.whiteTime -= 1
            if (window.whiteTime <= 0) {
                gameState.gameOver = true
                gameState.winner = "Black"
            }
        }
    }

    // Timer for Black's turn
    Timer {
        id: blackTimer
        interval: 1000 // 1 second interval
        running: window.currentPlayer === "black" && !gameState.gameOver
        repeat: true
        onTriggered: {
            window.blackTime -= 1
            if (window.blackTime <= 0) {
                gameState.gameOver = true
                gameState.winner = "White"
            }
        }
    }

	// Instance of the GameState component to handle the game rules and logic
    GameState {
        id: gameState
    }

    Rectangle {
        id: winScreen
        visible: gameState.gameOver
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        z: 10

        // This mouse area prevents interaction with the game after it ends
        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.centerIn: parent
            spacing: 20

            // Title Text (winner or draw message)
            Text {
                text: gameState.winner === "draw" ? "It's a Draw!" : gameState.winner + " Wins!"
                font.pixelSize: 40
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
            }

            // Play Again Button with enhanced styling
            Button {
                text: "Play Again"
                width: parent.width * 0.6
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    color: "#4CAF50"
                    border.color: "#388E3C"
                    border.width: 2
                }
                font.pixelSize: 18
                onClicked: {
                    resetGame();
                }
            }

            // Exit Button with enhanced styling
            Button {
                text: "Exit"
                width: parent.width * 0.6
                height: 50
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    color: "#F44336"
                    border.color: "#D32F2F"
                    border.width: 2
                }
                font.pixelSize: 18
                onClicked: {
                    Qt.quit();
                }
            }
        }
    }

    // Define chess pieces using a ListModel to store all pieces and their positions
    ListModel {
        id: piecesModel
        ListElement { piece: "king"; color: "white"; position: "4,7"; hasMoved: false; isInCheck: false }
        ListElement { piece: "king"; color: "black"; position: "4,0"; hasMoved: false; isInCheck: false }
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

    /**
     * Resets the game state to its initial configuration.
     * This includes resetting the game state variables, piece positions,
     * and game timers, as well as clearing any selections and highlighted moves.
     */
    function resetGame() {
        // Reset all game state variables
        gameState.gameOver = false;
        gameState.winner = "";
        window.currentPlayer = "white";

        // Reset piece positions in piecesModel
        piecesModel.clear();

        // Append the pieces according to ListModel
        piecesModel.append({ piece: "king", color: "white", position: "4,7", hasMoved: false, isInCheck: false });
        piecesModel.append({ piece: "king", color: "black", position: "4,0", hasMoved: false, isInCheck: false });

        piecesModel.append({ piece: "rook", color: "black", position: "0,0", hasMoved: false });
        piecesModel.append({ piece: "rook", color: "black", position: "7,0", hasMoved: false });
        piecesModel.append({ piece: "rook", color: "white", position: "0,7", hasMoved: false });
        piecesModel.append({ piece: "rook", color: "white", position: "7,7", hasMoved: false });

        piecesModel.append({ piece: "knight", color: "black", position: "1,0", hasMoved: false });
        piecesModel.append({ piece: "bishop", color: "black", position: "2,0", hasMoved: false });
        piecesModel.append({ piece: "queen", color: "black", position: "3,0", hasMoved: false });
        piecesModel.append({ piece: "bishop", color: "black", position: "5,0", hasMoved: false });
        piecesModel.append({ piece: "knight", color: "black", position: "6,0", hasMoved: false });

        piecesModel.append({ piece: "knight", color: "white", position: "1,7", hasMoved: false });
        piecesModel.append({ piece: "bishop", color: "white", position: "2,7", hasMoved: false });
        piecesModel.append({ piece: "queen", color: "white", position: "3,7", hasMoved: false });
        piecesModel.append({ piece: "bishop", color: "white", position: "5,7", hasMoved: false });
        piecesModel.append({ piece: "knight", color: "white", position: "6,7", hasMoved: false });

        piecesModel.append({ piece: "pawn", color: "black", position: "0,1", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "black", position: "1,1", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "black", position: "2,1", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "black", position: "3,1", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "black", position: "4,1", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "black", position: "5,1", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "black", position: "6,1", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "black", position: "7,1", hasMoved: false });

        piecesModel.append({ piece: "pawn", color: "white", position: "0,6", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "white", position: "1,6", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "white", position: "2,6", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "white", position: "3,6", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "white", position: "4,6", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "white", position: "5,6", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "white", position: "6,6", hasMoved: false });
        piecesModel.append({ piece: "pawn", color: "white", position: "7,6", hasMoved: false });

        // Clear highlighted moves and selected pieces
        window.highlightedMoves = [];
        window.selectedPiece = "";

        // Reset the timers
        window.whiteTime = 300
        window.blackTime = 300
    }

	/**
	 * Handles the capture of an enemy piece when a valid capture is made.
	 *
	 * This function verifies whether the capture target is a valid move,
	 * identifies the enemy piece to be captured, and removes it from the board.
	 */
    function handleCapture() {
		// Check if there is a valid piece-to-capture target
        if (window.pieceToCapture !== "") {
		
            // Validate if the capture position is one of the highlighted valid moves
            if (window.highlightedMoves.indexOf(window.pieceToCapture) !== -1) {
                for (var i = 0; i < piecesModel.count; i++) {
                    var enemyPiece = piecesModel.get(i);

                    // Ensure the piece is an enemy and matches the target position
                    if (enemyPiece.position === window.pieceToCapture && enemyPiece.color !== window.currentPlayer) {
					
                        // Remove the captured enemy piece from the board model
                        piecesModel.remove(i);
                        break;  // Exit the loop after the piece is captured
                    }
                }
            } else {
                // Log an error if the target position is not a valid highlighted move
                console.log("Invalid capture: " + window.pieceToCapture + " is not a valid highlighted move.");
            }

            // Reset the pieceToCapture property after the capture attempt
            window.pieceToCapture = "";
        }
    }

    /**
	 * Handles the castling logic for a king and its associated rook.
	 * 
	 * This function moves the king and the corresponding rook to their new positions 
	 * when a castling move is made. The specific logic differs based on the color 
	 * of the king and the target position of the castling move.
	 *
	 * @param {Object} king - The king piece object that is being moved.
	 * @param {string} targetPosition - The target position for the king to move to.
	 */
    function handleCastling(king, targetPosition) {
        var rookPosition, newRookPosition;

        // Determine the initial rook position and the new position based on the king's color and castling direction
        if (king.color === "white") {
			// White's rook positions for castling (kingside and queenside)
            rookPosition = (targetPosition === "6,7") ? "7,7" : "0,7"; // White's rook positions for castling
            newRookPosition = (targetPosition === "6,7") ? "5,7" : "3,7";
        } else if (king.color === "black") {
			// Black's rook positions for castling (kingside and queenside)
            rookPosition = (targetPosition === "6,0") ? "7,0" : "0,0"; // Black's rook positions for castling
            newRookPosition = (targetPosition === "6,0") ? "5,0" : "3,0";
        }

        // Move the king to the target position and mark it as having moved
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);
            if (piece.position === king.position && piece.piece === "king" && piece.color === king.color) {
                piecesModel.set(i, {
                    piece: piece.piece,
                    color: piece.color,
                    position: targetPosition,
                    hasMoved: true
                });
                break; // Exit after moving the king
            }
        }

        // Find and move the rook to its new position after the castling move
        for (var j = 0; j < piecesModel.count; j++) {
            var rook = piecesModel.get(j);
            if (rook.position === rookPosition && rook.piece === "rook" && rook.color === king.color) {
                piecesModel.set(j, {
                    piece: rook.piece,
                    color: rook.color,
                    position: newRookPosition,
                    hasMoved: true
                });
                break; // Exit after moving the rook
            }
        }
    }

    /**
	 * Handles the movement of a selected piece to a target position.
	 *
	 * This function ensures the target position is valid, processes the move, 
	 * and updates the board state accordingly. It also handles special moves 
	 * like castling and switches the turn after the move.
	 *
	 * @param {string} piece - The position of the piece to be moved.
	 * @param {string} targetPosition - The position to move the piece to.
	 */
    function handlePieceMovement(piece, targetPosition) {
        // Ensure the target position is valid by checking if it is part of the highlighted moves
        if (window.highlightedMoves.indexOf(targetPosition) === -1) {
            console.log("Invalid move: " + targetPosition + " is not highlighted.");
            return;
        }
		
		// Find the index of the selected piece in the pieces model
        var selectedPieceIndex = -1;
        for (var i = 0; i < piecesModel.count; i++) {
            if (piecesModel.get(i).position === piece) {
                selectedPieceIndex = i;
                break;
            }
        }
		
		// If the selected piece is found, proceed with the move
        if (selectedPieceIndex !== -1) {
            var selectedPiece = piecesModel.get(selectedPieceIndex);

            // If the move is castling (a special move for the king), handle castling logic
            if (selectedPiece.piece === "king" && (targetPosition === "6,7" || targetPosition === "2,7" || targetPosition === "6,0" || targetPosition === "2,0") && selectedPiece.hasMoved === false) {
                handleCastling(selectedPiece, targetPosition);
            } else if (selectedPiece.piece === "king" || selectedPiece.piece === "rook") {
                // If the piece is a king or rook, mark it as moved
                piecesModel.set(selectedPieceIndex, {
                    piece: selectedPiece.piece,
                    color: selectedPiece.color,
                    position: targetPosition,
                    hasMoved: true
                });
            } else {
                // For other pieces, simply move them to the new position
                piecesModel.set(selectedPieceIndex, {
                    piece: selectedPiece.piece,
                    color: selectedPiece.color,
                    position: targetPosition
                });
            }

            // Deselect the piece and clear the highlighted moves after the move is completed
            window.selectedPiece = "";
            window.highlightedMoves = [];

            // Switch the turn after the move
            window.currentPlayer = (window.currentPlayer === "white") ? "black" : "white";

            // Check if the move results in a check condition
            gameState.checkForCheck()
        }
    }

    /**
	 * Automatically triggers the piece capture and movement process when the `pieceToCapture` property is updated.
	 *
	 * This handler first checks if a piece is selected and if there is a valid target piece to capture.
	 * If both conditions are met, it performs the capture action and then moves the selected piece to the target position.
	 */
    onPieceToCaptureChanged: {
		// Check if a piece is currently selected
        if(window.selectedPiece !== ""){
		
            // Proceed only if there is a valid piece-to-capture target
            if(window.pieceToCapture !== ""){
                var thePiecePos = window.pieceToCapture
				
				// Call the capture function to remove the enemy piece from the board
                handleCapture();
				
                // After capturing, move the selected piece to the target position
                handlePieceMovement(window.selectedPiece, thePiecePos);
            }
        }
    }
	
    Column {
        anchors.fill: parent
        spacing: 20  // Adds space between the timer row and the chessboard

        // Timer and Turn Display Row
        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            // White Timer on the left
            Rectangle {
                width: 120
                height: 50
                color: "white"
                border.color: "black"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "White: " + window.whiteTime
                    font.pixelSize: 20
                    color: "black"
                }
            }

            // Turn display in the middle
            TurnDisplay {
                currentPlayer: window.currentPlayer  // Pass currentPlayer to TurnDisplay
                width: 200
                height: 50
            }

            // Black Timer on the right
            Rectangle {
                width: 120
                height: 50
                color: "white"
                border.color: "black"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "Black: " + window.blackTime
                    font.pixelSize: 20
                    color: "black"
                }
            }
        }

        // Add a spacer here to push the chessboard down
        Rectangle {
            width: parent.width
            height: 20
            color: "transparent"
        }

        // Board container for displaying the chessboard
        Rectangle {
            id: boardContainer
            width: Math.min(window.width, window.height) * 0.8
            height: width
            anchors.centerIn: parent
            border.color: "black"
            border.width: width * 0.07
            color: "transparent"

            // Chessboard grid setup (8 rows and 8 columns)
            Grid {
                id: chessBoard
                rows: 8
                columns: 8
                width: boardContainer.width - 10
                height: boardContainer.height - 10
                anchors.centerIn: boardContainer

                // Create 64 squares on the chessboard using Repeater
                Repeater {
                    model: 64
                    Rectangle {
                        width: chessBoard.width / 8
                        height: chessBoard.height / 8
                        color: (index + Math.floor(index / 8)) % 2 === 0 ? "#ecede8" : "#c2c18f" // Alternate colors for squares (light and dark)
                        border.color: "black"
                        x: (index % 8) * (chessBoard.width / 8)
                        y: Math.floor(index / 8) * (chessBoard.height / 8)

                        // Extract row and column from index
                        property int row: Math.floor(index / 8)
                        property int col: index % 8

                        // Add interaction logic to select and move pieces
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // Only proceed if a piece is selected
                                if (window.selectedPiece !== "") {
                                    var selectedPieceIndex = -1;
                                    // Find the selected piece in the pieces model
                                    for (var i = 0; i < piecesModel.count; i++) {
                                        if (piecesModel.get(i).position === window.selectedPiece) {
                                            selectedPieceIndex = i;
                                            break;
                                        }
                                    }

                                    // If the piece is found, move it to the target position
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

                // Highlights for valid moves
                Repeater {
                    model: 64
                    Rectangle {
                        width: chessBoard.width / 8
                        height: chessBoard.height / 8
                        // Highlight squares that are part of the valid moves list
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
                    model: piecesModel // Model containing the chess pieces
                    delegate: ChessPiece {
                        piece: model.piece
                        color: model.color
                        position: model.position
                        hasMoved: model.hasMoved
                        x: (parseInt(model.position.split(',')[0])) * (chessBoard.width / 8)
                        y: (parseInt(model.position.split(',')[1])) * (chessBoard.height / 8)

                        // Logic to highlight the king if it's in check
                        Rectangle {
                            anchors.fill: parent
                            color: model.isInCheck && model.piece === "king" ? Qt.rgba(255, 0, 0, 0.5) : "transparent" // Highlight king in check with a red overlay
                        }
                    }
                }

                // Use ChessboardLabels component to display coordinates on the chessboard
                ChessboardLabels {}
            }
        }
    }
}
