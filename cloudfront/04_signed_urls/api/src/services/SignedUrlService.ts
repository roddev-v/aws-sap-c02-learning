import { CloudFront } from "aws-sdk";

export class SginedUrlService implements AppTypes.Services.ISignedUrlService {
  constructor(private readonly signer: CloudFront.Signer) {}

  create(url: string, expiresIn: number): string {
    return this.signer.getSignedUrl({
      url,
      expires: Math.floor(Date.now() / 1000) + expiresIn,
    });
  }
}
