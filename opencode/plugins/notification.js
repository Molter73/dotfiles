const SOUNDS = "/usr/share/sounds/freedesktop/stereo"

async function getSessionInfo($) {
  try {
    const result = await $`tmux display-message -p '#S'`.text()
    return `Session: ${result.trim()}`
  } catch {
    return `Directory: ${process.env.PWD}`
  }
}

async function notify($, summary, { urgency = "normal", sound = "complete" } = {}) {
  const body = await getSessionInfo($)
  await Promise.all([
    $`notify-send -a opencode -u ${urgency} ${summary} ${body}`,
    $`pw-play ${SOUNDS}/${sound}.oga`,
  ])
}

async function isSubagentSession(client, sessionID) {
  if (!sessionID) return false
  const { data } = await client.session.get({ path: { id: sessionID } })
  return Boolean(data?.parentID)
}

export const NotificationPlugin = async ({ $, client }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        if (await isSubagentSession(client, event.properties.sessionID)) return
        await notify($, "OpenCode: Session completed", { sound: "complete" })
      }
      if (event.type === "session.error") {
        if (await isSubagentSession(client, event.properties.sessionID)) return
        await notify($, "OpenCode: Session error", { urgency: "critical", sound: "dialog-error" })
      }
      if (event.type === "permission.asked") {
        await notify($, "OpenCode: Permission requested", { sound: "dialog-warning" })
      }
    },
  }
}
