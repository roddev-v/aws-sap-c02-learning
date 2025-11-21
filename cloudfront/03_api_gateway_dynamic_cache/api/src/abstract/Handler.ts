import { APIGatewayEvent, Context } from "aws-lambda";
import { AbstractCommand } from "./AbstractCommand";

export class Handler {
  constructor(private readonly command: AbstractCommand<unknown, unknown>) {}

  handler: Types.Lambdas.Handler = async (
    _event: APIGatewayEvent,
    _context: Context
  ) => {
    const result = await this.command.Run();

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(result),
    };
  };
}
