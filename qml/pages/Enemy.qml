/***********************************
 * Copyright 2014 Peter Pykäläinen *
 *                                 *
 * This file is part of Collision  *
 ***********************************/

import QtQuick 2.0

Image {
    id: enemy
    source: "../images/enemy_collision.png"
    z: 1

    property string name: ""
    property string type: "enemy"
    property bool canKill: true;
    property int difficultyMultiplier: 0

    signal testCollision(int x, int y, int width, int height, var obj);

    Behavior on opacity { NumberAnimation { properties: "opacity"; duration: 250 } }

    states: [
        State {
            name: "alive"
            PropertyChanges { target: enemy; opacity: 1 }
        },

        State {
            name: "dead"
            PropertyChanges { target: enemy; opacity: 0; source: "../images/enemy_flame.png" }
        }
    ]

    Timer {
        id: enemyTimer
        running: Qt.application.active;
        interval: 50 - (10 * difficultyMultiplier)
        repeat: true;
        onTriggered: {
            testCollision(enemy.x, enemy.y, enemy.width, enemy.height, enemy);
        }
    }
}
