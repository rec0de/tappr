import QtQuick 2.0
import Sailfish.Silica 1.0
import "../data.js" as DB
import "../hash.js" as CR
import "../key.js" as Key




CoverBackground {

    Component.onCompleted: {
        // Initialize the database
        DB.initialize();
    }



    function refresh(){
        if(Qt.application.active){
            var oldscore = coverscore.text;
            coverscore.text = DB.getscore();

            if(tocheck == true){
                rank.text = getrank();
                tocheck = false;
            }

            // Upload 'old' highscore when uploading preference changes
            if(rank.text == 'off'){
                if(DB.getval(4) != 0){
                    rank.text = getrank();
                }
            }

            if(oldscore != coverscore.text){
                tocheck = true;
            }
        }
    }

    function forcerefresh(){
        rank.text = getrank();
    }

    function isNumber(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function load(url) {
        var xhr = new XMLHttpRequest();
        xhr.timeout = 1000;
        var output;

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log('status', xhr.status, xhr.statusText)
                console.log('response', xhr.responseText)
                if(xhr.status >= 200 && xhr.status < 300) {

                    var text = xhr.responseText;

                    //Escaping content fetched from web to prevent script injections
                    var patt1 = /(<|>|\{|\}|\[|\]|\\)/g;
                    text = text.replace(patt1, '');

                    rank.value = text;
                }
                else {
                    rank.value = DB.getval(2);
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

    function getrank(){
        var enable = DB.getval(4);

        if(enable != 0){
            var key = Key.get();
            var uid = DB.getval(3);
            var score = coverscore.text;

            if(uid == '0' || isNumber(uid) == false|| uid == '-1'){
                load('https://cdown.pf-control.de/tappr/getid.php');
                DB.setval(rank.value, 3);
                uid = rank.value;
            }

            var hash = CR.sha256(key + score + uid);

            load('https://cdown.pf-control.de/tappr/rank.php?id='+uid+'&sc='+score+'&h='+hash);
            var rankval = rank.value;
            DB.setval(rankval, 2);
            return rankval;
            }
        else{
            return 'off';
        }
    }

    Timer {
        id: updater
        interval: 2000
        running: true
        repeat: true
        onTriggered: refresh()
    }

    Image {
           source: "../img/cover.png"
           opacity: 0.1
           width: parent.width
           height: sourceSize.height * width / sourceSize.width
           y: height / 3
           x: - width / 2.5
       }

    Label {
        id: covertitle
        font.pixelSize: Theme.fontSizeLarge
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        text: "tappr"
    }

    Column{
        anchors.centerIn: parent    

        Label {
            id: debug
            font.pixelSize: Theme.fontSizeSmall
            anchors.horizontalCenter: parent.horizontalCenter
            text: 'highscore'
        }

        Label {
            id: coverscore
            font.pixelSize: Theme.fontSizeExtraLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: DB.getscore()
        }

        Label {
            font.pixelSize: Theme.fontSizeSmall
            anchors.horizontalCenter: parent.horizontalCenter
            text: 'rank'
        }

        Label {
            id: rank
            font.pixelSize: Theme.fontSizeExtraLarge
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            text: getrank();
            property string value: ""
        }

        CoverActionList {
            id: coverAction

            CoverAction {
                iconSource: "image://theme/icon-cover-refresh"
                onTriggered: {
                    forcerefresh()
                }
            }

        }

    }



}


