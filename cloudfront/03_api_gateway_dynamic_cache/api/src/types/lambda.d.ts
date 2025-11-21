import {
  APIGatewayProxyEvent,
  APIGatewayProxyResult,
  Context,
} from "aws-lambda";

export namespace Lambdas {
  export interface HandlerInput {
    event: APIGatewayProxyEvent;
    context: Context;
  }

  export interface HandlerOutput {
    statusCode: number;
    headers?: Record<string, string>;
    body: string;
  }

  export type Handler = (
    event: APIGatewayProxyEvent,
    context: Context
  ) => Promise<APIGatewayProxyResult>;
}
