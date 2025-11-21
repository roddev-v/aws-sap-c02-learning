import { CachedCommand } from "../abstract/CachedCommand";
import { sleep } from "../utils";

export class CommandAWithTTL extends CachedCommand<
  void,
  { cacheControl: string; data: Record<string, string> }
> {
  async Run(): Promise<{ cacheControl: string; data: Record<string, string> }> {
    await sleep(2000);
    return {
      cacheControl: "max-age=0,s-maxage=256",
      data: {
        message: "Enjoy this data for 256 seconds in CloudFront and zero seconds on your browser!",
      },
    };
  }
}
