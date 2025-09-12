import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Window {
    id: testPanel

    property var lockScreen: null

    // Reference to main components (set from parent)
    property var polkitAuth: null
    property var polkitInterceptor: null

    function hideTestPanel() {
        testPanel.visible = false;
    }
    function showTestPanel() {
        testPanel.visible = true;
    }

    // IPC functions for test panel control
    function toggleTestMode() {
        testPanel.visible = !testPanel.visible;
    }

    height: 200
    title: "Auth Test Panel"

    // Window properties
    visible: false
    width: 300
    x: 100
    y: 100

    Colors {
        id: colors

    }
    Rectangle {
        anchors.fill: parent
        border.color: colors.blue
        border.width: 1
        color: colors.base
        radius: colors.borderRadius

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: colors.spacing * 2

            Text {
                Layout.alignment: Qt.AlignHCenter
                color: colors.text
                font.bold: true
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize
                text: "Auth System Test"
            }
            Button {
                Layout.fillWidth: true
                text: "Test Polkit Auth"

                background: Rectangle {
                    color: parent.pressed ? colors.sapphire : colors.blue
                    implicitHeight: 32
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                }
                contentItem: Text {
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    text: parent.text
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Testing polkit authentication dialog");
                    if (testPanel.polkitAuth) {
                        testPanel.polkitAuth.startAuthentication("org.example.test", "Test polkit authentication dialog");
                    }
                }
            }
            Button {
                Layout.fillWidth: true
                text: "Test Lock Screen"

                background: Rectangle {
                    color: parent.pressed ? colors.green : colors.sapphire
                    implicitHeight: 32
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                }
                contentItem: Text {
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    text: parent.text
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Testing lock screen");
                    if (testPanel.lockScreen) {
                        testPanel.lockScreen.show();
                    }
                }
            }
            Button {
                Layout.fillWidth: true
                text: "Test Interceptor"

                background: Rectangle {
                    color: parent.pressed ? colors.mauve : colors.lavender
                    implicitHeight: 32
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                }
                contentItem: Text {
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    text: parent.text
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Testing polkit interceptor");
                    if (testPanel.polkitInterceptor) {
                        testPanel.polkitInterceptor.triggerTestAuth();
                    }
                }
            }
            Button {
                Layout.fillWidth: true
                text: "Enable Polkit Intercept"

                background: Rectangle {
                    color: parent.pressed ? colors.yellow : colors.peach
                    implicitHeight: 32
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                }
                contentItem: Text {
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    text: parent.text
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Enabling polkit intercept via UI");
                    if (testPanel.polkitInterceptor) {
                        testPanel.polkitInterceptor.enableInterceptMode();
                    }
                }
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: colors.spacing * 2
                color: colors.subtext
                font.family: colors.fontFamily
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                text: "Use these buttons to test\nthe authentication system"
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }
}
