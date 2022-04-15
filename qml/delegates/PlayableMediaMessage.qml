// SPDX-FileCopyrightText: 2021 Nheko Contributors
// SPDX-FileCopyrightText: 2022 Nheko Contributors
//
// SPDX-License-Identifier: GPL-3.0-or-later

import "../"
import "../ui/media"
import QtMultimedia
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import im.nheko

Item {
    id: content

    required property double proportionalHeight
    required property int type
    required property int originalWidth
    required property int duration
    required property string thumbnailUrl
    required property string eventId
    required property string url
    required property string body
    required property string filesize
    property double divisor: isReply ? 4 : 2
    property int tempWidth: originalWidth < 1? 400: originalWidth
    implicitWidth: type == MtxEvent.VideoMessage ? Math.round(tempWidth*Math.min((timelineView.height/divisor)/(tempWidth*proportionalHeight), 1)) : 500
    width: Math.min(parent.width, implicitWidth)
    height: (type == MtxEvent.VideoMessage ? width*proportionalHeight : 80) + fileInfoLabel.height
    implicitHeight: height

    property int metadataWidth
    property bool fitsMetadata: (parent.width - fileInfoLabel.width) > metadataWidth+4

    MxcMedia {
        id: mxcmedia

        roomm: room

        audioOutput: AudioOutput {
            muted: mediaControls.muted
            volume: mediaControls.desiredVolume
        }
        videoOutput: videoOutput
    }

    Rectangle {
        id: videoContainer

        color: type == MtxEvent.VideoMessage ? timelineRoot.palette.window : "transparent"
        width: parent.width
        height: parent.height - fileInfoLabel.height

        TapHandler {
            onTapped: Settings.openVideoExternal ? room.openMedia(eventId) : mediaControls.showControls()
        }

        Image {
            anchors.fill: parent
            source: thumbnailUrl ? thumbnailUrl.replace("mxc://", "image://MxcImage/") + "?scale" : ""
            asynchronous: true
            fillMode: Image.PreserveAspectFit

            VideoOutput {
                id: videoOutput

                visible: type == MtxEvent.VideoMessage
                clip: true
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
                //flushMode: VideoOutput.FirstFrame
                orientation: mxcmedia.orientation
            }

        }

    }

    MediaControls {
        id: mediaControls

        anchors.left: content.left
        anchors.right: content.right
        anchors.bottom: fileInfoLabel.top
        playingVideo: type == MtxEvent.VideoMessage
        positionValue: mxcmedia.position
        duration: mediaLoaded ? mxcmedia.duration : content.duration
        mediaLoaded: mxcmedia.loaded
        mediaState: mxcmedia.state
        onPositionChanged: mxcmedia.position = position
        onPlayPauseActivated: mxcmedia.state == MediaPlayer.PlayingState ? mxcmedia.pause() : mxcmedia.play()
        onLoadActivated: mxcmedia.eventId = eventId
    }

    // information about file name and file size
    Label {
        id: fileInfoLabel

        anchors.bottom: content.bottom
        text: body + " [" + filesize + "]"
        textFormat: Text.RichText
        elide: Text.ElideRight
        color: timelineRoot.palette.text

        background: Rectangle {
            color: timelineRoot.palette.base
        }

    }

}
