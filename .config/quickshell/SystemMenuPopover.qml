import QtQuick

BasePopover {
    id: popover

    property int panelRightMargin: 22
    property int rightPanelWidth: 80
    property int screenWidth: 0
    property int sectionSpacing: 12
    property int topPanelHeight: 48

    anchorSide: "right"
    cornerPositions: ["topLeft", "bottomRight"]
    namespace: "quickshell-system-menu"

    Column {
        id: contentColumn

        spacing: sectionSpacing
        width: parent.width

        // Volume Section
        SystemMenuVolumeSection {
            id: volumeSection

            width: parent.width
        }

        // Quick Settings (replaces individual Network, Language, Workmode sections)
        SystemMenuQuickSettings {
            id: quickSettings

            width: parent.width
        }

        // Power Section
        SystemMenuPowerSection {
            id: powerSection

            width: parent.width
        }
    }
}
