import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#0A0A1A"

    Image {
        id: background
        source: "background.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: 0.3
    }

    Rectangle {
        id: loginPanel
        width: 400
        height: 350
        anchors.centerIn: parent
        color: "#1A1A3A"
        radius: 12
        opacity: 0.95

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Image {
                id: logo
                source: "logo.png"
                Layout.alignment: Qt.AlignHCenter
                width: 64
                height: 64
            }

            Text {
                id: title
                text: "Firmus Linux"
                font.pixelSize: 24
                font.bold: true
                color: "#00FFFF"
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                id: usernameField
                placeholderText: "Username"
                Layout.fillWidth: true
                color: "#FFFFFF"
                background: Rectangle {
                    color: "#2A2A4A"
                    radius: 6
                }
            }

            TextField {
                id: passwordField
                placeholderText: "Password"
                echoMode: TextInput.Password
                Layout.fillWidth: true
                color: "#FFFFFF"
                background: Rectangle {
                    color: "#2A2A4A"
                    radius: 6
                }
            }

            Button {
                id: loginButton
                text: "Log In"
                Layout.fillWidth: true
                onClicked: sddm.login(usernameField.text, passwordField.text)

                background: Rectangle {
                    color: "#00FFFF"
                    radius: 6
                }

                contentItem: Text {
                    text: parent.text
                    color: "#0A0A1A"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    Text {
        id: clock
        anchors {
            bottom: parent.bottom
            bottomMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        color: "#FFFFFF"
        font.pixelSize: 14
        font.family: "DejaVu Sans Mono"

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = new Date().toLocaleString(Qt.locale(), "yyyy-MM-dd hh:mm:ss")
        }
    }
}
