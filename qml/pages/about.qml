import QtQuick 2.0
import Sailfish.Silica 1.0
import '../data.js' as DB
import "../hash.js" as CR
import "../key.js" as Key


// Error codes
// -1 Authentification failed
// -2 Secret already sent
// -3 Connection timeout
// -4 Data upload disabled
// -5 Generic connection error
// -6 Invalid secret given

Page {
    id: page

    Component.onCompleted: {
        // Initialize the database
        DB.initialize();
        update(ranking, 4);
        update(ambience, 6);
        update(sound, 7);
        update(reverse, 10);
        getsong();
        // Load stats (if server stats are enabled [see database id 4])
        stats('https://cdown.pf-control.de/tappr/stats.php?m=plain');
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
        else if(song == '2'){
            songmenu.currentIndex = 2;
        }

        else {
            songmenu.currentIndex = 0;
        }
        songmenu.previous = song;
    }

    function updatesong(){
        if(!Qt.application.active){
            songupdater.running = false;
        }
        if(songmenu.currentIndex != songmenu.previous){
            var state = songmenu.currentIndex;

            if(state == 1){
                DB.setval(1, 9);
            }
            else if(state == 2){
                DB.setval(2, 9);
            }

            else{
                DB.setval(0, 9);
            }
            songmenu.previous = state;
        }
    }

    // Commented out because not ready for release

   /* function getnick(){
        var nick = DB.getstring(1);
        if(nick.length < 3){
            nick = 'User #'+DB.getval(3);
            DB.setval(nick, 1, 'strings');
        }
        return nick;
    }

    function changeuser(){
        errormsg.visible = false;
        var oldnick = DB.getstring(1);
        if(oldnick != nicktext.text){
            var newnick = nicktext.text.replace(/[^a-z0-9]/gi,'');
            DB.setval(newnick, 1, 'strings');


            // Upload nickname

            // Get secret if not in DB
            if(DB.getstring(2) == '-1'){
                load('https://cdown.pf-control.de/tappr/getsecret.php?id=' + DB.getval(3) + '&h=' + CR.sha256(Key.get() + DB.getval(3)));
                var secret = debug.text;
                if(secret.length == 20){
                    secret = secret.replace(/[^a-z0-9]/gi,'');
                    DB.setval(secret, 2, 'strings');
                }
                else{
                    errormsg.visible = true;
                    if(secret == '-4'){
                        errormsg.text = 'Error: Data upload disabled';
                    }
                    else{
                        errormsg.text = 'Error: '+secret;
                    }
                    return;
                }
            }
            // Create signed message
            var nicksecret = DB.getstring(2);
            var nickkey = Key.get();
            var nickid = DB.getval(3);
            var nickmsg = '?h='+CR.sha256(newnick + nickkey + nickid)+'&n='+newnick+'&s='+nicksecret+'&i='+nickid;

        }
    }
*/

    function stats(url) {
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
            xhr.open('GET', url, true);
            xhr.setRequestHeader("User-Agent", "Mozilla/5.0 (compatible; tappr app for SailfishOS)");
            xhr.send();
      }
      else{
            number.text = 'Disabled';
            number.visible = true;
            max.visible = false;
            avg.visible = false;
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

                                debug.text = text;
                            }
                            else {
                                debug.text = '-5';
                            }
                        }
                }


        xhr.ontimeout = function() {
            debug.text = '-3';
        }

        xhr.open('GET', url, true);
        xhr.setRequestHeader("User-Agent", "Mozilla/5.0 (compatible; tappr app for SailfishOS)");
        xhr.send();
      }
      else {                   
             debug.text = '-4';
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
                title: "Info"
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
               onClicked: stats('https://cdown.pf-control.de/tappr/stats.php?m=plain');
            }
            /*
            SectionHeader {
                text: "Nickname"
            }

            TextField {
                id: nicktext
                placeholderText: getnick()
                width: parent.width
                EnterKey.enabled: text.length > 2
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: changeuser()
                validator: RegExpValidator { regExp: /[a-z0-9]*$/gi }
                property string response: ''
            }

            Label {
                id: errormsg
                text: ""
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: debug
                visible: true
                text: "..."
                anchors.horizontalCenter: parent.horizontalCenter
            } */

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
                id: reverse
                automaticCheck: false
                text: "Reverse tile flow"
                description: "Ends your running round"
                onClicked: {
                    toggle(reverse,10)
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
                    MenuItem { text: "Spring - Four seasons" }
                }
                property int previous: 0
                onClicked: songupdater.running = true
            }

            // Checks for changes in songmenu every second (i cant find an onchanged event for combobox...)
            Timer {
                id: songupdater
                interval: 1000
                running: false
                repeat: true
                onTriggered: updatesong()
            }


             RemorsePopup {
                 id: remorse
                 onTriggered: DB.setscore(0)
             }


            Button {
               id: reset
               anchors.horizontalCenter: parent.horizontalCenter
               text: "Reset Highscore"
               onClicked: remorse.execute("Reset Highscore")
            }

            Button {
               id: about
               anchors.horizontalCenter: parent.horizontalCenter
               text: "About Tappr"
               onClicked: pageStack.push(Qt.resolvedUrl("about2.qml"))
            }

        }
    }

}
