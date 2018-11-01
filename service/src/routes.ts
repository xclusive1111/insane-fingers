import {Request, Response} from "express";
import {QuoteController} from "./controller/quote-controller";

export class Routes {
  public quoteController: QuoteController = new QuoteController();

  public routes(app): void {

    // Ping request
    app.route("/ping").get((req: Request, res: Response) => {
      res.status(200).send({ message: 'Pong !!' })
    });

    // Test
    app.route("/add_quote").post(this.quoteController.addQuote);
    
  }

}

