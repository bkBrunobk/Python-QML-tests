import QtQuick 6.6
import QtQuick.Controls 6.2
import QtQuick.Layouts

// Fenêtre principale
ApplicationWindow {
    //Propriétés héritées de Window
    visible: true

    height: 600
    width: 400
    minimumHeight : 550
    minimumWidth : 350
    maximumHeight : 650
    maximumWidth : 450

    color: "#B5BD00"
    title: "buttonControls"

    Column {
        Button {text: "mySimpleButton"}

        ColumnLayout {
            CheckBox {
                checked: true
                text: qsTr("First")
            }
            CheckBox {
                text: qsTr("Second")
            }
            CheckBox {
                checked: true
                text: qsTr("Third")
            }
        }

        DelayButton {text: "myDelayButton" ; delay: 3000}

        ColumnLayout {
            RadioButton {
                checked: true
                text: qsTr("First")
            }
            RadioButton {
                text: qsTr("Second")
            }
            RadioButton {
                text: qsTr("Third")
            }
        }

        RoundButton {text: "\u2713"} // Unicode Character 'CHECK MARK'

        Switch {
                text: qsTr("Switch")
                checked: Networking.wifiEnabled
                onClicked: Networking.wifiEnabled = checked
            }

        ComboBox {model: ["First", "Second", "Third"]}


    }
    
    
    
        

}

