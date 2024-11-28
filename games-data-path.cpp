#include "games-data-path.hpp"


GamesDataPath::GamesDataPath(QObject *parent) : QObject(parent)
{

}

QString GamesDataPath::path() const
{
    return m_path;
}

void GamesDataPath::setPath(QString path)
{
    m_path = std::move(path);
}
