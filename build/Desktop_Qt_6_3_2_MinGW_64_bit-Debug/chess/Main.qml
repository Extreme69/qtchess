import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr("Chess Game")

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
                    // White pieces
                    { piece: "rook", color: "white", position: "0,0" },
                    { piece: "knight", color: "white", position: "1,0" },
                    { piece: "bishop", color: "white", position: "2,0" },
                    { piece: "queen", color: "white", position: "3,0" },
                    { piece: "king", color: "white", position: "4,0" },
                    { piece: "bishop", color: "white", position: "5,0" },
                    { piece: "knight", color: "white", position: "6,0" },
                    { piece: "rook", color: "white", position: "7,0" },

                    // Black pieces
                    { piece: "rook", color: "black", position: "0,7" },
                    { piece: "knight", color: "black", position: "1,7" },
                    { piece: "bishop", color: "black", position: "2,7" },
                    { piece: "queen", color: "black", position: "3,7" },
                    { piece: "king", color: "black", position: "4,7" },
                    { piece: "bishop", color: "black", position: "5,7" },
                    { piece: "knight", color: "black", position: "6,7" },
                    { piece: "rook", color: "black", position: "7,7" },

                    // White pawns
                    { piece: "pawn", color: "white", position: "0,1" },
                    { piece: "pawn", color: "white", position: "1,1" },
                    { piece: "pawn", color: "white", position: "2,1" },
                    { piece: "pawn", color: "white", position: "3,1" },
                    { piece: "pawn", color: "white", position: "4,1" },
                    { piece: "pawn", color: "white", position: "5,1" },
                    { piece: "pawn", color: "white", position: "6,1" },
                    { piece: "pawn", color: "white", position: "7,1" },

                    // Black pawns
                    { piece: "pawn", color: "black", position: "0,6" },
                    { piece: "pawn", color: "black", position: "1,6" },
                    { piece: "pawn", color: "black", position: "2,6" },
                    { piece: "pawn", color: "black", position: "3,6" },
                    { piece: "pawn", color: "black", position: "4,6" },
                    { piece: "pawn", color: "black", position: "5,6" },
                    { piece: "pawn", color: "black", position: "6,6" },
                    { piece: "pawn", color: "black", position: "7,6" }
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

                            onReleased: {
                                // Update position on release, adjust as per the grid.
                                var newX = Math.floor(parent.x / (chessBoardContainer.width / 8));
                                var newY = Math.floor(parent.y / (chessBoardContainer.height / 8));
                                pieceItem.position = { x: newX, y: newY };
                                parent.x = newX * (chessBoardContainer.width / 8);
                                parent.y = newY * (chessBoardContainer.height / 8);
                            }

                            onPressed: {
                                // Store initial position before drag starts
                                pieceItem.position = { x: Math.floor(parent.x / (chessBoardContainer.width / 8)),
                                                       y: Math.floor(parent.y / (chessBoardContainer.height / 8)) };
                            }

                            drag.axis: Drag.XandY
                        }
                    }
                }
            }
        }
    }
}
