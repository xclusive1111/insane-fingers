import {createServer, Server} from "http";
import * as express from "express";
import * as socketIo from "socket.io";

export class WsServer {
  public static readonly PORT: number = 4000;
  private server: Server;
  private port: number | string;
  private io: SocketIO.Server;
  private app: express.Application;

  constructor() { }

  public start(app): void {
    this.server = createServer(app);
    this.port = process.env.PORT || WsServer.PORT;
    this.io = socketIo(this.server);

    this.server.listen(this.port, () => {
      console.log("Running web socket on port %s", this.port);
    })

    this.io.on("connect", (socket: any) => {
      console.log("Connected client on port %s", this.port);

      socket.on("message", (m: any) => {
        console.log("[server](message): %s", m);
        this.io.emit("message", m);
      })

      socket.on("disconnect", () => {
        console.log("Client disconnected");
      })
    })
  }

}
