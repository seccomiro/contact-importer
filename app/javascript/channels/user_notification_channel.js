import consumer from "./consumer";
import makeToast from "../packs/toast";

consumer.subscriptions.create("UserNotificationChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    makeToast(data.message, data.action);
  },
});
