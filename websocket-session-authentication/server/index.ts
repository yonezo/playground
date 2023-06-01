"use strict";

import express from "express";
import http from "http";
import "dotenv/config";
import admin from "firebase-admin";

import { WebSocketServer } from "ws";
import cookieParser from "cookie-parser";

admin.initializeApp({
  projectId: process.env.FIREBASE_PROJECT_ID,
});

declare global {
  namespace Express {
    interface Request {
      user: admin.auth.DecodedIdToken;
    }
  }
}

function onSocketError(err: Error) {
  console.error(err);
}

const app = express();
const map = new Map();

const validateFirebaseIdToken = async (
  req: express.Request,
  res: express.Response | null,
  next: express.NextFunction
) => {
  console.log("Check if request is authorized with Firebase ID token");

  if (!(req.cookies && req.cookies.__session)) {
    console.error(
      "No Firebase ID token was passed as a Bearer token in the Authorization header.",
      "Make sure you authorize your request by providing the following HTTP header:",
      "Authorization: Bearer <Firebase ID Token>",
      'or by passing a "__session" cookie.'
    );
    res?.status(403).send("Unauthorized");
    return;
  }

  let idToken;
  if (req.cookies) {
    console.log('Found "__session" cookie');
    // Read the ID Token from cookie.
    idToken = req.cookies.__session;
  } else {
    // No cookie
    res?.status(403).send("Unauthorized");
    return;
  }

  try {
    const decodedIdToken = await admin.auth().verifyIdToken(idToken);
    console.log("ID Token correctly decoded", decodedIdToken);

    req.user = decodedIdToken;
    next();
    return;
  } catch (error) {
    console.error("Error while verifying Firebase ID token:", error);
    res?.status(403).send("Unauthorized");
    return;
  }
};

//
// Create an HTTP server.
//
const server = http.createServer(app);

//
// Create a WebSocket server completely detached from the HTTP server.
//
const wss = new WebSocketServer({ clientTracking: false, noServer: true });

server.on("upgrade", function (request: express.Request, socket, head) {
  socket.on("error", onSocketError);

  console.log("Parsing session from request...");

  console.log("headers", request.cookies);

  const parser = cookieParser();

  parser(request, {} as express.Response, () => {
    validateFirebaseIdToken(request, null, () => {
      if (!request.user?.uid) {
        socket.write("HTTP/1.1 401 Unauthorized\r\n\r\n");
        socket.destroy();
        return;
      }

      console.log("Session is parsed!");

      socket.removeListener("error", onSocketError);

      wss.handleUpgrade(request, socket, head, function (ws) {
        wss.emit("connection", ws, request.user);
      });
    });
  });
});

wss.on("connection", function (ws, user: admin.auth.DecodedIdToken) {
  const userId = user.uid;

  map.set(userId, ws);

  ws.on("error", console.error);

  ws.on("message", (message) => {
    //
    // Here we can now use session parameters.
    //
    console.log(`Received message ${message} from user ${userId}`);
  });

  ws.on("close", function () {
    map.delete(userId);
  });
});

//
// Start the server.
//
server.listen(8080, function () {
  console.log("Listening on http://localhost:8080");
});
