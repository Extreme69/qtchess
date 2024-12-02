import QtQuick 2.15

Item {
    property string piece
    property string color
    property string position
    property bool selected: false

    property int posX: parseInt(position.split(",")[0])
    property int posY: parseInt(position.split(",")[1])

    width: parent.width / 8 // Dynamically scale with the chessboard grid
    height: parent.height / 8

    Rectangle {
        anchors.fill: parent
        color: selected ? "lightblue" : "transparent"

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
                    // Deselect the piece
                    selected = false;
                    window.selectedPiece = "";
                } else {
                    // Select this piece
                    selected = true;
                    window.selectedPiece = position;

                    // Deselect any previously selected piece
                    for (let i = 0; i < piecesModel.count; i++) {
                        if (piecesModel.get(i).position !== position) {
                            piecesModel.set(i, {
                                piece: piecesModel.get(i).piece,
                                color: piecesModel.get(i).color,
                                position: piecesModel.get(i).position,
                                selected: false // Explicitly set `selected` to false
                            });
                        }
                    }
                }

                // Update the selected state in the model
                const index = piecesModel.findIndex(piece => piece.position === position);
                if (index !== -1) {
                    piecesModel.set(index, {
                        piece: piecesModel.get(index).piece,
                        color: piecesModel.get(index).color,
                        position: piecesModel.get(index).position,
                        selected: selected // Update selected state explicitly
                    });
                }
            }
        }
    }
}
