// SPDX-FileCopyrightText: 2021 Nheko Contributors
// SPDX-FileCopyrightText: 2022 Nheko Contributors
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.10
import im.nheko

Pane {
    property string title: qsTr("Successful Verification")
    background: Rectangle {
        color: timelineRoot.palette.window
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        Label {
            id: content

            Layout.preferredWidth: 400
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            text: qsTr("Verification successful! Both sides verified their devices!")
            color: timelineRoot.palette.text
            verticalAlignment: Text.AlignVCenter
        }

        Item { Layout.fillHeight: true; }

        RowLayout {
            Item {
                Layout.fillWidth: true
            }

            Button {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Close")
                onClicked: dialog.close()
            }

        }

    }

}
