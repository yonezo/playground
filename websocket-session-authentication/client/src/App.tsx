import React, { useEffect, useState } from "react";
import { initializeApp } from "firebase/app";
import {
  getAuth,
  User,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
} from "firebase/auth";

const HOST = "localhost:8080";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);

function App() {
  const ref = React.useRef<HTMLPreElement>(null);
  const wsRef = React.useRef<WebSocket | null>(null);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [user, setUser] = useState<User | null>(null);
  const [wsState, setWsState] = useState<"idle" | "open" | "close">("idle");

  const setWsRef = React.useCallback(
    (ws: WebSocket | null) => {
      if (ws && user) {
        ws.onerror = () => {
          showMessage("WebSocket error");
        };

        ws.onopen = () => {
          showMessage("WebSocket connection established");
          user.getIdToken().then((idToken) => {
            ws.send(JSON.stringify({ type: "authentication", token: idToken }));
            setWsState("open");
          });
        };

        ws.onmessage = (event) => {
          showMessage(`Receive: "${JSON.parse(event.data).text}"`);
        };

        ws.onclose = () => {
          showMessage("WebSocket connection closed");
          wsRef.current = null;
          setWsState("close");
        };
      } else {
        wsRef.current?.close();
      }

      wsRef.current = ws;
    },
    [user]
  );

  useEffect(() => {
    getAuth(app).onAuthStateChanged((user) => {
      setCookie(user);
    });
  }, []);

  const setCookie = (user: User | null) => {
    user
      ?.getIdToken(true)
      .then((idToken) => {
        document.cookie = "__session=" + idToken + ";max-age=3600";
        setUser(user);
      })
      .catch((error) => showMessage(error.message));
  };

  const showMessage = (message: string) => {
    if (!ref.current) return;
    ref.current.textContent += `\n${message}`;
    ref.current.scrollTop = ref.current.scrollHeight;
  };

  return (
    <div>
      {user == null && (
        <>
          <input
            type="email"
            placeholder="email"
            value={email}
            onChange={(e) => {
              setEmail(e.currentTarget.value);
            }}
          />
          <input
            type="password"
            placeholder="password"
            value={password}
            onChange={(e) => {
              setPassword(e.currentTarget.value);
            }}
          />
          <button
            type="button"
            onClick={() => {
              const auth = getAuth(app);
              createUserWithEmailAndPassword(auth, email, password)
                .then((credential) => setCookie(credential.user))
                .catch((error) => {
                  showMessage(error.message);
                });
            }}
          >
            Email & Password Sign up
          </button>
          <button
            type="button"
            onClick={() => {
              const auth = getAuth(app);
              signInWithEmailAndPassword(auth, email, password)
                .then((credential) => setCookie(credential.user))
                .catch((error) => {
                  showMessage(error.message);
                });
            }}
          >
            Email & Password Sign in
          </button>
        </>
      )}
      {user && (
        <>
          <div>Email: {user.email}</div>
          <button
            type="button"
            onClick={() => {
              switch (wsState) {
                case "idle":
                case "close":
                  setWsRef(new WebSocket(`ws://${HOST}`));
                  break;
                case "open":
                  setWsRef(null);
                  break;
              }
            }}
          >
            {wsState === "idle" || wsState === "close"
              ? "Open WebSocket connection"
              : wsState === "open"
              ? "Close WebSocket connection"
              : ""}
          </button>
          <button
            id="wsSendButton"
            type="button"
            title="Send WebSocket message"
            onClick={() => {
              const ws = wsRef.current;
              if (!ws) {
                showMessage("No WebSocket connection");
                return;
              }

              ws.send(JSON.stringify({ data: "Hello World!" }));
              showMessage('Sent "Hello World!"');
            }}
          >
            Send WebSocket message
          </button>
          <pre ref={ref} style={{ height: 400, overflow: "scroll" }} />
        </>
      )}
    </div>
  );
}

export default App;
