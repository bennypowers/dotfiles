import QtQuick
import Quickshell.Io

Item {
    id: polkitSocketClient
    
    // Public API
    signal showAuthDialog(string actionId, string message, string iconName, string cookie)
    signal authorizationResult(bool authorized, string actionId)
    signal authorizationError(string error)
    signal connected()
    signal disconnected()
    signal passwordRequest(string actionId, string request, bool echo, string cookie)
    
    property bool isConnected: socket.connected
    
    property string socketPath: ""
    
    // Use native Socket component with proper configuration
    Socket {
        id: socket
        path: "/run/user/1000/quickshell-polkit/quickshell-polkit"
        connected: false
        
        onConnectedChanged: {
            console.log("Socket connected changed:", connected, "path:", path)
            if (connected) {
                console.log("✅ Connected to quickshell-polkit-agent via Socket")
                polkitSocketClient.connected()
                retryTimer.stop()
            } else {
                console.log("❌ Disconnected from quickshell-polkit-agent")
                polkitSocketClient.disconnected()
                if (!retryTimer.running) {
                    retryTimer.start()
                }
            }
        }
        
        onError: function(error) {
            console.log("❌ Socket error:", error, "path:", path)
            if (!retryTimer.running) {
                retryTimer.start()
            }
        }
        
        parser: SplitParser {
            onRead: function(data) {
                try {
                    console.log("📥 Raw data from polkit agent:", data)
                    var message = JSON.parse(data)
                    console.log("📥 Received from polkit agent:", JSON.stringify(message))
                    handleMessage(message)
                } catch (e) {
                    console.log("Invalid JSON from polkit agent:", e, "Raw:", data)
                }
            }
        }
        
        Component.onCompleted: {
            console.log("🔄 Socket component ready, path:", path)
            // Try to connect after a short delay
            retryTimer.start()
        }
    }
    
    Component.onCompleted: {
        socketPath = "/run/user/1000/quickshell-polkit/quickshell-polkit"
        console.log("🔄 PolkitSocketClient initialized with path:", socketPath)
    }
    
    // Retry connection timer
    Timer {
        id: retryTimer
        interval: 2000
        running: false
        repeat: false
        
        onTriggered: {
            console.log("🔄 Retrying connection to polkit agent...")
            socket.connected = false
            // Small delay before reconnecting
            Qt.callLater(function() {
                socket.connected = true
            })
        }
    }
    
    function handleMessage(message) {
        switch (message.type) {
        case "show_auth_dialog":
            polkitSocketClient.showAuthDialog(
                message.action_id,
                message.message,
                message.icon_name,
                message.cookie
            )
            break
            
        case "authorization_result":
            polkitSocketClient.authorizationResult(
                message.authorized,
                message.action_id
            )
            break
            
        case "authorization_error":
            polkitSocketClient.authorizationError(message.error)
            break
            
        case "password_request":
            polkitSocketClient.passwordRequest(
                message.action_id,
                message.request,
                message.echo,
                message.cookie
            )
            break
            
        default:
            console.log("Unknown message type from polkit agent:", message.type)
        }
    }
    
    // Submit authentication response
    function submitAuthentication(cookie, response) {
        if (!socket.connected) {
            console.log("❌ Not connected to polkit agent")
            return false
        }
        
        var message = {
            "type": "submit_authentication",
            "cookie": cookie,
            "response": response || ""
        }
        
        console.log("📤 Submitting authentication:", JSON.stringify(message))
        socket.write(JSON.stringify(message) + "\n")
        socket.flush()
        return true
    }
    
    function cancelAuthentication() {
        if (!socket.connected) return
        
        var message = {
            "type": "cancel_authorization"
        }
        
        console.log("📤 Cancelling authentication:", JSON.stringify(message))
        socket.write(JSON.stringify(message) + "\n")
        socket.flush()
    }
}