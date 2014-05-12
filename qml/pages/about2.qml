import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        height: parent.height
        contentHeight: col.height + 10
        id: flick

        VerticalScrollDecorator{}

        Column {
            id: col
            width: parent.width
            anchors.margins: Theme.paddingLarge
            spacing: Theme.paddingMedium

            PageHeader {
                title: "About"
            }

            SectionHeader {
                text: "License"
            }

            Label {
                text: "GPL v2"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    id : licenseMouseArea
                    anchors.fill : parent
                    onClicked: Qt.openUrlExternally("http://choosealicense.com/licenses/gpl-v2/")
                }
            }

            SectionHeader {
                text: "Made by"
            }

            Label {
                text: "@rec0denet"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    id : madebyMouseArea
                    anchors.fill : parent
                    onClicked: Qt.openUrlExternally("http://rec0de.net")
                }
            }

            SectionHeader {
                text: "Source"
            }

            Label {
                text: "github.com/rec0de/tappr"
                font.underline: true;
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    id : sourceMouseArea
                    anchors.fill : parent
                    onClicked: Qt.openUrlExternally("https://github.com/rec0de/tappr")
                }
            }


            SectionHeader {
                text: "Contact"
            }

            Label {
                text: "mail@rec0de.net <br> GnuPG available"
                anchors.horizontalCenter: parent.horizontalCenter
                MouseArea {
                    id : contactMouseArea
                    anchors.fill : parent
                    onClicked: Qt.openUrlExternally("mailto:mail@rec0de.net")
                }
            }

            SectionHeader {
                text: "Support me?"
            }

            Button {
                text: "Tip me (BTC/DOGE)"
               onClicked: Qt.openUrlExternally("http://rec0de.net/a/tip.php")
               anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                text: "About me"
            }

            Label {
                id: aboutme
                text:   'I develop these apps as a hobby. Therefore, please don\'t expect them to work perfect. If you like what I\'m doing, consider liking / commenting the app or following me on twitter. For a developer, knowing that people out there use & like your app is one of the greatest feelings ever.'
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
            }

            SectionHeader {
                text: "Thanks"
            }

            Label {
                id: body
                text: 'SHA256 implementation by webtoolkit.info<br>Music made with pulseboy.com<br>Font by astramat.com<br>Database derived from \'noto\' by leszek. Thanks to all of you!'
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.paddingMedium
                    rightMargin: Theme.paddingMedium
                }
            }
        }
    }

}
