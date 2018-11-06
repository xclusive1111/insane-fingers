import {ApiError} from "../model";

export default class Api {

  public static err(msg: string, code: number): ApiError {
    return {message: msg, status: code};
  }

  public static random(max: number, min: number): number {
    return Math.random() * (max - min) + min;
  }
}