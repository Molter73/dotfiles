import { $ } from "bun"

const SOUNDS = "/usr/share/sounds/freedesktop/stereo"

async function getSessionInfo() {
  try {
    const result = await $`tmux display-message -p '#S'`.text()
    return `Session: ${result.trim()}`
  } catch {
    return `Directory: ${process.env.PWD}`
  }
}

async function notify(summary, { urgency = "normal", sound = "complete" } = {}) {
  const body = await getSessionInfo()
  await Promise.all([
    $`notify-send -a opencode -u ${urgency} ${summary} ${body}`,
    $`pw-play ${SOUNDS}/${sound}.oga`,
  ])
}

async function isSubagentSession(ctx, sessionID) {
  if (!sessionID) return false
  const session = await ctx.session.get({ sessionID })
  return Boolean(session?.parentID)
}

export default {
  id: "notification",

  setup(ctx) {
    const controller = new AbortController()

    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        if (event.type === "session.idle") {
          if (await isSubagentSession(ctx, event.properties.sessionID)) continue
          await notify("OpenCode: Session completed", { sound: "complete" })
        }
        if (event.type === "session.error") {
          if (await isSubagentSession(ctx, event.properties.sessionID)) continue
          await notify("OpenCode: Session error", { urgency: "critical", sound: "dialog-error" })
        }
        if (event.type === "permission.asked") {
          await notify("OpenCode: Permission requested", { sound: "dialog-warning" })
        }
      }
    })()

    return () => controller.abort()
  },
}
