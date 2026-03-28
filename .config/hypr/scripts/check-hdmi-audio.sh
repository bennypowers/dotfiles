#!/bin/bash
# Returns 0 (inhibit) if any audio stream is playing to the HDMI sink.
# Used by hypridle to skip power-off-monitors when the monitor's speakers
# are in use (since DPMS off kills HDMI audio).

HDMI_SINK="alsa_output.pci-0000_c3_00.1.hdmi-stereo"

# Get the sink's index by name
sink_index=$(pactl list sinks short | awk -v name="$HDMI_SINK" '$2 == name { print $1 }')

if [[ -z "$sink_index" ]]; then
    # Sink not found (monitor disconnected?), allow power off
    exit 1
fi

# Check if any sink-input is routed to this sink
if pactl list sink-inputs short | awk -v idx="$sink_index" '$2 == idx' | grep -q .; then
    exit 0  # audio playing to HDMI, inhibit power off
fi

exit 1
