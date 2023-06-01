"use strict";

import admin from "firebase-admin";
import "dotenv/config";
import ws, { WebSocketServer, WebSocket } from "ws";

declare module "ws" {
  export interface WebSocket extends ws {
    user?: admin.auth.DecodedIdToken;
  }
}

admin.initializeApp({
  projectId: process.env.FIREBASE_PROJECT_ID,
});

const map = new Map<string, WebSocket>();

const wss = new WebSocketServer({ port: 8080 });

wss.on("connection", function (ws, request) {
  ws.on("error", console.error);

  ws.on("message", async (data, isBinary) => {
    const packet = JSON.parse(data.toString());

    if (!ws.user) {
      if (packet.type === "authentication" && packet["token"]) {
        const decodedIdToken = await admin
          .auth()
          .verifyIdToken(packet["token"]);
        map.set(decodedIdToken.uid, ws);
        ws.user = decodedIdToken;
      } else {
        ws.close();
      }
    }

    if (packet.type === "message") {
      map.forEach((ws, id) => {
        if (id !== packet.uid) {
          ws.send(data, { binary: isBinary });
        }
      });
    }

    console.log("Number of clients", wss.clients.size);
    console.log(`Received message ${data} from user ${ws.user?.uid}`);
  });

  ws.on("close", function () {
    if (ws.user?.uid) map.delete(ws.user?.uid);
  });
});
