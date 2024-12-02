import QtQuick 2.15

Item {
    property real boardWidth: 0
    property real boardHeight: 0

    // Add letters (A-H) along the top and bottom
    Repeater {
        model: 8
        Rectangle {
            width: parent.boardWidth / 8
            height: 30
            color: "transparent"
            x: index * (parent.boardWidth / 8)
            y: -30

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
            height: parent.boardHeight / 8
            color: "transparent"
            x: -30
            y: index * (parent.boardHeight / 8)

            Text {
                anchors.centerIn: parent
                text: (8 - index).toString() // Numbers 1 to 8
                font.bold: true
                font.pixelSize: 18
            }
        }
    }
}
