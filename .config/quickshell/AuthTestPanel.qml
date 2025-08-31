import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Window {
    id: testPanel
    
    // Reference to main components (set from parent)
    property var polkitAuth: null
    property var lockScreen: null
    property var polkitInterceptor: null
    
    // Window properties
    visible: false
    width: 300
    height: 200
    title: "Auth Test Panel"
    x: 100
    y: 100
    
    // IPC functions for test panel control
    function toggleTestMode() {
        testPanel.visible = !testPanel.visible
    }
    
    function showTestPanel() {
        testPanel.visible = true
    }
    
    function hideTestPanel() {
        testPanel.visible = false
    }
        
        Colors { id: colors }
    
    Rectangle {
        anchors.fill: parent
        color: colors.base
        border.color: colors.blue
        border.width: 1
        radius: colors.borderRadius
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: colors.spacing * 2
            
            Text {
                text: "Auth System Test"
                color: colors.text
                font.family: colors.fontFamily
                font.pixelSize: colors.textSize
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            Button {
                text: "Test Polkit Auth"
                Layout.fillWidth: true
                
                background: Rectangle {
                    color: parent.pressed ? colors.sapphire : colors.blue
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                    implicitHeight: 32
                }
                
                contentItem: Text {
                    text: parent.text
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    console.log("Testing polkit authentication dialog")
                    if (testPanel.polkitAuth) {
                        testPanel.polkitAuth.startAuthentication(
                            "org.example.test",
                            "Test polkit authentication dialog"
                        )
                    }
                }
            }
            
            Button {
                text: "Test Lock Screen"
                Layout.fillWidth: true
                
                background: Rectangle {
                    color: parent.pressed ? colors.green : colors.sapphire
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                    implicitHeight: 32
                }
                
                contentItem: Text {
                    text: parent.text
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    console.log("Testing lock screen")
                    if (testPanel.lockScreen) {
                        testPanel.lockScreen.show()
                    }
                }
            }
            
            Button {
                text: "Test Interceptor"
                Layout.fillWidth: true
                
                background: Rectangle {
                    color: parent.pressed ? colors.mauve : colors.lavender
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                    implicitHeight: 32
                }
                
                contentItem: Text {
                    text: parent.text
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    console.log("Testing polkit interceptor")
                    if (testPanel.polkitInterceptor) {
                        testPanel.polkitInterceptor.triggerTestAuth()
                    }
                }
            }
            
            Button {
                text: "Enable Polkit Intercept"
                Layout.fillWidth: true
                
                background: Rectangle {
                    color: parent.pressed ? colors.yellow : colors.peach
                    opacity: parent.pressed ? 0.8 : 1.0
                    radius: colors.borderRadius
                    implicitHeight: 32
                }
                
                contentItem: Text {
                    text: parent.text
                    color: colors.crust
                    font.family: colors.fontFamily
                    font.pixelSize: colors.smallTextSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    console.log("Enabling polkit intercept via UI")
                    if (testPanel.polkitInterceptor) {
                        testPanel.polkitInterceptor.enableInterceptMode()
                    }
                }
            }
            
            Text {
                text: "Use these buttons to test\nthe authentication system"
                color: colors.subtext
                font.family: colors.fontFamily
                font.pixelSize: 10
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
                Layout.topMargin: colors.spacing * 2
            }
            
            Item {
                Layout.fillHeight: true
            }
        }
    }
}