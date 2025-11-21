import { CachedCommand } from "./CachedCommand";
import { APIGatewayEvent, Context } from "aws-lambda";

export class CachedHandler {
  constructor(
    private readonly command: CachedCommand<
      unknown,
      { cacheControl: string; data: unknown }
    >
  ) {}

  handler: Types.Lambdas.Handler = async (
    _event: APIGatewayEvent,
    _context: Context
  ) => {
    const { cacheControl, data } = await this.command.Run();

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": cacheControl,
      },
      body: JSON.stringify(data),
    };
  };
}
