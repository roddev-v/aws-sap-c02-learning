import { CachedCommand } from "../abstract/CachedCommand";
import { sleep } from "../utils";

export class CommandBWithTTL extends CachedCommand<
  void,
  { cacheControl: string; data: Record<string, string> }
> {
  async Run(): Promise<{ cacheControl: string; data: Record<string, string> }> {
    await sleep(2000);
    return {
      cacheControl: "max-age=100,s-maxage=420",
      data: {
        message: "Enjoy this data for 420 seconds in CloudFront and 100 seoncds in your browser!",
      },
    };
  }
}
