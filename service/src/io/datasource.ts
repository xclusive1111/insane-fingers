import * as sqlite from 'sqlite3';

export default class Db {

  public static getDb(dbPath: string): sqlite.Database {
    return new sqlite.Database(dbPath, (err) => {
      if (err) {
        console.error(err);
      }
      console.log("Open connection to path: " + dbPath);
    });
  }

  public static using<A extends { close(): void }, B>(resource: A, fn: (A) => B): B {
    try {
      return fn(resource)
    } finally {
      resource.close()
    }
  }
}
