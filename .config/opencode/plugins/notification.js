import { homedir } from "os";
import { join } from "path";

export const NotificationPlugin = async ({ $, client }) => {
  const soundsDir = join(homedir(), ".config/opencode/sounds");
  const idleSound = join(soundsDir, "go-ahead-do-your-thing.mp3");
  const attentionSound = join(soundsDir, "chief.mp3");

  // Check if a session is a main (non-subagent) session
  const isMainSession = async (sessionID) => {
    try {
      const result = await client.session.get({ path: { id: sessionID } });
      const session = result.data ?? result;
      return !session.parentID;
    } catch {
      // If we can't fetch the session, assume it's main to avoid missing notifications
      return true;
    }
  };

  return {
    event: async ({ event }) => {
      // Session finished processing (replaces deprecated session.idle)
      if (event.type === "session.status") {
        const { sessionID, status } = event.properties;
        if (status.type === "idle" && (await isMainSession(sessionID))) {
          await $`afplay ${idleSound}`;
        }
      }

      // Permission prompt — needs user attention
      if (event.type === "permission.asked") {
        await $`afplay ${attentionSound}`;
      }

      // Question asked — agent needs user input
      if (event.type === "question.asked") {
        await $`afplay ${attentionSound}`;
      }
    },
  };
};
