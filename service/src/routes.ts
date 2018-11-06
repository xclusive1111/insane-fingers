import {QuoteController} from "./controller/quote-controller";

export class Routes {
  public quoteController: QuoteController = new QuoteController();

  public routes(app): void {
    app.route("/ping").get(this.quoteController.ping);

    app.route("/quotes/add").post(this.quoteController.addQuotes);

    app.route("/quotes").get(this.quoteController.getQuotes);

    app.route("/quotes/random").get(this.quoteController.random);
  }
}

