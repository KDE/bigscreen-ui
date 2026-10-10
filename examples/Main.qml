// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

Kirigami.ApplicationWindow {
    id: root

    width: 1100
    height: 720
    minimumWidth: 720
    minimumHeight: 540
    visible: true
    title: qsTr("Bigscreen UI Components")

    property string lastAction: qsTr("Use Tab, arrow keys, Enter, and Escape to explore the controls.")

    pageStack.initialPage: BigscreenUI.ScrollablePage {
        id: page

        title: qsTr("Bigscreen UI Components")

        ColumnLayout {
            width: page.availableWidth
            spacing: Kirigami.Units.largeSpacing

            QQC2.Label {
                Layout.fillWidth: true
                text: qsTr("Controls designed for television and remote-control interfaces")
                font.pixelSize: BigscreenUI.Units.headingFontPixelSize
                wrapMode: Text.Wrap
            }

            QQC2.Label {
                Layout.fillWidth: true
                text: root.lastAction
                color: Kirigami.Theme.disabledTextColor
                wrapMode: Text.Wrap
            }

            GridLayout {
                Layout.fillWidth: true
                columns: root.width >= 900 ? 2 : 1
                columnSpacing: Kirigami.Units.gridUnit
                rowSpacing: Kirigami.Units.largeSpacing

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Heading {
                        text: qsTr("Buttons and fields")
                        level: 2
                    }

                    BigscreenUI.Button {
                        id: primaryButton
                        Layout.fillWidth: true
                        text: qsTr("Primary button")
                        icon.name: "media-playback-start"
                        Component.onCompleted: forceActiveFocus()
                        onClicked: root.lastAction = qsTr("Primary button activated")
                    }

                    BigscreenUI.TextField {
                        Layout.fillWidth: true
                        placeholderText: qsTr("Bigscreen text field")
                        onTextEdited: root.lastAction = qsTr("Text field changed to “%1”").arg(text)
                    }

                    BigscreenUI.ButtonDelegate {
                        Layout.fillWidth: true
                        text: qsTr("Button delegate")
                        description: qsTr("A delegate with secondary text and leading/trailing items")
                        icon.name: "applications-graphics"
                        trailing: Kirigami.Icon {
                            source: "go-next"
                            implicitWidth: Kirigami.Units.iconSizes.medium
                            implicitHeight: Kirigami.Units.iconSizes.medium
                        }
                        onClicked: root.lastAction = qsTr("Button delegate activated")
                    }

                    BigscreenUI.SwitchDelegate {
                        Layout.fillWidth: true
                        text: qsTr("Switch delegate")
                        description: checked ? qsTr("Enabled") : qsTr("Disabled")
                        icon.name: "preferences-system"
                        onToggled: root.lastAction = checked
                            ? qsTr("Switch enabled")
                            : qsTr("Switch disabled")
                    }

                    BigscreenUI.ComboBoxDelegate {
                        Layout.fillWidth: true
                        text: qsTr("Combo box delegate")
                        icon.name: "view-list-details"
                        model: [qsTr("Small"), qsTr("Medium"), qsTr("Large")]
                        currentIndex: 1
                        onActivated: index => root.lastAction = qsTr("Selected %1").arg(model[index])
                    }

                    BigscreenUI.TextDelegate {
                        Layout.fillWidth: true
                        text: qsTr("Text delegate")
                        description: qsTr("Informational content without focus")
                        icon.name: "dialog-information"
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Heading {
                        text: qsTr("Overlays and building blocks")
                        level: 2
                    }

                    BigscreenUI.Button {
                        Layout.fillWidth: true
                        text: qsTr("Open dialog")
                        icon.name: "window-new"
                        onClicked: demoDialog.open()
                    }

                    BigscreenUI.Button {
                        Layout.fillWidth: true
                        text: qsTr("Open sidebar")
                        icon.name: "sidebar-show"
                        onClicked: demoSidebar.open()
                    }

                    QQC2.Control {
                        id: backgroundPreview

                        Layout.fillWidth: true
                        implicitHeight: Kirigami.Units.gridUnit * 4
                        focusPolicy: Qt.StrongFocus
                        hoverEnabled: true

                        contentItem: QQC2.Label {
                            text: qsTr("DelegateBackground (focus me)")
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: BigscreenUI.DelegateBackground {
                            control: backgroundPreview
                            alternateBackgroundColor: true
                        }

                        TapHandler {
                            onTapped: {
                                backgroundPreview.forceActiveFocus()
                                root.lastAction = qsTr("Custom background focused")
                            }
                        }
                    }

                    Kirigami.Heading {
                        Layout.topMargin: Kirigami.Units.largeSpacing
                        text: qsTr("Item delegates")
                        level: 3
                    }

                    ListView {
                        id: abstractList

                        Layout.fillWidth: true
                        implicitHeight: contentHeight
                        spacing: Kirigami.Units.smallSpacing
                        model: [qsTr("Movies"), qsTr("Music"), qsTr("Games")]
                        currentIndex: 0
                        keyNavigationEnabled: true

                        delegate: BigscreenUI.ItemDelegate {
                            id: itemDelegate

                            required property int index
                            required property string modelData

                            width: ListView.view.width
                            text: itemDelegate.modelData
                            contentItem: QQC2.Label {
                                text: itemDelegate.modelData
                                font.pixelSize: BigscreenUI.Units.defaultFontPixelSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: root.lastAction = qsTr("%1 delegate activated").arg(itemDelegate.modelData)
                        }
                    }
                }
            }
        }
    }

    BigscreenUI.Dialog {
        id: demoDialog

        title: qsTr("Bigscreen dialog")
        standardButtons: QQC2.Dialog.Ok | QQC2.Dialog.Cancel

        contentItem: ColumnLayout {
            spacing: Kirigami.Units.largeSpacing

            QQC2.Label {
                Layout.fillWidth: true
                text: qsTr("Dialog and DialogButtonBox are shown together here.")
                wrapMode: Text.Wrap
            }

            BigscreenUI.TextField {
                id: dialogField
                Layout.fillWidth: true
                placeholderText: qsTr("Enter a value")
            }
        }

        openFocusItem: dialogField
        onAccepted: root.lastAction = qsTr("Dialog accepted with “%1”").arg(dialogField.text)
        onRejected: root.lastAction = qsTr("Dialog cancelled")
    }

    BigscreenUI.SidebarOverlay {
        id: demoSidebar

        header: BigscreenUI.SidebarOverlayHeader {
            title: qsTr("Sidebar overlay")
            subtitle: qsTr("Press Escape or the back mouse button to close")
            iconSource: "view-right-close"
        }

        content: ColumnLayout {
            spacing: Kirigami.Units.smallSpacing

            BigscreenUI.ButtonDelegate {
                id: sidebarFirstButton
                Layout.fillWidth: true
                text: qsTr("First action")
                icon.name: "favorite"
                onClicked: {
                    root.lastAction = qsTr("First sidebar action activated")
                    demoSidebar.close()
                }
            }

            BigscreenUI.SwitchDelegate {
                Layout.fillWidth: true
                text: qsTr("Sidebar setting")
                description: qsTr("An interactive setting inside the overlay")
            }

            Item {
                Layout.fillHeight: true
            }
        }

        openFocusItem: sidebarFirstButton
    }
}
