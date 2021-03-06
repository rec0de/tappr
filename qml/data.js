
.import QtQuick.LocalStorage 2.0 as LS

// Code derived from 'Noto' by leszek -- Thanks :)


// Database Structure:
// score 1: local highscore
// score 2: worldwide rank
// score 3: unique ID for server communication
// score 4: enable/disable ranking
// score 5: enable/disable sound
// score 6: ambience mode enable/disable
// score 7: fancy sound enable/disable
// score 8: version (0.0.1.x -> 1)
// score 9: song selection
// score 10: reverse enable/disable

// strings 1: nickname
// strings 2: crypto secret (for nickname authorization)

// First, let's create a short helper function to get the database connection
function getDatabase() {
    return LS.LocalStorage.openDatabaseSync("tappr", "1.0", "StorageDatabase", 10000);
}


// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS score(uid INTEGER UNIQUE, points INTEGER)');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS strings(uid INTEGER UNIQUE, data TEXT)');
                });
}


// This function is used to update highscore
function setscore(score) {
    var db = getDatabase();
    var uid = 1;
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO score VALUES (?,?);', [uid,score]);
        if (rs.rowsAffected > 0) {
            res = "OK";
            console.log ("Saved to database");
        } else {
            res = "Error";
            console.log ("Error saving to database");
        }
    }
    );
    return res;
}


// This function is used to retrieve highscore from the database
function getscore() {
    var db = getDatabase();
    var uid = 1;
    var notesText="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT points FROM score WHERE uid=?;', [uid]);
        if (rs.rows.length > 0) {
            notesText = rs.rows.item(0).points
        } else {
            notesText = "0"
        }
    })
    return notesText
}

// This function is used to update settings/values
function setval(value, uid, table) {
    if (typeof table == 'undefined' ) table = 'score';

    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO '+ table +' VALUES (?,?);', [uid,value]);
        if (rs.rowsAffected > 0) {
            res = "OK";
            console.log ("Saved to database");
        } else {
            res = "Error";
            console.log ("Error saving to database");
        }
    }
    );
    return res;
}


// This function is used to retrieve settings/values from the database
function getval(uid) {
    var db = getDatabase();
    var notesText="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT points FROM score WHERE uid=?;', [uid]);
        if (rs.rows.length > 0) {
            notesText = rs.rows.item(0).points
        } else {
            notesText = '-1'
        }
    })
    return notesText
}

// This function is used to retrieve strings from the database
function getstring(uid) {
    var db = getDatabase();
    var notesText="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT data FROM strings WHERE uid=?;', [uid]);
        if (rs.rows.length > 0) {
            notesText = rs.rows.item(0).data
        } else {
            notesText = '-1'
        }
    })
    return notesText
}

