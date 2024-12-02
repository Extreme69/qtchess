import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: turnDisplayContainer

    property string currentPlayer: ""

    width: parent.width * 0.15
    height: parent.height * 0.05
    border.color: "black"
    border.width: 2
    anchors.topMargin: 20
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    Text {
        id: turnDisplay
        anchors.centerIn: parent
        text: currentPlayer === "white" ? "White's Turn" : "Black's Turn"
        font.bold: true
        font.pixelSize: 24
        padding: 10
    }
}
