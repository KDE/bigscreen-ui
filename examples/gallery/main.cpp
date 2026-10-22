// SPDX-FileCopyrightText: 2026 Devin Lin <devin@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <KAboutData>
#include <KLocalizedQmlContext>

int main(int argc, char *argv[])
{
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        qputenv("QT_QUICK_CONTROLS_STYLE", "org.kde.desktop");
    }

    QGuiApplication application(argc, argv);
    application.setApplicationName(QStringLiteral("bigscreen-ui-demo"));
    application.setApplicationDisplayName(QStringLiteral("Bigscreen UI Gallery"));
    application.setOrganizationDomain(QStringLiteral("kde.org"));

    KAboutData about(QStringLiteral("bigscreen-ui-demo"),
                     QStringLiteral("Bigscreen UI Gallery"),
                     QStringLiteral("1.0"),
                     QStringLiteral("The components of the Bigscreen UI library"),
                     KAboutLicense::LGPL_V2,
                     QStringLiteral("© 2026 Devin Lin"));
    about.addAuthor(QStringLiteral("Devin Lin"), QStringLiteral("Maintainer"), QStringLiteral("devin@kde.org"));
    about.setHomepage(QStringLiteral("https://invent.kde.org/libraries/bigscreen-ui"));
    about.setDesktopFileName(QStringLiteral("org.kde.bigscreen-ui-demo"));
    KAboutData::setApplicationData(about);

    QQmlApplicationEngine engine;
    KLocalization::setupLocalizedContext(&engine);
    engine.loadFromModule("org.kde.bigscreen.ui.demo", "Main");

    if (engine.rootObjects().isEmpty()) {
        return 1;
    }

    return application.exec();
}
