// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

pragma Singleton

import QtQml

QtObject {
    readonly property var movies: [
        { title: "Konqi & Tux's Adventure", year: 2025, genres: "Sci-fi, Drama", runtime: "1h 52m", badges: ["4K HDR", "13+"], image: "qrc:/images/mountain.jpg",
          synopsis: "Konqi and Tux got sucked into a computer! Can they fight their way back to KDEValley?" },
        { title: "Krita: Paint the world", year: 2023, genres: "Family", runtime: "1h 58m", badges: ["4K", "16+"], image: "qrc:/images/safelanding.jpg",
          synopsis: "Kiki the cyber squirrel's discovery of a paintbrush illuminates the lives of all those around her." },
        { title: "Katie", year: 2024, genres: "Drama", runtime: "2h 04m", badges: ["4K", "12+"], image: "qrc:/images/scarlettree.jpg",
          synopsis: "Bugs have overwhelmed KDEValley's defenses. The entire town turns to the one dragon they can count on, Katie." },
        { title: "Agents", year: 2025, genres: "Thriller", runtime: "1h 47m", badges: ["4K HDR", "16+"], image: "qrc:/images/altai.jpg",
          synopsis: "A secret organization is trying to undermine KDEValley's autonomy." },
        { title: "This is tough", year: 2024, genres: "Documentary", runtime: "1h 31m", badges: ["4K", "All"], image: "qrc:/images/volna.jpg",
          synopsis: "Follow a group of hackers trying to build a new mobile operating system and platform." },
        { title: "Plasma", year: 2025, genres: "Animation, Family", runtime: "1h 26m", badges: ["4K HDR", "All"], image: "qrc:/images/patak.jpg",
          synopsis: "Discover what happens when one child finds a Fedora USB and boots it on the family computer for the first time." },
        { title: "Brainrot", year: 2023, genres: "Comedy, Romance", runtime: "1h 38m", badges: ["HD", "12+"], image: "qrc:/images/coast.jpg",
          synopsis: "Follow Devin's journey in trying to overcome his social media addiction, and try to touch some grass." }
    ]

    readonly property var albums: [
        { title: "Green Dragon", artist: "Konqi", image: "qrc:/images/milkyway.jpg" },
        { title: "Qt Inside", artist: "Katie", image: "qrc:/images/flow.jpg" },
        { title: "Acrylic", artist: "Kiki", image: "qrc:/images/honeywave.jpg" },
        { title: "Late night codin'", artist: "D.J. Tux", image: "qrc:/images/shell.jpg" },
        { title: "PROPRIETARY", artist: "CHONKI", image: "qrc:/images/konqi.png" }
    ]
}
