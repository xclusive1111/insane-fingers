import app from "./app";
import {WsServer} from "./controller/ws-controller";
const PORT = 3000;
const wsServer: WsServer = new WsServer();

app.listen(PORT, () => {
  console.log("Express server listening on port " + PORT);
});

wsServer.start(app);
