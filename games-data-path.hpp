#pragma once

#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>


class GamesDataPath : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString path READ path WRITE setPath FINAL)

public:

    GamesDataPath(QObject *parent = nullptr);

    QString path() const;
    void setPath(QString path);

private:

    QString m_path;
};
