import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: turnDisplayContainer

    // Current player to display on the turn indicator
    property string currentPlayer: ""

    width: parent.width * 0.15
    height: parent.height * 0.05
    border.color: "black"
    border.width: 2
    anchors.topMargin: 20
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    // Text displaying the current turn information
    Text {
        id: turnDisplay
        anchors.centerIn: parent
        text: currentPlayer === "white" ? "White's Turn" : "Black's Turn"
        font.bold: true
        font.pixelSize: parent.width * 0.1
        padding: 10
    }
}
