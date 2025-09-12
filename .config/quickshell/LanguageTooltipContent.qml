import QtQuick

Item {
    id: root

    property string currentLayout: ""

    // Properties passed from parent
    property var languages: []

    // Signal to communicate language selection back to parent
    signal languageRequested(string layoutKey)

    height: languageRow.height + 16
    width: languageRow.width + 16

    Colors {
        id: colors

    }
    Row {
        id: languageRow

        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: root.languages

            Rectangle {
                property bool isCurrent: modelData.glyph === root.currentLayout

                color: "transparent"
                height: colors.iconSize + 8
                radius: 4
                width: colors.iconSize + 8

                Text {
                    anchors.centerIn: parent
                    color: parent.isCurrent ? colors.text : colors.overlay
                    font.bold: true
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: colors.iconSize
                    opacity: parent.isCurrent ? 1.0 : 0.7
                    text: modelData.glyph

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        root.languageRequested(modelData.layoutKey);
                    }
                    onEntered: {
                        if (!parent.isCurrent) {
                            parent.color = colors.surface;
                        }
                    }
                    onExited: {
                        parent.color = "transparent";
                    }
                }
            }
        }
    }
}
