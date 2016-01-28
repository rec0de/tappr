import QtQuick 2.0
import QtQuick.Window 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import "../data.js" as DB

Page {
    id: page

    Component.onCompleted: {
        // Initialize the database
        DB.initialize();

        if(DB.getval(8) < '5'){
            DB.setval('5', 8);
            DB.setval('1', 6); // Activate ambience once
        }
        if(DB.getval(8) < '6'){
            DB.setval('6', 8);
            DB.setval('1', 10); // Enable reverse mode
        }

        if(DB.getval(10) == '1'){
            score.oldreverse = true;
        }

        // Load settings from DB
        updatesettings();

    }

    FontLoader { id: pixels; source: "../img/pixelmix.ttf" }

    // Makes the start text blink
    function blink() {
        if(start.visible){
             start.visible = false;
        }
        else {
             start.visible = true;
        }
    }

    // Pause game and go to about page
    function about() {
        pageStack.push(Qt.resolvedUrl("about.qml"))
        pause();
    }

    function pause() {
        ticker.running = false;
        blinker.running = false;
        updatesett.running = false;
        start.visible = true;
        start.text = 'tap to resume'
    }

    function options(){
        pause();
        menu2.visible = true;
        logo.visible = false;
        score.visible = false;
    }

    function die() {
        ticker.running = false;        
        blinker.running = true;        
        score.speed = 5;
        if(score.value > DB.getscore()){
            DB.setscore(score.value);
            score.high = score.value;
            start.text = 'new high score: '+ score.text;
        }
        else {
            start.text = 'you died. score: ' + score.text;
        }

        score.value = 0;
        score.text = '0';
        score.index = 0;
        resetter.start();


        // Yeah, that code is horrible... I apologize for my past self.
        r11.active = false;
        r12.active = false;
        r13.active = false;
        r14.active = false;
        r21.active = false;
        r22.active = false;
        r23.active = false;
        r24.active = false;
        r31.active = false;
        r32.active = false;
        r33.active = false;
        r34.active = false;
        r41.active = false;
        r42.active = false;
        r43.active = false;
        r44.active = false;
        r51.active = false;
        r52.active = false;
        r53.active = false;
        r54.active = false;
        update(r11);
        update(r12);
        update(r13);
        update(r14);
        update(r21);
        update(r22);
        update(r23);
        update(r24);
        update(r31);
        update(r32);
        update(r33);
        update(r34);
        update(r41);
        update(r42);
        update(r43);
        update(r44);
        update(r51);
        update(r52);
        update(r53);
        update(r54);
    }

    function reset() {

    }

    // Increment score and show score
    function addscore(){
        score.value = score.value + 1;
        score.text = score.value.toString();
    }

    // Get highscore from DB
    function geths(){
        var highscore = DB.getscore();
        return highscore;
    }

    // Get up-to-date settings from DB
    function updatesettings(){
        var ambience = DB.getval(6);
        var fsound = DB.getval(7);
        var song = DB.getval(9);
        var reverse = DB.getval(10);

        if(ambience != '0'){
            score.ambience = true;
            rect.color = 'transparent';
        }
        else{
            score.ambience = false;
        }

        if(fsound != '0'){
            score.fancysound = true;
        }
        else{
            score.fancysound = false;
        }

        if(song == '1'){
            score.song = 1;
        }
        else if(song == '2'){
            score.song = 2;
        }
        else{
            score.song = 0;
        }

        if(reverse != '0'){
            score.reverse = true;
        }
        else{
            score.reverse = false;
        }
        if(reverse != score.oldreverse){
            die();
            start.text = 'tap to restart';
            score.oldreverse = reverse;
        }
    }


    // Sound stuff starts here
    SoundEffect{
        id: c
        source: '../aud/c.wav'
    }

    SoundEffect{
        id: d
        source: '../aud/d.wav'
    }
    SoundEffect{
        id: e
        source: '../aud/e.wav'
    }
    SoundEffect{
        id: f
        source: '../aud/f.wav'
    }
    SoundEffect{
        id: g
        source: '../aud/g.wav'
    }
    SoundEffect{
        id: a
        source: '../aud/a.wav'
    }


    function playnext(){
        if(!score.mute){
            if(score.fancysound){
                var beat = [];

                if(score.song == 0){
                    // Ode to joy by Ludwig van Beethoven (Slightly modified)
                    beat =  ['e', 'e', 'f', 'g', 'g', 'f', 'e', 'd', 'c', 'c', 'd', 'e', 'e', 'd', 'd',
                             'e', 'e', 'f', 'g', 'g', 'f', 'e', 'd', 'c', 'c', 'd', 'e', 'd', 'c', 'c',
                             'd', 'd', 'e', 'c', 'd', 'f', 'e', 'c', 'd', 'f', 'e', 'd', 'c', 'd', 'g',
                             'e', 'e', 'f', 'g', 'g', 'f', 'e', 'd', 'c', 'c', 'd', 'e', 'd', 'c', 'c'];
                }
                else if(score.song == 1){

                    // My own 'composition' :)
                    beat = ['f', 'g', 'a', 'g', 'a', 'g', 'd', 'e', 'f', 'e', 'f', 'e', 'd', 'e', 'f',
                            'e', 'd', 'e', 'd', 'c', 'g', 'f', 'e', 'g', 'a', 'g', 'a', 'd', 'e', 'f',
                            'd', 'c'];
                }
                else{
                    // 'Spring' from 'the four seasons' by Vivaldi (heavily simplified)
                    beat = ['e', 'e', 'e', 'g', 'g', 'f', 'e', 'e', 'e', 'g', 'g', 'f', 'e', 'f', 'g',
                            'f', 'e', 'd', 'e', 'e', 'e', 'g', 'g', 'f', 'e', 'e', 'e', 'g', 'g', 'f',
                            'e', 'f', 'g', 'f', 'e', 'd', 'g', 'f', 'e', 'f', 'g', 'a', 'b', 'a', 'g',
                            'f', 'e', 'f', 'g', 'a', 'g', 'f', 'e', 'd', 'd'];
                }

                var index = score.index;

                if(beat[index] == 'c'){
                    c.play();
                }
                else if(beat[index] == 'd'){
                    d.play();
                }
                else if(beat[index] == 'e'){
                    e.play();
                }
                else if(beat[index] == 'f'){
                    f.play();
                }
                else if(beat[index] == 'g'){
                    g.play();
                }
                else if(beat[index] == 'a'){
                    a.play();
                }

                score.index = score.index + 1;
                if(score.index == beat.length){
                    score.index = 0;
                }
           }
           else{
                g.play();
            }

         }

       }
    function togglesound(){
        var soundstate = DB.getval(5);
        if(soundstate != '0'){
            DB.setval('0', 5)
            score.mute = true;
            mute.text = 'Unmute';
        }
        else{
            DB.setval('1', 5);
            score.mute = false;
            mute.text = 'Mute'
        }
    }

    function getsound(){
        if(DB.getval(5) != '0'){
            mute.text = 'Mute'
            return false;
        }
        else{
            mute.text = 'Unmute'
            return true;
        }
    }

    // END Sound stuff


    // Check for activated ambience mode
    function getambience(){
        var state = DB.getval(6);
        if(state != '0'){
            return true;
        }
        else{
            return false;
        }
    }

    // Return correct background color (for ambience mode)
    function getcolor(){
        if(score.ambience){
            return 'transparent';
        }
        else{
            return '#00bfff';
        }
    }

    function touch(id) {

        if(ticker.running == false && resetter.running == false){
            ticker.running = true;
            updatesett.running = true;
            blinker.running = false;
            start.visible = false;
            menu2.visible = false;
            logo.visible = true;
            score.visible = true;
            updatesettings();
        }
        else if(resetter.running == false){

            if(id.active){
                id.active = false;
                id.color = 'transparent';
                addscore();
                playnext();
            }
            else{
                id.active = true;               
                die();
            }
        }

        // Change game color
        if(!score.ambience){

            var ran = Math.floor(Math.random() * 3);

            if(rect.color == '#00bfff'){
                if(ran == 0){
                    rect.color = '#ff6000';
                }
                else if(ran == 1){
                    rect.color = '#f000cc';
                }
                else if(ran == 2){
                    rect.color = '#44ff00';
                }
            }
            else if(rect.color == '#ff6000'){
                if(ran == 0){
                    rect.color = '#00bfff';
                }
                else if(ran == 1){
                    rect.color = '#f000cc';
                }
                else if(ran == 2){
                    rect.color = '#44ff00';
                }
            }
            else if(rect.color == '#f000cc'){
                if(ran == 0){
                    rect.color = '#00bfff';
                }
                else if(ran == 1){
                    rect.color = '#ff6000';
                }
                else if(ran == 2){
                    rect.color = '#44ff00';
                }
            }
            else if(rect.color == '#44ff00'){
                if(ran == 0){
                    rect.color = '#00bfff';
                }
                else if(ran == 1){
                    rect.color = '#ff6000';
                }
                else if(ran == 2){
                    rect.color = '#f000cc';
                }
            }
        }

    }

    function update(tile){
        if(tile.active){
            //Change tile color in ambience mode
            if(score.ambience){
                tile.color = Theme.highlightColor;
            }
            else{
                tile.color = '#ffffff';
            }
        }
        else{
          tile.color = 'transparent';
        }
    }

    //Randomizes a single row
    function newrandomize(tile1, tile2, tile3, tile4){
        var ran = Math.floor(Math.random() * 4)

        tile1.active = false;
        tile2.active = false;
        tile3.active = false;
        tile4.active = false;

        if(ran == 0){
            tile1.active = true;
        }
        else if(ran == 1){
            tile2.active = true;
        }
        else if(ran == 2){
            tile3.active = true;
        }
        else if(ran == 3){
            tile4.active = true;
        }
        update(tile1);
        update(tile2);
        update(tile3);
        update(tile4);
    }



    // Checks for active (= missed) rects
    function check(tile1, tile2, tile3, tile4){
            if(tile1.active || tile2.active || tile3.active || tile4.active){
                die();
            }
    }

    function move(tile1, tile2, tile3, tile4){
        if(score.reverse){
            tile1.y = tile1.y + score.speed;
        }
        else{
            tile1.y = tile1.y - score.speed;
        }

        tile2.y = tile1.y;
        tile3.y = tile1.y;
        tile4.y = tile1.y;

    }


    function tick() {
        // Pause if minimized
        if(!Qt.application.active){
            pause();
        }
        else {
            // Move all rectangles
            move(r11, r12, r13, r14);
            move(r21, r22, r23, r24);
            move(r31, r32, r33, r34);
            move(r41, r42, r43, r44);
            move(r51, r52, r53, r54);

            if(!score.reverse){
                // normal flow
                if(r11.y < -r11.height){
                    r11.y = rect.height + (r11.y + r11.height);
                    r12.y = r11.y;
                    r13.y = r11.y;
                    r14.y = r11.y;
                    check(r11, r12, r13, r14);
                    newrandomize(r11, r12, r13, r14);
                }
                if(r21.y < -r21.height){
                    r21.y = rect.height + (r21.y + r21.height);
                    r22.y = r21.y;
                    r23.y = r21.y;
                    r24.y = r21.y;
                    check(r21, r22, r23, r24);
                    newrandomize(r21, r22, r23, r24);
                }
                if(r31.y < -r31.height){
                    r31.y = rect.height + (r31.y + r31.height);
                    r32.y = r31.y;
                    r33.y = r31.y;
                    r34.y = r31.y;
                    check(r31, r32, r33, r34);
                    newrandomize(r31, r32, r33, r34);
                }
                if(r41.y < -r41.height){
                    r41.y = rect.height + (r41.y + r41.height);
                    r42.y = r41.y;
                    r43.y = r41.y;
                    r44.y = r41.y;
                    check(r41, r42, r43, r44);
                    newrandomize(r41, r42, r43, r44);
                }
                if(r51.y < -r51.height){
                    r51.y = rect.height + (r51.y + r51.height);
                    r52.y = r51.y;
                    r53.y = r51.y;
                    r54.y = r51.y;
                    check(r51, r52, r53, r54);
                    newrandomize(r51, r52, r53, r54);
                }
            }
            else{
                // reversed flow
                if(r11.y > rect.height){
                    r11.y = -(r11.height - (r11.y - rect.height));
                    r12.y = r11.y;
                    r13.y = r11.y;
                    r14.y = r11.y;
                    check(r11, r12, r13, r14);
                    newrandomize(r11, r12, r13, r14);
                }
                if(r21.y > rect.height){
                    r21.y = -(r21.height - (r21.y - rect.height));
                    r22.y = r21.y;
                    r23.y = r21.y;
                    r24.y = r21.y;
                    check(r21, r22, r23, r24);
                    newrandomize(r21, r22, r23, r24);
                }
                if(r31.y > rect.height){
                    r31.y = -(r31.height - (r31.y - rect.height));
                    r32.y = r31.y;
                    r33.y = r31.y;
                    r34.y = r31.y;
                    check(r31, r32, r33, r34);
                    newrandomize(r31, r32, r33, r34);
                }
                if(r41.y > rect.height){
                    r41.y = -(r41.height - (r41.y - rect.height));
                    r42.y = r41.y;
                    r43.y = r41.y;
                    r44.y = r41.y;
                    check(r41, r42, r43, r44);
                    newrandomize(r41, r42, r43, r44);
                }
                if(r51.y > rect.height){
                    r51.y = -(r51.height - (r51.y - rect.height));
                    r52.y = r51.y;
                    r53.y = r51.y;
                    r54.y = r51.y;
                    check(r51, r52, r53, r54);
                    newrandomize(r51, r52, r53, r54);
                }

            }

           // Increase game speed
           score.speed = score.speed + 0.015;


        }

    }

    Timer {
        id: blinker
        interval: 750
        running: true
        repeat: true
        onTriggered: blink()
    }

    Timer {
        id: ticker
        interval: 35
        running: false
        repeat: true
        onTriggered: tick()
    }


    Timer {
        id: resetter
        interval: 1000
        running: false
        repeat: false
        onTriggered: reset()
    }

    // Update ambience and sound setting every 3s to save resources
    Timer {
        id: updatesett
        interval: 3000
        running: true
        repeat: true
        onTriggered: updatesettings()
    }

    Rectangle {
        id: rect
        width: parent.width
        height: parent.height
        color: getcolor()
    }

    // All Rectangles
    Rectangle {
        id: r11
        height: rect.height / 4
        width: rect.width / 4
        x: 0
        y: 0
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r11)
        }
    }

    Rectangle {
        id: r12
        height: rect.height / 4
        width: rect.width / 4
        x: rect.width / 4
        y: 0
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r12)
        }
    }

    Rectangle {
        id: r13
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*2
        y: 0
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r13)
        }
    }

    Rectangle {
        id: r14
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*3
        y: 0
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r14)
        }
    }

    Rectangle {
        id: r21
        height: rect.height / 4
        width: rect.width / 4
        x: 0
        y: rect.height / 4
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r21)
        }
    }

    Rectangle {
        id: r22
        height: rect.height / 4
        width: rect.width / 4
        x: rect.width / 4
        y: rect.height / 4
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r22)
        }
    }

    Rectangle {
        id: r23
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*2
        y: rect.height / 4
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r23)
        }
    }

    Rectangle {
        id: r24
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*3
        y: rect.height / 4
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r24)
        }
    }

    Rectangle {
        id: r31
        height: rect.height / 4
        width: rect.width / 4
        x: 0
        y: rect.height / 2
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r31)
        }
    }

    Rectangle {
        id: r32
        height: rect.height / 4
        width: rect.width / 4
        x: rect.width / 4
        y: rect.height / 2
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r32)
        }
    }

    Rectangle {
        id: r33
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*2
        y: rect.height / 2
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r33)
        }
    }

    Rectangle {
        id: r34
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*3
        y: rect.height / 2
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r34)
        }
    }

    Rectangle {
        id: r41
        height: rect.height / 4
        width: rect.width / 4
        x: 0
        y: (rect.height / 4)*3
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r41)
        }
    }

    Rectangle {
        id: r42
        height: rect.height / 4
        width: rect.width / 4
        x: rect.width / 4
        y: (rect.height / 4)*3
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r42)
        }
    }

    Rectangle {
        id: r43
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*2
        y: (rect.height / 4)*3
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r43)
        }
    }

    Rectangle {
        id: r44
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*3
        y: (rect.height / 4)*3
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r44)
        }
    }

    Rectangle {
        id: r51
        height: rect.height / 4
        width: rect.width / 4
        x: 0
        y: rect.height
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r51)
        }
    }

    Rectangle {
        id: r52
        height: rect.height / 4
        width: rect.width / 4
        x: rect.width / 4
        y: rect.height
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r52)
        }
    }

    Rectangle {
        id: r53
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*2
        y: rect.height
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r53)
        }
    }

    Rectangle {
        id: r54
        height: rect.height / 4
        width: rect.width / 4
        x: (rect.width / 4)*3
        y: rect.height
        color: 'transparent'
        property bool active: false
        MouseArea {
            anchors.fill: parent
            onClicked: touch(r54)
        }
    }



// End rectangles



    Label {
        id: start
        visible: true
        text: "tap to start"
        font.pixelSize: 24
        font.family: pixels.name
        anchors.centerIn: parent
    }

    Rectangle{
        id: menu
        y: -5
        x: -5
        color: rect.color
        height: 65
        width: rect.width + 10
        border.color: '#ffffff'
        border.width: 5
        MouseArea {
            anchors.fill: parent
            onClicked: options()
        }

        Rectangle{
            id: menu2
            visible: false
            color: 'transparent'
            anchors.fill: parent;



            Label {
                id: info
                text: 'Info'
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 42
                font.family: pixels.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width/2
                MouseArea {
                    anchors.fill: parent
                    onClicked: about()
                }
            }


            Label {
                id: mute
                text: 'Mute'
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 42
                font.family: pixels.name
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width/2
                MouseArea {
                    anchors.fill: parent
                    onClicked: togglesound()
                }
            }



        }
    }



    Label {
        x: 10
        y: 5
        id: score
        visible: true
        text: '0'
        font.pixelSize: 42
        font.family: pixels.name
        property int value: 0
        property int high: geths()
        property real speed: 5
        property int index: 0
        property bool mute: getsound()
        property bool ambience: true
        property bool fancysound: true
        property bool reverse: false
        property bool oldreverse: false
        property int song: 0
    }

    Label {
        y: 5
        id: logo
        text: 'Menu'
        font.pixelSize: 42
        font.family: pixels.name
        anchors.horizontalCenter: menu.horizontalCenter
    }


}
