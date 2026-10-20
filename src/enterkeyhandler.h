/*
    SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#pragma once

#include <QObject>
#include <QPointer>
#include <QQmlEngine>
#include <QTimer>
#include <qqmlregistration.h>

class QQuickItem;

/*!
   \brief Attached property that makes the Enter key work like a mouse button on a button when selected.

   Pressing Enter while the button is selected clicks the button. Holding Enter emits the pressAndHold() event
   on the button. Key-repeat (while holding down) is disabled.

   \code
   T.Button {
       BigscreenUI.EnterKeyHandler.enabled: true
   }
   \endcode
 */
class EnterKeyHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged FINAL)
    QML_ELEMENT
    QML_UNCREATABLE("Attached property only")
    QML_ATTACHED(EnterKeyHandler)

public:
    explicit EnterKeyHandler(QObject *target);

    bool enabled() const;
    void setEnabled(bool enabled);

    static EnterKeyHandler *qmlAttachedProperties(QObject *object);

Q_SIGNALS:
    void enabledChanged();

protected:
    bool eventFilter(QObject *watched, QEvent *event) override;

private:
    void press();
    void release();
    void cancel();
    void hold();
    bool isPressAndHoldConnected() const;

    QPointer<QQuickItem> m_target;
    QTimer m_holdTimer;
    bool m_enabled = true;
    bool m_pressed = false;
    bool m_held = false;
};

QML_DECLARE_TYPEINFO(EnterKeyHandler, QML_HAS_ATTACHED_PROPERTIES)
