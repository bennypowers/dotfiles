import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: audioIndicator

    property var defaultSink: Pipewire.defaultAudioSink
    property var defaultSource: Pipewire.defaultAudioSource
    property bool isMuted: defaultSink && defaultSink.ready && defaultSink.audio ? defaultSink.audio.muted : false
    property bool isMicMuted: defaultSource && defaultSource.ready && defaultSource.audio ? defaultSource.audio.muted : false
    property real currentVolume: defaultSink && defaultSink.ready && defaultSink.audio && !isNaN(defaultSink.audio.volume) ? defaultSink.audio.volume : 0.5
    property bool shouldDisplay: true  // Audio indicator always shown

    property string volumeIcon: {
        if (isMuted) return "󰝟"
        if (currentVolume > 0.7) return "󰕾"
        if (currentVolume > 0.3) return "󰖀"
        if (currentVolume > 0) return "󰕿"
        return "󰝟"
    }
}
