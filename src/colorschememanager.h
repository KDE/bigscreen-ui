/*
    SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#pragma once

#include <QAbstractItemModel>
#include <QObject>
#include <QQmlEngine>
#include <qqmlregistration.h>

/*!
   \qmltype ColorSchemeManager
   \inqmlmodule org.kde.bigscreen.ui

   \brief The color schemes the app can use, and the one it is using.

   Changing the scheme applies it to the whole app and is remembered across restarts.
 */
class ColorSchemeManager : public QObject
{
    Q_OBJECT

    /*!
       \qmlproperty QAbstractItemModel ColorSchemeManager::model
       \brief The model with all color schemes.
       \sa KColorSchemeManager::model
    */
    Q_PROPERTY(QAbstractItemModel *model READ model CONSTANT FINAL)

    /*!
       \qmlproperty int ColorSchemeManager::currentIndex
       \brief The index of the active color scheme.
    */
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged FINAL)
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit ColorSchemeManager(QObject *parent = nullptr);

    QAbstractItemModel *model() const;

    int currentIndex() const;
    void setCurrentIndex(int index);

Q_SIGNALS:
    void currentIndexChanged();
    void defaultSchemeIdChanged();

private:
    void applyDefaultScheme();

    QString m_defaultSchemeId = QStringLiteral("BreezeDark");
};
