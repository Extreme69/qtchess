import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    title: qsTr("Chess Game")
    visibility: Window.Maximized

    property string currentPlayer: "white"  // Track whose turn it is ("white" or "black")

    // Display whose turn it is
    Rectangle {
        id: turnDisplayContainer
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.15
        height: parent.height * 0.05
        border.color: "black"
        border.width: 2
        anchors.topMargin: 20 // Keep it 20px down from the top

        // Inside the Rectangle, add the Text element
        Text {
            id: turnDisplay
            anchors.centerIn: parent
            text: currentPlayer === "white" ? "White's Turn" : "Black's Turn"
            font.bold: true
            font.pixelSize: 24
            padding: 10
        }
    }


    // Create a Rectangle to act as the border for the chessboard
    Rectangle {
        id: boardContainer
        width: Math.min(window.width, window.height) * 0.8 // Maintain square shape
        height: width
        anchors.centerIn: parent
        border.color: "black"
        border.width: width * 0.07  // Set the border thickness
        color: "transparent" // Make sure the inside of the rectangle is transparent

        // Inside the container, place the chessboard
        Grid {
            id: chessBoard
            rows: 8
            columns: 8
            width: boardContainer.width - 10 // Adjust to fit within the border
            height: boardContainer.height - 10 // Adjust to fit within the border
            anchors.centerIn: boardContainer // Center the grid in the container

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
                }
            }

            // Define chess pieces
            Repeater {
                model: [
                    // Black pieces (on the white side)
                    { piece: "rook", color: "black", position: "0,0" },
                    { piece: "knight", color: "black", position: "1,0" },
                    { piece: "bishop", color: "black", position: "2,0" },
                    { piece: "queen", color: "black", position: "3,0" },
                    { piece: "king", color: "black", position: "4,0" },
                    { piece: "bishop", color: "black", position: "5,0" },
                    { piece: "knight", color: "black", position: "6,0" },
                    { piece: "rook", color: "black", position: "7,0" },

                    // White pieces (on the black side)
                    { piece: "rook", color: "white", position: "0,7" },
                    { piece: "knight", color: "white", position: "1,7" },
                    { piece: "bishop", color: "white", position: "2,7" },
                    { piece: "queen", color: "white", position: "3,7" },
                    { piece: "king", color: "white", position: "4,7" },
                    { piece: "bishop", color: "white", position: "5,7" },
                    { piece: "knight", color: "white", position: "6,7" },
                    { piece: "rook", color: "white", position: "7,7" },

                    // Black pawns (on the white side)
                    { piece: "pawn", color: "black", position: "0,1" },
                    { piece: "pawn", color: "black", position: "1,1" },
                    { piece: "pawn", color: "black", position: "2,1" },
                    { piece: "pawn", color: "black", position: "3,1" },
                    { piece: "pawn", color: "black", position: "4,1" },
                    { piece: "pawn", color: "black", position: "5,1" },
                    { piece: "pawn", color: "black", position: "6,1" },
                    { piece: "pawn", color: "black", position: "7,1" },

                    // White pawns (on the black side)
                    { piece: "pawn", color: "white", position: "0,6" },
                    { piece: "pawn", color: "white", position: "1,6" },
                    { piece: "pawn", color: "white", position: "2,6" },
                    { piece: "pawn", color: "white", position: "3,6" },
                    { piece: "pawn", color: "white", position: "4,6" },
                    { piece: "pawn", color: "white", position: "5,6" },
                    { piece: "pawn", color: "white", position: "6,6" },
                    { piece: "pawn", color: "white", position: "7,6" }
                ]

                delegate: Item {
                    id: pieceItem
                    width: chessBoard.width / 8
                    height: chessBoard.height / 8
                    property string piece: modelData.piece
                    property string color: modelData.color
                    property string position: modelData.position

                    // Parse the position string (e.g., "0,0") into separate x and y coordinates
                    property int posX: parseInt(pieceItem.position.split(",")[0])
                    property int posY: parseInt(pieceItem.position.split(",")[1])

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        x: posX * parent.width // Position on the board (x-axis)
                        y: posY * parent.height // Position on the board (y-axis)

                        // Display piece image
                        Image {
                            id: chessPiece
                            source: "qrc:/pieces/images/" + pieceItem.piece + "_" + pieceItem.color + ".png"
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: parent.height * 0.8
                        }

                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            drag.target: parent

                            // Disable dragging if it's not the current player's piece
                            enabled: pieceItem.color === currentPlayer

                            onReleased: {
                                // Calculate nearest grid coordinates based on mouse release position
                                var gridWidth = chessBoard.width / 8;
                                var gridHeight = chessBoard.height / 8;

                                // Calculate the closest x and y grid indices
                                var newX = Math.floor((parent.x + gridWidth / 2) / gridWidth);
                                var newY = Math.floor((parent.y + gridHeight / 2) / gridHeight);

                                // Update piece position on the board
                                pieceItem.position = newX + "," + newY;
                                parent.x = newX * gridWidth; // Snap to nearest x
                                parent.y = newY * gridHeight; // Snap to nearest y

                                // Switch turn after move
                                currentPlayer = (currentPlayer === "white") ? "black" : "white";
                            }

                            onPressed: {
                                // Store initial position before drag starts
                                pieceItem.position = { x: Math.floor(parent.x / (chessBoard.width / 8)),
                                                       y: Math.floor(parent.y / (chessBoard.height / 8)) };
                            }

                            drag.axis: Drag.XandY
                        }
                    }
                }
            }

            // Add letters (A-H) along the top and bottom
            Repeater {
                model: 8
                Rectangle {
                    width: chessBoard.width / 8
                    height: 30
                    color: "transparent"
                    x: index * (chessBoard.width / 8)
                    y: -30 // Position at the top of the board

                    Text {
                        anchors.centerIn: parent
                        text: String.fromCharCode(65 + index) // Letters A to H
                        font.bold: true
                        font.pixelSize: 18
                    }
                }
            }

            // Add numbers (1-8) along the left and right
            Repeater {
                model: 8
                Rectangle {
                    width: 30
                    height: chessBoard.height / 8
                    color: "transparent"
                    x: -30 // Position at the left of the board
                    y: index * (chessBoard.height / 8)

                    Text {
                        anchors.centerIn: parent
                        text: (8 - index).toString() // Numbers 1 to 8
                        font.bold: true
                        font.pixelSize: 18
                    }
                }
            }
        }
    }
}
