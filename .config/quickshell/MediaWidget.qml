import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Mpris

Rectangle {
    id: mediaWidget
    height: visible ? 40 : 0
    color: "transparent"
    radius: 8
    visible: Mpris.players.length > 0

    property MprisPlayer player: Mpris.players[0]
    
    Colors {
        id: colors
    }
    property string mediaIcon: {
        if (!player) return ""

        switch (player.playbackState) {
            case "Playing": return " "
            case "Paused": return " "
            default: return " "
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (player) {
                player.playPause()
            }
        }
        onWheel: function(wheel) {
            if (player) {
                if (wheel.angleDelta.y > 0) {
                    player.next()
                } else {
                    player.previous()
                }
            }
        }
        hoverEnabled: true

        onEntered: {
            parent.color = colors.surface
        }

        onExited: {
            parent.color = "transparent"
        }
    }

    Column {
        anchors.centerIn: parent
        width: parent.width - 8
        spacing: 2

        Text {
            text: mediaWidget.mediaIcon
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.smallIconSize
            color: colors.text
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: {
                if (!player) return ""
                const title = player.title || ""
                const artist = player.artist || ""
                if (title && artist) {
                    return (artist + " - " + title).length > 15 ? 
                           (artist + " - " + title).substring(0, 12) + "..." :
                           artist + " - " + title
                }
                return title || artist || "Unknown"
            }
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.smallTextSize
            color: colors.subtext
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }

    ToolTip {
        visible: parent.hovered && player
        text: player ? `${player.artist || "Unknown"} - ${player.title || "Unknown"}\n${player.album || ""}` : ""
    }
}
