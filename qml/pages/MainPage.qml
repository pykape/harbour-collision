/***********************************
 * Copyright 2014 Peter Pykäläinen *
 *                                 *
 * This file is part of Collision  *
 ***********************************/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtFeedback 5.0

Page {
    id: page

    property bool isAppActive: true
    property bool isTalbot: page.width > 540

    Connections {
        target: Qt.application
        onActiveChanged: {
            if (!Qt.application.active) {
                isAppActive = false;
            }
            else {
                isAppActive = true;
            }
        }
    }

    Component.onCompleted: {
        var component;
        var sprite;
        var xCoord = Math.floor((Math.random() * 430) + 10);
        var yCoord = Math.floor((Math.random() * 650) + 200);
        component = Qt.createComponent("Enemy.qml");
        sprite = component.createObject(background, {"x": (background.width / 2 - 37), "y": (background.height / 2 - 64)});
        if (sprite !== null) {
            var date = new Date();
            var ms = date.getTime();
            sprite.name = "enemy" + ms;
            sprite.testCollision.connect(testCollision);
        }
    }

    HapticsEffect {
        id: rumbler
        attackIntensity: 0.0
        attackTime: 250
        intensity: 1.0
        duration: 100
        fadeTime: 250
        fadeIntensity: 0.0
    }

    Rectangle {
        id: background

//        width: 540; height: 800
        width: parent.width; height: parent.height - (parent.height / 100 * 16);
        Behavior on color { ColorAnimation { duration: 200 } }
        color: "lightgrey"

        // To enable PullDownMenu, place our content in a SilicaFlickable
        SilicaFlickable {
            id: flickable
            anchors.fill: parent
            contentWidth: flickable.width;
//            contentHeight: 800
            contentHeight: parent.height
            contentY: flickable.contentHeight;
            interactive: false;
            clip: true

            Column {
                width: flickable.width
                height: flickable.contentHeight
            }
        }

        Image {
            id: plane
            source: "../images/fighter_collision.png"
            z: 999
            y: flickable.height - 128;
            x: parent.width / 2 - (plane.width / 2)
            Behavior on x { SmoothedAnimation { velocity: 200 } }
            Behavior on y { SmoothedAnimation { velocity: 500 } }
            Behavior on opacity { NumberAnimation { properties: "opacity"; duration: 1000 } }

            states: [
                State {
                    name: "alive"
                    PropertyChanges { target: plane; opacity: 1; source: "../images/plane.png" }
                },

                State {
                    name: "dead"
                    PropertyChanges { target: plane; opacity: 0; source: "../images/plane_flame.png" }
                }
            ]

            MouseArea {
                anchors.fill: parent
                property int startX
                property int startY

                onPressed: {
                    startX = mouse.x
                    startY = mouse.y
                }
                onPositionChanged: {
                    plane.x += mouse.x - startX
                    plane.y += mouse.y - startY
                }
                onReleased: {
                    startX = mouse.x
                    startY = mouse.y
                }
            }
        }
    }

    Label {
        id: lblX
        anchors.topMargin: 10
        anchors.leftMargin: 20
        anchors.top: background.bottom
        anchors.left: background.left
        text: "X: " + Math.round(plane.x) + "<br />Y: " + Math.round(plane.y);
    }

//    Label {
//        id: lblY
//        anchors.topMargin: 30
//        anchors.leftMargin: 20
//        anchors.top: background.bottom
//        anchors.right: background.left
//        text: "Y: " + plane.y;
//    }

    function testCollision(x, y, width, height, obj) {
//        var canvas = this.createElement("canvas");
//        canvas.width = obj.width;
//        canvas.height = obj.height;
//        canvas.getContext('2d').drawImage(obj, 0, 0, obj.width, obj.height);

//        var context = canvas.getContext("2d");
//        var imgd = context.getImageData(x, y, width, height);
//        var pix = imgd.data;

//        for (var i = 0, n = pix.length; i < n; i += 4) {
//          console.log(pix[i+3]);
//        }

//        if (x < plane.x + plane.width &&
//                x + width > plane.x &&
//                y < plane.y + plane.height &&
//                height + y > plane.y) {

        var radius1 = width / 2;
        var radius2 = plane.width / 2;
        var dx = (x + radius1) - (plane.x + radius2);
        var dy = (y + radius1) - (plane.y + radius2);
        var distance = Math.sqrt(dx * dx + dy * dy);

        if (distance < radius1 + radius2) {
            if (obj.canKill && obj.type === "enemy") {
                rumbler.start();
            }
        }
    }

    function pointIsInPoly(p, polygon) {
        var isInside = false;
        var minX = polygon[0].x, maxX = polygon[0].x;
        var minY = polygon[0].y, maxY = polygon[0].y;
        for (var n = 1; n < polygon.length; n++) {
            var q = polygon[n];
            minX = Math.min(q.x, minX);
            maxX = Math.max(q.x, maxX);
            minY = Math.min(q.y, minY);
            maxY = Math.max(q.y, maxY);
        }

        if (p.x < minX || p.x > maxX || p.y < minY || p.y > maxY) {
            return false;
        }

        var i = 0, j = polygon.length - 1;
        for (i, j; i < polygon.length; j = i++) {
            if ( (polygon[i].y > p.y) != (polygon[j].y > p.y) &&
                    p.x < (polygon[j].x - polygon[i].x) * (p.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x ) {
                isInside = !isInside;
            }
        }

        return isInside;
    }
}


