import QtQuick

Column {
    id: powerSection

    spacing: 8

    Colors {
        id: colors
    }

    // Reuse the existing PowerOverlay component for actions
    PowerOverlay {
        id: powerOverlay
    }

    // Power actions using the existing PowerActionsRow component
    PowerActionsRow {
        actions: powerOverlay.actions
        iconSize: 48
        itemSpacing: 8

        onActionTriggered: function (index, action) {
            action.action()
        }
    }
}
