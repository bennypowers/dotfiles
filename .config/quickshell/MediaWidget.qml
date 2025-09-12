import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Mpris

Rectangle {
    id: mediaWidget

    property string mediaIcon: {
        if (!player)
            return "";

        switch (player.playbackState) {
        case "Playing":
            return " ";
        case "Paused":
            return " ";
        default:
            return " ";
        }
    }
    property MprisPlayer player: Mpris.players[0]

    color: "transparent"
    height: visible ? 40 : 0
    radius: 8
    visible: Mpris.players.length > 0

    Colors {
        id: colors

    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            if (player) {
                player.playPause();
            }
        }
        onEntered: {
            parent.color = colors.surface;
        }
        onExited: {
            parent.color = "transparent";
        }
        onWheel: function (wheel) {
            if (player) {
                if (wheel.angleDelta.y > 0) {
                    player.next();
                } else {
                    player.previous();
                }
            }
        }
    }
    Column {
        anchors.centerIn: parent
        spacing: 2
        width: parent.width - 8

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.text
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.smallIconSize
            text: mediaWidget.mediaIcon
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.subtext
            elide: Text.ElideRight
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: colors.smallTextSize
            horizontalAlignment: Text.AlignHCenter
            text: {
                if (!player)
                    return "";
                const title = player.title || "";
                const artist = player.artist || "";
                if (title && artist) {
                    return (artist + " - " + title).length > 15 ? (artist + " - " + title).substring(0, 12) + "..." : artist + " - " + title;
                }
                return title || artist || "Unknown";
            }
            width: parent.width
        }
    }
    ToolTip {
        text: player ? `${player.artist || "Unknown"} - ${player.title || "Unknown"}\n${player.album || ""}` : ""
        visible: parent.hovered && player
    }
}
