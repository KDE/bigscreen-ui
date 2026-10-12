// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Window
import QtQml.Models

import org.kde.kirigami as Kirigami

/*!
   \brief A vertical stack of ContentRails.

   \code
   BigscreenUI.RailView {
       BigscreenUI.ContentRail { title: i18n("Continue watching") ... }
       BigscreenUI.ContentRail { title: i18n("Recently added") ... }
   }
   \endcode
 */
ListView {
    id: root

    /*!
       \qmlproperty list<Item> rails
       \brief The rails shown in the view.
     */
    default property alias rails: railModel.children

    /*!
       \brief Whether rails above the current rail are faded out.
       \default true
     */
    property bool fadeRailsAbove: true

    model: ObjectModel {
        id: railModel
    }

    orientation: ListView.Vertical
    spacing: Kirigami.Units.gridUnit * 2
    topMargin: Kirigami.Units.gridUnit * 2
    keyNavigationEnabled: true
    clip: true
    layer.enabled: scrollAnimation.running
    layer.effect: EdgeFadeEffect {
        topFadeLength: root.topMargin
    }
    cacheBuffer: Math.max(height * 4, 0)

    highlightFollowsCurrentItem: false

    // Scroll the current rail to the top of the view, below the top margin
    onCurrentItemChanged: scrollToCurrent()

    function scrollToCurrent(): void {
        if (!currentItem) {
            return;
        }
        scrollAnimation.to = currentItem.y - topMargin;
        scrollAnimation.restart();
    }

    NumberAnimation {
        id: scrollAnimation
        target: root
        property: "contentY"
        duration: Kirigami.Units.longDuration * 1.5
        easing.type: Easing.OutCubic
    }

    onCurrentIndexChanged: updateFade()
    onFadeRailsAboveChanged: updateFade()
    onCountChanged: updateRails()
    Component.onCompleted: updateRails()

    // Make the rail holding the focused item current when focus arrives by mouse or touch
    Connections {
        target: root.Window.window
        function onActiveFocusItemChanged() {
            for (let item = root.Window.activeFocusItem; item; item = item.parent) {
                for (let i = 0; i < railModel.count; ++i) {
                    if (railModel.get(i) === item) {
                        root.currentIndex = i;
                        return;
                    }
                }
            }
        }
    }

    function updateRails(): void {
        for (let i = 0; i < railModel.count; ++i) {
            railModel.get(i).width = Qt.binding(() => root.width);
        }
        updateSafeArea();
        updateFade();
    }

    SafeArea.onMarginsChanged: updateSafeArea()

    // Pass the safearea props to children
    function updateSafeArea(): void {
        for (let i = 0; i < railModel.count; ++i) {
            const rail = railModel.get(i);
            rail.SafeArea.additionalMargins.left = root.SafeArea.margins.left;
            rail.SafeArea.additionalMargins.right = root.SafeArea.margins.right;
        }
    }

    function updateFade(): void {
        for (let i = 0; i < railModel.count; ++i) {
            railModel.get(i).opacity = (fadeRailsAbove && i < currentIndex) ? 0 : 1;
        }
    }
}
