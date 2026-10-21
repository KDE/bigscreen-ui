/*
    SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "colorschememanager.h"

#include <KColorSchemeManager>
#include <KConfigGroup>
#include <KSharedConfig>

#include <QDebug>

using namespace Qt::StringLiterals;

static bool isPlasma()
{
    const QList<QByteArray> desktops = qgetenv("XDG_CURRENT_DESKTOP").split(':');
    return desktops.contains("KDE");
}

static KConfigGroup settingsGroup()
{
    return KSharedConfig::openConfig()->group(u"UiSettings"_s);
}

ColorSchemeManager::ColorSchemeManager(QObject *parent)
    : QObject(parent)
{
    applyDefaultScheme();
}

QAbstractItemModel *ColorSchemeManager::model() const
{
    return KColorSchemeManager::instance()->model();
}

int ColorSchemeManager::currentIndex() const
{
    auto manager = KColorSchemeManager::instance();
    return manager->indexForSchemeId(manager->activeSchemeId()).row();
}

void ColorSchemeManager::setCurrentIndex(int index)
{
    if (index == currentIndex()) {
        return;
    }
    auto manager = KColorSchemeManager::instance();
    manager->activateScheme(manager->model()->index(index, 0));

    if (!m_defaultSchemeId.isEmpty() && !isPlasma() && manager->activeSchemeId().isEmpty()) {
        auto group = settingsGroup();
        group.writeEntry("ColorScheme", u""_s);
        group.sync();
    }
    Q_EMIT currentIndexChanged();
}

void ColorSchemeManager::applyDefaultScheme()
{
    if (settingsGroup().hasKey("ColorScheme")) {
        KColorSchemeManager::instance();
        return;
    }
    if (isPlasma()) {
        return;
    }

    auto manager = KColorSchemeManager::instance();
    const QModelIndex index = manager->indexForSchemeId(m_defaultSchemeId);
    if (!index.isValid()) {
        qWarning() << "No color scheme with id" << m_defaultSchemeId;
        return;
    }

    // Applying the default isn't the user's choice so don't save it
    manager->setAutosaveChanges(false);
    manager->activateScheme(index);
    manager->setAutosaveChanges(true);
    Q_EMIT currentIndexChanged();
}
