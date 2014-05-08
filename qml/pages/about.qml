import QtQuick 2.0
import Sailfish.Silica 1.0
import '../data.js' as DB

Page {
    id: page

    Component.onCompleted: {
        // Initialize the database
        DB.initialize();
        update(ranking, 4);
        update(ambience, 6);
        update(sound, 7);
        getsong();
        // Load stats (if server stats are enabled [see database id 4])
        load('https://cdown.pf-control.de/tappr/stats.php?m=plain');
    }

    function update(object, dbid) {
        var state = DB.getval(dbid);

        if(state != 0){
            object.checked = true;
        }
        else{
            object.checked = false;
        }
    }

    function toggle(oid, dbid){
        var state = DB.getval(dbid);

        if(state != 0){
            DB.setval(0, dbid);
            update(oid, dbid);
        }
        else{
            DB.setval(1, dbid);
            update(oid, dbid);
        }
    }

    function getsong(){
        var song = DB.getval(9);
        if(song == '1'){
            songmenu.currentIndex = 1;
        }
        else {
            songmenu.currentIndex = 0;
        }
        songmenu.previous = song;
    }

    function updatesong(){
        if(songmenu.currentIndex != songmenu.previous){
            var state = songmenu.currentIndex;

            if(state == 1){
                DB.setval(1, 9);
            }
            else{
                DB.setval(0, 9);
            }
            songmenu.previous = state;
        }
    }

    function load(url) {
        if(DB.getval(4) != '0'){

            var xhr = new XMLHttpRequest();
            xhr.timeout = 1000;
            var output;

            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if(xhr.status >= 200 && xhr.status < 300) {

                        var text = xhr.responseText;

                        //Escaping content fetched from web to prevent script injections
                        var patt1 = /(<|>|\{|\}|\[|\]|\\)/g;
                        text = text.replace(patt1, '');

                        var dataarray = text.split('|')

                        number.text = '# of Players: ' + dataarray[0];
                        avg.text = 'Avg. score: ' + dataarray[1];
                        max.text = 'Max. score: ' + dataarray[2];
                        number.visible = true;
                        max.visible = true;
                        avg.visible = true;
                    }
                    else {
                        number.text = 'Error';
                        number.visible = true;
                        max.visible = false;
                        avg.visible = false;
                    }
                }
        }

        xhr.ontimeout = function() {
            message.visible = true;
            message.text = 'Error: Request timed out.<br>';
        }

        xhr.open('GET', url, true);
        xhr.setRequestHeader("User-Agent", "Mozilla/5.0 (compatible; tappr app for SailfishOS)");
        xhr.send();
      }
      else {
          number.text = 'Disabled';
          number.visible = true;
          max.visible = false;
          avg.visible = false;
      }
    }

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
                title: "About & Settings"
            }

            SectionHeader {
                text: "Stats"
            }

            Label {
                id: number
                text: "# of Players: ..."
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: avg
                text: "Avg. score: ..."
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: max
                text: "Max. score: ..."
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
               anchors.horizontalCenter: parent.horizontalCenter
               text: "Refresh stats"
               onClicked: load('https://cdown.pf-control.de/tappr/stats.php?m=plain');
            }

            SectionHeader {
                text: "Settings"
            }

            TextSwitch {
                id: ranking
                automaticCheck: false
                text: "Upload highscore"
                description: "Needed for ranking & stats"
                onClicked: {
                    toggle(ranking, 4)
                }
            }

            TextSwitch {
                id: ambience
                automaticCheck: false
                text: "Ambience Mode"
                onClicked: {
                    toggle(ambience, 6)
                }
            }

            TextSwitch {
                id: sound
                automaticCheck: false
                text: "Fancy sound"
                onClicked: {
                    toggle(sound, 7)
                }
            }
            ComboBox {
                id: songmenu
                label: "Song:"

                menu: ContextMenu {
                    MenuItem { text: "Ode to Joy" }
                    MenuItem { text: "Own composition #1" }
                }
                property int previous: 0
            }

            // Checks for changes in songmenu every second (i cant find an onchanged event for combobox...)
            Timer {
                id: songupdater
                interval: 1000
                running: true
                repeat: true
                onTriggered: updatesong()
            }


            RemorseItem {
                id: remorse
                onTriggered: DB.setscore(0)
            }


            Button {
               id: reset
               anchors.horizontalCenter: parent.horizontalCenter
               text: "Reset Highscore"
               onClicked: remorse.execute(reset, "Reset Highscore")
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
