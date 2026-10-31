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
       \brief The rails in the view.
     */
    default property list<Item> rails

    model: ObjectModel {
        id: railModel
    }

    orientation: ListView.Vertical
    spacing: Kirigami.Units.gridUnit * 2
    topMargin: Kirigami.Units.gridUnit * 2
    keyNavigationEnabled: true
    clip: true

    // HACK: delay as toggling the layer deletes its effect at once (see EdgeFadeEffect)
    Binding on layer.enabled {
        value: root.contentHeight > root.height
        delayed: true
    }
    layer.effect: EdgeFadeEffect {
        topFadeLength: root.topMargin
    }
    cacheBuffer: Math.max(height * 4, 0)

    highlightFollowsCurrentItem: false

    onCurrentItemChanged: scrollToCurrent()

    function scrollToCurrent(): void {
        if (!currentItem) {
            return;
        }
        const minimum = originY - topMargin;
        const maximum = Math.max(minimum, originY + contentHeight + bottomMargin - height);
        scrollAnimation.to = Math.max(minimum, Math.min(maximum, currentItem.y - topMargin));
        scrollAnimation.restart();
    }

    NumberAnimation {
        id: scrollAnimation
        target: root
        property: "contentY"
        duration: Kirigami.Units.veryLongDuration
        easing.type: Easing.BezierSpline
        easing.bezierCurve: [0.2, 0, 0, 1, 1, 1]
    }

    onCountChanged: updateRails()
    onRailsChanged: __updateShownRails()
    Component.onCompleted: __updateShownRails()

    function __updateShownRails(): void {
        const current = currentItem;
        let currentRow = 0;
        railModel.clear();

        // HACK: needed to ensure ListView doesn't explode them out of existence when going up/down
        forceLayout();

        // Puts the rails with items in the view and keeping the current one
        for (const rail of rails) {
            if (rail.count === 0) {
                rail.parent = hiddenRails;
                continue;
            }
            if (rail === current) {
                currentRow = railModel.count;
            }
            railModel.append(rail);
        }
        currentIndex = currentRow;
    }

    // Holds the rails left out
    Item {
        id: hiddenRails
        visible: false
    }

    Instantiator {
        model: root.rails
        delegate: Connections {
            required property Item modelData
            target: modelData
            ignoreUnknownSignals: true
            function onCountChanged(): void {
                Qt.callLater(root.__updateShownRails);
            }
        }
    }

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
}
