// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick
import QtQuick.Templates as T

import org.kde.kirigami as Kirigami
import org.kde.bigscreen.ui as BigscreenUI

// Opens the player over the whole window
BigscreenUI.Page {
    id: root

    function openPlayer(): void {
        T.ApplicationWindow.window.openPlayer();
    }

    BigscreenUI.PlaceholderMessage {
        anchors.centerIn: parent
        width: Math.min(parent.width - root.contentMargins.left - root.contentMargins.right, implicitWidth)
        focus: true

        iconName: "media-playback-start"
        text: "PlayerOverlay"
        explanation: "Playback controls over a video, with simulated playback. Open it over the whole window, then press back to close it."
        helpfulAction: Kirigami.Action {
            text: "Open player"
            icon.name: "media-playback-start"
            onTriggered: root.openPlayer()
        }
    }
}
