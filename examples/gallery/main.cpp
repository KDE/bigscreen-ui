// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        qputenv("QT_QUICK_CONTROLS_STYLE", "org.kde.desktop");
    }

    QGuiApplication application(argc, argv);
    application.setApplicationName(QStringLiteral("bigscreen-ui-demo"));
    application.setApplicationDisplayName(QStringLiteral("Bigscreen UI Gallery"));
    application.setOrganizationDomain(QStringLiteral("kde.org"));

    QQmlApplicationEngine engine;
    engine.loadFromModule("org.kde.bigscreen.ui.demo", "Main");

    if (engine.rootObjects().isEmpty()) {
        return 1;
    }

    return application.exec();
}
