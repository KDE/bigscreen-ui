// SPDX-FileCopyrightText: 2018 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.coreaddons as Core

/*!
   \brief A page with information about the app.
 */
ScrollablePage {
    id: root

    property var aboutData: Core.AboutData

    /*!
       \brief A link to a page on how to help with the app.
     */
    property url getInvolvedUrl: {
        const url = root.__aboutUrl(Core.AboutUrlType?.Contribute);
        if (url.length > 0) {
            return url;
        }
        return aboutData.desktopFileName.startsWith("org.kde.") ? "https://community.kde.org/Get_Involved" : "";
    }

    /*!
       \brief A link to a page for donating to the app.
     */
    property url donateUrl: {
        const url = root.__aboutUrl(Core.AboutUrlType?.Donation);
        if (url.length > 0) {
            return url;
        }
        return aboutData.desktopFileName.startsWith("org.kde.") ? "https://kde.org/donate" : "";
    }

    /*!
       \brief Whether to list the libraries the app uses.
     */
    property bool showLibraries: true

    function __aboutUrl(type: var): string {
        if (type === undefined || typeof aboutData.url !== "function") {
            return "";
        }
        return aboutData.url(type).toString();
    }

    function __openText(title: string, text: string): void {
        textDialog.title = title;
        textDialog.text = text;
        textDialog.open();
    }

    title: i18nd("bigscreen-ui", "About %1", aboutData.displayName)

    BackHandler.enabled: visible && (T.StackView.index ?? 0) > 0
    BackHandler.onActivated: T.StackView.view.pop()

    // Focus arriving on the page goes on to the first entry
    onActiveFocusChanged: {
        if (activeFocus && Window.activeFocusItem === root) {
            nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason);
        }
    }

    ColumnLayout {
        id: column
        spacing: Kirigami.Units.gridUnit * 2

        KeyNavigationGroup.orientation: Qt.Vertical

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.gridUnit * 1.5

            Kirigami.Icon {
                Layout.alignment: Qt.AlignTop
                implicitWidth: Kirigami.Units.iconSizes.enormous
                implicitHeight: Kirigami.Units.iconSizes.enormous
                source: root.aboutData.programLogo || Kirigami.Settings.applicationWindowIcon || root.aboutData.componentName
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                Label {
                    Layout.fillWidth: true
                    text: root.aboutData.displayName + " " + root.aboutData.version
                    type: Label.Section
                    wrapMode: Text.Wrap
                }
                Label {
                    Layout.fillWidth: true
                    visible: text.length > 0
                    text: root.aboutData.shortDescription
                    type: Label.Heading
                    wrapMode: Text.Wrap
                }
                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing
                    visible: text.length > 0
                    text: root.aboutData.copyrightStatement
                    textFormat: Text.PlainText
                    color: Kirigami.Theme.disabledTextColor
                    wrapMode: Text.Wrap
                }
                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing
                    visible: text.length > 0
                    text: root.aboutData.otherText
                    wrapMode: Text.Wrap
                }
            }
        }

        Section {
            title: i18ndp("bigscreen-ui", "License", "Licenses", root.aboutData.licenses.length)
            visible: root.aboutData.licenses.length > 0

            Repeater {
                model: root.aboutData.licenses
                delegate: ButtonDelegate {
                    required property var modelData
                    Layout.fillWidth: true
                    text: modelData.name
                    icon.name: "license"
                    onClicked: root.__openText(modelData.name, modelData.text)
                }
            }
        }

        Section {
            title: i18nd("bigscreen-ui", "Links")
            visible: links.count > 0

            Repeater {
                id: links

                model: [
                    { text: i18nd("bigscreen-ui", "Homepage"), icon: "globe", url: root.aboutData.homepage },
                    { text: i18nd("bigscreen-ui", "Report a Bug"), icon: "tools-report-bug", url: root.__bugUrl },
                    { text: i18nd("bigscreen-ui", "Source Code"), icon: "code-context", url: root.__aboutUrl(Core.AboutUrlType?.VCSBrowser) },
                    { text: i18nd("bigscreen-ui", "Get Involved"), icon: "applications-development", url: root.getInvolvedUrl.toString() },
                    { text: i18nd("bigscreen-ui", "Donate"), icon: "donate", url: root.donateUrl.toString().length > 0 ? root.donateUrl + "?app=" + root.aboutData.componentName : "" }
                ].filter(link => link.url.length > 0)

                delegate: ButtonDelegate {
                    required property var modelData
                    Layout.fillWidth: true
                    text: modelData.text
                    description: modelData.url
                    icon.name: modelData.icon
                    onClicked: Qt.openUrlExternally(modelData.url)
                }
            }
        }

        Section {
            title: i18nd("bigscreen-ui", "Libraries in Use")
            visible: root.showLibraries

            Repeater {
                model: root.showLibraries ? [...(root.aboutData.components ?? []), ...root.__platformComponents] : []
                delegate: ButtonDelegate {
                    id: library

                    required property var modelData
                    readonly property bool hasLicense: modelData.licenses.key !== 0

                    Layout.fillWidth: true
                    text: modelData.version.length > 0 ? modelData.name + " " + modelData.version : modelData.name
                    description: modelData.description
                    descriptionItem.wrapMode: Text.Wrap
                    trailing: Label {
                        visible: text.length > 0
                        text: library.hasLicense ? library.modelData.licenses.name : ""
                        color: Kirigami.Theme.disabledTextColor
                    }
                    onClicked: {
                        if (hasLicense) {
                            root.__openText(modelData.name, modelData.licenses.text);
                        }
                    }
                }
            }
        }

        PeopleSection {
            title: i18nd("bigscreen-ui", "Authors")
            people: root.aboutData.authors
        }

        PeopleSection {
            title: i18nd("bigscreen-ui", "Credits")
            people: root.aboutData.credits
        }

        PeopleSection {
            title: i18nd("bigscreen-ui", "Translators")
            people: root.aboutData.translators
        }
    }

    readonly property list<var> __platformComponents: {
        const pluginName = Qt.platform.pluginName;
        const windowing = pluginName === "wayland" ? "Wayland" : pluginName === "xcb" ? "X11" : "";
        const platform = windowing.length > 0
            ? i18ndc("bigscreen-ui", "@info Platform name", "%1 (%2)", Core.KOSRelease.prettyName, windowing)
            : Core.KOSRelease.prettyName;

        let packaging = i18ndc("bigscreen-ui", "Linux packaging format", "Unknown/Default");
        if (Core.Sandbox.type === Core.Sandbox.Flatpak) {
            packaging = i18ndc("bigscreen-ui", "Linux packaging format", "Flatpak");
        } else if (Core.Sandbox.type === Core.Sandbox.Snap) {
            packaging = i18ndc("bigscreen-ui", "Linux packaging format", "Snap");
        }

        const component = (name, description) => ({ name, description, version: "", webAddress: "", licenses: { key: 0, name: "", text: "" } });
        return [
            component(platform, i18ndc("bigscreen-ui", "@info", "Underlying platform.")),
            component(packaging, i18ndc("bigscreen-ui", "@info", "Distribution method."))
        ];
    }

    readonly property string __bugUrl: {
        if (aboutData.bugAddress !== "submit@bugs.kde.org") {
            return aboutData.bugAddress;
        }
        const product = aboutData.productName.split("/");
        let url = `https://bugs.kde.org/enter_bug.cgi?format=guided&product=${product[0]}&version=${aboutData.version}`;
        if (product.length === 2) {
            url += "&component=" + product[1];
        }
        return url;
    }

    AboutTextDialog {
        id: textDialog
    }

    component Section: ColumnLayout {
        id: section

        property string title
        default property alias content: body.data

        Layout.fillWidth: true
        spacing: Kirigami.Units.largeSpacing

        Label {
            Layout.fillWidth: true
            text: section.title
            type: Label.Section
        }

        ColumnLayout {
            id: body
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
        }
    }

    component PeopleSection: Section {
        id: peopleSection

        property var people: []

        visible: people.length > 0

        Repeater {
            model: peopleSection.people
            delegate: ButtonDelegate {
                required property var modelData
                readonly property string webAddress: modelData.webAddress ?? ""

                Layout.fillWidth: true
                text: modelData.name
                description: [modelData.task, modelData.emailAddress, webAddress].filter(part => part && part.length > 0).join("  ·  ")
                icon.name: "user"
                onClicked: {
                    if (webAddress.length > 0) {
                        Qt.openUrlExternally(webAddress);
                    }
                }
            }
        }
    }
}
