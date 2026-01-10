import QtQuick 6.6
import QtQuick.Controls 6.2

// Fenêtre principale
ApplicationWindow {
    id: window
    visible: true
    width: 400
    height: 300
    title: "Fenêtre minimale PySide6 + QML"

    // Contenu simple
    Column {
        anchors.centerIn: parent

        Text {
            text: "Hello World !"
        }
    }
}
