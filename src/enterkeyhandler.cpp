/*
    SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "enterkeyhandler.h"

#include <QDebug>
#include <QGuiApplication>
#include <QKeyEvent>
#include <QMetaMethod>
#include <QQuickItem>
#include <QStyleHints>

EnterKeyHandler::EnterKeyHandler(QObject *target)
    : QObject(target)
    , m_target(qobject_cast<QQuickItem *>(target))
{
    if (!m_target) {
        qWarning() << "EnterKeyHandler must be attached to an Item";
        return;
    }
    m_target->installEventFilter(this);

    m_holdTimer.setSingleShot(true);
    connect(&m_holdTimer, &QTimer::timeout, this, &EnterKeyHandler::hold);
}

bool EnterKeyHandler::enabled() const
{
    return m_enabled;
}

void EnterKeyHandler::setEnabled(bool enabled)
{
    if (m_enabled == enabled) {
        return;
    }

    m_enabled = enabled;
    if (!m_enabled) {
        cancel();
    }
    Q_EMIT enabledChanged();
}

EnterKeyHandler *EnterKeyHandler::qmlAttachedProperties(QObject *object)
{
    return new EnterKeyHandler(object);
}

bool EnterKeyHandler::eventFilter(QObject *watched, QEvent *event)
{
    if (!m_enabled || watched != m_target) {
        return false;
    }

    if (event->type() == QEvent::FocusOut) {
        cancel();
        return false;
    }

    if (event->type() != QEvent::KeyPress && event->type() != QEvent::KeyRelease) {
        return false;
    }

    auto keyEvent = static_cast<QKeyEvent *>(event);
    if (keyEvent->key() != Qt::Key_Return && keyEvent->key() != Qt::Key_Enter) {
        return false;
    }

    if (keyEvent->isAutoRepeat()) {
        return true;
    }

    if (event->type() == QEvent::KeyPress) {
        press();
        return true;
    }

    // A release without a press here started elsewhere, such as on the card a long press came from
    if (!m_pressed) {
        return false;
    }
    release();
    return true;
}

void EnterKeyHandler::press()
{
    m_pressed = true;
    m_held = false;
    m_target->setProperty("down", true);
    if (isPressAndHoldConnected()) {
        m_holdTimer.start(QGuiApplication::styleHints()->mousePressAndHoldInterval());
    }
}

void EnterKeyHandler::release()
{
    const bool held = m_held;
    cancel();
    if (!held) {
        QMetaObject::invokeMethod(m_target, "click");
    }
}

void EnterKeyHandler::cancel()
{
    m_holdTimer.stop();
    if (m_pressed) {
        m_pressed = false;
        // An invalid value resets it, back to following whether the mouse presses it
        m_target->setProperty("down", QVariant());
    }
}

void EnterKeyHandler::hold()
{
    m_held = true;
    QMetaObject::invokeMethod(m_target, "pressAndHold");
}

bool EnterKeyHandler::isPressAndHoldConnected() const
{
    // isSignalConnected() is protected, so reach it through a subclass
    struct Access : QObject {
        using QObject::isSignalConnected;
    };
    const int index = m_target->metaObject()->indexOfSignal("pressAndHold()");
    return index >= 0 && (m_target->*&Access::isSignalConnected)(m_target->metaObject()->method(index));
}
