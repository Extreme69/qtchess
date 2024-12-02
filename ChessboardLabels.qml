import QtQuick 2.15

Item {
    // Dynamically calculate the font size based on the smaller dimension of the chessboard
    property real fontSize: Math.min(chessBoard.width, chessBoard.height) / 35

    // Repeater to create letters (A-H) along the top and bottom
    Repeater {
        model: 8
        Rectangle {
            width: chessBoard.width / 8
            height: fontSize * 2
            color: "transparent"
            x: index * (chessBoard.width / 8)
            y: -fontSize * 2  // Position letters above the chessboard

            Text {
                anchors.centerIn: parent
                text: String.fromCharCode(65 + index)  // Letters A to H
                font.bold: true
                font.pixelSize: fontSize  // Apply dynamic font size
            }
        }
    }

    // Repeater to create numbers (1-8) along the left and right
    Repeater {
        model: 8
        Rectangle {
            width: fontSize * 2
            height: chessBoard.height / 8
            color: "transparent"
            x: -fontSize * 2  // Position numbers on the left
            y: index * (chessBoard.height / 8)

            Text {
                anchors.centerIn: parent
                text: (8 - index).toString()  // Numbers 1 to 8
                font.bold: true
                font.pixelSize: fontSize  // Apply dynamic font size
            }
        }
    }
}
