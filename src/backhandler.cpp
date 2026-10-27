/*
    SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

#include "backhandler.h"

#include <QEvent>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QQuickItem>
#include <QQuickWindow>
#include <QTimer>
#include <QVariant>

// Dispatcher installed per window, tracking handlers up the item hierarchy
class BackHandlerDispatcher : public QObject
{
    Q_OBJECT

public:
    explicit BackHandlerDispatcher(QQuickWindow *window)
        : QObject(window)
        , m_window(window)
    {
        m_window->installEventFilter(this);
    }

    static BackHandlerDispatcher *get(QQuickWindow *window, bool create)
    {
        auto dispatcher = window->findChild<BackHandlerDispatcher *>(QString(), Qt::FindDirectChildrenOnly);
        if (!dispatcher && create) {
            dispatcher = new BackHandlerDispatcher(window);
        }
        return dispatcher;
    }

    void add(BackHandler *handler)
    {
        if (!m_handlers.contains(handler)) {
            m_handlers.append(handler);
        }
    }

    void remove(BackHandler *handler)
    {
        m_handlers.removeAll(handler);
    }

protected:
    bool eventFilter(QObject *watched, QEvent *event) override
    {
        if (watched != m_window) {
            return false;
        }

        bool isAutoRepeat = false;
        bool emitActivated = true;

        switch (event->type()) {
        case QEvent::KeyPress: {
            auto keyEvent = static_cast<QKeyEvent *>(event);
            if (keyEvent->key() != Qt::Key_Escape && keyEvent->key() != Qt::Key_Back) {
                return false;
            }
            isAutoRepeat = keyEvent->isAutoRepeat();
            break;
        }
        case QEvent::MouseButtonPress:
        case QEvent::MouseButtonRelease:
            if (static_cast<QMouseEvent *>(event)->button() != Qt::BackButton) {
                return false;
            }
            emitActivated = event->type() == QEvent::MouseButtonRelease;
            break;
        default:
            return false;
        }

        if (!m_window->isActive()) {
            return false;
        }

        const QList<QPointer<BackHandler>> handlers = handlersForFocusItem();

        for (const auto &handler : handlers) {
            if (!handler || !handler->isActive()) {
                continue;
            }
            // Don't propagate back button from autorepeat further
            if (emitActivated && !isAutoRepeat) {
                Q_EMIT handler->activated();
            }
            if (handler && handler->accepted()) {
                event->accept();
                return true;
            }
        }
        return false;
    }

private:
    QList<QPointer<BackHandler>> handlersForFocusItem()
    {
        m_handlers.removeAll(nullptr);

        QList<QPointer<BackHandler>> result;
        for (QQuickItem *item = m_window->activeFocusItem(); item; item = item->parentItem()) {
            for (const auto &handler : std::as_const(m_handlers)) {
                if (handler->isActive() && handler->targetItem() == item) {
                    result.append(handler);
                }
            }
        }
        return result;
    }

    QQuickWindow *m_window;
    QList<QPointer<BackHandler>> m_handlers;
};

BackHandler::BackHandler(QObject *target)
    : QObject(target)
    , m_target(target)
{
    if (m_target) {
        const int visibleChangedIndex = m_target->metaObject()->indexOfSignal("visibleChanged()");
        if (visibleChangedIndex >= 0) {
            QMetaObject::connect(m_target, visibleChangedIndex, this, metaObject()->indexOfSlot("updateWindow()"));
        }
    }

    QTimer::singleShot(0, this, &BackHandler::updateWindow);
}

BackHandler::~BackHandler()
{
    if (m_window) {
        if (auto dispatcher = BackHandlerDispatcher::get(m_window, false)) {
            dispatcher->remove(this);
        }
    }
}

bool BackHandler::enabled() const
{
    return m_enabled;
}

void BackHandler::setEnabled(bool enabled)
{
    if (m_enabled == enabled) {
        return;
    }

    m_enabled = enabled;
    Q_EMIT enabledChanged();
}

bool BackHandler::accepted() const
{
    return m_accepted;
}

void BackHandler::setAccepted(bool accepted)
{
    if (m_accepted == accepted) {
        return;
    }

    m_accepted = accepted;
    Q_EMIT acceptedChanged();
}

BackHandler *BackHandler::qmlAttachedProperties(QObject *object)
{
    return new BackHandler(object);
}

void BackHandler::updateWindow()
{
    auto item = targetItem();
    if (m_targetItem != item) {
        disconnect(m_targetItemWindowChangedConnection);
        m_targetItem = item;

        if (m_targetItem) {
            m_targetItemWindowChangedConnection = connect(m_targetItem, &QQuickItem::windowChanged, this, &BackHandler::updateWindow);
        }
    }

    auto window = targetWindow();
    if (m_window == window) {
        return;
    }

    if (m_window) {
        if (auto dispatcher = BackHandlerDispatcher::get(m_window, false)) {
            dispatcher->remove(this);
        }
    }

    m_window = window;

    if (m_window) {
        BackHandlerDispatcher::get(m_window, true)->add(this);
    }
}

bool BackHandler::isActive() const
{
    if (!m_enabled || !m_target) {
        return false;
    }

    const QVariant visibleProperty = m_target->property("visible");
    return !visibleProperty.isValid() || visibleProperty.toBool();
}

QQuickItem *BackHandler::targetItem() const
{
    if (!m_target) {
        return nullptr;
    }

    if (auto item = qobject_cast<QQuickItem *>(m_target)) {
        return item;
    }

    if (auto window = qobject_cast<QQuickWindow *>(m_target)) {
        return window->contentItem();
    }

    const QVariant contentItemProperty = m_target->property("contentItem");
    auto contentItem = qobject_cast<QQuickItem *>(contentItemProperty.value<QObject *>());

    // QQuickPopup is not a QQuickItem
    if (contentItem && m_target->inherits("QQuickPopup") && contentItem->parentItem()) {
        return contentItem->parentItem();
    }
    return contentItem;
}

QQuickWindow *BackHandler::targetWindow() const
{
    if (!m_target) {
        return nullptr;
    }

    if (auto window = qobject_cast<QQuickWindow *>(m_target)) {
        return window;
    }

    if (auto item = targetItem()) {
        return item->window();
    }

    const QVariant windowProperty = m_target->property("window");
    return qobject_cast<QQuickWindow *>(windowProperty.value<QObject *>());
}

#include "backhandler.moc"
#include "moc_backhandler.cpp"
