import {Request, Response} from 'express';
import {QuoteDb} from '../io/quote-db';
import {QuoteForm} from "../model";
import Api from "./api";

export class QuoteController {

  constructor() { }

  public ping(req: Request, res: Response) {
    res.status(200).send({ message: "Pong !!" });
  }

  public addQuotes(req: Request, res: Response) {
    const body = req.body as Array<QuoteForm>;
    QuoteDb.addQuotes(body, (err: Error) => {
      if (err) res.status(500).send(Api.err(err.message, 500));
      else res.status(200).send({ message: "Added " + body.length + " quotes"});
    })
  }

  public getQuotes(req: Request, res: Response) {
    QuoteDb.showQuotes((err, rows) => {
      if (err) res.status(500).send(Api.err("Failed to get quotes", 500));
      else res.status(200).send(rows);
    });
  }

  public random(req: Request, res: Response) {
    QuoteDb.randomQuote((err, quote) => {
      if (err) res.status(500).send(Api.err("Failed get a random quote", 500));
      else res.status(200).send(quote);
    })
  }
}
