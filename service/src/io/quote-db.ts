import Db from './datasource';
import * as sqlite from 'sqlite3';
import {Quote, QuoteForm} from "../model";
import Api from "../controller/api";

export class QuoteDb {
  private static dbPath = process.env.QUOTE_DB;

  constructor() { }

  public static showQuotes(fn: (e: Error, a: Array<Quote>) => void): void {
    const sql = "SELECT * FROM quote";
    const showAll = (db: sqlite.Database) =>
      db.all(sql, (e, xs: Array<Quote>) => fn(e, xs.map(x => QuoteDb.decodeQuote(x))));

    Db.using(Db.getDb(QuoteDb.dbPath), showAll);
  }

  public static addQuotes(quotes: Array<QuoteForm>, fn: (err) => void): void {
    const values = quotes.map(x => `("${QuoteDb.encodeWords(x.words)}", "${x.addedBy}")`).join(",");
    const sql = "INSERT INTO quote(words, added_by) VALUES " + values;

    Db.using(Db.getDb(QuoteDb.dbPath), (db) => db.run(sql, fn));
  }

  public static randomQuote(fn: (err: Error, quote: Quote) => void): void {
    const cntSql = "SELECT COUNT(*) AS cnt FROM quote";
    const sqlFn = (offset: number) => "SELECT * FROM quote LIMIT 1 OFFSET " + offset;
    const randomOffset = (max: number) => Math.floor(Api.random(max - 1, 0));

    const first = (db: sqlite.Database, offset: number) =>
      db.get(sqlFn(offset), (e: Error, q: Quote) => fn(e, QuoteDb.decodeQuote(q)));

    const getFirst = (db: sqlite.Database) => db.get(cntSql, (err: Error, row: { cnt: number }) => {
      if (err) fn(err, undefined);
      else first(db, randomOffset(row.cnt));
    });

    Db.using(Db.getDb(QuoteDb.dbPath), getFirst);
  }

  public static decodeQuote(quote: Quote): Quote {
    return {words: decodeURIComponent(quote.words), id: quote.id, added_by: quote.added_by};
  }

  public static encodeWords(words: string): string {
    return encodeURIComponent(words);
  }
}
