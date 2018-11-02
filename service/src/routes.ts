import {Request, Response} from "express";
import {QuoteController} from "./controller/quote-controller";
import {WsServer} from "./controller/ws-controller";

export class Routes {
  public quoteController: QuoteController = new QuoteController();
  public wsServer: WsServer = new WsServer();

  public routes(app): void {
    app.route("/ping").get((req: Request, res: Response) => {
      res.status(200).send({ message: 'Pong !!' })
    });

    app.route("/add_quote").post(this.quoteController.addQuote);
  }
}

