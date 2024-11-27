import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    visible: true
    title: qsTr("Chess Game")
    visibility: Window.Maximized

    property string currentPlayer: "white"

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
                }
            }

            // Define chess pieces using ChessPiece component
            Repeater {
                model: [
                    { piece: "rook", color: "black", position: "0,0" },
                    { piece: "knight", color: "black", position: "1,0" },
                    { piece: "bishop", color: "black", position: "2,0" },
                    { piece: "queen", color: "black", position: "3,0" },
                    { piece: "king", color: "black", position: "4,0" },
                    { piece: "bishop", color: "black", position: "5,0" },
                    { piece: "knight", color: "black", position: "6,0" },
                    { piece: "rook", color: "black", position: "7,0" },

                    { piece: "rook", color: "white", position: "0,7" },
                    { piece: "knight", color: "white", position: "1,7" },
                    { piece: "bishop", color: "white", position: "2,7" },
                    { piece: "queen", color: "white", position: "3,7" },
                    { piece: "king", color: "white", position: "4,7" },
                    { piece: "bishop", color: "white", position: "5,7" },
                    { piece: "knight", color: "white", position: "6,7" },
                    { piece: "rook", color: "white", position: "7,7" },

                    { piece: "pawn", color: "black", position: "0,1" },
                    { piece: "pawn", color: "black", position: "1,1" },
                    { piece: "pawn", color: "black", position: "2,1" },
                    { piece: "pawn", color: "black", position: "3,1" },
                    { piece: "pawn", color: "black", position: "4,1" },
                    { piece: "pawn", color: "black", position: "5,1" },
                    { piece: "pawn", color: "black", position: "6,1" },
                    { piece: "pawn", color: "black", position: "7,1" },

                    { piece: "pawn", color: "white", position: "0,6" },
                    { piece: "pawn", color: "white", position: "1,6" },
                    { piece: "pawn", color: "white", position: "2,6" },
                    { piece: "pawn", color: "white", position: "3,6" },
                    { piece: "pawn", color: "white", position: "4,6" },
                    { piece: "pawn", color: "white", position: "5,6" },
                    { piece: "pawn", color: "white", position: "6,6" },
                    { piece: "pawn", color: "white", position: "7,6" }
                ]

                delegate: ChessPiece {
                    piece: modelData.piece
                    color: modelData.color
                    position: modelData.position
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
