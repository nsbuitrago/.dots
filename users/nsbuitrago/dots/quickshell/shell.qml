// Bar.qml
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string time: ""
  property var occupiedWorkspaceIds: []

  component Pill: Rectangle {
    required property string label

    implicitWidth: pillText.implicitWidth + 24
    implicitHeight: 24
    radius: height / 2
    color: "#b31e1e2e"
    border.color: "#4dffffff"
    border.width: 1

    Text {
      id: pillText
      anchors.centerIn: parent
      text: parent.label
      color: "#f5f5f5"
      font.pixelSize: 13
      font.weight: Font.Medium
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 32
      color: "transparent"

      Rectangle {
        anchors.centerIn: parent
        property bool singleWorkspace: workspaceRow.implicitWidth === 20

        implicitWidth: workspaceRow.implicitWidth + (singleWorkspace ? 0 : 8)
        implicitHeight: singleWorkspace ? workspaceRow.implicitHeight : 24
        radius: height / 2
        color: "#b31e1e2e"
        border.color: "#4dffffff"
        border.width: 1
        visible: root.occupiedWorkspaceIds.length > 0

        Row {
          id: workspaceRow
          anchors.centerIn: parent
          spacing: 2

          Repeater {
            model: root.occupiedWorkspaceIds

            delegate: Rectangle {
              id: workspaceButton
              required property int modelData
              property int workspaceId: modelData

              implicitWidth: 20
              implicitHeight: 20
              radius: height / 2
              color: Hyprland.focusedWorkspace
                && Hyprland.focusedWorkspace.id === workspaceId
                ? "#e6ffffff"
                : "transparent"

              Text {
                anchors.centerIn: parent
                text: workspaceButton.workspaceId
                color: Hyprland.focusedWorkspace
                  && Hyprland.focusedWorkspace.id === workspaceButton.workspaceId
                  ? "#1e1e2e"
                  : "#f5f5f5"
                font.pixelSize: 13
                font.weight: Font.Medium
              }
            }
          }
        }
      }

      Pill {
        anchors {
          right: parent.right
          rightMargin: 8
          verticalCenter: parent.verticalCenter
        }
        label: root.time
        visible: root.time.length > 0
      }
    }
  }

  Process {
    id: dateProc
    command: ["date", "+%a %b %d %H:%M"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.time = this.text.trim()
    }
  }

  Process {
    id: clientsProc
    command: ["hyprctl", "clients", "-j"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const workspaceIds = new Set()
          for (const client of JSON.parse(this.text)) {
            if (client.workspace && client.workspace.id > 0)
              workspaceIds.add(client.workspace.id)
          }
          root.occupiedWorkspaceIds = Array.from(workspaceIds)
            .sort((first, second) => first - second)
        } catch (error) {
          root.occupiedWorkspaceIds = []
        }
      }
    }
  }

  Connections {
    target: Hyprland

    function onRawEvent(event) {
      clientsProc.running = true
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}
