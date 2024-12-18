import QtQuick 2.15

Item {
    property bool gameOver: false
    property string winner: ""

    /**
	 * Retrieves the chess piece located at a specified position.
	 *
	 * @param {string} position - The board position to check.
	 * @returns {Object|null} - The chess piece object at the given position,
	 *                          or null if no piece is found.
	 */
    function getPieceAtPosition(position) {
        for (var i = 0; i < piecesModel.count; i++) {
            if (piecesModel.get(i).position === position) {
                return piecesModel.get(i);
            }
        }
        return null;
    }
	
	/**
	 * Determines whether a given position is within the bounds of the chessboard.
	 *
	 * @param {number} col - The column index of the position (0 to 7).
	 * @param {number} row - The row index of the position (0 to 7).
	 * @returns {boolean} - True if the position is within the bounds of the chessboard,
	 *                      false otherwise.
	 */
    function isPositionInBounds(col, row) {
        return col >= 0 && col < 8 && row >= 0 && row < 8;
    }
	
	/**
	 * Adds a position to the list of valid moves if it is within bounds and does not contain
	 * a piece of the same color.
	 *
	 * This function checks if the specified position is valid for movement based on board 
	 * boundaries and the presence of an allied piece. If the square is either empty or occupied 
	 * by an opponent's piece, it is added to the list of moves.
	 *
	 * @param {Array} moves - The array of valid moves to which the position may be added.
	 * @param {number} col - The column of the target position (0 to 7).
	 * @param {number} row - The row of the target position (0 to 7).
	 * @param {string} color - The color of the moving piece ("white" or "black").
	 * @returns {Array} - The updated array of valid moves.
	 */
    function addIfValidMove(moves, col, row, color) {
		// Check if the position is within board boundaries
        if (isPositionInBounds(col, row)) {
            var position = col + "," + row;
            var pieceAtPosition = getPieceAtPosition(position); // Check for a piece at the target position
			
			// Add the position if it is empty or occupied by an opponent's piece
            if (!pieceAtPosition || pieceAtPosition.color !== color) {
                moves.push(position); // Add valid move to the array
            }
        }
        return moves; // Return the updated moves array
    }
	
	/**
	 * Traces the path along a given direction on the chessboard, adding valid positions 
	 * to the list of possible moves. This function handles movement for sliding pieces 
	 * such as rooks, bishops, and queens.
	 *
	 * It continues moving in the specified direction until it reaches the edge of the board 
	 * or encounters a piece. If an opponent's piece is encountered, it is added as a 
	 * capture move. The function stops tracing the path after the first encounter with 
	 * any piece, whether it is an enemy or an ally.
	 *
	 * @param {number} col - The current column of the piece (0 to 7).
	 * @param {number} row - The current row of the piece (0 to 7).
	 * @param {number} dCol - The direction of movement in the column (1 for right, -1 for left).
	 * @param {number} dRow - The direction of movement in the row (1 for down, -1 for up).
	 * @param {number} maxSteps - The maximum number of steps the piece can move in this direction.
	 * @param {string} color - The color of the piece (either "white" or "black").
	 * @returns {Array} - An array of valid positions that the piece can move to along the traced path.
	 */
    function tracePath(col, row, dCol, dRow, maxSteps, color) {
        var moves = [];
		
		// Loop through the steps in the given direction (up to maxSteps)
        for (var step = 1; step <= maxSteps; step++) {
			// Calculate new column position and row
            var newCol = col + step * dCol;
            var newRow = row + step * dRow;
			
			// Break if the new position is out of bounds
            if (!isPositionInBounds(newCol, newRow)) {
                break; // Stop at the edge of the board
            }

            var position = newCol + "," + newRow;
            var pieceAtPosition = getPieceAtPosition(position); // Get the piece at the new position

            if (pieceAtPosition) {
				// Capture the enemy piece and stop tracing the path
                if (pieceAtPosition.color !== color) {
                    moves.push(position); // Add enemy piece as a capture move
                }
                break; // Stop further movement if the path is blocked by a piece
            }
			
			// Add the free square to the list of valid moves
            moves.push(position);
        }
        return moves; // Return the list of valid moves along the traced path
    }
	
	/**
	 * Checks if a given position is adjacent to the opponent's king position.
	 *
	 * @param {number} col - The column index of the position to check.
	 * @param {number} row - The row index of the position to check.
	 * @param {string} opponentKingPosition - The position of the opponent's king, 
	 *                                        formatted as "col,row" (e.g., "4,4").
	 * @returns {boolean} - True if the position is adjacent to the opponent's king, 
	 *                      false otherwise.
	 */
    function isAdjacent(col, row, opponentKingPosition) {
        var opponentKingCol = parseInt(opponentKingPosition.split(",")[0]);
        var opponentKingRow = parseInt(opponentKingPosition.split(",")[1]);

        var dx = Math.abs(opponentKingCol - col);
        var dy = Math.abs(opponentKingRow - row);

        // Kings cannot move next to each other, so the difference should not be 1 in both x and y axes
        return dx <= 1 && dy <= 1;
    }
	
	
    /**
	 * Retrieves a list of valid moves for the current player's pieces that can block 
	 * or capture the opponent's piece responsible for checking the king.
	 *
	 * This function evaluates all potential moves for allied pieces and filters out 
	 * those that cannot resolve the check on the king. It uses the `canBlockOrCapture` 
	 * function to determine which moves are effective.
	 *
	 * @param {string} position - The position of the king under check or the square 
	 *                             threatened by the checking piece.
	 * @returns {Array} - An array of moves that can block or capture the threatening piece.
	 */
    function getMovesThatCanBlockOrCapture(position) {
        var moves = [];
        var opponentColor = (window.currentPlayer === "white") ? "black" : "white";
		
		// Locate the piece at the specified position
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);

            if(piece.position === position){
                break; // Found the piece at the given position
            }
        }
		
		//Calculate the pieces valid moves
        var validMoves = calculateValidMoves(piece, false, false, true, true);

        // Evaluate moves to check if they can block or capture the checking piece
        for (var move of validMoves) {
            if (canBlockOrCapture(piece, move, opponentColor)) {
                moves.push(move); // Add the move to the list if it resolves the check
            }
        }
		
        return moves; // Return the list of resolving moves
    }
	
	/**
	 * Determines if a move by a piece would reveal a check on the player's own king.
	 *
	 * This function evaluates whether a move leaves the king vulnerable to an attack 
	 * by an opponent's piece by simulating the move and checking the resulting state.
	 *
	 * @param {string} position - The current position of the piece attempting the move.
	 * @param {string} move - The target square for the piece's move.
	 * @param {string} opponentColor - The color of the opponent's pieces.
	 * @returns {boolean} - True if the move reveals a check on the king, false otherwise.
	 */
    function isMoveRevealingCheck(position, move, oponentColor){
		// Locate the piece at the specified position
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);

            if(piece.position === position){
                break; // Found the piece at the given position
            }
        }
		
		// Return true if the move reveals a check, determined by `canBlockOrCapture`
        return !canBlockOrCapture(piece, move, oponentColor)
    }
	
	/**
	 * Calculates all the valid moves for a given piece based on its type, position, 
	 * and the state of the game (e.g., whether the king is in check). The function 
	 * handles different movement rules for each piece type (rook, bishop, queen, knight, 
	 * king, pawn) and filters out invalid moves such as those that would expose the king 
	 * to check. It also accounts for special moves like castling.
	 * 
	 * @param {Object} piece - The piece object representing the piece whose moves we are calculating.
	 * @param {boolean} checkKing - Flag indicating whether to check for king moves.
	 * @param {boolean} checkPawnCaptures - Flag indicating whether to consider pawn captures when calculating moves (even without posible pawn captures).
	 * @param {boolean} smth - Additional parameter used to allow certain conditions in specific situations.
	 * @param {boolean} checkValidMoves - Flag to filter out moves that would expose the king to check.
	 * @returns {Array} - An array of valid moves for the piece.
	 */
    function calculateValidMoves(piece, checkKing, checkPawnCaptures = false, smth, checkValidMoves = false) {
        var moves = [];
        var possibleMoves = [];

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
		
		// Switch based on piece type to calculate valid moves
        switch (pieceType) {
            case "rook":
                    if (!isInCheck || smth) {
						// Rook moves in straight lines (left, right, up, down)
                        possibleMoves = moves.concat(
                            tracePath(col, row, 1, 0, 8, color),  // Right
                            tracePath(col, row, -1, 0, 8, color), // Left
                            tracePath(col, row, 0, 1, 8, color),  // Down
                            tracePath(col, row, 0, -1, 8, color)  // Up
                        );
						
						// If filtering valid moves, remove moves that expose the king to check
                        if(checkValidMoves){
                            // Filter out moves that expose the king to check
                            moves = possibleMoves.filter(function(move) {
                                return !isMoveRevealingCheck(piece.position, move, opponentKing.color);
                            });
                        } else {
                            moves = possibleMoves
                        }

                    } else {
                        // Restrict rook moves to block the check or capture the attacking piece
                        moves = getMovesThatCanBlockOrCapture(piece.position);
                    }
                    break;

            case "bishop":
                if (!isInCheck || smth) {
					// Bishop moves diagonally (four diagonal directions)
                    possibleMoves = moves.concat(
                        tracePath(col, row, 1, 1, 8, color),   // Bottom-right
                        tracePath(col, row, -1, -1, 8, color), // Top-left
                        tracePath(col, row, 1, -1, 8, color),  // Top-right
                        tracePath(col, row, -1, 1, 8, color)   // Bottom-left
                    );
					
					// If filtering valid moves, remove moves that expose the king to check
                    if(checkValidMoves){
                        // Filter out moves that expose the king to check
                        moves = possibleMoves.filter(function(move) {
                            return !isMoveRevealingCheck(piece.position, move, opponentKing.color);
                        });
                    } else {
                        moves = possibleMoves
                    }

                } else {
                    // Restrict bishop moves to block the check or capture the attacking piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
                break;

            case "queen":
                if (!isInCheck || smth) {
					// Queen combines rook and bishop movements
                    possibleMoves = moves.concat(
                        tracePath(col, row, 1, 0, 8, color),   // Right
                        tracePath(col, row, -1, 0, 8, color),  // Left
                        tracePath(col, row, 0, 1, 8, color),   // Down
                        tracePath(col, row, 0, -1, 8, color),  // Up
                        tracePath(col, row, 1, 1, 8, color),   // Bottom-right
                        tracePath(col, row, -1, -1, 8, color), // Top-left
                        tracePath(col, row, 1, -1, 8, color),  // Top-right
                        tracePath(col, row, -1, 1, 8, color)   // Bottom-left
                    );
					
					// If filtering valid moves, remove moves that expose the king to check
                    if(checkValidMoves){
                        moves = possibleMoves.filter(function(move) {
                            return !isMoveRevealingCheck(piece.position, move, opponentKing.color);
                        });
                    } else {
                        moves = possibleMoves
                    }

                } else {
                    // Restrict queen moves to block the check or capture the attacking piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
                break;

            case "knight":
                if (!isInCheck || smth){
					// Knight has special "L-shaped" moves
                    var knightMoves = [
                        [2, 1], [2, -1], [-2, 1], [-2, -1],
                        [1, 2], [1, -2], [-1, 2], [-1, -2]
                    ];
                    knightMoves.forEach(function(move) {
                        addIfValidMove(possibleMoves, col + move[0], row + move[1], color);
                    });
					
					// If filtering valid moves, remove moves that expose the king to check
                    if(checkValidMoves){
                        moves = possibleMoves.filter(function(move) {
                            return !isMoveRevealingCheck(piece.position, move, opponentKing.color);
                        });
                    } else {
                        moves = possibleMoves
                    }

                } else {
                    // Restrict knight moves to block the check or capture the attacking piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
                break;

            case "king":
                if(checkKing === false){
                    break;
                }

                // King's movement is one square in any direction
                var directions = [
                    [1, 0], [-1, 0], [0, 1], [0, -1],
                    [1, 1], [-1, -1], [1, -1], [-1, 1]
                ];

                console.log("We are moving the king again.")

                // Loop through all possible movement directions for the king
                directions.forEach(function(dir) {
                    var newCol = col + dir[0];
                    var newRow = row + dir[1];

                    if (isPositionInBounds(newCol, newRow)) {
                        var newPosition = newCol + "," + newRow;

                        // Ensure the new position is not under threat by the opponent
                        if (!isSquareThreatened(newPosition, color === "white" ? "black" : "white")) {
                            console.log("The king can move to a square without it beaing threatened: " + newPosition)
                            var pieceAtPosition = getPieceAtPosition(newPosition);

                            // Only add valid moves (empty squares or capturing the opponent’s piece)
                            if (!pieceAtPosition || pieceAtPosition.color !== color) {

                                // Ensure the king isn't adjacent to the opponent's king (as it would be in check)
                                var isAdjacentToOpponentKing = isAdjacent(newCol, newRow, opponentKing.position);
                                if (!isAdjacentToOpponentKing) {
                                    moves.push(newPosition); // Add valid king move
                                }
                            }
                        }
                    }
                });

                // Castling logic for the king, only if the king has not moved
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
                        // Black side castling checks similar to white side
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
                    var direction = (color === "white") ? -1 : 1; // Set direction of pawn's movement based on color
                    var forwardPos = col + "," + (row + direction); // Move forward by one square

                    if(checkPawnCaptures === false){
                        // Pawn forward move: Check if the forward square is empty
                        if (!getPieceAtPosition(forwardPos)) {
                            possibleMoves.push(forwardPos);
                            // Check for starting row where pawn can move two squares
                            if ((color === "white" && row === 6) || (color === "black" && row === 1)) {
                                var doubleForwardPos = col + "," + (row + 2 * direction);
								// Ensure no pieces block the double move
                                if (!getPieceAtPosition(doubleForwardPos) && !getPieceAtPosition(forwardPos)) {
                                    possibleMoves.push(doubleForwardPos);
                                }
                            }
                        }
                    }

                    // Capturing: Pawn can capture diagonally one square
                    [-1, 1].forEach(function(offset) {
                        var captureCol = col + offset;
                        var captureRow = row + direction;
                        if (isPositionInBounds(captureCol, captureRow)) {
                            var capturePos = captureCol + "," + captureRow;
                            if(checkPawnCaptures === true){
                                possibleMoves.push(capturePos); // Add a capture position (only for simulating)
                            }

                            var pieceAtCapture = getPieceAtPosition(capturePos);
							// Only add capture if there's an enemy piece at the capture square
                            if (pieceAtCapture && pieceAtCapture.color !== color) {
                                possibleMoves.push(capturePos); // Add valid capture position
                            }
                        }
                    });
					
					// If filtering valid moves, remove moves that expose the king to check
                    if(checkValidMoves){
                        moves = possibleMoves.filter(function(move) {
                            return !isMoveRevealingCheck(piece.position, move, opponentKing.color);
                        });
                    } else {
                        moves = possibleMoves
                    }

                } else {
					// Restrict pawn moves to block the check or capture the attacking piece
                    moves = getMovesThatCanBlockOrCapture(piece.position);
                }
                break;
        }

        return moves; // Return the list of valid moves
    }

    /**
	 * Checks if the current player's king is in check and updates its status.
	 *
	 * This function evaluates whether the current player's king is under attack
	 * by any of the opponent's pieces. If the king is in check, it also triggers
	 * a checkmate evaluation and adjusts relevant properties to prevent castling.
	 */
    function checkForCheck() {
		// Retrieve references to both kings from the pieces model
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
                // Skip evaluating the opponent's king (kings can't directly attack)
                if (piece.piece === "king") continue;
				
                var validMoves = calculateValidMoves(piece, false);
                if (validMoves.indexOf(currentKing.position) !== -1) {
                    currentKing.isInCheck = true;
                    checkForCheckmate(currentKing, opponentColor); // Check for checkmate after confirming the king is in check
                    currentKing.hasMoved = true; // Update the kings hasMoved property to disable castling if in check
                    return; // Exit early since the king is in check
                }
            }
        }
    }
	
	/**
	 * Determines if the king is in checkmate by evaluating potential moves for escape
	 * and possible defensive actions by allied pieces.
	 *
	 * @param {Object} king - The king piece object currently in check.
	 * @param {string} opponentColor - The color of the opponent's pieces.
	 * @returns {boolean} - True if the king is in checkmate, false otherwise.
	 */
    function checkForCheckmate(king, opponentColor) {
        console.log("Checking for checkmate...");

        // 1. Check if the king has any valid moves to escape the check
        var kingMoves = calculateValidMoves(king, true, false, true);
        for (var move of kingMoves) {
            // Simulate the king moving to the target square
            var originalPosition = king.position;
            king.position = move;

            // Check if the square is safe for the king
            var isSafe = !isSquareThreatened(move, opponentColor);

            // Revert the king's position to its original location
            king.position = originalPosition;

            if (isSafe) {
                console.log("King can escape to:", move);
                return false; // If the king can move to a safe square, it's not checkmate
            }
        }

        // 2. Check if an allied piece can block or capture the threatening piece
        for (var j = 0; j < piecesModel.count; j++) {
            var piece = piecesModel.get(j);
            if (piece.color === king.color && piece.piece !== "king") {
				// Get valid moves for the allied piece
                var validMoves = calculateValidMoves(piece, false, false, true);
				
				// Check if the piece can block or capture the threatening piece
                for (var move_ of validMoves) {
                    if (canBlockOrCapture(piece, move_, opponentColor)) {
                        console.log("Allied piece can block or capture at:", move_);
                        return false; // If any piece can defend, it's not checkmate
                    }
                }
            }
        }
		
		// If no escape or defense is possible, the king is in checkmate
        console.log("Checkmate! The king cannot escape.");
        gameEnded(opponentColor)
        return true;
    }

	/**
	 * Determines if a specific square is threatened by any of the opponent's pieces.
	 *
	 * This function evaluates whether the given square is under attack by any 
	 * opponent piece, considering special rules for pawns and allowing the exclusion 
	 * of a specific piece (useful for simulations).
	 *
	 * @param {string} square - The target square to evaluate.
	 * @param {string} opponentColor - The color of the opponent's pieces.
	 * @param {Object|null} excludePiece - (Optional) A piece to exclude from the check,
	 *                                      typically used during simulations.
	 * @returns {boolean} - True if the square is threatened, false otherwise.
	 */
    function isSquareThreatened(square, opponentColor, excludePiece = null) {
        // Iterate through all pieces in the model
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);

            // Skip excluded piece and pieces that don't belong to the opponent
            if (piece === excludePiece || piece.color !== opponentColor) continue;

            var validMoves = [];

            // If it's a pawn, check for pawn captures
            if (piece.piece === "pawn") {
                validMoves = calculateValidMoves(piece, false, true, true);  // Pawn captures
            } else {
                validMoves = calculateValidMoves(piece, false, false, true);  // Regular piece moves
            }

            // Check if the square is under attack by this piece
            if (validMoves.includes(square)) {
                return true; // Square is threatened
            }
        }

        return false;  // No threats detected
    }

	/**
	 * Determines whether a given piece can block a check or capture a threatening piece
	 * to resolve a check on its king.
	 *
	 * This function simulates the piece's move to evaluate its impact on the check status 
	 * of the king. It temporarily updates the board state, checks the threat status, and 
	 * then reverts all changes.
	 *
	 * @param {Object} pieceToMove - The piece attempting to block or capture.
	 * @param {string} move - The target square for the piece to move to.
	 * @param {string} opponentColor - The color of the opponent's pieces.
	 * @returns {boolean} - True if the move resolves the check, false otherwise.
	 */
    function canBlockOrCapture(pieceToMove, move, opponentColor) {
        var whiteKing = piecesModel.get(0);
        var blackKing = piecesModel.get(1);

        // Save the original positions
        var originalPosition = pieceToMove.position;
        var capturedPiece = null;

        // Check if there is an opponent's piece at the destination square
        for (var i = 0; i < piecesModel.count; i++) {
            var piece = piecesModel.get(i);
            if (piece.position === move && piece.color !== pieceToMove.color) {
                capturedPiece = piece; // Record the piece being captured
                break;
            }
        }

        // Simulate the move by updating the piece's position
        pieceToMove.position = move;
		
		// Temporarily remove the captured piece from the board if applicable
        if (capturedPiece) capturedPiece.position = null; // Temporarily "remove" captured piece

        // Determine if the king is still in check after the simulated move
        var isKingStillInCheck = isSquareThreatened(
            pieceToMove.color === "white" ? whiteKing.position : blackKing.position,
            opponentColor
        );

        // Revert the simulated move
        pieceToMove.position = originalPosition;
        if (capturedPiece) capturedPiece.position = move;

        // Return true if the king is no longer in check, indicating the move resolves the check
        return !isKingStillInCheck;
    }
	
	/**
	 * Marks the game as ended and sets the winner.
	 *
	 * @param {string} winnerColor - The color of the winning player ("white" or "black").
	 *                               The input is converted to title case for display purposes.
	 */
    function gameEnded(winnerColor){
        gameOver = true
        winner = winnerColor.charAt(0).toUpperCase() + winnerColor.slice(1);
    }
}
