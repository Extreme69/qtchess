import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: turnDisplayContainer

    // Property to store the current player, either "white" or "black"
    property string currentPlayer: ""

    width: parent.width * 0.15
    height: parent.height * 0.05
    border.color: "black"
    border.width: 2

    // Text element to display the current player's turn (either "White's Turn" or "Black's Turn")
    Text {
        id: turnDisplay
        anchors.centerIn: parent
        text: currentPlayer === "white" ? "White's Turn" : "Black's Turn"
        font.bold: true
        font.pixelSize: parent.width * 0.1
        padding: 10
    }
}
