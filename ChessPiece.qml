import QtQuick 2.15

Item {
    property string piece
    property string color
    property string position
    property bool selected: false // Track if this piece is selected

    property int posX: parseInt(position.split(",")[0])
    property int posY: parseInt(position.split(",")[1])

    Rectangle {
        width: 100
        height: 100
        color: selected ? "lightblue" : "transparent" // Highlight selected piece
        x: posX * width
        y: posY * height

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
                if (window.selectedPiece === "") {
                    // Select the piece if no piece is selected
                    window.selectedPiece = position;
                } else {
                    // If a piece is selected, move it to the clicked position
                    if (window.selectedPiece === position) {
                        // Deselect the piece if the same piece is clicked again
                        window.selectedPiece = "";
                    } else {
                        // Update the selected piece's position
                        var selectedPieceIndex = piecesModel.findIndex(piece => piece.position === window.selectedPiece);
                        if (selectedPieceIndex !== -1) {
                            // Update position in the model
                            piecesModel.get(selectedPieceIndex).position = position;
                        }
                        // Switch turn after move
                        window.currentPlayer = (window.currentPlayer === "white") ? "black" : "white";
                        // Deselect after move
                        window.selectedPiece = "";
                    }
                }
            }
        }
    }
}
