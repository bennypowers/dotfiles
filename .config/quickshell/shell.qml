//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.DBusMenu

ShellRoot {
    // Global font configuration
    readonly property string defaultFontFamily: "JetBrainsMono Nerd Font"
    readonly property int defaultFontSize: 12
    readonly property int smallFontSize: 8
    readonly property int largeFontSize: 14

    // Global margin configuration
    readonly property int panelTopMargin: 24
    readonly property int panelBottomMargin: 24
    readonly property int panelLeftMargin: 22
    readonly property int panelRightMargin: 16

    // Volume OSD
    VolumeOSD {}

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                left: true
                top: true
                bottom: true
            }

            implicitWidth: 64
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: panelTopMargin
                anchors.bottomMargin: panelBottomMargin
                anchors.leftMargin: panelLeftMargin
                anchors.rightMargin: panelRightMargin

                // CPU widget
                CpuWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 60
                    Layout.leftMargin: 6
                    Layout.alignment: Qt.AlignCenter
                }

                // Workspace switcher (minimap style) at top
                WorkspaceIndicator {
                    Layout.preferredWidth: parent.width
                }

                // Spacer to center clock
                Item {
                    Layout.fillHeight: true
                }

                // Clock (centered)
                ClockWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 60
                }

                // Spacer to push bottom widgets down
                Item {
                    Layout.fillHeight: true
                }

                // System tray
                SystemTrayWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 120
                }

                // Workmode widget (vm/WM) at very bottom
                WorkmodeWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 40
                }

                // Network widget at bottom
                NetworkWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 40
                }

                // Volume widget at bottom
                VolumeWidget {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: 60
                }

            }
        }
    }
}
