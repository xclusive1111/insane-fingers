import * as express from "express";
import * as bodyParser from "body-parser";
import * as socketio from "socket.io";
import * as http from "http";
import {Routes} from "./routes";

export default class App {
  private app: express.Application;
  private route: Routes = new Routes();
  private server: http.Server;
  private io: SocketIO.Server;

  constructor() {
    this.app = express();
    this.server = new http.Server(this.app);
    this.io = socketio(this.server);
    this.config();
  }

  private config(): void {
    this.app.use(bodyParser.json());
    this.app.use(bodyParser.urlencoded({ extended: false }));
    this.route.routes(this.app);
  }

  public start(port: number): void {
    this.server.listen(port, () => {
      console.log("Express server listening on port " + port);
    });
    this.io.on('connection', (socket: any) => {
      socket.broadcast.emit('A client connected');
      socket.emit('news', { hello: 'world' });

      socket.on('news', (m: any) => {
        console.log("Got a message: ", m);
        socket.emit('news', 'It got your message');
      });

      socket.on('disconnect', () => {
        console.log("A client disconnected");
      });
    })
  }
}
