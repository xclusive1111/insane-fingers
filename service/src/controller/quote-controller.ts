import * as mongoose from 'mongoose';
import {Request, Response} from 'express';


export class QuoteController {
  public addQuote(req: Request, res: Response) {
    res.json(req.body);
  }
}
