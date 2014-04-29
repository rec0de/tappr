import QtQuick 2.0
import QtQuick.Window 2.0
import Sailfish.Silica 1.0
import "../data.js" as DB

Page {
    id: page

    Component.onCompleted: {
        // Initialize the database
        DB.initialize();
    }

    FontLoader { id: pixels; source: "../img/pixelmix.ttf" }

    // Makes the start text blink
    function blink() {
        if(start.visible == false){
             start.visible = true;
        }
        else {
             start.visible = false;
        }
    }

    // Pause game and go to about page
    function about() {
        pageStack.push(Qt.resolvedUrl("about.qml"))
        ticker.running = false;
        blinker.running = true;
        start.text = 'tap to resume'
    }

    function pause() {
        ticker.running = false;
        blinker.running = true;
        start.text = 'tap to resume'
    }

    function die() {
        ticker.running = false;        
        blinker.running = true;        
        score.speed = 4;
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
        resetter.start();


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


    function touch(id) {


        if(ticker.running == false && resetter.running == false){
            ticker.running = true;
            blinker.running = false;
            start.visible = false;
        }
        else if(resetter.running == false){

            if(id.active){
                id.active = false;
                id.color = 'transparent';
                addscore();
            }
            else{
                id.active = true;
                id.color = '#ffffff';
                die();
            }
        }

        // Change game color
       var ran = Math.floor(Math.random() * 4)

        if(ran == 0){
            rect.color = '#00bfff';
        }
        else if(ran == 1){
            rect.color = '#f000cc';
        }
        else if(ran == 2){
            rect.color = '#44ff00';
        }
        else if(ran == 3){
            rect.color = '#ff6000';
        }

    }

    // returns random boolean
    function ranbool()
    {
    return Math.random() >= 0.5;
    }

    function update(tile){
        if(tile.active){
          tile.color = '#ffffff';
        }
        else{
          tile.color = 'transparent';
        }
    }


    // Randomizes tiles per row
    function randomize(row){
        if(row == 1){
            r11.active = ranbool();
            r12.active = ranbool();
            r13.active = ranbool();
            r14.active = ranbool();
            update(r11);
            update(r12);
            update(r13);
            update(r14);
        }
        if(row == 2){
            r21.active = ranbool();
            r22.active = ranbool();
            r23.active = ranbool();
            r24.active = ranbool();
            update(r21);
            update(r22);
            update(r23);
            update(r24);
        }
        if(row == 3){
            r31.active = ranbool();
            r32.active = ranbool();
            r33.active = ranbool();
            r34.active = ranbool();
            update(r31);
            update(r32);
            update(r33);
            update(r34);
        }
        if(row == 4){
            r41.active = ranbool();
            r42.active = ranbool();
            r43.active = ranbool();
            r44.active = ranbool();
            update(r41);
            update(r42);
            update(r43);
            update(r44);
        }
        if(row == 5){
            r51.active = ranbool();
            r52.active = ranbool();
            r53.active = ranbool();
            r54.active = ranbool();
            update(r51);
            update(r52);
            update(r53);
            update(r54);
        }

    }

    // Checks for active (= missed) rects
    function check(row){
        if(row == 1){
            if(r11.active || r12.active || r13.active || r14.active){
                die();
            }
        }
        if(row == 2){
            if(r21.active || r22.active || r23.active || r24.active){
                die();
            }
        }
        if(row == 3){
            if(r31.active || r32.active || r33.active || r34.active){
                die();
            }
        }
        if(row == 4){
            if(r41.active || r42.active || r43.active || r44.active){
                die();
            }
        }
        if(row == 5){
            if(r51.active || r52.active || r53.active || r54.active){
                die();
            }
        }

    }


    function tick() {
        // Pause if minimized
        if(!Qt.application.active){
            pause();
        }
        else {
            // Move all rectangles
            r11.y = r11.y - score.speed;
            r12.y = r11.y;
            r13.y = r11.y;
            r14.y = r11.y;

            r21.y = r21.y - score.speed;
            r22.y = r21.y;
            r23.y = r21.y;
            r24.y = r21.y;

            r31.y = r31.y - score.speed;
            r32.y = r31.y;
            r33.y = r31.y;
            r34.y = r31.y;

            r41.y = r41.y - score.speed;
            r42.y = r41.y;
            r43.y = r41.y;
            r44.y = r41.y;

            r51.y = r51.y - score.speed;
            r52.y = r51.y;
            r53.y = r51.y;
            r54.y = r51.y;

                if(r11.y < -r11.height){
                    r11.y = rect.height + (r11.y + r11.height);
                    r12.y = r11.y;
                    r13.y = r11.y;
                    r14.y = r11.y;
                    score.speed = score.speed + 0.1
                    check(1);
                    randomize(1);
                }
                if(r21.y < -r21.height){
                    r21.y = rect.height + (r21.y + r21.height);
                    r22.y = r21.y;
                    r23.y = r21.y;
                    r24.y = r21.y;
                    score.speed = score.speed + 0.1
                    check(2);
                    randomize(2);
                }
                if(r31.y < -r31.height){
                    r31.y = rect.height + (r31.y + r31.height);
                    r32.y = r31.y;
                    r33.y = r31.y;
                    r34.y = r31.y;
                    score.speed = score.speed + 0.1
                    check(3);
                    randomize(3);
                }
                if(r41.y < -r41.height){
                    r41.y = rect.height + (r41.y + r41.height);
                    r42.y = r41.y;
                    r43.y = r41.y;
                    r44.y = r41.y;
                    score.speed = score.speed + 0.1
                    check(4);
                    randomize(4);
                }
                if(r51.y < -r51.height){
                    r51.y = rect.height + (r51.y + r51.height);
                    r52.y = r51.y;
                    r53.y = r51.y;
                    r54.y = r51.y;
                    score.speed = score.speed + 0.2
                    check(5);
                    randomize(5);
                }


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

    Rectangle {
        id: rect
        width: parent.width
        height: parent.height
        color: '#00bfff'
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
    }

    Image {
        id: info
        y: 7
        x: rect.width - 50
        visible: true
        source: "../img/info.png"
        MouseArea {
            anchors.fill: parent
            onClicked: about()
        }
    }

    Image {
        id: stop
        y: 7
        x: rect.width - 125
        visible: true
        source: "../img/pause.png"
        MouseArea {
            anchors.fill: parent
            onClicked: pause()
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
        property real speed: 4
    }

    Label {
        y: 5
        id: logo
        text: 'Tappr'
        font.pixelSize: 42
        font.family: pixels.name
        anchors.horizontalCenter: menu.horizontalCenter
    }


}
