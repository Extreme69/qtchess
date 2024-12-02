import QtQuick 2.15

Item {
    property string piece
    property string color
    property string position

    width: parent.width / 8 // Dynamically scale with the chessboard grid
    height: parent.height / 8

    Rectangle {
        anchors.fill: parent
        color: (window.selectedPiece === position) ? "lightblue" : "transparent"

        Image {
            source: "qrc:/pieces/images/" + piece + "_" + color + ".png"
            anchors.centerIn: parent
            width: parent.width * 0.8
            height: parent.height * 0.8
        }

        MouseArea {
            id: selectArea
            anchors.fill: parent
            onClicked: {
                if (window.selectedPiece === position) {
                    // Deselect the piece if clicked again
                    window.selectedPiece = "";
                } else {
                    // Select this piece
                    window.selectedPiece = position;
                }
            }
        }
    }
}

