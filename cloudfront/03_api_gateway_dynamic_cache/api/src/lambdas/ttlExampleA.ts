import { CachedHandler } from "../abstract/CachedHandler";
import { CommandAWithTTL } from "../commands/CommandAWithTTL";

export const handler = new CachedHandler(new CommandAWithTTL()).handler;
