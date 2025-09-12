import QtQuick

Item {
    id: root

    // Signal to communicate action triggers back to parent
    signal actionRequested(int actionIndex)

    height: 40
    width: 200

    Colors {
        id: colors

    }
    Row {
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: [
                {
                    icon: "󰍃",
                    color: colors.yellow
                },
                {
                    icon: "󰐥",
                    color: colors.blue
                },
                {
                    icon: "󰜉",
                    color: colors.peach
                },
                {
                    icon: "󰤂",
                    color: colors.red
                }
            ]

            Rectangle {
                color: "transparent"
                height: colors.iconSize + 8
                radius: 4
                width: colors.iconSize + 8

                Text {
                    anchors.centerIn: parent
                    color: modelData.color
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: colors.iconSize
                    text: modelData.icon
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        root.actionRequested(index);
                    }
                    onEntered: {
                        parent.color = colors.overlay;
                    }
                    onExited: {
                        parent.color = "transparent";
                    }
                }
            }
        }
    }
}
