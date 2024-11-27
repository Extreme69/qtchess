import QtQuick 2.15

Item {
    property string piece
    property string color
    property string position

    // Parse the position string (e.g., "0,0") into separate x and y coordinates
    property int posX: parseInt(position.split(",")[0])
    property int posY: parseInt(position.split(",")[1])

    Rectangle {
        width: 100 // Adjust as per your board size
        height: 100
        color: "transparent"
        x: posX * width
        y: posY * height

        // Display piece image
        Image {
            source: "qrc:/pieces/images/" + piece + "_" + color + ".png"
            anchors.centerIn: parent
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: parent

            // Disable dragging if it's not the current player's piece
            enabled: color === window.currentPlayer

            onReleased: {
                // Calculate nearest grid coordinates based on mouse release position
                var gridWidth = parent.width;
                var gridHeight = parent.height;

                // Calculate the closest x and y grid indices
                var newX = Math.floor((parent.x + gridWidth / 2) / gridWidth);
                var newY = Math.floor((parent.y + gridHeight / 2) / gridHeight);

                // Update piece position on the board
                position = newX + "," + newY;
                parent.x = newX * gridWidth; // Snap to nearest x
                parent.y = newY * gridHeight; // Snap to nearest y

                // Switch turn after move
                window.currentPlayer = (window.currentPlayer === "white") ? "black" : "white";
            }

            onPressed: {
                // Store initial position before drag starts
                position = { x: Math.floor(parent.x / (parent.width)),
                            y: Math.floor(parent.y / (parent.height)) };
            }

            drag.axis: Drag.XandY
        }
    }
}
