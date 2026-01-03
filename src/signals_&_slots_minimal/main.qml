import QtQuick 2.15
import QtQuick.Controls 2.15

/*
  Application de démonstration : communication QML ↔ Python (PySide6)
  
  Illustre :
  - Appel asynchrone : QML → Python (slot) + retour via signal
  - Appel synchrone : QML → Python (slot) + retour immédiat
  - Notification asynchrone : Python → QML (signal)
  
  Bonnes pratiques :
  - Vérification de l'existence du backend
  - Validation des inputs avant envoi
  - Gestion défensive des signaux
  - Désactivation des boutons lors de saisie invalide
*/

ApplicationWindow {
    id: window
    width: 400
    height: 280
    visible: true
    title: qsTr("Signaux & Slots Qt - Communication QML ↔ Python")
    color: "#f0f0f0"

    Column {
        anchors.centerIn: parent
        anchors.margins: 16
        spacing: 12
        width: Math.min(parent.width - 32, 350)

        // Titre informatif
        Text {
            text: qsTr("Communication PySide6 / QML")
            font.bold: true
            font.pixelSize: 14
            color: "#333333"
        }

        // Champ pour saisir un message à envoyer vers Python
        Column {
            width: parent.width
            spacing: 4

            Text {
                text: qsTr("Entrez un message (max 500 chars) :")
                font.pixelSize: 11
                color: "#666666"
            }

            TextField {
                id: input
                placeholderText: qsTr("Message → Python")
                width: parent.width
                selectByMouse: true
                color: "#333333"
                
                // Feedback visuel si champ invalide
                background: Rectangle {
                    border.color: input.length > 500 ? "#ff6b6b" : (input.focus ? "#4c8dff" : "#cccccc")
                    border.width: 1
                    radius: 4
                    color: "#ffffff"
                }
            }

            // Compteur de caractères
            Text {
                text: qsTr("%1 / 500").arg(input.length)
                font.pixelSize: 10
                color: input.length > 500 ? "#ff6b6b" : "#999999"
                anchors.right: parent.right
            }
        }

        // Boutons tests
        Row {
            spacing: 8
            width: parent.width

            Button {
                id: sendBtn
                text: qsTr("Envoyer")
                enabled: input.length > 0 && input.length <= 500 && typeof backend !== 'undefined'
                
                onClicked: {
                    if (typeof backend !== 'undefined' && backend) {
                        backend.send_to_python(input.text)
                        input.text = ""
                        input.focus = false
                    }
                }
            }

            Button {
                id: requestBtn
                text: qsTr("Demander")
                enabled: typeof backend !== 'undefined'
                
                onClicked: {
                    if (typeof backend !== 'undefined' && backend) {
                        try {
                            var r = backend.request_from_python()
                            response.text = r || qsTr("(réponse vide)")
                        } catch (e) {
                            response.text = qsTr("Erreur : ") + e
                        }
                    }
                }
            }

            Button {
                id: pingBtn
                text: qsTr("Ping")
                enabled: typeof backend !== 'undefined'
                
                onClicked: {
                    if (typeof backend !== 'undefined' && backend) {
                        // Appel asynchrone : réponse via signal messageToQml
                        backend.ping()
                    }
                }
            }
        }

        // Zone d'état / logs
        Rectangle {
            width: parent.width
            height: 80
            color: "#fafafa"
            border.color: "#dddddd"
            border.width: 1
            radius: 4

            Flickable {
                anchors.fill: parent
                anchors.margins: 8
                contentHeight: response.height
                clip: true

                Text {
                    id: response
                    width: parent.width
                    text: qsTr("En attente de réponse...")
                    wrapMode: Text.WordWrap
                    color: "#333333"
                    font.pixelSize: 12
                }
            }
        }

        // Message informatif si backend non disponible
        Rectangle {
            width: parent.width
            height: backendWarning.height + 12
            color: typeof backend === 'undefined' ? "#fff3cd" : "transparent"
            border.color: typeof backend === 'undefined' ? "#ffc107" : "transparent"
            border.width: 1
            radius: 4
            visible: typeof backend === 'undefined'

            Text {
                id: backendWarning
                anchors.centerIn: parent
                text: qsTr("⚠ Backend Python non disponible")
                color: "#856404"
                font.pixelSize: 11
            }
        }
    }

    // Branchement sur le signal Python messageToQml
    Connections {
        target: typeof backend !== 'undefined' ? backend : null
        
        function onMessageToQml(msg) {
            // Validation défensive du paramètre
            var m = (typeof msg !== 'undefined' && msg !== null) ? String(msg) : qsTr("(sans contenu)")
            response.text = m
            // Feedback auditif optionnel : console.log("[QML] Signal reçu :", m)
        }
    }
}
